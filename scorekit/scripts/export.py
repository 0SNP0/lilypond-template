#!/usr/bin/env python3
"""Build version-independent notation hashes and SVG + MIDI-timed measure data.

LilyPond is the notation source of truth. No MusicXML re-engraving is used.
"""
from __future__ import annotations

import hashlib
import json
import math
import os
import re
import shutil
import struct
import subprocess
import sys
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import build as b

ROOT = b.ROOT
VIEWER = ROOT / "dist" / "viewer"
SCHEMA = "score-viewer-v2"
SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)


def digest(blob: bytes) -> str:
    return hashlib.sha256(blob).hexdigest()


def read_vlq(data: bytes, at: int) -> tuple[int, int]:
    number = 0
    for _ in range(4):
        if at >= len(data):
            raise ValueError("Truncated MIDI variable-length quantity")
        byte = data[at]
        at += 1
        number = (number << 7) | (byte & 127)
        if byte < 128:
            return number, at
    raise ValueError("Invalid MIDI VLQ")


def midi_events(file: Path) -> tuple[int, list[tuple[int, str, int, bytes]]]:
    """Track-aware SMF reader: ignore track names and other nonmusical text."""
    blob = file.read_bytes()
    if blob[:4] != b"MThd" or len(blob) < 14:
        raise ValueError("Missing MIDI header: " + str(file))
    hlen = struct.unpack_from(">I", blob, 4)[0]
    fmt, tracks, division = struct.unpack_from(">HHH", blob, 8)
    if division & 0x8000:
        raise ValueError("SMPTE MIDI timing is not supported yet")
    if fmt not in (0, 1):
        raise ValueError("Only type 0/1 MIDI supported")
    pos = 8 + hlen
    events: list[tuple[int, str, int, bytes]] = []
    for track in range(tracks):
        if blob[pos:pos+4] != b"MTrk":
            raise ValueError("Missing MIDI track chunk")
        size = struct.unpack_from(">I", blob, pos + 4)[0]
        at, end = pos + 8, pos + 8 + size
        if end > len(blob):
            raise ValueError("Truncated MIDI track")
        tick = 0
        running = 0
        while at < end:
            dt, at = read_vlq(blob, at)
            tick += dt
            status = blob[at]
            if status & 128:
                at += 1
                if status < 240:
                    running = status
            elif running:
                status = running
            else:
                raise ValueError("MIDI running status without previous event")
            if status == 255:
                typ = blob[at]
                at += 1
                count, at = read_vlq(blob, at)
                content = blob[at:at+count]
                at += count
                if typ == 81 and len(content) == 3:
                    events.append((tick, "tempo", track, content))
                elif typ == 88 and len(content) >= 2:
                    events.append((tick, "meter", track, content[:2]))
                continue
            if status in (240, 247):
                count, at = read_vlq(blob, at)
                at += count
                running = 0
                continue
            kind = status & 240
            n = 1 if kind in (192, 208) else 2
            content = blob[at:at+n]
            at += n
            if len(content) != n:
                raise ValueError("Truncated MIDI event")
            events.append((tick, "channel", track, bytes([status]) + content))
        pos = end
    return division, sorted(events, key=lambda e: (e[0], e[2], e[1], e[3]))


def music_digest(file: Path) -> str:
    division, events = midi_events(file)
    normalized = [
        [tick, typ, track, content.hex()]
        for tick, typ, track, content in events
    ]
    return digest(json.dumps([division, normalized], separators=(",", ":")).encode())



def playback_print_map() -> tuple[list[int] | None, int | None]:
    """Optional work-specific repeat map; generic viewer knows no work names."""
    config = ROOT / "music" / "playback-map.json"
    if not config.is_file():
        return None, None
    document = json.loads(config.read_text(encoding="utf-8"))
    printed = int(document["printed_measures"])
    sections = document["playback_sections"]
    playback: list[int] = []
    for section in sections:
        start, end = int(section["start"]), int(section["end"])
        if not 1 <= start <= end <= printed:
            raise ValueError(f"Invalid repeat section {section}")
        playback.extend(range(start, end + 1))
    if not playback or set(playback) != set(range(1, printed + 1)):
        raise ValueError("Playback map omits some printed measures")
    return playback, printed

def make_timeline(file: Path) -> dict:
    """Compute exact MIDI-clock measure intervals, including tempo changes.

    A time-signature change must occur at a measure boundary. Repeats may
    create multiple playback visits and will need an explicit notation map.
    """
    playback_map, printed_measure_count = playback_print_map()
    division, events = midi_events(file)
    timings = [(0, 500000)]
    meters = [(0, 4, 4)]
    max_tick = 0
    for tick, typ, track, content in events:
        if typ == "tempo":
            tempo = int.from_bytes(content, "big")
            if tempo > 0:
                timings.append((tick, tempo))
        elif typ == "meter":
            meters.append((tick, content[0], 1 << content[1]))
        elif typ == "channel":
            max_tick = max(max_tick, tick)
    # Identical meta events in multiple parts are redundant; last at a tick wins.
    tempos = dict(timings)
    tempo_points = sorted(tempos.items())
    meter_points = sorted({m[0]: (m[1], m[2]) for m in meters}.items())

    def seconds(tick: int) -> float:
        prior_tick, micros = 0, 500000
        elapsed = 0.0
        for point, new_micros in tempo_points:
            if point > tick:
                break
            elapsed += (point - prior_tick) * micros / (division * 1_000_000)
            prior_tick, micros = point, new_micros
        return elapsed + (tick - prior_tick) * micros / (division * 1_000_000)

    out = []
    tick = 0
    for number in range(1, 10001):
        current_meter = [(t, nd) for t, nd in meter_points if t <= tick][-1][1]
        numerator, denominator = current_meter
        bar_ticks = division * numerator * 4 // denominator
        if bar_ticks <= 0:
            raise ValueError("Invalid MIDI time signature")
        following = tick + bar_ticks
        change = next((t for t, _ in meter_points if tick < t < following), None)
        if change is not None:
            raise ValueError("Time-signature change mid-measure: unsupported")
        if playback_map is not None and number > len(playback_map):
            raise ValueError("Playback MIDI exceeds the declared repeat structure")
        printed_number = playback_map[number - 1] if playback_map else number
        out.append({
            "id": f"playback-{number:04d}",
            "printed_measure_id": f"measure-{printed_number:04d}",
            "printed_number": printed_number,
            "number": number,
            "start_tick": tick,
            "end_tick": following,
            "start_ms": round(seconds(tick) * 1000, 3),
            "end_ms": round(seconds(following) * 1000, 3),
        })
        tick = following
        if tick >= max_tick:
            break
    if playback_map is not None and len(out) != len(playback_map):
        raise ValueError(f"Expected {len(playback_map)} playback measures; got {len(out)}")
    if printed_measure_count is None:
        printed_measure_count = len(out)
    return {
        "schema": SCHEMA,
        "clock_source": file.name,
        "printed_measures": printed_measure_count,
        "playback_measures": len(out),
        "ticks_per_quarter": division,
        "tempo_events": [{"tick": tick, "microseconds_per_quarter": us} for tick, us in tempo_points],
        "time_signature_events": [
            {"tick": tick, "numerator": m[0], "denominator": m[1]}
            for tick, m in meter_points
        ],
        "measures": out,
        "limitations": [
            "The audio player may introduce a small MP3 encoder delay.",
            "D.C./Fine playback occurrence maps to printed_measure_id.",
            "Fermatas without explicit MIDI tempo changes cannot be inferred.",
        ],
    }


def svg_files(directory: Path, basename: str) -> list[Path]:
    results = list(directory.glob(basename + "*.svg"))
    def rank(path: Path) -> tuple[int, str]:
        m = re.search(r"(?:-page)?(\d+)\.svg$", path.name)
        return (int(m.group(1)) if m else 1, path.name)
    return sorted(results, key=rank)


def render_svg(source: Path, view_id: str, naming: dict) -> list[Path]:
    """Render directly from LilyPond with SVG-only BarNumber metadata."""
    lily = shutil.which("lilypond")
    if not lily:
        raise RuntimeError("LilyPond executable missing")
    view_dir = VIEWER / "svg" / view_id
    view_dir.mkdir(parents=True, exist_ok=True)
    base = naming["slug"] + "-" + view_id + "-" + naming["revision"]
    wrapper = ROOT / "build" / "svg-source" / (view_id + ".ly")
    wrapper.parent.mkdir(parents=True, exist_ok=True)
    # Only SVG gets tiny bar numbers on each measure. These grobs carry
    # a class, so the rendered coordinates can be extracted reliably.
    wrapper.write_text(
        '\\layout {\n'
        '  \\context { \\Score\n'
        '    barNumberVisibility = #all-bar-numbers-visible\n'
        '    \\override BarNumber.break-visibility = ##(#t #t #t)\n'
        '    \\override BarNumber.font-size = #-7\n'
        '    \\override BarNumber.output-attributes = #\'((class . "ea-measure-number"))\n'
        '    \\override CenteredBarNumber.output-attributes = #\'((class . "ea-measure-number"))\n'
        '  }\n'
        '}\n'
        f'\\include "{source.as_posix()}"\n',
        encoding="utf-8",
    )
    cmd = [
        lily, "-dbackend=svg", "-dno-point-and-click",
        "-I", str(ROOT), "-o", str(view_dir / base), str(wrapper),
    ]
    env = {**os.environ, "SCORE_BUILD_REVISION": naming["revision"]}
    if view_id in ("score", "concert-score"):
        size = b.natural_score_staff_size(b.score_staff_count())
        first, later = b.score_instrument_indents(size)
        env["SCORE_INDENT_MM"] = str(first)
        env["SCORE_SHORT_INDENT_MM"] = str(later)
    completed = subprocess.run(cmd, cwd=ROOT, env=env, text=True,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if completed.returncode:
        raise RuntimeError("LilyPond SVG failed: " + str(source) + "\n" + completed.stdout[-5000:])
    print("SVG:", view_id, completed.stdout.strip()[-400:], flush=True)
    results = svg_files(view_dir, base)
    if not results:
        raise RuntimeError("No SVG pages produced: " + str(source))
    renamed = []
    for number, path in enumerate(results, start=1):
        target = view_dir / f"page-{number:03d}.svg"
        path.rename(target)
        renamed.append(target)
    return renamed


def _svg_translation(transform: str) -> tuple[float, float]:
    match = re.search(r"translate\(\s*(-?[\d.]+)[,\s]+(-?[\d.]+)\s*\)", transform)
    return (float(match.group(1)), float(match.group(2))) if match else (0., 0.)


def _svg_staff_geometry(root: ET.Element) -> tuple[list[tuple[float, float, float, float]],
                                                       list[tuple[float, float]]]:
    """Extract native LilyPond staff-lines and barline rectangles.

    Coordinates are SVG viewBox units, not screenshots or guessed spacing.
    Staff lines: five consecutive horizontal SVG lines with 1-ish-unit gaps.
    Bar-lines: tall, narrow rectangles that align to a staff's top line.
    """
    horizontal: list[tuple[float, float, float]] = []
    vertical: list[tuple[float, float, float]] = []
    for group in root:
        if group.tag.rsplit("}", 1)[-1] != "g":
            continue
        gx, gy = _svg_translation(group.get("transform", ""))
        for element in group:
            name = element.tag.rsplit("}", 1)[-1]
            if name == "line":
                x1 = gx + float(element.get("x1", "0"))
                x2 = gx + float(element.get("x2", "0"))
                y1 = gy + float(element.get("y1", "0"))
                y2 = gy + float(element.get("y2", "0"))
                if abs(y1 - y2) < 0.02 and x2 - x1 > 15:
                    horizontal.append((y1, x1, x2))
            elif name == "rect":
                width = float(element.get("width", "0"))
                height = float(element.get("height", "0"))
                if 0.05 < width < 0.40 and 3.7 < height < 5.4:
                    vertical.append((gx + float(element.get("x", "0")),
                                     gy + float(element.get("y", "0")), height))
    horizontal.sort()
    staves: list[tuple[float, float, float, float]] = []
    i = 0
    while i <= len(horizontal) - 5:
        group = horizontal[i:i + 5]
        gaps = [group[k + 1][0] - group[k][0] for k in range(4)]
        if (all(0.65 < value < 1.36 for value in gaps)
                and max(x[1] for x in group) - min(x[1] for x in group) < 0.25
                and max(x[2] for x in group) - min(x[2] for x in group) < 0.25):
            staves.append((group[0][0], group[-1][0],
                           min(x[1] for x in group), max(x[2] for x in group)))
            i += 5
        else:
            i += 1
    return staves, [(x, y) for x, y, _height in vertical]


def _svg_measure_regions(
    staff: list[tuple[float, float, float, float]],
    bars: list[tuple[float, float]],
    labels: list[tuple[int, float, float]],
    kind: str,
    page_idx: int,
    carry_number: int | None = None,
) -> tuple[list[dict], int | None]:
    """Attach LilyPond's end-of-system bar number to the NEXT system.

    A BarNumber at the far right of a system names the *following* measure.
    That measure is printed at the far left of the next system, where LilyPond
    may omit a duplicate number. This applies to ordinary notes and compressed
    multimeasure rests alike, including across a page break.
    """
    if not staff:
        return [], carry_number

    if kind in ("score", "concert-score"):
        systems = {0: (min(s[0] for s in staff),
                       max(s[1] for s in staff),
                       min(s[2] for s in staff), max(s[3] for s in staff))}
        rows = {0: labels}
        carry_number = None
    else:
        systems = dict(enumerate(staff))
        rows: dict[int, list[tuple[int, float, float]]] = {}
        for number, x, y in labels:
            system = min(systems, key=lambda k: abs(y - systems[k][0]))
            if abs(y - systems[system][0]) < 11:
                rows.setdefault(system, []).append((number, x, y))

    areas: list[dict] = []

    def add(number: int, left: float, right: float,
            top: float, bottom: float) -> None:
        if right - left < .3:
            return
        areas.append({
            "measure_id": f"measure-{number:04d}", "page": page_idx,
            "x": round(left, 3), "y": round(top - .4, 3),
            "width": round(right - left, 3),
            "height": round(bottom - top + .8, 3),
        })

    for system in sorted(systems, key=lambda key: systems[key][0]):
        top, bottom, left, right = systems[system]
        markers = sorted(rows.get(system, []), key=lambda value: value[1])
        boundaries = sorted({round(x, 3) for x, y in bars
                             if abs(y - top) < .42 and left - .8 <= x <= right + .8}
                            | {round(left, 3), round(right, 3)})
        clean: list[float] = []
        for x in boundaries:
            if clean and x - clean[-1] < .4:
                clean[-1] = x
            else:
                clean.append(x)
        if len(clean) < 2:
            continue

        if kind not in ("score", "concert-score") and carry_number is not None:
            # A page break can explicitly repeat the measure number at the
            # system start. Do not produce a second copy in that case.
            labeled_at_start = any(
                number == carry_number and x <= left + 1.5
                for number, x, _y in markers
            )
            if not labeled_at_start:
                end = min((x for x in clean if x > left + .3), default=right)
                add(carry_number, left, end, top, bottom)
            carry_number = None

        for number, x, _y in markers:
            closest = min(clean, key=lambda value: abs(value - x))
            if x <= left + 1.5:
                following = [value for value in clean if value > left + .3]
                if following:
                    add(number, left, min(following), top, bottom)
            elif abs(x - closest) < .55:
                next_values = [value for value in clean if value > closest + .3]
                if next_values:
                    add(number, closest, min(next_values), top, bottom)
                elif kind not in ("score", "concert-score"):
                    # This BarNumber belongs to the first physical measure
                    # of the NEXT system, not the last of this one.
                    carry_number = number
                else:
                    prev = [value for value in clean if value < closest - .3]
                    if prev:
                        add(number, max(prev), closest, top, bottom)
            else:
                # CenteredBarNumber labels a real measure inside a system.
                begin = max((v for v in clean if v <= x), default=left)
                finish = min((v for v in clean if v > x), default=right)
                add(number, begin, finish, top, bottom)

    return areas, carry_number


def _clean_svg(root: ET.Element, staves: list[tuple[float, float, float, float]],
               revision: str) -> list[float]:
    """The web viewer supplies its own centered title and release metadata.

    Remove the PDF book-title, running headers and Git-version footer.
    Keep the notes, rehearsal marks and the SVG-only measure identifiers.
    """
    viewbox = [float(n) for n in root.get("viewBox", "0 0 210 297").split()]
    # A footer can be only a few millimeters below the final stave (in
    # dense single-page percussion parts), so geometry alone is insufficient.
    # Discard the actual Git-revision text before applying margin trimming.
    for group in list(root):
        if group.tag.rsplit("}", 1)[-1] != "g":
            continue
        if revision and revision in "".join(group.itertext()):
            root.remove(group)
    if not staves:
        return viewbox
    top = min(s[0] for s in staves)
    bottom = max(s[1] for s in staves)
    for group in list(root):
        if group.tag.rsplit("}", 1)[-1] != "g":
            continue
        if group.get("data-measure-id"):
            continue
        text = "".join(group.itertext()).strip()
        if not text:
            continue
        _x, y = _svg_translation(group.get("transform", ""))
        if y < top - 4 or y > bottom + 9:
            root.remove(group)
    # Trim empty title/footer paper without enlarging or distorting staves.
    first = max(viewbox[1], top - 9)
    last = min(viewbox[1] + viewbox[3], bottom + 12)
    if last > first + 10:
        viewbox[1], viewbox[3] = first, last - first
        root.set("viewBox", " ".join(f"{x:.4f}" for x in viewbox))
        old_width = re.match(r"([\d.]+)mm", root.get("width", ""))
        if old_width and viewbox[2] > 0:
            root.set("height", f"{float(old_width.group(1))*viewbox[3]/viewbox[2]:.2f}mm")
    return viewbox


def tag_svg(pages: list[Path], timeline: dict, kind: str,
            revision: str) -> tuple[list[dict], list[dict], dict]:
    """Index native SVG measure numbers AND real barline-to-barline regions."""
    anchors: list[dict] = []
    regions: list[dict] = []
    page_boxes: dict[str, list[float]] = {}
    allowed = {m["printed_number"] for m in timeline["measures"]}
    carry_number: int | None = None
    for page_idx, file in enumerate(pages, start=1):
        doc = ET.parse(file)
        root = doc.getroot()
        labels: list[tuple[int, float, float]] = []
        for group in root.iter():
            if group.tag.rsplit("}", 1)[-1] != "g":
                continue
            if "ea-measure-number" not in group.get("class", "").split():
                continue
            content = "".join(group.itertext()).strip()
            matches = re.findall(r"\d+", content)
            if not matches:
                continue
            number = int(matches[0])
            if number not in allowed:
                continue
            identifier = f"measure-{number:04d}"
            if any(a["measure_id"] == identifier and a["page"] == page_idx for a in anchors):
                continue
            group.set("id", identifier)
            group.set("data-measure-id", identifier)
            anchors.append({"measure_id": identifier, "page": page_idx,
                            "element_id": identifier})
            child = next(iter(group), None)
            if child is not None:
                x, y = _svg_translation(child.get("transform", ""))
                labels.append((number, x, y))
        staves, barlines = _svg_staff_geometry(root)
        found, carry_number = _svg_measure_regions(
            staves, barlines, labels, kind, page_idx, carry_number
        )
        regions.extend(found)
        page_boxes[str(page_idx)] = _clean_svg(root, staves, revision)
        doc.write(file, encoding="utf-8", xml_declaration=True)
    if not regions:
        print(f"WARNING: {kind}: no safe barline areas recovered; "
              "click-to-seek remains available through the timeline slider")
    return anchors, regions, page_boxes



def main() -> None:
    naming = b.current_names()
    parts = b.instruments()
    combined = b.combined_parts()
    if VIEWER.exists():
        shutil.rmtree(VIEWER)
    VIEWER.mkdir(parents=True)
    shutil.copy2(b.FRAMEWORK / "viewer" / "index.html", VIEWER / "index.html")
    timeline = make_timeline(b.BUILD / "midi" / (naming["mix"] + ".midi"))
    (VIEWER / "timeline.json").write_text(
        json.dumps(timeline, indent=2, ensure_ascii=False) + "\n", encoding="utf-8",
    )
    sources = [
        ("score", ROOT / "score.ly", "score", None),
        ("concert-score", ROOT / "concert-score.ly", "concert-score", None),
    ] + [
        (part.stem, part, "individual", part) for part in parts
    ] + [
        ("combined-" + part.stem, part, "combined", part) for part in combined
    ]
    from notation_hash import music_fingerprint, print_fingerprint
    views = {}
    notation = {}
    for view_id, source, kind, part in sources:
        pages = render_svg(source, view_id, naming)
        anchors, regions, page_boxes = tag_svg(pages, timeline, kind, naming["revision"])
        if kind in ("score", "concert-score"):
            expected = timeline["printed_measures"]
            covered = len({a["measure_id"] for a in regions})
            if covered != expected:
                raise RuntimeError(
                    f"Interactive {view_id} has {covered}/{expected} "
                    "barline regions; refusing an inaccurate viewer export")
        for page in pages:
            if naming["revision"] in page.read_text(encoding="utf-8"):
                raise RuntimeError(f"SVG still contains a Git-version footer: {page}")
        music_hash = music_fingerprint(source)
        print_hash = print_fingerprint(source)
        views[view_id] = {
            "kind": kind,
            "source": str(source.relative_to(ROOT)),
            "pages": [str(file.relative_to(VIEWER)) for file in pages],
            "measure_anchors": anchors,
            "measure_areas": regions,
            "page_viewboxes": page_boxes,
            "anchors_found": len({a["measure_id"] for a in anchors}),
        }
        if kind == "score":
            pdf_basename = naming["score"]
        elif kind == "concert-score":
            pdf_basename = naming["concert"]
        else:
            pdf_basename = b.part_name(part, naming)
        notation[view_id] = {
            "kind": kind,
            "pdf": pdf_basename + ".pdf",
            "music_hash": music_hash,
            "print_hash": print_hash,
        }
    manifest = {
        "schema": SCHEMA,
        "revision": naming["revision"],
        "work_slug": naming["slug"],
        "work_title": b.metadata().get("workTitle", naming["slug"]),
        "orchestra_name": b.metadata().get("orchestraName", ""),
        "audio": "../audio/" + naming["mix"] + ".mp3",
        "audio_tracks": [
            {
                "id": "orchestra",
                "label": "Весь оркестр",
                "path": "../audio/" + naming["mix"] + ".mp3",
            },
            *[
                {
                    "id": part.stem,
                    "label": part.stem.replace("-", " ").title(),
                    "path": "../audio/stems/" + b.part_name(part, naming) + ".mp3",
                }
                for part in parts
            ],
        ],
        "shared_timeline": "timeline.json",
        "views": views,
        "notes": [
            "Each SVG uses printed measure IDs. Playback measures map via printed_measure_id.",
            "Only recovered LilyPond SVG anchors have a geometric target; missing anchors are never fabricated.",
            "Audio tracks share the same MIDI-derived measure timeline; MP3 delay is not compensated.",
        ],
    }
    (VIEWER / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8",
    )
    if len(manifest["audio_tracks"]) != 1 + len(parts):
        raise RuntimeError("Audio track manifest is incomplete")
    for track in manifest["audio_tracks"]:
        target = (VIEWER / track["path"]).resolve()
        if not target.is_file():
            raise RuntimeError("Missing viewer audio track: " + str(target))
    for name, view in views.items():
        if view["anchors_found"] != timeline["printed_measures"]:
            print(f"WARNING: {name}: recovered {view['anchors_found']} / "
                  f"{timeline['printed_measures']} SVG measure anchors; "
                  "unmatched measures remain available in the JSON/CSV clock")
    print("SVG and synchronization data:", len(views), "views,",
          len(timeline["measures"]), "measures")
    for key, view in views.items():
        print(f"  {key}: {len(view['pages'])} SVG page(s); "
              f"{view['anchors_found']} measure anchors, "
              f"{len(view['measure_areas'])} barline hit regions")


if __name__ == "__main__":
    main()
