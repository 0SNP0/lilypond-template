#!/usr/bin/env python3
"""Check score structure using optional work-specific music/playback-map.json.

All musical exceptions and assertions are stored in the parent score project;
this reusable checker contains no composer, instrument-pair, or bar-number data.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
ROOT = FRAMEWORK.parent
MUSIC = ROOT / "music"


def bars(block: str) -> list[str]:
    result: list[str] = []
    for line in block.splitlines():
        line = line.strip()
        if not line.endswith("|"):
            continue
        match = re.fullmatch(r"R2\.\*(\d+)\s*\|", line)
        if match:
            result.extend(["R2. |"] * int(match.group(1)))
        else:
            result.append(line)
    return result


def extract(text: str, suffix: str) -> list[str]:
    pattern = rf"(?ms)^[A-Za-z]\w*{suffix} = (?:\\drummode )?\{{\s*\n(.*?)^\}}"
    match = re.search(pattern, text)
    if not match:
        raise ValueError(f"Missing {suffix} music section")
    return bars(match.group(1))


def main() -> None:
    music_files = [p for p in sorted(MUSIC.glob("*.ily"))
                   if p.name not in ("global.ily", "paired.ily", "drum-kit.ily")]
    if not music_files:
        raise ValueError("No editable music/*.ily instrumental sources")

    paired = MUSIC / "paired.ily"
    if paired.is_file() and r"\partCombine" not in paired.read_text(encoding="utf-8"):
        raise ValueError("music/paired.ily must combine independent source parts")

    config = MUSIC / "playback-map.json"
    if not config.is_file():
        print(f"Music sources found: {len(music_files)}; no optional playback map")
        return
    spec = json.loads(config.read_text(encoding="utf-8"))
    printed = int(spec["printed_measures"])
    if printed <= 0:
        raise ValueError("printed_measures must be positive")
    sections = spec.get("playback_sections") or [{"start": 1, "end": printed}]
    if not all(isinstance(s.get("start"), int) and
               isinstance(s.get("end"), int) and
               1 <= s["start"] <= s["end"] <= printed for s in sections):
        raise ValueError("Playback sections refer outside the printed score")
    visits = sum(s["end"] - s["start"] + 1 for s in sections)

    for name in spec.get("forbid_duplicate_music_sources", []):
        if (MUSIC / (name + ".ily")).exists():
            raise ValueError(f"Duplicate canonical source music/{name}.ily")

    split = spec.get("source_section_split")
    per_file: dict[str, list[str]] = {}
    if split is not None:
        split = int(split)
        if not 0 < split < printed:
            raise ValueError("source_section_split must be inside printed score")
        for path in music_files:
            src = path.read_text(encoding="utf-8")
            opening, bridge = extract(src, "Opening"), extract(src, "Bridge")
            if len(opening) != split or len(bridge) != printed - split:
                raise ValueError(
                    f"{path.name}: expected {split}+{printed-split} measures, "
                    f"found {len(opening)}+{len(bridge)}")
            if not re.search(r"(?m)^[A-Za-z]\w*MusicPlayback = ", src):
                raise ValueError(f"Missing playback binding in {path.name}")
            per_file[path.name] = opening + bridge

    for item in spec.get("exclusive_measures", []):
        number, allowed = int(item["measure"]), set(item["allowed_music_files"])
        if not 1 <= number <= printed:
            raise ValueError(f"Invalid exclusive measure {number}")
        for file, measures in per_file.items():
            bar = measures[number - 1].strip()
            if file in allowed and bar == "R2. |":
                raise ValueError(f"{file}: no music in exclusive measure {number}")
            if file not in allowed and bar != "R2. |":
                raise ValueError(f"{file}: forbidden music in measure {number}: {bar}")

    for stem, measure_numbers in spec.get("solo_part_rests", {}).items():
        file = stem + ".ily"
        if file not in per_file:
            raise ValueError(f"Unknown solo part {file}; configure source_section_split")
        for number in measure_numbers:
            if not 1 <= number <= printed or per_file[file][number - 1] != "R2. |":
                raise ValueError(f"Solo rest regression: {stem}:{number}")

    for stem, marks in spec.get("import_text_marks", {}).items():
        file = stem + ".ily"
        if file not in per_file:
            raise ValueError(f"Unknown text-mark part {file}")
        for number, word in marks.items():
            number = int(number)
            if not 1 <= number <= printed or f'"{word}"' not in per_file[file][number-1]:
                raise ValueError(f"Missing text mark {word}: {stem}:{number}")

    barline = spec.get("required_final_barline")
    if barline is not None:
        global_text = (MUSIC / "global.ily").read_text(encoding="utf-8")
        if fr'\bar "{barline}"' not in global_text:
            raise ValueError(f"Expected final barline {barline}")

    if spec.get("validate_navigation"):
        subprocess.run([sys.executable, str(FRAMEWORK / "scripts/navigation.py"),
                        "--check"], check=True)
    drum_kit = MUSIC / "drum-kit.ily"
    if drum_kit.is_file() and drum_kit.read_text(
            encoding="utf-8").startswith("% AUTO-GENERATED PRINT VIEW"):
        subprocess.run([sys.executable, str(FRAMEWORK / "scripts/merge_percussion.py"),
                        "--check"], check=True)
    print(f"Music checked: {len(music_files)} sources, "
          f"{printed} printed bars, {visits} playback bars")


if __name__ == "__main__":
    main()
