#!/usr/bin/env python3
"""Cross-platform LilyPond builder; .ly files, not JSON, are the source of truth."""

from __future__ import annotations

import argparse
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
REPOSITORY = "0SNP0/lilypond-template"
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
    if names != included:
        raise RuntimeError(
            "The orchestra and playable parts must agree: "
            f"missing part wrappers={sorted(included-names)}, "
            f"not present in score={sorted(names-included)}"
        )
    return paths


def names(rev: str) -> dict[str, str]:
    slug = metadata().get("workFileSlug", "")
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", slug):
        raise RuntimeError("Invalid workFileSlug in metadata.ily")
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._+-]*", rev):
        raise RuntimeError(f"Invalid revision for filename: {rev}")
    return dict(slug=slug, revision=rev, score=f"{slug}-{rev}",
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
        ("Оркестр", "ensembleName"),
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
    return "\n".join(f"| {title} | {value(key)} |" for title, key in fields)


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


def compile_lilypond(source: Path, output: Path, version: str,
                     *, score: bool = False) -> None:
    lilypond = shutil.which("lilypond")
    if not lilypond:
        raise RuntimeError("Install native LilyPond; lilypond executable not in PATH")
    output.parent.mkdir(parents=True, exist_ok=True)
    score_size: float | None = None
    attempt = 0
    while True:
        args = [
            lilypond, "-dno-point-and-click",
            "-o", str(output), str(source),
        ]
        env = {"ENSEMBLE_SCORE_VERSION": version}
        if score_size is not None:
            env["ENSEMBLE_SCORE_STAFF_SPACE"] = str(score_size)
        text = run(args, capture=True, environment=env)
        print(text, end="", flush=True)
        overfull = "compressing over-full page" in text
        if "error:" in text.lower() or not Path(str(output) + ".pdf").is_file():
            raise RuntimeError(f"LilyPond failed or produced no PDF: {source}")
        if not overfull:
            return
        if not score:
            raise RuntimeError(f"Overfull A4 part: {source}")
        sizes = re.findall(r"EA_STAFF_SIZE\s+([0-9]+(?:\.[0-9]+)?)", text)
        if not sizes:
            raise RuntimeError(f"Cannot determine current score scale: {source}")
        current = float(sizes[-1])
        next_size = round(current - 0.05, 3)
        if next_size < 0.55 or attempt >= 20:
            raise RuntimeError(f"Cannot fit score on A4 without compression: {source}")
        print(f"Retry score at staff-space {next_size:.3f} mm", flush=True)
        score_size = next_size
        attempt += 1


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
                    "ensemble": metadata().get("ensembleName"),
                    "parts": [p.stem for p in parts],
                    "combined_parts": [p.stem for p in combined_parts()]},
                   ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8")
    naming = names(rev)
    print("Revision:", rev)
    compile_lilypond(ROOT / "score.ly", PDF / naming["score"], rev, score=True)
    score_midi = PDF / (naming["score"] + ".midi")
    if not score_midi.is_file():
        raise RuntimeError("Score did not emit orchestra MIDI")
    shutil.move(str(score_midi), str(AUDIO / (naming["mix"] + ".midi")))
    compile_lilypond(ROOT / "concert-score.ly", PDF / naming["concert"], rev, score=True)
    for source in parts:
        stem = part_name(source, naming)
        compile_lilypond(source, PDF / stem, rev)
        midi = PDF / (stem + ".midi")
        if not midi.is_file():
            raise RuntimeError(f"No concert-pitch MIDI from part {source.name}")
        shutil.move(str(midi), str(BUILD / "midi" / midi.name))
    # PDF-only paired parts; do not duplicate these voices in the audio mix.
    for source in combined_parts():
        compile_lilypond(source, PDF / part_name(source, naming), rev)
    if audio:
        render_audio(parts, font, naming)
    verify(audio=audio)


def locate_soundfont(override: str | None) -> Path:
    candidates = [
        override, os.environ.get("SOUNDFONT"),
        str(ROOT / "soundfonts" / "MS_Basic.sf3"),
        str(ROOT / "soundfonts" / "FluidR3_GM.sf2"),
        "/usr/share/sounds/sf2/FluidR3_GM.sf2",
    ]
    for candidate in candidates:
        if candidate and Path(candidate).is_file():
            return Path(candidate).resolve()
    raise RuntimeError("No SoundFont; use --soundfont PATH or SOUNDFONT")


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
            fluidsynth, "-ni", "-g", "0.25", "-r", "48000",
            "-F", str(wav), str(soundfont), str(BUILD / "midi" / f"{stem}.midi"),
        ])
        run([
            ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
            "-i", str(wav), "-c:a", "libmp3lame", "-q:a", "1",
            str(mp3_dir / f"{stem}.mp3"),
        ])
    # No MP3 generation loss: mix PCM files, not already encoded stems.
    inputs = [arg for path in wavs for arg in ("-i", str(path))]
    mix = (f"amix=inputs={len(wavs)}:duration=longest:"
           "dropout_transition=0:normalize=1,alimiter=limit=0.95")
    run([
        ffmpeg, "-hide_banner", "-loglevel", "error", "-y",
        *inputs, "-filter_complex", mix,
        "-c:a", "libmp3lame", "-q:a", "0", str(AUDIO / (naming["mix"] + ".mp3")),
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


def package() -> None:
    verify(audio=True)
    naming = current_names()
    PACKAGES.mkdir(parents=True, exist_ok=True)
    for old in PACKAGES.glob("*.zip"):
        old.unlink()
    with zipfile.ZipFile(PACKAGES / naming["pdf_zip"], "w", zipfile.ZIP_DEFLATED) as archive:
        for item in sorted(PDF.glob("*.pdf")):
            paired_ids = {part_name(p, naming) for p in combined_parts()}
            sub = ("scores" if item.stem in (naming["score"], naming["concert"])
                   else "parts/combined" if item.stem in paired_ids
                   else "parts")
            archive.write(item, f"{sub}/{item.name}")
        archive.write(BUILD / "build-info.json", "build-info.json")
    with zipfile.ZipFile(PACKAGES / naming["audio_zip"], "w", zipfile.ZIP_DEFLATED) as archive:
        for ext in (".mp3", ".midi"):
            item = AUDIO / (naming["mix"] + ext)
            archive.write(item, f"audio/{item.name}")
        for item in sorted((AUDIO / "stems").glob("*.mp3")):
            archive.write(item, f"audio/stems/{item.name}")
        archive.write(BUILD / "build-info.json", "build-info.json")
    print("Ready:", naming["pdf_zip"], naming["audio_zip"])


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_command = commands.add_parser("build")
    build_command.add_argument("--audio", action="store_true")
    build_command.add_argument("--soundfont")
    commands.add_parser("verify")
    commands.add_parser("package")
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
            package()
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
