#!/usr/bin/env python3
"""Work-independent validation of compact print scores and expanded playback.

Optional music/playback-map.json defines playback visits, Fine and D.C. markers.
Rejects accidental duplicate bars and forbidden notes in declared silent bars.
"""
from __future__ import annotations
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MUSIC = ROOT / "music"


def bars(block: str) -> list[str]:
    return [line.strip() for line in block.splitlines()
            if line.rstrip().endswith("|")]


def extract(text: str, suffix: str) -> list[str]:
    pattern = rf"(?ms)^[A-Za-z]\w*{suffix} = (?:\\drummode )?\{{\s*\n(.*?)^\}}"
    match = re.search(pattern, text)
    if not match:
        raise ValueError(f"Missing {suffix} music block")
    return bars(match.group(1))


def main() -> None:
    map_path = MUSIC / "playback-map.json"
    if not map_path.is_file():
        print("No playback-map.json, using linear notation")
        return
    spec = json.loads(map_path.read_text(encoding="utf-8"))
    sections = spec["playback_sections"]
    if not sections:
        raise ValueError("Empty playback sections")
    first = sections[0]
    if first["start"] != 1:
        raise ValueError("Opening section must begin at bar 1")
    break_bar = first["end"]
    printed = spec["printed_measures"]
    if [s["start"] for s in sections] != [1, break_bar + 1, 1] or \
       [s["end"] for s in sections] != [break_bar, printed, break_bar]:
        raise ValueError("Unexpected playback order for D.C. al Fine")
    music_files = [p for p in sorted(MUSIC.glob("*.ily"))
                   if p.name not in ("global.ily", "paired.ily")]
    if not music_files:
        raise ValueError("No music sources")
    per_file: dict[str, list[str]] = {}
    for file in music_files:
        text = file.read_text(encoding="utf-8")
        opening = extract(text, "Opening")
        bridge = extract(text, "Bridge")
        if len(opening) != break_bar or len(bridge) != printed - break_bar:
            raise ValueError(f"{file.name}: expected {break_bar}+{printed-break_bar}, "
                             f"got {len(opening)}+{len(bridge)}")
        if not re.search(r"(?m)^[A-Za-z]\w*MusicPlayback = ", text):
            raise ValueError(f"{file.name} missing explicit playback music")
        per_file[file.name] = opening + bridge
    for item in spec.get("exclusive_measures", []):
        number = item["measure"]
        allowed = set(item["allowed_music_files"])
        if not 1 <= number <= printed:
            raise ValueError(f"Invalid exclusive measure {number}")
        for file, measures in per_file.items():
            bar = measures[number - 1].strip()
            if file in allowed:
                if bar == "R2. |":
                    raise ValueError(f"{file}: expected notes in measure {number}")
            elif bar != "R2. |":
                raise ValueError(f"{file}: unexpected events in measure {number}: {bar}")
    print(f"Music checked: {len(music_files)} sources, {printed} printed bars, "
          f"{sum(s['end']-s['start']+1 for s in sections)} playback bars")


if __name__ == "__main__":
    main()
