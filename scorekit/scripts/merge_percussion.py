#!/usr/bin/env python3
"""Combine any number of simple LilyPond drummode source streams into one print voice.

The independent sources remain canonical for MIDI.  Use --write after
editing their rhythm, and --check in CI to detect stale printed attacks.
The source stems are discovered from the generated file's playback block.
Supports snare/cymbals/bass-drum names and basic 3/4 quarter/eighth pulses;
unsupported rhythms fail loudly rather than silently deleting notes.
"""
from __future__ import annotations
import argparse
import re
from collections import defaultdict
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
ROOT = FRAMEWORK.parent
MUSIC = ROOT / "music"
OUTPUT = MUSIC / "percussion.ily"
STROKES = re.compile(r"(<[a-z][a-z0-9]*(?: [a-z][a-z0-9]*)*>|\b[a-z][a-z0-9]*)(2\.|4|8)")
DURATIONS = {"8": 1, "4": 2, "2.": 6}
DYNAMICS = re.compile(r"\\(pp|mp|mf|ff|sf|p|f)\b")
MARKUP = re.compile(r'\\markup\s+\\italic\s+\{\s*"([^"]+)"\s*\}')


def read_bars(text: str, section: str) -> list[str]:
    found = re.search(r"(?ms)^\w+" + section +
                      r" = \\drummode \{\s*\n(.*?)^\}", text)
    if not found:
        raise ValueError(f"Missing {section} drummode")
    result = []
    for line in found.group(1).splitlines():
        line = line.strip()
        if not line.endswith("|"):
            continue
        group = re.fullmatch(r"R2\.\*(\d+)\s*\|", line)
        if group:
            result.extend(["R2. |"] * int(group.group(1)))
        else:
            result.append(line)
    return result


def hits(line: str) -> list[tuple[int, int, str, str]]:
    # A doubled sustained bass-drum pitch at the same onset is a single
    # percussion attack.  The additional VoiceTwo length is not another hit.
    if "<<" in line:
        line = line.split("{", 1)[1].split("} \\\\ {", 1)[0]
    tick = 0
    result = []
    for m in STROKES.finditer(line):
        duration = DURATIONS[m.group(2)]
        if m.group(1) != "r":
            for note in m.group(1).strip("<>").split():
                result.append((tick, duration, note,
                               line[m.end():m.end()+3]))
        tick += duration
    if tick != 6 and not line.startswith("R2."):
        raise ValueError(f"Unsupported percussion measure: {line} ({tick}/6)")
    return result


def combine(lines: list[str]) -> str:
    events = defaultdict(list)
    dynamics: list[tuple[int, str]] = []
    labels: list[str] = []
    for player, line in enumerate(lines):
        for event in hits(line):
            events[event[0]].append(event)
        dynamics += [(player, value) for value in DYNAMICS.findall(line)]
        labels += MARKUP.findall(line)
    if not events:
        mark = (' ^\\markup \\italic { "' + "; ".join(labels) + '" }'
                if labels else "")
        return "R2." + mark + " |"
    output: list[str] = []
    tick = 0
    for ix, time in enumerate(sorted(events)):
        while tick < time:
            duration = 2 if time-tick >= 2 else 1
            output.append("r4" if duration == 2 else "r8")
            tick += duration
        voices = events[time]
        next_time = sorted(events)[ix+1] if ix+1 < len(events) else 6
        gap = next_time - time
        duration = 6 if gap == 6 and all(e[1] == 6 for e in voices) else (
            2 if gap >= 2 else 1)
        names = list(dict.fromkeys(e[2] for e in voices))
        note = names[0] if len(names) == 1 else "<" + " ".join(names) + ">"
        suffix = ("2." if duration == 6 else "4" if duration == 2 else "8")
        articulation = ("-^" if any("-^" in e[3] for e in voices)
                        else "-!" if any("-!" in e[3] for e in voices) else "")
        rendered = note + suffix + articulation
        if not any(re.match(r"(?:sn|cymc|bd|<)", n) for n in output):
            if dynamics:
                rendered += " \\" + min(dynamics)[1]
            if labels:
                rendered += ' ^\\markup \\italic { "' + "; ".join(labels) + '" }'
            grace = re.search(r"\\acciaccatura\s*\{[^{}]*\}", " ".join(lines))
            if grace:
                rendered = grace.group(0) + " " + rendered
            if r"\<" in lines[0]:
                rendered += r" \<"
        output.append(rendered)
        tick += duration
    while tick < 6:
        duration = 2 if 6-tick >= 2 else 1
        output.append("r4" if duration == 2 else "r8")
        tick += duration
    return " ".join(output) + " |"


def input_sources(output_text: str) -> list[Path]:
    playback = output_text.split("percussionKitPlayback =", 1)[-1]
    names = re.findall(r"\\(\w+MusicPlayback)\b", playback)
    if not names:
        raise ValueError("Percussion playback sources not found")
    files = []
    for name in names:
        matches = [p for p in MUSIC.glob("*.ily")
                   if re.search(r"(?m)^" + re.escape(name) + r"\s*=", p.read_text())]
        if len(matches) != 1:
            raise ValueError(f"Cannot resolve independent source {name}: {matches}")
        files.append(matches[0])
    return files


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path, default=OUTPUT)
    args = parser.parse_args()
    original = args.output.read_text(encoding="utf-8")
    paths = input_sources(original)
    tracks = []
    for path in paths:
        source = path.read_text(encoding="utf-8")
        tracks.append(read_bars(source, "Opening") + read_bars(source, "Bridge"))
    if len({len(t) for t in tracks}) != 1:
        raise ValueError("Percussion source lengths disagree")
    expected = [combine(bars) for bars in zip(*tracks)]
    opening = re.search(r"(?ms)^percussionKitMusic = \\drummode \{\s*\n(.*?)^\}",
                        original)
    if not opening:
        raise ValueError("Percussion print is not one drummode voice")
    actual = []
    for line in opening.group(1).splitlines():
        row = line.strip()
        if not row.endswith("|"):
            continue
        group = re.fullmatch(r"R2\.\*(\d+)\s*\|", row)
        if group:
            actual.extend(["R2. |"] * int(group.group(1)))
        else:
            actual.append(row)
    if args.check:
        if len(actual) != len(expected):
            raise ValueError(f"Expected {len(expected)} print measures, got {len(actual)}")
        for i, (a, e) in enumerate(zip(actual, expected), 1):
            def onsets(s: str) -> set[tuple[int, str]]:
                return {(t, note) for t, _, note, _ in hits(s)}
            # The first pass uses exact rhythms; at simultaneous attacks,
            # a chord is one rhythmic onset but several instrument notes.
            if onsets(a) != onsets(e):
                raise ValueError(f"Percussion merged attack mismatch in bar {i}: {a}")
        print(f"Percussion validated: one voice, {len(expected)} measures")
    if args.write:
        print_rows = []
        number = 0
        while number < len(expected):
            if expected[number] == "R2. |":
                stop = number
                while stop < len(expected) and expected[stop] == "R2. |":
                    stop += 1
                length = stop - number
                if length > 1:
                    print_rows.append(f"  % Bars {number+1}–{stop}")
                    print_rows.append(f"  R2.*{length} |")
                    number = stop
                    continue
            if number % 4 == 0:
                print_rows.append(f"  % Bars {number+1}–{min(number+4, len(expected))}")
            print_rows.append("  " + expected[number])
            number += 1
        body = "\n".join(print_rows)
        replacement = (r"percussionKitMusic = \drummode {" +
                       "\n  \\clef percussion\n  \\time 3/4\n" + body + "\n}")
        rebuilt = original[:opening.start()] + replacement + original[opening.end():]
        args.output.write_text(rebuilt, encoding="utf-8")
        print(f"Regenerated {args.output}")


if __name__ == "__main__":
    main()
