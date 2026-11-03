#!/usr/bin/env python3
"""Cross-platform LilyPond builder; .ly files, not JSON, are the source of truth."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
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
    return dict(slug=slug, revision=rev, score=f"{slug}-score-{rev}",
                concert=f"{slug}-concert-score-{rev}", mix=f"{slug}-orchestra-{rev}",
                pdf_zip=f"{slug}-pdf-{rev}.zip", audio_zip=f"{slug}-audio-{rev}.zip")


def current_names() -> dict[str, str]:
    return names(json.loads((BUILD / "build-info.json").read_text(encoding="utf-8"))["revision"])


def part_name(part: Path, naming: dict[str, str]) -> str:
    return f"{naming['slug']}-{part.stem}-{naming['revision']}"


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
            "run: python scripts/build.py readme"
        )
    if not check and new != text:
        README.write_text(new, encoding="utf-8")
        print("README.md refreshed from LilyPond metadata")


def score_staff_count() -> int:
    """Count printed staves, not individual players or optional parts."""
    orchestration = (ROOT / "orchestra.ily").read_text(encoding="utf-8")
    return len(re.findall(r'\\new\s+(?:Staff|DrumStaff|RhythmicStaff|TabStaff)\b',
                          orchestration))


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
    part_staff_size: float | None = None
    size_match = (re.search(r'#\(define\s+partStaffSize\s+(\d+(?:\.\d+)?)\)',
                            source.read_text(encoding="utf-8")) if not score else None)
    preferred_part_staff_size = float(size_match.group(1)) if size_match else 20.0
    score_staff_size = natural_score_staff_size(score_staff_count()) if score else None
    attempt = 0
    while True:
        args = [
            lilypond, "-dno-point-and-click",
            "-o", str(output), str(source),
        ]
        env = {"SCORE_BUILD_REVISION": version}
        # Start from the number of staves and find the largest usable A4 size.
        if score_staff_size is not None:
            env["SCORE_STAFF_SIZE"] = str(score_staff_size)
        if part_staff_size is not None:
            env["PART_STAFF_SIZE"] = str(part_staff_size)
        text = run(args, capture=True, environment=env)
        print(text, end="", flush=True)
        overfull = "compressing over-full page" in text
        if "error:" in text.lower() or not Path(str(output) + ".pdf").is_file():
            raise RuntimeError(f"LilyPond failed or produced no PDF: {source}")
        if not overfull:
            return
        if score:
            assert score_staff_size is not None
            next_size = round(score_staff_size - 0.5, 1)
            if next_size < 11.5 or attempt >= 18:
                raise RuntimeError(
                    f"A4 score still overfull at {score_staff_size} pt: {source}; "
                    "adjust score layout, not the A4 paper size.")
            print(f"Retry A4 score at {next_size:.1f} pt "
                  f"({score_staff_count()} staves)", flush=True)
            score_staff_size = next_size
            attempt += 1
            continue
        if not score:
            # Dense individual parts have a limited, separate adjustment.

            current = float(env.get("PART_STAFF_SIZE", preferred_part_staff_size))
            reduced = round(current - 0.5, 2)
            if reduced < 15 or attempt >= 10:
                print(f"WARNING: overfull part at {current} pt: {source}", flush=True)
                return
            print(f"Retry part at {reduced:.1f} pt: {source}", flush=True)
            part_staff_size = reduced
            attempt += 1
            continue


def build(*, audio: bool, font: str | None) -> None:
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
    for path in (PDF, AUDIO, BUILD / "midi"):
        if path.exists():
            shutil.rmtree(path)
        path.mkdir(parents=True)
    (BUILD / "build-info.json").write_text(
        json.dumps({"revision": rev, "commit": sha, "work": metadata().get("workTitle"),
                    "orchestra": metadata().get("orchestraName"),
                    "parts": [p.stem for p in parts],
                    "combined_parts": [p.stem for p in combined_parts()]},
                   ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8")
    naming = names(rev)
    print("Revision:", rev)
    compile_lilypond(ROOT / "score.ly", PDF / naming["score"], rev, score=True)
    score_midi = PDF / (naming["score"] + ".midi")
    if audio:
        if not score_midi.is_file():
            raise RuntimeError("Score did not emit orchestra MIDI")
        shutil.move(str(score_midi), str(AUDIO / (naming["mix"] + ".midi")))
    elif score_midi.is_file():
        score_midi.unlink()  # PDF-only CI must not export MIDI
    compile_lilypond(ROOT / "concert-score.ly", PDF / naming["concert"], rev, score=True)
    for source in parts:
        stem = part_name(source, naming)
        compile_lilypond(source, PDF / stem, rev)
        midi = PDF / (stem + ".midi")
        if audio:
            if not midi.is_file():
                raise RuntimeError(f"No concert-pitch MIDI from part {source.name}")
            shutil.move(str(midi), str(BUILD / "midi" / midi.name))
        elif midi.is_file():
            midi.unlink()  # Keep PDF-only artifact clean
    # PDF-only paired parts; do not duplicate these voices in the audio mix.
    for source in combined_parts():
        compile_lilypond(source, PDF / part_name(source, naming), rev)
    if audio:
        validate_midi_programs(parts, naming)
        render_audio(parts, font, naming)
    verify(audio=audio)
    if audio:
        run([sys.executable, str(ROOT / "scripts" / "export.py")])


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


def validate_midi_programs(parts: list[Path], naming: dict[str, str]) -> None:
    """Reject pitched MIDI stems that quietly fall back to GM piano."""
    import export
    for part in parts:
        src = part.read_text(encoding="utf-8")
        if r"\new DrumStaff" in src:
            continue
        instruments = re.findall(r'midiInstrument\s*=\s*"([^"]+)"', src)
        if not instruments:
            raise RuntimeError(f"Missing midiInstrument in {part}")
        midi = BUILD / "midi" / (part_name(part, naming) + ".midi")
        _division, events = export.midi_events(midi)
        programs = {payload[1] for _tick, kind, _track, payload in events
                    if kind == "channel" and (payload[0] & 0xF0) == 0xC0}
        if not programs:
            raise RuntimeError(f"No instrument program in MIDI {part}")
        if 0 in programs and not any("piano" in x.lower() or
                                      "acoustic grand" in x.lower() for x in instruments):
            raise RuntimeError(f"Unexpected piano in {part}: {sorted(programs)}")
        print(f"Checked MIDI {part.stem}: programs {sorted(programs)}")


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
            "-i", str(wav), "-c:a", "libmp3lame", "-q:a", "1",
            str(mp3_dir / f"{stem}.mp3"),
        ])
    # No MP3 generation loss: mix PCM files, not already encoded stems.
    inputs = [arg for path in wavs for arg in ("-i", str(path))]
    # The previous amix normalize=1 divided by the number of instruments
    # (21), leaving a noticeably quieter result than any individual stem.
    # Sum in floating point and then perform EBU R128 loudness normalization;
    # loudnorm also imposes a true-peak limit so the mix does not clip.
    mix = (
        f"amix=inputs={len(wavs)}:duration=longest:"
        "dropout_transition=0:normalize=0,"
        "loudnorm=I=-16:TP=-1.5:LRA=11"
    )
    run([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
        *inputs, "-filter_complex", mix,
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
        if not (AUDIO / (naming["mix"] + ".midi")).read_bytes().startswith(b"MThd"):
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
            midi = AUDIO / (naming["mix"] + ".midi")
        elif stem == naming["concert"]:
            midi = AUDIO / (naming["mix"] + ".midi")
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
            for ext in (".mp3", ".midi"):
                item = AUDIO / (naming["mix"] + ext)
                archive.write(item, f"audio/{item.name}")
            for item in sorted((AUDIO / "stems").glob("*.mp3")):
                archive.write(item, f"audio/stems/{item.name}")
            archive.write(BUILD / "build-info.json", "build-info.json")
        viewer = ROOT / "dist" / "viewer"
        if (viewer / "manifest.json").is_file() and (viewer / "timeline.json").is_file():
            archive_name = naming["slug"] + "-viewer-" + naming["revision"] + ".zip"
            with zipfile.ZipFile(PACKAGES / archive_name, "w", zipfile.ZIP_DEFLATED) as archive:
                for item in sorted(viewer.rglob("*")):
                    if item.is_file():
                        archive.write(item, str(item.relative_to(ROOT / "dist")))
                archive.write(BUILD / "build-info.json", "build-info.json")
                mix = AUDIO / (naming["mix"] + ".mp3")
                archive.write(mix, f"audio/{mix.name}")
                for stem in sorted((AUDIO / "stems").glob("*.mp3")):
                    archive.write(stem, f"audio/stems/{stem.name}")
    print("Ready:", naming["pdf_zip"], *( [naming["audio_zip"]] if full else [] ))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_command = commands.add_parser("build")
    build_command.add_argument("--audio", action="store_true")
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
            build(audio=args.audio, font=args.soundfont)
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
