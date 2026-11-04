#!/usr/bin/env python3
"""Derive playback from Fine and D.C. indications in printed music/global.ily.

Run --write after editing navigation marks; --check is called by CI.
Unsupported forms fail loudly instead of silently creating wrong MIDI.
"""
from __future__ import annotations
import argparse
import json
import re
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
ROOT = FRAMEWORK.parent
GLOBAL = ROOT / "music/global.ily"
META = ROOT / "metadata.ily"
MAP = ROOT / "music/playback-map.json"


def infer():
    source = GLOBAL.read_text(encoding="utf-8")
    m = re.search(r"(?m)^global\s*=\s*\{[^\n]*s2\.\*(\d+)", source)
    if not m:
        raise ValueError("Cannot infer number of printed bars")
    printed = int(m.group(1))
    rehearsal = source.split("rehearsalMarks = {", 1)[1].split("\n}", 1)[0]
    index, fine, jump = 0, None, None
    for line in rehearsal.splitlines():
        if not line.rstrip().endswith("|"):
            continue
        repeat = re.search(r"s2\.\*(\d+)\s*\|", line)
        index += int(repeat.group(1)) if repeat else 1
        match = re.search(r'\\textEndMark.*?"([^"]+)"', line)
        if not match:
            continue
        name = match.group(1)
        if name == "Fine":
            if fine is not None:
                raise ValueError("Multiple Fine marks")
            fine = index
        elif name.startswith(("D.C.", "D.S.")):
            if jump is not None:
                raise ValueError("Multiple jump marks")
            jump = name
        else:
            raise ValueError("Unsupported navigation mark: " + name)
    if index != printed:
        raise ValueError(f"Printed {printed} measures but counted {index} in marks")
    if jump is None:
        sections = [{"start": 1, "end": printed}]
        formula = "$opening $bridge"
    elif jump == "D.C. al Fine":
        if fine is None or not 1 <= fine < printed:
            raise ValueError("D.C. al Fine needs an earlier Fine mark")
        sections = [{"start": 1, "end": fine},
                    {"start": fine+1, "end": printed},
                    {"start": 1, "end": fine}]
        formula = "$opening $bridge $opening"
    elif jump == "D.C.":
        sections = [{"start": 1, "end": printed},
                    {"start": 1, "end": printed}]
        formula = "$opening $bridge $opening $bridge"
    else:
        raise ValueError("For D.S., Coda and alternative endings use explicit "
                         "source sections or LilyPond repeat segno")
    return printed, fine, jump, sections, formula


def sync(write=False):
    printed, fine, jump, sections, formula = infer()
    visits = [n for s in sections for n in range(s["start"], s["end"]+1)]
    current = json.loads(MAP.read_text(encoding="utf-8"))
    proposed = dict(current)
    proposed["printed_measures"] = printed
    proposed["playback_sections"] = sections
    proposed["navigation"] = (
        ([{"after_measure": fine, "label": "Fine"}] if fine else []) +
        ([{"after_measure": printed, "label": jump, "jump_to": 1,
           **({"stop_after": fine} if fine and "al Fine" in jump else {})}]
         if jump else [])
    )
    global_text = GLOBAL.read_text(encoding="utf-8")
    m = re.search(r"(globalPlayback\s*=\s*\{\s*\\time\s+\d+/\d+\s+s2\.\*)(\d+)",
                  global_text)
    if not m:
        raise ValueError("Missing globalPlayback")
    new_global = global_text[:m.start(2)] + str(len(visits)) + global_text[m.end(2):]
    meta = META.read_text(encoding="utf-8")
    match = re.search(r"(scorePlayback\s*=\s*#\(define-music-function.*?#\{)(.*?)(#\}\))",
                      meta, re.S)
    if not match:
        raise ValueError("Missing scorePlayback function")
    new_meta = meta[:match.start(2)] + " " + formula + " " + meta[match.end(2):]
    if write:
        MAP.write_text(json.dumps(proposed, ensure_ascii=False, indent=2) + "\n",
                       encoding="utf-8")
        GLOBAL.write_text(new_global, encoding="utf-8")
        META.write_text(new_meta, encoding="utf-8")
        print("Navigation updated directly from printed marks")
    else:
        old_visits = [n for s in current["playback_sections"]
                      for n in range(s["start"], s["end"]+1)]
        if (old_visits != visits or current["printed_measures"] != printed or
            current["navigation"] != proposed["navigation"] or
            global_text != new_global or meta != new_meta):
            raise ValueError("Playback differs from printed navigation: "
                             "run python3 scripts/navigation.py --write")
        print(f"Navigation checked: {printed} printed / {len(visits)} sounding bars")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--write", action="store_true")
    p.add_argument("--check", action="store_true")
    args = p.parse_args()
    sync(write=args.write)
