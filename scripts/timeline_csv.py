#!/usr/bin/env python3
"""Generate a shared measure clock and one CSV per instrumental view.

MIDI clock is shared by all synchronized stems. We do not derive bar lines
from note-on events, which would lose silent measures.
"""
from __future__ import annotations
import csv
import json
from pathlib import Path
import build as b
import export

def write_csv(path: Path, timeline: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(stream)
        writer.writerow(["measure_id", "measure_number", "start_tick", "end_tick",
                         "start_ms", "end_ms", "ticks_per_quarter"])
        for measure in timeline["measures"]:
            writer.writerow([measure["id"], measure["number"],
                             measure["start_tick"], measure["end_tick"],
                             measure["start_ms"], measure["end_ms"],
                             timeline["ticks_per_quarter"]])

def main() -> None:
    naming = b.current_names()
    timeline = export.make_timeline(b.AUDIO / (naming["mix"] + ".midi"))
    if not timeline["measures"]:
        raise RuntimeError("No MIDI measure boundaries")
    dist = b.ROOT / "dist"
    (dist / "timeline.json").write_text(
        json.dumps(timeline, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    write_csv(dist / "timeline.csv", timeline)
    parts = b.instruments()
    combined = b.combined_parts()
    ids = ["score", "concert-score", *[part.stem for part in parts],
           *["combined-" + part.stem for part in combined]]
    for name in ids:
        write_csv(dist / "timelines" / (name + ".csv"), timeline)
        write_csv(dist / "viewer" / "csv" / (name + ".csv"), timeline)
    print(f"CSV timeline: {len(timeline['measures'])} measures, {len(ids)} views")

if __name__ == "__main__":
    main()
