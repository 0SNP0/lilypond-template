#!/usr/bin/env python3
"""Cross-platform LilyPond builder; .ly files, not JSON, are the source of truth."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
ROOT = FRAMEWORK.parent
PDF = ROOT / "dist" / "pdf"
AUDIO = ROOT / "dist" / "audio"
PACKAGES = ROOT / "dist" / "packages"
BUILD = ROOT / "build"
README = ROOT / "README.md"
METADATA = ROOT / "metadata.ily"
METADATA_START = "<!-- SCORE-METADATA:START -->"
METADATA_END = "<!-- SCORE-METADATA:END -->"


def run(args: list[str], *, capture: bool = False,
        environment: dict[str, str] | None = None) -> str:
    print("+", " ".join(args), flush=True)
    p = subprocess.run(args, cwd=ROOT, check=False,
                       env={**os.environ, **(environment or {})},
                       stdout=subprocess.PIPE if capture else None,
                       stderr=subprocess.STDOUT if capture else None,
                       text=True, errors="replace")
    if p.returncode:
        if capture and p.stdout:
            print(p.stdout, flush=True)
        raise subprocess.CalledProcessError(p.returncode, args)
    return p.stdout or ""


def git(*args: str) -> str:
    return subprocess.check_output(["git", "-C", str(ROOT), *args],
                                   stderr=subprocess.DEVNULL, text=True).strip()


def revision() -> tuple[str, str]:
    try:
        sha = git("rev-parse", "HEAD")
        assert Path(git("rev-parse", "--show-toplevel")).resolve() == ROOT.resolve()
        exact = ""
        try:
            exact = git("describe", "--tags", "--exact-match", "--match", "v[0-9]*")
        except subprocess.CalledProcessError:
            pass
        if exact:
            name = exact
        else:
            name = git("describe", "--tags", "--always", "--long",
                       "--abbrev=8", "--match", "v[0-9]*")
        if git("status", "--porcelain=v1", "--untracked-files=normal"):
            name += "-dirty"
        return name, sha
    except (OSError, subprocess.CalledProcessError, AssertionError):
        return "unversioned", "unversioned"


def metadata() -> dict[str, str]:
    contents = METADATA.read_text(encoding="utf-8")
    return {key: bytes(value, "utf-8").decode("unicode_escape")
            if "\\\"" in value else value
            for key, value in re.findall(
                r'(?m)^([a-zA-Z]\w*)\s*=\s*"((?:[^"\\]|\\.)*)"\s*$',
                contents,
            )}


def instruments() -> list[Path]:
    paths = sorted((ROOT / "parts").glob("*.ly"))
    if not paths:
        raise RuntimeError("No parts/*.ly found")
    names = {p.stem for p in paths}
    sources = {p.stem for p in (ROOT / "music").glob("*.ily")}
    missing = names - sources
    if missing:
        raise RuntimeError(f"Missing concert-pitch music sources: {sorted(missing)}")
    orchestration = (ROOT / "orchestra.ily").read_text(encoding="utf-8")
    included = set(re.findall(r'\\include\s+"music/([^/"]+)\.ily"', orchestration)) - {"global", "paired"}
    # Additional solo and combined desks are legitimate source views.

    return paths


def names(rev: str) -> dict[str, str]:
    slug = metadata().get("workFileSlug", "")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", slug):
        raise RuntimeError("Invalid workFileSlug in metadata.ily")
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._+-]*", rev):
        raise RuntimeError(f"Invalid revision for filename: {rev}")
    # Stable lexicographic release order: scores, players, archives.
    # Prefixes are independent of a particular work or orchestra.
    return dict(slug=slug, revision=rev, score=f"00-{slug}-score-{rev}",
                concert=f"01-{slug}-concert-score-{rev}",
                mix=f"{slug}-orchestra-{rev}",
                pdf_zip=f"90-{slug}-pdf-{rev}.zip",
                audio_zip=f"91-{slug}-audio-{rev}.zip",
                viewer_zip=f"92-{slug}-viewer-{rev}.zip")


def current_names() -> dict[str, str]:
    return names(json.loads((BUILD / "build-info.json").read_text(encoding="utf-8"))["revision"])


def part_name(part: Path, naming: dict[str, str]) -> str:
    return f"10-{naming['slug']}-{part.stem}-{naming['revision']}"


def combined_parts() -> list[Path]:
    """Optional two-voice desks. Never render these as audio stems:
    their voices already appear in the individual player MIDI tracks.
    """
    return sorted((ROOT / "parts" / "combined").glob("*.ly"))


def replace_section(markdown: str, start: str, end: str, body: str) -> str:
    a = markdown.find(start)
    b = markdown.find(end)
    if a < 0 or b < 0 or a > b:
        raise RuntimeError(f"README markers missing: {start}, {end}")
    return markdown[:a + len(start)] + "\n" + body.rstrip() + "\n" + markdown[b:]


def metadata_section() -> str:
    m = metadata()
    fields = [
        ("Произведение", "workTitle"),
        ("Короткое имя файлов", "workFileSlug"),
        ("Подзаголовок", "workSubtitle"),
        ("Оркестр", "orchestraName"),
        ("Композитор", "composerCredit"),
        ("Автор текста", "lyricistCredit"),
        ("Перевод", "translatorCredit"),
        ("Транскрипция", "transcriberCredit"),
        ("Аранжировка", "arrangerCredit"),
        ("Корректура", "proofreaderCredit"),
        ("Источник", "sourceCredit"),
        ("Авторские права", "rightsCredit"),
    ]
    def value(k: str) -> str:
        return m.get(k, "") or "—"
    return "| Поле | Значение |\n|---|---|\n" + "\n".join(
        f"| {title} | {value(key)} |" for title, key in fields)


def sync_readme(*, check: bool = False) -> None:
    text = README.read_text(encoding="utf-8")
    new = replace_section(text, METADATA_START, METADATA_END, metadata_section())
    if check and new != text:
        raise RuntimeError(
            "README metadata disagrees with metadata.ily; "
            "run: python scorekit/scripts/build.py readme"
        )
    if not check and new != text:
        README.write_text(new, encoding="utf-8")
        print("README.md refreshed from LilyPond metadata")


def score_staff_count() -> int:
    """Count printed staves, not individual players or optional parts."""
    orchestration = (ROOT / "orchestra.ily").read_text(encoding="utf-8")
    return len(re.findall(r'\\new\s+(?:Staff|DrumStaff|RhythmicStaff|TabStaff)\b',
                          orchestration))


def score_instrument_indents(staff_size: float) -> tuple[float, float]:
    """Estimate label extents from the actual score's instrument names.

    No fixed orchestration or instrument-specific names belong in ScoreKit.
    The small safety margin accounts for the staff-group braces and padding.
    Both print and SVG use the same values.
    """
    source = (ROOT / "orchestra.ily").read_text(encoding="utf-8")
    pattern = re.compile(
        r'(shortInstrumentName|instrumentName)\s*=\s*'
        r'(?:\\markup\s+\\fontsize\s+#-?\d+(?:\.\d+)?\s*)?'
        r'"([^"]+)"'
    )
    labels = {"instrumentName": [], "shortInstrumentName": []}
    for kind, name in pattern.findall(source):
        labels[kind].append(name)

    def width_mm(label: str) -> float:
        # Font-independent approximate advances in em units. No system font,
        # user language or platform-specific measurement tools are required.
        narrow = "ilI1.,:;!| '"
        wide = "MW@%w"
        width_em = sum(0.27 if ch in narrow else 0.85 if ch in wide
                       else 0.51 for ch in label)
        return width_em * staff_size * 0.89 * (25.4 / 72)

    full = max((width_mm(label) for label in labels["instrumentName"]), default=0)
    short = max((width_mm(label) for label in labels["shortInstrumentName"]), default=0)
    return round(max(7.0, full + 3.0), 2), round(max(5.0, short + 3.0), 2)


def natural_score_staff_size(count: int) -> float:
    """Starting A4 size for the orchestra; the final size must fit uncompressed."""
    if count <= 6:
        return 20.0
    if count <= 10:
        return 18.0
    if count <= 14:
        return 16.0
    if count <= 18:
        return 15.0
    if count <= 22:
        return 14.0
    return 12.5


def compile_lilypond(source: Path, output: Path, version: str,
                     *, score: bool = False) -> None:
    lilypond = shutil.which("lilypond")
    if not lilypond:
        raise RuntimeError("Install native LilyPond; lilypond executable not in PATH")
    output.parent.mkdir(parents=True, exist_ok=True)
    source_text = source.read_text(encoding="utf-8")
    size_match = (re.search(r'#\(define\s+partStaffSize\s+(\d+(?:\.\d+)?)\)',
                            source_text) if not score else None)
    preferred_size = float(size_match.group(1)) if size_match else 20.0
    pages_match = (re.search(r'#\(define\s+partTargetPages\s+(\d+)\)',
                             source_text) if not score else None)
    target_pages = int(pages_match.group(1)) if pages_match else None
    score_size = natural_score_staff_size(score_staff_count()) if score else None
    size = preferred_size
    best_size: float | None = None
    attempts = 0
    if target_pages:
        try:
            from pypdf import PdfReader
        except ImportError as exc:
            raise RuntimeError("Automatic page filling requires pypdf") from exc
        if target_pages < 1:
            raise ValueError("partTargetPages must be positive")
    while True:
        env = {"SCORE_BUILD_REVISION": version}
        if score_size is not None:
            env["SCORE_STAFF_SIZE"] = str(score_size)
            first_indent, continuation_indent = score_instrument_indents(score_size)
            env["SCORE_INDENT_MM"] = str(first_indent)
            env["SCORE_SHORT_INDENT_MM"] = str(continuation_indent)
            print(f"Score label indents: {first_indent:g} / {continuation_indent:g} mm", flush=True)
        elif target_pages or size != preferred_size:
            env["PART_STAFF_SIZE"] = str(size)
        result = run([lilypond, "-dno-point-and-click",
                      "-o", str(output), str(source)],
                     capture=True, environment=env)
        print(result, end="", flush=True)
        pdf = Path(str(output) + ".pdf")
        if "error:" in result.lower() or not pdf.is_file():
            raise RuntimeError(f"LilyPond failed or produced no PDF: {source}")
        overfull = "compressing over-full page" in result
        if target_pages:
            pages = len(PdfReader(str(pdf)).pages)
            valid = pages <= target_pages and not overfull
            print(f"Part {source.name}: {size:g} pt, {pages} pages "
                  f"(target {target_pages}, overfull={overfull})", flush=True)
            if valid:
                best_size = size
                if size >= 34 or attempts >= 26:
                    return
                size = round(size + 0.5, 2)
                attempts += 1
                continue
            if best_size is not None:
                # The last probe exceeded the page budget: restore the largest
                # valid setting, not the overflowing final test.
                print(f"Selected {best_size:g} pt for {source.name}", flush=True)
                run([lilypond, "-dno-point-and-click",
                     "-o", str(output), str(source)],
                    capture=True,
                    environment={"SCORE_BUILD_REVISION": version,
                                 "PART_STAFF_SIZE": str(best_size)})
                return
            size = round(size - 0.5, 2)
            attempts += 1
            if size < 15 or attempts >= 40:
                raise RuntimeError(
                    f"Cannot fit {source.name} into {target_pages} A4 pages")
            continue
        if not overfull:
            return
        if score:
            assert score_size is not None
            score_size = round(score_size - 0.5, 1)
            if score_size < 11.5 or attempts >= 18:
                raise RuntimeError(f"Overfull A4 score: {source}")
            attempts += 1
            continue
        size = round(size - 0.5, 2)
        if size < 15 or attempts >= 10:
            raise RuntimeError(f"Overfull part at minimum staff size: {source}")
        attempts += 1


def compile_midi(source: Path, output: Path, version: str) -> Path:
    """Generate MIDI only; the first CI job already engraved the final PDFs."""
    lilypond = shutil.which("lilypond")
    if not lilypond:
        raise RuntimeError("LilyPond executable missing for MIDI-only export")
    output.parent.mkdir(parents=True, exist_ok=True)
    run([lilypond, "-dno-print-pages", "-dno-point-and-click",
         "-o", str(output), str(source)],
        environment={"SCORE_BUILD_REVISION": version})
    midi = Path(str(output) + ".midi")
    if not midi.is_file() or not midi.read_bytes().startswith(b"MThd"):
        raise RuntimeError(f"No MIDI from {source}")
    return midi


def build(*, audio: bool, font: str | None, reuse_pdf: bool = False) -> None:
    parts = instruments()
    rev, sha = revision()
    source_tag = os.environ.get("SOURCE_TAG", "")
    if source_tag:
        if not re.fullmatch(r"v[0-9][0-9A-Za-z.+-]*", source_tag):
            raise RuntimeError("Invalid release tag")
        if git("rev-parse", f"refs/tags/{source_tag}^{{commit}}") != sha:
            raise RuntimeError("Release tag must point at HEAD")
        if rev != source_tag:
            raise RuntimeError(f"Release must be clean and exactly tagged: {rev}")
    if reuse_pdf and not audio:
        raise RuntimeError("--reuse-pdf requires --audio")
    if not reuse_pdf and PDF.exists():
        shutil.rmtree(PDF)
    PDF.mkdir(parents=True, exist_ok=True)
    for path in (AUDIO, BUILD / "midi", BUILD / "midi-render"):
        if path.exists():
            shutil.rmtree(path)
        path.mkdir(parents=True, exist_ok=True)
    (BUILD / "build-info.json").write_text(
        json.dumps({"revision": rev, "commit": sha, "work": metadata().get("workTitle"),
                    "orchestra": metadata().get("orchestraName"),
                    "parts": [p.stem for p in parts],
                    "combined_parts": [p.stem for p in combined_parts()]},
                   ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8")
    naming = names(rev)
    print("Revision:", rev)
    if reuse_pdf:
        # The first job has already produced the final PDF set.
        verify(audio=False)
        score_midi = compile_midi(ROOT / "score.ly",
                                  BUILD / "midi-render" / naming["score"], rev)
    else:
        compile_lilypond(ROOT / "score.ly", PDF / naming["score"], rev, score=True)
        score_midi = PDF / (naming["score"] + ".midi")
    if audio:
        if not score_midi.is_file():
            raise RuntimeError("Score did not emit orchestra MIDI")
        shutil.move(str(score_midi), str(BUILD / "midi" / (naming["mix"] + ".midi")))
    elif score_midi.is_file():
        score_midi.unlink()
    if not reuse_pdf:
        compile_lilypond(ROOT / "concert-score.ly", PDF / naming["concert"], rev, score=True)
    for source in parts:
        stem = part_name(source, naming)
        if reuse_pdf:
            midi = compile_midi(source, BUILD / "midi-render" / stem, rev)
        else:
            compile_lilypond(source, PDF / stem, rev)
            midi = PDF / (stem + ".midi")
        if audio:
            if not midi.is_file():
                raise RuntimeError(f"No concert-pitch MIDI from part {source.name}")
            shutil.move(str(midi), str(BUILD / "midi" / midi.name))
        elif midi.is_file():
            midi.unlink()
    # Combined desks are only printed; MIDI tracks remain individual.
    if not reuse_pdf:
        for source in combined_parts():
            compile_lilypond(source, PDF / part_name(source, naming), rev)
    if audio:
        validate_midi_programs(parts, naming)
        render_audio(parts, font, naming)
    verify(audio=audio)
    if audio:
        run([sys.executable, str(FRAMEWORK / "scripts" / "export.py")])


def locate_soundfont(override: str | None) -> Path:
    candidates = [
        override, os.environ.get("SOUNDFONT"),
        str(ROOT / "soundfonts" / "MS_Basic.sf3"),
        str(ROOT / "soundfonts" / "GeneralUser-GS.sf2"),
        str(ROOT / "soundfonts" / "FluidR3_GM.sf2"),
        "/usr/share/sounds/sf2/FluidR3_GM.sf2",
    ]
    for candidate in candidates:
        if candidate and Path(candidate).is_file():
            return Path(candidate).resolve()
    raise RuntimeError("No SoundFont; use --soundfont PATH or SOUNDFONT")


def validate_repeat_timbres(events: list[tuple], division: int,
                            timeline: dict, part: str) -> None:
    """Detect MIDI program leakage when a printed passage is replayed.

    Compare effective program numbers at actual note-on events for each
    occurrence of a printed measure. This works for strings, organs, synths,
    and arbitrary repeat maps without instrument-name assumptions.
    """
    from bisect import bisect_right
    from collections import defaultdict

    bars = timeline["measures"]
    if len({m["printed_number"] for m in bars}) == len(bars):
        return
    factor = division / timeline["ticks_per_quarter"]
    starts = [round(m["start_tick"] * factor) for m in bars]
    ends = [round(m["end_tick"] * factor) for m in bars]
    programs = defaultdict(list)
    notes = []
    for tick, kind, track, data in events:
        if kind != "channel":
            continue
        status = data[0] & 0xF0
        key = (track, data[0] & 0x0F)
        if status == 0xC0 and len(data) > 1:
            programs[key].append((tick, data[1]))
        elif status == 0x90 and len(data) > 2 and data[2] > 0:
            notes.append((tick, key, data[1]))
    program_ticks = {}
    program_values = {}
    for key, entries in programs.items():
        entries.sort()
        program_ticks[key] = [t for t, _ in entries]
        program_values[key] = [value for _, value in entries]
    played = defaultdict(list)
    for tick, key, pitch in notes:
        bar = bisect_right(starts, tick) - 1
        if bar < 0 or tick >= ends[bar]:
            continue
        times = program_ticks.get(key, [])
        idx = bisect_right(times, tick) - 1
        program = program_values[key][idx] if idx >= 0 else 0
        played[bar].append((tick - starts[bar], pitch, program))
    first = {}
    for idx, bar in enumerate(bars):
        number = bar["printed_number"]
        signature = sorted(played[idx])
        if number in first and signature != first[number]:
            raise RuntimeError(
                f"Repeated MIDI bar {number} differs in {part} "
                f"(playback bar {bar['number']}). "
                "Check instrument resets at repeated section starts; "
                "MIDI instrument programs persist after jumps."
            )
        first.setdefault(number, signature)


def validate_midi_programs(parts: list[Path], naming: dict[str, str]) -> None:
    """Reject unintended piano and compare actual timbres across all repeats."""
    import export
    timeline = export.make_timeline(BUILD / "midi" / (naming["mix"] + ".midi"))
    for part in parts:
        source = part.read_text(encoding="utf-8")
        if r"\new DrumStaff" in source:
            continue
        instruments = re.findall(r'midiInstrument\s*=\s*"([^"]+)"', source)
        if not instruments:
            raise RuntimeError(f"Missing midiInstrument in {part}")
        midi = BUILD / "midi" / (part_name(part, naming) + ".midi")
        division, events = export.midi_events(midi)
        programs = {data[1] for _, kind, _, data in events
                    if kind == "channel" and (data[0] & 0xF0) == 0xC0}
        if not programs:
            raise RuntimeError(f"No instrument program in MIDI {part}")
        if 0 in programs and not any("piano" in x.lower() or
                                      "acoustic grand" in x.lower() for x in instruments):
            raise RuntimeError(f"Unexpected piano in {part}: {sorted(programs)}")
        validate_repeat_timbres(events, division, timeline, part.stem)
        note_velocities = sorted({data[2] for _, kind, _, data in events
                                  if kind == "channel" and (data[0] & 0xF0) == 0x90
                                  and len(data) >= 3 and data[2] > 0})
        controllers = sorted({(data[1], data[2]) for _, kind, _, data in events
                              if kind == "channel" and (data[0] & 0xF0) == 0xB0
                              and len(data) >= 3 and data[1] in (7, 11)})
        print(f"Checked MIDI {part.stem}: programs {sorted(programs)}, "
              f"note velocities {note_velocities}, volume/expression CC {controllers[:20]}")


def render_audio(parts: list[Path], soundfont_path: str | None,
                 naming: dict[str, str]) -> None:
    soundfont = locate_soundfont(soundfont_path)
    fluidsynth, ffmpeg = shutil.which("fluidsynth"), shutil.which("ffmpeg")
    if not fluidsynth or not ffmpeg:
        raise RuntimeError("Audio requires FluidSynth and FFmpeg in PATH")
    wav_dir, mp3_dir = BUILD / "wav", AUDIO / "stems"
    if wav_dir.exists():
        shutil.rmtree(wav_dir)
    wav_dir.mkdir(parents=True)
    mp3_dir.mkdir(parents=True)
    wavs: list[Path] = []
    for part in parts:
        stem = part_name(part, naming)
        wav = wav_dir / f"{stem}.wav"
        wavs.append(wav)
        run([
            fluidsynth, "-ni", "-R", "1", "-C", "1", "-g", "0.30", "-r", "48000",
            "-F", str(wav), str(soundfont), str(BUILD / "midi" / f"{stem}.midi"),
        ])
        run([
            ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(wav), "-c:a", "libmp3lame", "-q:a", "0",
            str(mp3_dir / f"{stem}.mp3"),
        ])
    # Mix lossless stems. A single-pass loudnorm can perform dynamic
    # processing and reduce expressive contrasts, so instead analyze the
    # uncompressed orchestral mix and apply exactly ONE fixed gain.
    # The true-peak cap is always honored; no gain riding or compression.
    inputs = [arg for path in wavs for arg in ("-i", str(path))]
    mixed_pcm = (
        f"amix=inputs={len(wavs)}:duration=longest:"
        "dropout_transition=0:normalize=0"
    )
    measure_filter = mixed_pcm + ",loudnorm=I=-16:TP=-1.5:LRA=50:print_format=json"
    measure_cmd = [
        ffmpeg, "-hide_banner", "-nostats", "-y",
        *inputs, "-filter_complex", measure_filter, "-f", "null", "-",
    ]
    print("+", " ".join(measure_cmd), flush=True)
    measured = subprocess.run(measure_cmd, cwd=ROOT,
                              stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                              text=True, check=False)
    if measured.returncode:
        raise RuntimeError("Audio loudness analysis failed: " + measured.stderr[-3000:])
    match = re.search(r'\{\s*"input_i"\s*:.*?\}', measured.stderr, re.S)
    if not match:
        raise RuntimeError("FFmpeg omitted loudness statistics")
    stats = json.loads(match.group())
    integrated = float(stats["input_i"])
    true_peak = float(stats["input_tp"])
    if not math.isfinite(integrated) or not math.isfinite(true_peak):
        raise RuntimeError("Invalid integrated loudness or true peak")
    static_gain = min(-16.0 - integrated, -1.5 - true_peak)
    print(f"Orchestra audio: {integrated:.2f} LUFS, {true_peak:.2f} dBTP; "
          f"constant gain {static_gain:+.2f} dB (no dynamics compression)",
          flush=True)
    run([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
        *inputs,
        "-filter_complex", mixed_pcm + f",volume={static_gain:.3f}dB",
        "-ar", "48000", "-c:a", "libmp3lame", "-q:a", "0",
        str(AUDIO / (naming["mix"] + ".mp3")),
    ])
    shutil.rmtree(wav_dir)


def verify(*, audio: bool = False) -> None:
    parts = instruments()
    naming = current_names()
    expected = {naming["score"] + ".pdf", naming["concert"] + ".pdf"}
    expected |= {part_name(p, naming) + ".pdf" for p in parts}
    expected |= {part_name(p, naming) + ".pdf" for p in combined_parts()}
    found = {p.name for p in PDF.glob("*.pdf")}
    if found != expected:
        raise RuntimeError(f"PDF set mismatch: missing={expected-found}, extra={found-expected}")
    for name in expected:
        data = (PDF / name).read_bytes()
        if not data.startswith(b"%PDF"):
            raise RuntimeError(f"Invalid PDF {name}")
    if audio:
        if not (BUILD / "midi" / (naming["mix"] + ".midi")).read_bytes().startswith(b"MThd"):
            raise RuntimeError("Invalid orchestra MIDI")
    try:
        from pypdf import PdfReader
    except ImportError:
        print("INFO: install pypdf to check A4 sizes and page counts")
    else:
        for path in PDF.glob("*.pdf"):
            doc = PdfReader(str(path))
            if not doc.pages:
                raise RuntimeError(f"Blank PDF {path}")
            for page in doc.pages:
                w, h = float(page.mediabox.width), float(page.mediabox.height)
                if abs(w - 595.28) > 1 or abs(h - 841.89) > 1:
                    raise RuntimeError(f"Not A4: {path} {w:.1f}x{h:.1f}")
            print(f"{path.name}: {len(doc.pages)} A4 page(s)")
    if audio:
        stem_names = {p.name for p in (AUDIO / "stems").glob("*.mp3")}
        expected_stems = {part_name(p, naming) + ".mp3" for p in parts}
        if stem_names != expected_stems:
            raise RuntimeError(f"MP3 stems mismatch: {expected_stems - stem_names}")
        for path in [AUDIO / (naming["mix"] + ".mp3"), *((AUDIO / "stems" / n) for n in expected_stems)]:
            if not path.is_file() or path.stat().st_size < 128:
                raise RuntimeError(f"Missing/empty MP3: {path}")
    print(f"Verified {len(expected)} PDFs (individual + paired), MIDI" + (f", {len(parts)} MP3 stems and mixed MP3" if audio else ""))


def package(*, full: bool = False) -> None:
    verify(audio=full)
    naming = current_names()
    PACKAGES.mkdir(parents=True, exist_ok=True)
    for old in PACKAGES.glob("*.zip"):
        old.unlink()
    # Music-print fingerprints: only the LilyPond staff music is hashed.
    # PDF bytes are kept as a separate audit hash, never as print_hash.
    from notation_hash import music_fingerprint, print_fingerprint
    documents = {}
    for pdf in sorted(PDF.glob("*.pdf")):
        stem = pdf.stem
        if stem == naming["score"]:
            midi = BUILD / "midi" / (naming["mix"] + ".midi")
        elif stem == naming["concert"]:
            midi = BUILD / "midi" / (naming["mix"] + ".midi")
        else:
            midi = BUILD / "midi" / (stem + ".midi")
        if stem == naming["score"] or stem == naming["concert"]:
            source = ROOT / ("score.ly" if stem == naming["score"] else "concert-score.ly")
        else:
            source = next((p for p in [*instruments(), *combined_parts()]
                           if stem == part_name(p, naming)), None)
        if source is None:
            raise RuntimeError("Unknown print source for " + stem)
        music_hash = music_fingerprint(source)
        print_hash = print_fingerprint(source)
        documents[stem] = {"pdf": pdf.name,
                           "print_hash": print_hash,
                           "music_hash": music_hash,
                           "pdf_sha256": hashlib.sha256(pdf.read_bytes()).hexdigest()}
    manifest_file = ROOT / "dist" / "print-manifest.json"
    manifest_file.write_text(
        json.dumps({"schema": "score-print-fingerprint-v2", "revision": naming["revision"],
                    "documents": documents,
                    "warning": "music_hash ignores engraving-only changes; print_hash also tracks print layout, wrappers and credits, but both ignore Git revision. pdf_sha256 tracks exact PDF bytes."},
                   indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    with zipfile.ZipFile(PACKAGES / naming["pdf_zip"], "w", zipfile.ZIP_DEFLATED) as archive:
        for item in sorted(PDF.glob("*.pdf")):
            paired_ids = {part_name(p, naming) for p in combined_parts()}
            sub = ("scores" if item.stem in (naming["score"], naming["concert"])
                   else "parts/combined" if item.stem in paired_ids
                   else "parts")
            archive.write(item, f"{sub}/{item.name}")
        archive.write(BUILD / "build-info.json", "build-info.json")
        manifest_file = ROOT / "dist" / "print-manifest.json"
        if manifest_file.is_file():
            archive.write(manifest_file, "print-manifest.json")
    if full:
        with zipfile.ZipFile(PACKAGES / naming["audio_zip"], "w", zipfile.ZIP_DEFLATED) as archive:
            item = AUDIO / (naming["mix"] + ".mp3")
            archive.write(item, f"audio/{item.name}")
            for item in sorted((AUDIO / "stems").glob("*.mp3")):
                archive.write(item, f"audio/stems/{item.name}")
            archive.write(BUILD / "build-info.json", "build-info.json")
        viewer = ROOT / "dist" / "viewer"
        if (viewer / "manifest.json").is_file() and (viewer / "timeline.json").is_file():
            archive_name = naming["viewer_zip"]
            with zipfile.ZipFile(PACKAGES / archive_name, "w", zipfile.ZIP_DEFLATED) as archive:
                for item in sorted(viewer.rglob("*")):
                    if item.is_file():
                        archive.write(item, str(item.relative_to(ROOT / "dist")))
                # Keep viewer data small: media is distributed in the audio ZIP
                # and loaded by the browser only after a track is selected.
                archive.write(BUILD / "build-info.json", "build-info.json")
    print("Ready:", naming["pdf_zip"], *( [naming["audio_zip"]] if full else [] ))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_command = commands.add_parser("build")
    build_command.add_argument("--audio", action="store_true")
    build_command.add_argument("--reuse-pdf", action="store_true",
                               help="reuse PDFs from the first job; generate MIDI/audio only")
    build_command.add_argument("--soundfont")
    commands.add_parser("verify")
    package_command = commands.add_parser("package")
    package_command.add_argument("--full", action="store_true",
                                 help="include audio and interactive SVG viewer")
    commands.add_parser("version")
    commands.add_parser("readme")
    commands.add_parser("readme-check")
    commands.add_parser("clean")
    args = parser.parse_args()
    try:
        if args.command == "build":
            build(audio=args.audio, font=args.soundfont,
                  reuse_pdf=args.reuse_pdf)
        elif args.command == "verify":
            verify()
        elif args.command == "package":
            package(full=args.full)
        elif args.command == "version":
            print(revision()[0])
        elif args.command == "readme":
            sync_readme()
        elif args.command == "readme-check":
            sync_readme(check=True)
        elif args.command == "clean":
            for path in (BUILD, ROOT / "dist"):
                if path.exists():
                    shutil.rmtree(path)
    except (RuntimeError, OSError, subprocess.CalledProcessError) as ex:
        parser.exit(1, f"ERROR: {ex}\n")


if __name__ == "__main__":
    main()
