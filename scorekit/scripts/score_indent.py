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


def derived_indents(initial: tuple[float, float],
                    first_x: float | None, later_x: float | None,
                    margin_mm: float) -> tuple[float, float]:
    """Shift the leftmost printed name to margin + 1 mm of breathing room."""
    target = margin_mm + 1.0
    first = max(0.0, initial[0] - (first_x - target)) if first_x is not None else initial[0]
    later = max(0.0, initial[1] - (later_x - target)) if later_x is not None else initial[1]
    return round(first, 2), round(later, 2)


def score_indents(staff_size: float) -> tuple[float, float]:
    signature = hashlib.sha256()
    for source in (SOURCE, ORCHESTRATION, LAYOUT,
                   ROOT / "scorekit" / "lilypond" / "layout" / "shared.ily"):
        signature.update(source.read_bytes())
    signature.update(str(staff_size).encode())
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
    stem = folder / "score"
    env = {**os.environ, "SCORE_STAFF_SIZE": str(staff_size),
           "SCORE_INDENT_MM": str(START_INDENT),
           "SCORE_SHORT_INDENT_MM": str(START_SHORT_INDENT)}
    cmd = [lilypond, "-dbackend=svg", "-dno-point-and-click",
           "-o", str(stem), str(SOURCE)]
    probe = subprocess.run(cmd, cwd=ROOT, env=env, capture_output=True, text=True)
    if probe.returncode:
        raise RuntimeError("Score indentation probe failed:\n" + probe.stdout[-4000:]
                           + probe.stderr[-4000:])
    pages = sorted(folder.glob("score*.svg"))
    if not pages:
        raise RuntimeError("LilyPond did not produce SVG pages for indentation measurement")

    full_names, short_names = score_names()
    first_x = label_x_from_svg(pages[0], full_names)
    # The first page of a dense score contains its first system. Additional
    # pages carry shortened names, which are independent of the musical work.
    later_positions = [label_x_from_svg(page, short_names) for page in pages[1:]]
    later_positions = [x for x in later_positions if x is not None]
    later_x = min(later_positions) if later_positions else None
    if first_x is None and full_names:
        raise RuntimeError("Could not identify full instrument labels in LilyPond SVG")

    margin = re.search(r"(?m)^\s*left-margin\s*=\s*(\d+(?:\.\d+)?)\\mm", LAYOUT.read_text(encoding="utf-8"))
    margin_mm = float(margin.group(1)) if margin else 15.0
    first, later = derived_indents(
        (START_INDENT, START_SHORT_INDENT), first_x, later_x, margin_mm
    )
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(json.dumps({"key": key, "first_mm": first,
                                 "later_mm": later}, indent=2) + "\n",
                     encoding="utf-8")
    print(f"LilyPond-measured score indents: {first:g} / {later:g} mm "
          f"(label origins: {first_x}, {later_x})", flush=True)
    shutil.rmtree(folder)
    return first, later
