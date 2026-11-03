#!/usr/bin/env python3
"""Separate Git-independent music and printed-notation fingerprints."""
from __future__ import annotations
import hashlib
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INCLUDE = re.compile(r'\\include\s+"([^"]+)"')
# Formatting-only commands: changing them must not invalidate music_hash.
PRINT_ONLY = re.compile(
    r'\\(?:once\s+\\)?override\s+[\w.-]+\s*=\s*(?:##[tf]|#[^\s{}]+|[^\s{}]+)'
    r'|\\tweak\s+[\w.-]+\s+(?:##[tf]|#[^\s{}]+)'
    r'|\\(?:omit|hide|revert)\s+[\w.-]+'
    r'|\\(?:voiceOne|voiceTwo|voiceThree|voiceFour|oneVoice|stemUp|stemDown|stemNeutral|break|pageBreak|noBreak)\b')

def sources(source: Path) -> list[Path]:
    source = source.resolve()
    if source.name in ("score.ly", "concert-score.ly"):
        included = INCLUDE.findall((ROOT / "orchestra.ily").read_text(encoding="utf-8"))
        included += ["music/global.ily", "music/paired.ily"]
        paths = [ROOT / rel for rel in included if rel.startswith("music/")]
    else:
        included = INCLUDE.findall(source.read_text(encoding="utf-8"))
        paths = [(source.parent / rel).resolve() for rel in included
                 if "/music/" in rel or rel.startswith("music/")]
        paths.append(ROOT / "music/global.ily")
    return sorted(set(p.resolve() for p in paths))

def normalize(text: str, *, music_only: bool = False) -> str:
    lines = []
    for line in text.splitlines():
        quoted, escaped, cut = False, False, len(line)
        for i, char in enumerate(line):
            if char == '"' and not escaped:
                quoted = not quoted
            if char == "%" and not quoted:
                cut = i
                break
            escaped = char == "\\" and not escaped
            if char != "\\":
                escaped = False
        cleaned = line[:cut]
        if music_only:
            cleaned = PRINT_ONLY.sub("", cleaned)
        if cleaned.strip():
            lines.append(cleaned.strip())
    result = " ".join(" ".join(lines).split())
    if music_only:
        # Rests and silent rehearsal clocks can change textual grouping
        # without changing even one sounding or expressive event.
        for symbol in ("R2.", "s2."):
            result = re.sub(re.escape(symbol) + r"\*(\d+)\s*\|",
                            lambda m: " ".join([symbol + " |"] * int(m.group(1))),
                            result)
    return result

def _digest(version: str, fields: list[tuple[str, str]]) -> str:
    h = hashlib.sha256()
    h.update(version.encode() + b"\0")
    for key, value in fields:
        h.update(key.encode() + b"\0" + value.encode() + b"\0")
    return h.hexdigest()

def music_fingerprint(source: Path) -> str:
    """Sounding/expressive source events; ignores purely visual overrides."""
    fields = [("edition", source.name)]
    for path in sources(source):
        # Generated engravings and paired-staff merging are views, not
        # independent sounding sources.
        if path.name == "paired.ily":
            continue
        if path.name == "percussion.ily" and path.read_text(
                encoding="utf-8").startswith("% AUTO-GENERATED PRINT VIEW"):
            continue
        if not path.is_file():
            raise FileNotFoundError(path)
        fields.append((path.relative_to(ROOT).as_posix(),
                       normalize(path.read_text(encoding="utf-8"), music_only=True)))
    return _digest("score-music-v1", fields)

def print_fingerprint(source: Path) -> str:
    """Music, print wrappers, layout, and credits, but no actual Git SHA."""
    source = source.resolve()
    fields = [("music_hash", music_fingerprint(source))]
    fields.extend((p.relative_to(ROOT).as_posix(),
                   normalize(p.read_text(encoding="utf-8"))) for p in sources(source))
    original = source.read_text(encoding="utf-8")
    before, sep, after = original.partition(r"\score")
    fields.append((source.relative_to(ROOT).as_posix(),
                   normalize(before + sep + after.split(r"\score", 1)[0])))
    layouts = (["orchestra.ily", "layout/score.ily", "layout/shared.ily", "metadata.ily"]
               if source.name in ("score.ly", "concert-score.ly")
               else ["layout/part.ily", "layout/shared.ily", "metadata.ily"])
    fields.extend((rel, normalize((ROOT / rel).read_text(encoding="utf-8")))
                  for rel in layouts)
    return _digest("score-print-v2", fields)

def staff_fingerprint(source: Path) -> str:
    return print_fingerprint(source)
