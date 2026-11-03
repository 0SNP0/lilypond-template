#!/usr/bin/env python3
"""Stable staff-content fingerprints, independent of PDF bytes and Git headers."""
from __future__ import annotations
import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INCLUDE = re.compile(r'\\include\s+"([^"]+)"')

def sources(source: Path) -> list[Path]:
    """Only music includes contribute; book titles, revision and layout do not."""
    source = source.resolve()
    if source.name in ("score.ly", "concert-score.ly"):
        root = ROOT / "orchestra.ily"
        included = INCLUDE.findall(root.read_text(encoding="utf-8"))
        included += ["music/global.ily", "music/paired.ily"]
        paths = [ROOT / x for x in included if x.startswith("music/")]
    else:
        content = source.read_text(encoding="utf-8")
        paths = [(source.parent / rel).resolve()
                 for rel in INCLUDE.findall(content)
                 if "/music/" in rel or rel.startswith("music/")]
        # All individual parts include the canonical clock.
        paths.append(ROOT / "music/global.ily")
    return sorted(set(p.resolve() for p in paths))

def normalize(text: str) -> str:
    # LilyPond comments are not music. Preserve all note, rest, dynamics,
    # articulation, markup and transposition tokens, regardless of line breaks.
    tokens = []
    for line in text.splitlines():
        # Ignore percent-comment markers occurring inside quoted markup.
        inside = False
        escaped = False
        cut = len(line)
        for i, char in enumerate(line):
            if char == '"' and not escaped:
                inside = not inside
            if char == '%' and not inside:
                cut = i
                break
            escaped = (char == '\\' and not escaped)
            if char != '\\':
                escaped = False
        cleaned = line[:cut].strip()
        if cleaned:
            tokens.append(cleaned)
    return ' '.join(' '.join(tokens).split())

def staff_fingerprint(source: Path) -> str:
    paths = sources(source)
    if not paths:
        raise ValueError(f"No staff music found for {source}")
    fingerprint = hashlib.sha256()
    fingerprint.update(b"score-staff-content-v3\\0")
    # The displayed notes also depend on the score's written/concert view
    # and on instrument transpositions in its wrapper. Ignore headers and
    # MIDI-only articulation settings.
    wrapper = (ROOT / "orchestra.ily") if source.name in ("score.ly", "concert-score.ly") else source
    transformations = re.findall(r'\\transpose\s+[^\s{}]+\s+[^\s{}]+', wrapper.read_text(encoding="utf-8"))
    fingerprint.update(source.name.encode("utf-8"))
    fingerprint.update(b"\\0")
    fingerprint.update(" ".join(transformations).encode("utf-8"))
    fingerprint.update(b"\\0")
    for path in paths:
        if not path.is_file():
            raise FileNotFoundError(path)
        fingerprint.update(path.relative_to(ROOT).as_posix().encode("utf-8"))
        fingerprint.update(b"\\0")
        fingerprint.update(normalize(path.read_text(encoding="utf-8")).encode("utf-8"))
        fingerprint.update(b"\\0")
    return fingerprint.hexdigest()
