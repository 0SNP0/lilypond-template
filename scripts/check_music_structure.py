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
                   if p.name not in ("global.ily", "paired.ily", "percussion.ily")]
    if not music_files:
        raise ValueError("No music sources")
    # A combined staff must reference the individual voices, never duplicate
    # a second 152-measure notation file (shared source of truth).
    forbidden = ("flutes-1-2", "oboes-1-2", "clarinets-in-a-1-2",
                 "bassoons-1-2", "horns-1-3", "horns-2-4",
                 "trumpets-1-2", "trombones-1-2", "trombone-3-and-tuba")
    for stem in forbidden:
        if (MUSIC / (stem + ".ily")).exists():
            raise ValueError(f"Duplicate paired notes: music/{stem}.ily")
    pairs = (MUSIC / "paired.ily").read_text(encoding="utf-8")
    if r"\partCombine" not in pairs:
        raise ValueError("Paired desks must combine the solo source parts")

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
    # Work-specific assertions for explicitly designated solo passages.
    # Prevent doubled notes from returning to the non-playing desk.
    for stem, measure_numbers in spec.get("solo_part_rests", {}).items():
        file = stem + ".ily"
        if file not in per_file:
            raise ValueError(f"Unknown solo part {file}")
        for number in measure_numbers:
            if not 1 <= number <= printed:
                raise ValueError(f"Invalid solo-only measure {stem}: {number}")
            if per_file[file][number - 1].strip() != "R2. |":
                raise ValueError(
                    f"Solo-only split regression: {stem}, measure {number}: "
                    f"{per_file[file][number - 1]}")

    # MusicXML other-dynamics is not a GM dynamic level.  Keep its
    # expressive words as visible italic markup in the printed source.
    for stem, expected in spec.get("import_text_marks", {}).items():
        source = stem + ".ily"
        if source not in per_file:
            raise ValueError(f"Unknown import text source {source}")
        for measure_string, word in expected.items():
            number = int(measure_string)
            if not 1 <= number <= printed:
                raise ValueError(f"Invalid text marking position: {source}:{number}")
            if f'"{word}"' not in per_file[source][number - 1]:
                raise ValueError(
                    f"Missing MusicXML other-dynamics: {source}:{number}:{word}")

    printed_global = (MUSIC / "global.ily").read_text(encoding="utf-8")
    if '\\bar "||"' not in printed_global:
        raise ValueError("Missing double barline at the end of the printed score")

    print(f"Music checked: {len(music_files)} sources, {printed} printed bars, "
          f"{sum(s['end']-s['start']+1 for s in sections)} playback bars")


if __name__ == "__main__":
    main()
