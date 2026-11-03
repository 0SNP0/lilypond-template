#!/usr/bin/env python3
"""Export precise MIDI tempo-map measure boundaries for a synchronized player."""
from __future__ import annotations
import csv
import json
from pathlib import Path
import build as b
import export

def main():
    naming = b.current_names()
    audio_midi = b.AUDIO / (naming["mix"] + ".midi")
    timeline = export.make_timeline(audio_midi)
    if not timeline["measures"]:
        raise RuntimeError("MIDI contains no measures")
    output = b.ROOT / "dist" / "timeline.csv"
    with output.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(stream)
        writer.writerow(["measure_id", "measure_number", "start_tick", "end_tick",
                         "start_ms", "end_ms", "ticks_per_quarter"])
        for measure in timeline["measures"]:
            writer.writerow([measure["id"], measure["number"],
                             measure["start_tick"], measure["end_tick"],
                             measure["start_ms"], measure["end_ms"],
                             timeline["ticks_per_quarter"]])
    (b.ROOT / "dist" / "timeline.json").write_text(
        json.dumps(timeline, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("CSV timeline:", len(timeline["measures"]), "measures:", output)

if __name__ == "__main__":
    main()
