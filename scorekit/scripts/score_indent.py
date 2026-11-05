"""Measure score indentation using real LilyPond-rendered labels, not guesses.

The probe has the same staff size, fonts and project files as the final PDF
and SVG. The result is cached for the media job through the PDF artifact.
"""
from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

SCRIPTS = Path(__file__).resolve().parent
ROOT = SCRIPTS.parents[1]
CACHE = ROOT / "build" / "score-indent.json"
SOURCE = ROOT / "score.ly"
LAYOUT = ROOT / "scorekit" / "lilypond" / "layout" / "score.ily"
ORCHESTRATION = ROOT / "orchestra.ily"
START_INDENT = 45.0
START_SHORT_INDENT = 28.0
TRIAL_DELTA_MM = 10.0
TRANSLATION = re.compile(r"translate\(\s*([-+\d.]+)[,\s]+([-+\d.]+)\s*\)")
LABEL = re.compile(
    r'(shortInstrumentName|instrumentName)\s*=\s*'
    r'(?:\\markup\s+\\fontsize\s+#-?\d+(?:\.\d+)?\s*)?'
    r'"([^"]+)"'
)


def score_names() -> tuple[set[str], set[str]]:
    content = ORCHESTRATION.read_text(encoding="utf-8")
    names = {"instrumentName": set(), "shortInstrumentName": set()}
    for kind, value in LABEL.findall(content):
        names[kind].add(value)
    return names["instrumentName"], names["shortInstrumentName"]


def label_x_from_svg(file: Path, names: set[str]) -> float | None:
    """SVG glyph groups give exact label origins in LilyPond millimeters."""
    if not names:
        return None
    root = ET.parse(file).getroot()
    locations = []
    for group in root:
        if group.tag.rsplit("}", 1)[-1] != "g":
            continue
        if "".join(group.itertext()).strip() not in names:
            continue
        match = TRANSLATION.search(group.get("transform", ""))
        if match:
            locations.append(float(match.group(1)))
    return min(locations) if locations else None


def layout_left_margin(content: str) -> float:
    """Read the real paper margin (mm); don't silently assume 15 mm."""
    match = re.search(
        r"(?m)^\s*left-margin\s*=\s*(\d+(?:\.\d+)?)\\mm",
        content,
    )
    return float(match.group(1)) if match else 15.0


def derived_indents(
    initial: tuple[float, float],
    baseline: tuple[float | None, float | None],
    trial: tuple[float | None, float | None],
    margin_mm: float,
    trial_delta_mm: float = TRIAL_DELTA_MM,
) -> tuple[float, float]:
    """Find the real sensitivity of leftmost labels to LilyPond indent.

    LilyPond's final ink origin does not move 1 mm for every 1 mm of
    indent. Comparing two *native renders* rather than assuming a slope
    of one prevents an excessive blank gutter. Names are never shortened.
    """
    target = margin_mm + 1.0

    def calculate(start: float, x0: float | None,
                  x1: float | None) -> float:
        if x0 is None or x1 is None:
            return round(start, 2)
        slope = (x0 - x1) / trial_delta_mm
        if not 0.1 <= slope <= 1.5:
            raise RuntimeError(
                f"Unexpected instrument-label displacement {slope:.3f}; "
                "cannot safely calibrate score indentation"
            )
        result = start - (x0 - target) / slope
        return round(max(0.0, result), 2)

    return (
        calculate(initial[0], baseline[0], trial[0]),
        calculate(initial[1], baseline[1], trial[1]),
    )


def score_indents(staff_size: float) -> tuple[float, float]:
    signature = hashlib.sha256()
    for source in (SOURCE, ORCHESTRATION, LAYOUT,
                   ROOT / "scorekit" / "lilypond" / "layout" / "shared.ily"):
        signature.update(source.read_bytes())
    signature.update(str(staff_size).encode())
    signature.update(Path(__file__).read_bytes())
    key = signature.hexdigest()
    if CACHE.is_file():
        cached = json.loads(CACHE.read_text(encoding="utf-8"))
        if cached.get("key") == key:
            return float(cached["first_mm"]), float(cached["later_mm"])

    lilypond = shutil.which("lilypond")
    if lilypond is None:
        raise RuntimeError("LilyPond must be installed to measure staff labels")
    folder = ROOT / "build" / "indent-probe"
    if folder.exists():
        shutil.rmtree(folder)
    folder.mkdir(parents=True)
    full_names, short_names = score_names()

    def probe(first_indent: float, later_indent: float,
              name: str) -> tuple[float | None, float | None]:
        target = folder / name
        target.mkdir(parents=True)
        stem = target / "score"
        env = {**os.environ, "SCORE_STAFF_SIZE": str(staff_size),
               "SCORE_INDENT_MM": str(first_indent),
               "SCORE_SHORT_INDENT_MM": str(later_indent)}
        command = [lilypond, "-dbackend=svg", "-dno-point-and-click",
                   "-o", str(stem), str(SOURCE)]
        completed = subprocess.run(
            command, cwd=ROOT, env=env, capture_output=True, text=True
        )
        if completed.returncode:
            raise RuntimeError(
                "Score indentation probe failed:\\n" +
                completed.stdout[-4000:] + completed.stderr[-4000:]
            )
        pages = sorted(target.glob("score*.svg"))
        if not pages:
            raise RuntimeError("LilyPond did not produce probe SVG pages")
        first_x = label_x_from_svg(pages[0], full_names)
        later_positions = [label_x_from_svg(page, short_names)
                           for page in pages[1:]]
        later_positions = [x for x in later_positions if x is not None]
        return first_x, min(later_positions) if later_positions else None

    baseline = probe(START_INDENT, START_SHORT_INDENT, "baseline")
    trial = probe(START_INDENT - TRIAL_DELTA_MM,
                  START_SHORT_INDENT - TRIAL_DELTA_MM, "trial")
    if baseline[0] is None and full_names:
        raise RuntimeError("Could not locate full instrument names in SVG")
    margin_mm = layout_left_margin(LAYOUT.read_text(encoding="utf-8"))
    first, later = derived_indents(
        (START_INDENT, START_SHORT_INDENT), baseline, trial, margin_mm
    )
    print(f"LilyPond-calibrated indents: {first:g} / {later:g} mm "
          f"(SVG baseline: {baseline}, trial: {trial})", flush=True)
    shutil.rmtree(folder)
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(json.dumps({"key": key, "first_mm": first,
                                 "later_mm": later}, indent=2) + "\n",
                     encoding="utf-8")
    return first, later
