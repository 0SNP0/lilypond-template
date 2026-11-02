#!/usr/bin/env python3
"""Cross-platform LilyPond orchestra builder (Python standard library only).

Source music is in concert pitch. The transposed full score and parts use
\transpose; the MIDI render uses concert pitch and GM instrument mapping.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.json"
BUILD = ROOT / "build"
DIST = ROOT / "dist"
PDF = DIST / "pdf"
AUDIO = DIST / "audio"
PACKAGES = DIST / "packages"
VERSION_FILE = BUILD / "version.ily"
VERSION_PATTERN = re.compile(r"^v[0-9][0-9A-Za-z.+-]*$")


def execute(cmd: list[str]) -> None:
    print("+", " ".join(cmd), flush=True)
    subprocess.run(cmd, cwd=ROOT, check=True)


def git(*args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(ROOT), *args],
        cwd=ROOT, capture_output=True, text=True, check=True,
    )
    return result.stdout.strip()


def repository_version() -> tuple[str, str]:
    """Return human-readable revision and full commit, or 'unversioned'."""
    try:
        if Path(git("rev-parse", "--show-toplevel")).resolve() != ROOT.resolve():
            return "unversioned", "unversioned"
        sha = git("rev-parse", "HEAD")
        requested_tag = os.environ.get("SOURCE_TAG", "").strip()
        if requested_tag:
            if not VERSION_PATTERN.fullmatch(requested_tag):
                raise RuntimeError(f"Invalid release tag {requested_tag!r}")
            tagged = git("rev-parse", f"refs/tags/{requested_tag}^{{commit}}")
            if tagged != sha:
                raise RuntimeError("SOURCE_TAG does not point to HEAD")
            name = requested_tag
        else:
            name = git("describe", "--tags", "--always", "--abbrev=8",
                       "--match", "v[0-9]*")
        dirty = bool(git("status", "--porcelain=v1", "--untracked-files=normal"))
        if requested_tag and dirty:
            raise RuntimeError("Refusing to release a dirty working tree")
        return (name + ("-dirty" if dirty else "")), sha
    except (OSError, subprocess.CalledProcessError):
        if os.environ.get("SOURCE_TAG"):
            raise
        return "unversioned", "unversioned"


def lily_string(text: object) -> str:
    value = str(text)
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", " ") + '"'


def project() -> dict:
    return json.loads(PROJECT.read_text(encoding="utf-8"))


def check_manifest(p: dict) -> None:
    instruments = p["instruments"]
    if not instruments:
        raise RuntimeError("Instrument manifest is empty")
    ids = [i["id"] for i in instruments]
    if len(ids) != len(set(ids)):
        raise RuntimeError("Duplicate instrument ID")
    valid = {"soloists", "woodwinds", "brass", "percussion", "keys", "choir", "strings"}
    for i in instruments:
        if i["group"] not in valid:
            raise RuntimeError(f"Unknown section: {i['group']}")
        if not (ROOT / i["source"]).is_file():
            raise RuntimeError(f"Missing source: {i['source']}")
        if bool(i.get("staves")) == bool(i.get("music")):
            raise RuntimeError(f"Expected either music or staves for {i['id']}")
        if "staves" in i and len(i["staves"]) != 2:
            raise RuntimeError(f"Only 2-staff keyboards supported: {i['id']}")
    layout = p["layout"]
    if set(layout.get("part_overrides", {})) - set(ids):
        raise RuntimeError("Unknown instrument ID in layout.part_overrides")
    if set(layout.get("score_overrides", {})) - {"full-score", "concert-score"}:
        raise RuntimeError("Unknown edition in layout.score_overrides")
    for item in instruments:
        for field in ("name", "short"):
            if not item[field].isascii():
                raise RuntimeError(f"Instrument {field} must be English/ASCII: {item['id']}")
        edition_layout(p, item)
    edition_layout(p)
    edition_layout(p, concert=True)
    order = ["soloists", "woodwinds", "brass", "percussion", "keys", "choir", "strings"]
    groups = [i["group"] for i in instruments]
    if groups != sorted(groups, key=order.index):
        raise RuntimeError("Instrument order differs from orchestral convention")


def version_metadata(p: dict) -> tuple[str, dict]:
    revision, sha = repository_version()
    display = revision[1:] if revision.startswith("v") else revision
    label = f"{p['ensemble']}_V{display}"
    metadata = {
        "revision": revision, "commit": sha, "edition_label": label,
        "title": p["title"], "copyright": p.get("copyright", ""),
        "instrument_count": len(p["instruments"]),
    }
    BUILD.mkdir(parents=True, exist_ok=True)
    VERSION_FILE.write_text(f"buildLabel = {lily_string(label)}\n", encoding="utf-8")
    (BUILD / "build-info.json").write_text(
        json.dumps(metadata, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Revision:", revision)
    return revision, metadata


def edition_layout(p: dict, instrument: dict | None = None, *, concert: bool = False) -> dict:
    layout = p["layout"]
    if layout.get("score_paper") != "a4" or layout.get("parts_paper") != "a4":
        raise RuntimeError("All score and part editions must use A4 paper")
    if instrument is not None:
        overrides = layout.get("part_overrides", {}).get(instrument["id"], {})
        default_staff_space = layout["part_staff_space_mm"]
    else:
        score_id = "concert-score" if concert else "full-score"
        overrides = layout.get("score_overrides", {}).get(score_id, {})
        default_staff_space = layout["score_staff_space_mm"]
        if default_staff_space == "auto":
            # Count actual five-line staves; piano and accordion each have two.
            stave_count = sum(
                len(item["staves"]) if item.get("staves") else 1
                for item in p["instruments"]
            )
            # Nominal vertical capacity of A4 music area; compensated for
            # rehearsal marks, ledger lines, braces and section separators.
            default_staff_space = round(
                min(1.75, max(0.55, 235.0 / (9.0 * stave_count))), 3
            )
    if not isinstance(overrides, dict):
        raise RuntimeError("Page layout overrides must be JSON objects")
    allowed = {"target_pages", "systems_per_page", "system_count", "staff_space_mm",
               "ragged_last_bottom", "ragged_bottom", "page_spacing_weight"}
    unknown = set(overrides) - allowed
    if unknown:
        raise RuntimeError(f"Unknown page layout options: {sorted(unknown)}")
    result = {
        "staff_space_mm": default_staff_space,
        "ragged_last_bottom": layout.get(
            "parts_ragged_last_bottom" if instrument else "score_ragged_last_bottom",
            True,
        ),
        "ragged_bottom": layout.get(
            "parts_ragged_bottom" if instrument else "score_ragged_bottom",
            True,
        ),
    }
    result.update(overrides)
    for field in ("target_pages", "systems_per_page", "system_count"):
        value = result.get(field)
        if value is not None and (type(value) is not int or value < 1):
            raise RuntimeError(f"{field} must be a positive integer")
    value = result["staff_space_mm"]
    minimum = 1.2 if instrument else 0.55
    if isinstance(value, bool) or not isinstance(value, (int, float)) or not minimum <= value <= 1.75:
        raise RuntimeError(
            f"staff_space_mm must be between {minimum:.2f} and 1.75 mm for this edition"
        )
    for field in ("ragged_bottom", "ragged_last_bottom"):
        if type(result[field]) is not bool:
            raise RuntimeError(f"{field} must be a boolean")
    if "page_spacing_weight" in result and (
        isinstance(result["page_spacing_weight"], bool)
        or not isinstance(result["page_spacing_weight"], (int, float))
        or result["page_spacing_weight"] <= 0
    ):
        raise RuntimeError("page_spacing_weight must be positive")
    return result


def paper_and_header(p: dict, edition: str, instrument: dict | None = None,
                     *, concert: bool = False,
                     staff_space_override: float | None = None) -> str:
    layout = p["layout"]
    options = edition_layout(p, instrument, concert=concert)
    points = (staff_space_override or options["staff_space_mm"]) * 20 / 1.7573
    margin = layout["margin_mm"]
    indent = 0 if instrument else layout.get("score_indent_mm", 18)
    if not isinstance(indent, (int, float)) or isinstance(indent, bool) or not 0 <= indent <= 35:
        raise RuntimeError("score_indent_mm must be between 0 and 35")
    composer = "Composer: " + p.get("composer", "") if p.get("composer") else ""
    lyricist = "Lyrics: " + p.get("lyricist", "") if p.get("lyricist") else ""
    translator = "Translation: " + p.get("translator", "") if p.get("translator") else ""
    transcriber = "Transcription: " + p.get("transcriber", "") if p.get("transcriber") else ""
    arranged_by = "Arrangement: " + p.get("arranged_by", "") if p.get("arranged_by") else ""

    paper_lines = [
        '  #(set-paper-size "a4")',
        f'  top-margin = {margin}\\mm',
        f'  bottom-margin = {margin}\\mm',
        f'  left-margin = {margin}\\mm',
        f'  right-margin = {margin}\\mm',
        f'  indent = {indent}\\mm',
        f'  short-indent = {indent}\\mm',
        '  print-page-number = ##t',
        '  print-first-page-number = ##t',
        '  ragged-bottom = ' + ('##t' if options['ragged_bottom'] else '##f'),
        '  ragged-last-bottom = ' + ('##t' if options['ragged_last_bottom'] else '##f'),
        '  page-breaking = #ly:optimal-breaking',
    ]
    if instrument:
        # A natural, bounded-looking gap: do not stretch sparse systems
        # across the entire A4 page. Collision avoidance remains active.
        paper_lines.append(
            "  system-system-spacing = "
            "#'((basic-distance . 12) (minimum-distance . 9) "
            "(padding . 1) (stretchability . 0))"
        )
        paper_lines.append(
            "  markup-system-spacing = "
            "#'((basic-distance . 9) (minimum-distance . 6) "
            "(padding . 1) (stretchability . 0))"
        )
    if options.get('target_pages') is not None:
        paper_lines.append(f'  page-count = #{options["target_pages"]}')
    if options.get('systems_per_page') is not None:
        paper_lines.append(f'  systems-per-page = #{options["systems_per_page"]}')
    if options.get('page_spacing_weight') is not None:
        paper_lines.append(f'  page-spacing-weight = #{options["page_spacing_weight"]}')
    paper_lines.extend([
        r'  oddHeaderMarkup = \ensemblePageHeader',
        r'  evenHeaderMarkup = \ensemblePageHeader',
        r'  oddFooterMarkup = \ensemblePageFooter',
        r'  evenFooterMarkup = \ensemblePageFooter',
        r'  bookTitleMarkup = \ensembleBookTitle' if instrument
        else r'  bookTitleMarkup = \ensembleCompactBookTitle',
    ])
    return ('\\version "2.24.3"\n'
            '\\include "build/version.ily"\n'
            '\\include "layout/style.ily"\n'
            '\\include "music/global.ily"\n'
            f'#(set-global-staff-size {points:.5f})\n'
            '\\paper {\n' + '\n'.join(paper_lines) + '\n}\n'
            '\\header {\n'
            f'  title = {lily_string(p["title"])}\n'
            f'  subtitle = {lily_string(p.get("subtitle", ""))}\n'
            f'  instrument = {lily_string(edition)}\n'
            f'  composer = {lily_string(composer)}\n'
            f'  poet = {lily_string(lyricist)}\n'
            f'  translator = {lily_string(translator)}\n'
            f'  transcriber = {lily_string(transcriber)}\n'
            f'  arrangedBy = {lily_string(arranged_by)}\n'
            '  arranger = \\buildLabel\n'
            f'  copyright = {lily_string(p.get("copyright", ""))}\n'
            '  tagline = ##f\n}\n')


def edition_score_layout(p: dict, instrument: dict | None = None,
                         *, concert: bool = False) -> str:
    opts = edition_layout(p, instrument, concert=concert)
    statements = []
    if opts.get('system_count') is not None:
        statements.append(f'system-count = #{opts["system_count"]}')
    if instrument is None:
        # Only the conductor's score uses these compact within-system gaps.
        # LilyPond's skyline-based collision avoidance still takes precedence.
        statements.append(
            "\\context { \\Score "
            "\\override StaffGrouper.staff-staff-spacing.basic-distance = #7 "
            "\\override StaffGrouper.staff-staff-spacing.minimum-distance = #6 "
            "\\override StaffGrouper.staff-staff-spacing.padding = #0.5 "
            "\\override StaffGrouper.staffgroup-staff-spacing.basic-distance = #9 "
            "\\override StaffGrouper.staffgroup-staff-spacing.minimum-distance = #7 "
            "\\override StaffGrouper.staffgroup-staff-spacing.padding = #0.8 "
            "}"
        )
    return "\\layout { " + " ".join(statements) + " }"


def simple_staff(i: dict, *, concert: bool, for_midi: bool, first: bool, part: bool = False) -> str:
    inst = lily_string(i["midi"])
    if part or for_midi:
        # The part's identity is already shown in the page header/title.
        # No labels are printed in the left gutter of individual systems.
        labels = ""
    else:
        # Short names even on the first system prevent overflow on A4.
        short = lily_string(i["short"])
        small = f"\\markup \\fontsize #-3 {short}"
        labels = f"instrumentName = {small} shortInstrumentName = {small} "
    settings = f'{labels}midiInstrument = {inst}'
    intro = "\\introMark " if first else ""
    transpose = i["transpose_to"] if not concert else "c"
    if i["group"] == "percussion":
        inner = f"\\drumsGlobal {intro}\\{i['music']}"
        return f"\\new DrumStaff \\with {{ {labels} }} {{ {inner} }}"
    if i.get("staves"):
        staves = []
        for k, var in enumerate(i["staves"]):
            clef = "treble" if k == 0 else "bass"
            inner = f"\\clef {clef} \\global {intro if k == 0 else ''}\\{var}"
            staves.append(f"\\new Staff \\with {{ midiInstrument = {inst} }} {{ {inner} }}")
        return f"\\new PianoStaff \\with {{ {labels} }} << {' '.join(staves)} >>"
    clef = f"\\clef {i['clef']} " if i.get("clef") else ""
    music = f"\\global {intro}\\{i['music']}"
    if transpose != "c":
        music = f"\\transpose c {transpose} {{ {music} }}"
    if part:
        music = f"\\compressMMRests {{ {music} }}"
    return f"\\new Staff \\with {{ {settings} }} {{ {clef}{music} }}"


def make_document(p: dict, instrument: dict | None = None, *, concert: bool = False,
                  midi: bool = False, staff_space_override: float | None = None) -> str:
    if midi:
        base = '''\\version "2.24.3"
\\include "music/global.ily"
'''
    else:
        title = instrument["name"] if instrument else ("Concert Score" if concert else "Full Score")
        base = paper_and_header(p, title, instrument, concert=concert,
                                staff_space_override=staff_space_override)
    items = [instrument] if instrument else p["instruments"]
    for item in items:
        base += f'\\include "{item["source"]}"\n'
    if instrument:
        expression = simple_staff(
            instrument, concert=midi, for_midi=midi,
            first=True, part=not midi,
        )
    else:
        categories = []
        for group in ("soloists", "woodwinds", "brass", "percussion", "keys", "choir", "strings"):
            entries = [i for i in items if i["group"] == group]
            if not entries:
                continue
            members = [simple_staff(i, concert=concert or midi,
                                    for_midi=midi, first=i is items[0]) for i in entries]
            categories.append("\\new StaffGroup <<\n" + "\n".join(members) + "\n>>")
        expression = "<<\n" + "\n".join(categories) + "\n>>"
    if midi:
        base += ("\\score {\n" + expression +
                 "\n\\midi { \\context { \\Score midiChannelMapping = #'instrument } }\n}\n")
    else:
        base += "\\score {\n" + expression + "\n" + edition_score_layout(p, instrument, concert=concert) + "\n}\n"
    return base


def build(p: dict, *, audio: bool, soundfont: str | None) -> None:
    check_manifest(p)
    version_metadata(p)
    if PDF.exists():
        shutil.rmtree(PDF)
    if AUDIO.exists():
        shutil.rmtree(AUDIO)
    PDF.mkdir(parents=True)
    AUDIO.mkdir(parents=True)
    generated = BUILD / "generated"
    generated.mkdir(parents=True, exist_ok=True)
    lilypond = shutil.which("lilypond")
    if not lilypond:
        raise RuntimeError("lilypond is not in PATH (install LilyPond for Windows or Linux)")

    def compile_ly(name: str, source: str, output: Path, expected: str) -> None:
        src = generated / (name + ".ly")
        src.write_text(source, encoding="utf-8")
        output.parent.mkdir(parents=True, exist_ok=True)
        cmd = [lilypond, "-dno-point-and-click", "-I", str(ROOT),
               "-o", str(output), str(src)]
        print("+", " ".join(cmd), flush=True)
        result = subprocess.run(
            cmd, cwd=ROOT, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, text=True, errors="replace",
        )
        print(result.stdout, end="", flush=True)
        if result.returncode != 0:
            raise RuntimeError(f"LilyPond failed for {name}: exit {result.returncode}")
        if "compressing over-full page" in result.stdout or re.search(
            r"warning: page \d+ has been compressed", result.stdout
        ):
            raise RuntimeError(
                f"{name}: page is overfull/compressed; reduce score size "
                "or adjust page layout, do not release an unreadable page"
            )
        if not output.with_suffix(expected).is_file():
            raise RuntimeError(f"Missing expected {expected}: {output}")

    def build_score(name: str, concert: bool) -> None:
        overrides = p["layout"].get("score_overrides", {}).get(name, {})
        automatic = (p["layout"]["score_staff_space_mm"] == "auto"
                     and "staff_space_mm" not in overrides)
        size = edition_layout(p, concert=concert)["staff_space_mm"]
        while True:
            try:
                compile_ly(
                    name,
                    make_document(p, concert=concert, staff_space_override=size),
                    PDF / name, ".pdf",
                )
                print(f"{name}: {size:.3f} mm staff space")
                break
            except RuntimeError as exc:
                if not automatic or "overfull/compressed" not in str(exc) or size <= 0.551:
                    raise
                # Treat a page-compression warning as a fit constraint.
                size = round(max(0.55, size - 0.05), 3)
                print(f"{name}: retrying at {size:.3f} mm (A4 overfull)")

    build_score("full-score", concert=False)
    build_score("concert-score", concert=True)
    for item in p["instruments"]:
        compile_ly(item["id"], make_document(p, item), PDF / item["id"], ".pdf")

    compile_ly("orchestra", make_document(p, midi=True), AUDIO / "orchestra", ".midi")

    if audio:
        midi_stems = BUILD / "midi-stems"
        midi_stems.mkdir(parents=True, exist_ok=True)
        for item in p["instruments"]:
            compile_ly(
                "midi-" + item["id"],
                make_document(p, item, midi=True),
                midi_stems / item["id"], ".midi",
            )
        render_audio(p, soundfont, midi_stems)
    verify(p, expect_audio=audio)


def locate_soundfont(override: str | None) -> Path:
    paths = [override, os.environ.get("SOUNDFONT"),
             str(ROOT / "soundfonts" / "MS_Basic.sf3"),
             str(ROOT / "soundfonts" / "FluidR3_GM.sf2"),
             "/usr/share/sounds/sf2/FluidR3_GM.sf2"]
    for value in paths:
        if value and Path(value).is_file():
            return Path(value).resolve()
    raise RuntimeError("No SoundFont. Pass --soundfont PATH or set SOUNDFONT")


def render_audio(p: dict, override: str | None, midi_stems: Path) -> None:
    """Render each concert-pitch part separately, then sum PCM stems to MP3."""
    soundfont = locate_soundfont(override)
    fluidsynth = shutil.which("fluidsynth")
    ffmpeg = shutil.which("ffmpeg")
    if not fluidsynth or not ffmpeg:
        raise RuntimeError("Audio needs fluidsynth and ffmpeg in PATH")

    wav_dir = BUILD / "wav-stems"
    if wav_dir.exists():
        shutil.rmtree(wav_dir)
    wav_dir.mkdir(parents=True)
    mp3_dir = AUDIO / "stems"
    mp3_dir.mkdir(parents=True, exist_ok=True)
    wavs: list[Path] = []
    for item in p["instruments"]:
        identifier = item["id"]
        wav = wav_dir / (identifier + ".wav")
        wavs.append(wav)
        execute([
            fluidsynth, "-ni", "-g", "0.25", "-r", "48000",
            "-F", str(wav), str(soundfont),
            str(midi_stems / (identifier + ".midi")),
        ])
        execute([
            ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(wav), "-c:a", "libmp3lame", "-q:a", "1",
            str(mp3_dir / (identifier + ".mp3")),
        ])

    # Mixing the uncompressed WAVs prevents generational MP3 losses.
    # Equal weights preserve the relative rehearsal balance; normalizing
    # by the 21 active stems keeps the sum below clipping.
    inputs = [arg for wav in wavs for arg in ("-i", str(wav))]
    mix_filter = (
        f"amix=inputs={len(wavs)}:duration=longest:"
        "dropout_transition=0:normalize=1,alimiter=limit=0.95"
    )
    execute([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
        *inputs, "-filter_complex", mix_filter,
        "-c:a", "libmp3lame", "-q:a", "0",
        str(AUDIO / "orchestra.mp3"),
    ])
    shutil.rmtree(wav_dir)


def verify(p: dict, *, expect_audio: bool = False) -> None:
    check_manifest(p)
    expected = {"full-score.pdf", "concert-score.pdf"}
    expected |= {f"{item['id']}.pdf" for item in p["instruments"]}
    observed = {f.name for f in PDF.glob("*.pdf")}
    if observed != expected:
        raise RuntimeError(f"PDF mismatch. Missing: {sorted(expected-observed)}; extra: {sorted(observed-expected)}")
    for file in PDF.glob("*.pdf"):
        if not file.stat().st_size or file.open("rb").read(4) != b"%PDF":
            raise RuntimeError(f"Invalid PDF: {file}")
    midi = AUDIO / "orchestra.midi"
    if not midi.is_file() or midi.open("rb").read(4) != b"MThd":
        raise RuntimeError("Missing/invalid orchestra MIDI")
    if expect_audio:
        expected_stems = {item["id"] + ".mp3" for item in p["instruments"]}
        observed_stems = {f.name for f in (AUDIO / "stems").glob("*.mp3")}
        if observed_stems != expected_stems:
            raise RuntimeError(
                f"Stem MP3 mismatch: missing={sorted(expected_stems - observed_stems)} "
                f"extra={sorted(observed_stems - expected_stems)}"
            )
        for path in [AUDIO / "orchestra.mp3",
                     *((AUDIO / "stems" / name) for name in expected_stems)]:
            if not path.is_file() or not path.stat().st_size:
                raise RuntimeError(f"Missing audio: {path}")
    has_targets = (any(edition_layout(p, item).get("target_pages") is not None
                       for item in p["instruments"])
                   or edition_layout(p).get("target_pages") is not None
                   or edition_layout(p, concert=True).get("target_pages") is not None)
    pdf_page_report(p, strict=has_targets)
    print(f"Verified {len(expected)} PDFs + MIDI" + (f" + mix and {len(p['instruments'])} MP3 stems" if expect_audio else ""))


def pdf_page_report(p: dict, *, strict: bool = False) -> dict[str, int]:
    """Inspect A4 geometry and requested page counts when pypdf is installed."""
    try:
        from pypdf import PdfReader
    except ImportError as ex:
        if strict:
            raise RuntimeError(
                "Page inspection needs pypdf. On Windows: py -3 -m pip install pypdf; "
                "on Linux: python3 -m pip install pypdf"
            ) from ex
        print("INFO: Install optional 'pypdf' to validate actual A4 page sizes")
        return {}
    targets = {
        "full-score": edition_layout(p).get("target_pages"),
        "concert-score": edition_layout(p, concert=True).get("target_pages"),
        **{item["id"]: edition_layout(p, item).get("target_pages")
           for item in p["instruments"]},
    }
    pages = {}
    for name, target in targets.items():
        path = PDF / f"{name}.pdf"
        if not path.is_file():
            raise RuntimeError(f"Missing PDF: {path}")
        doc = PdfReader(str(path))
        count = len(doc.pages)
        if count == 0:
            raise RuntimeError(f"Empty PDF: {path}")
        for number, page in enumerate(doc.pages, 1):
            width, height = float(page.mediabox.width), float(page.mediabox.height)
            if not (abs(width - 595.28) < 1 and abs(height - 841.89) < 1):
                raise RuntimeError(
                    f"{name}: page {number} is not A4 portrait ({width:.1f} x {height:.1f} pt)")
        if target is not None and count != target:
            raise RuntimeError(
                f"{name}: requested {target} page(s), but got {count}. "
                "Adjust target_pages, system_count, systems_per_page or staff_space_mm")
        pages[name] = count
        print(f"  {name}: {count} A4 page(s)" +
              (f" [target: {target}]" if target is not None else ""))
    return pages


def package(p: dict) -> None:
    verify(p, expect_audio=True)
    PACKAGES.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(PACKAGES / "scores-pdf.zip", "w", compression=zipfile.ZIP_DEFLATED) as z:
        for file in sorted(PDF.glob("*.pdf")):
            folder = "score" if file.stem in ("full-score", "concert-score") else "parts"
            z.write(file, f"{folder}/{file.name}")
        z.write(BUILD / "build-info.json", "build-info.json")
    with zipfile.ZipFile(PACKAGES / "audio.zip", "w", compression=zipfile.ZIP_DEFLATED) as z:
        for suffix in ("mp3", "midi"):
            file = AUDIO / f"orchestra.{suffix}"
            z.write(file, f"audio/{file.name}")
        for item in p["instruments"]:
            file = AUDIO / "stems" / (item["id"] + ".mp3")
            z.write(file, f"audio/stems/{file.name}")
        z.write(BUILD / "build-info.json", "build-info.json")
    print("Release archives are ready in dist/packages/")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="action", required=True)
    cmd = sub.add_parser("build", help="Build full score, all parts, MIDI, optionally audio")
    cmd.add_argument("--audio", action="store_true", help="Render 21 MP3 stems and a mixed MP3 via FluidSynth + FFmpeg")
    cmd.add_argument("--soundfont", help="Path to .sf2 or FluidSynth-compatible .sf3")
    sub.add_parser("verify", help="Verify all PDFs and MIDI")
    sub.add_parser("package", help="Make PDF and audio release archives (audio required)")
    sub.add_parser("version", help="Print Git-derived version and write build metadata")
    sub.add_parser("pages", help="Report/verify A4 size and page counts (needs pypdf)")
    sub.add_parser("clean", help="Remove ignored build/ and dist/ folders")
    args = parser.parse_args()
    p = project()
    try:
        if args.action == "build":
            build(p, audio=args.audio, soundfont=args.soundfont)
        elif args.action == "verify":
            verify(p)
        elif args.action == "package":
            package(p)
        elif args.action == "version":
            version_metadata(p)
        elif args.action == "pages":
            pdf_page_report(p, strict=True)
        elif args.action == "clean":
            for folder in (BUILD, DIST):
                if folder.exists():
                    shutil.rmtree(folder)
    except (RuntimeError, subprocess.CalledProcessError, OSError) as ex:
        parser.exit(1, f"ERROR: {ex}\n")


if __name__ == "__main__":
    main()
