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
SCHEMA = "ensemble-assemble-viewer-v1"
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


def make_timeline(file: Path) -> dict:
    """Compute exact MIDI-clock measure intervals, including tempo changes.

    A time-signature change must occur at a measure boundary. Repeats may
    create multiple playback visits and will need an explicit notation map.
    """
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
        out.append({
            "id": f"measure-{number:04d}",
            "number": number,
            "start_tick": tick,
            "end_tick": following,
            "start_ms": round(seconds(tick) * 1000, 3),
            "end_ms": round(seconds(following) * 1000, 3),
        })
        tick = following
        if tick >= max_tick:
            break
    return {
        "schema": SCHEMA,
        "clock_source": file.name,
        "ticks_per_quarter": division,
        "tempo_events": [{"tick": tick, "microseconds_per_quarter": us} for tick, us in tempo_points],
        "time_signature_events": [
            {"tick": tick, "numerator": m[0], "denominator": m[1]}
            for tick, m in meter_points
        ],
        "measures": out,
        "limitations": [
            "The audio player may introduce a small MP3 encoder delay.",
            "Repeated sections need a future occurrence-to-printed-measure mapping.",
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
        '  }\n'
        '}\n'
        f'\\include "{source.as_posix()}"\n',
        encoding="utf-8",
    )
    cmd = [
        lily, "-dbackend=svg", "-dno-point-and-click",
        "-I", str(ROOT), "-o", str(view_dir / base), str(wrapper),
    ]
    env = {**os.environ, "ENSEMBLE_SCORE_VERSION": naming["revision"]}
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


def tag_svg(pages: list[Path], timeline: dict) -> list[dict]:
    """Add stable ID tags to the native SVG BarNumber groups.

    When LilyPond does not expose a recoverable number/coordinate, the
    missing anchor is reported rather than inventing geometric positions.
    """
    anchors: list[dict] = []
    allowed = {m["number"] for m in timeline["measures"]}
    for page_idx, file in enumerate(pages, start=1):
        doc = ET.parse(file)
        root = doc.getroot()
        found = []
        for group in root.iter():
            if group.tag.rsplit("}", 1)[-1] != "g":
                continue
            if "ea-measure-number" not in group.get("class", "").split():
                continue
            content = "".join(group.itertext()).strip()
            matches = re.findall(r"\d+", content)
            if matches:
                number = int(matches[0])
                if number in allowed:
                    found.append((number, group))
        for number, group in found:
            identifier = f"measure-{number:04d}"
            # First annotation only on a page, prevents duplicate IDs.
            if not any(a["measure_id"] == identifier and a["page"] == page_idx for a in anchors):
                group.set("id", identifier)
                group.set("data-measure-id", identifier)
                anchors.append({"measure_id": identifier, "page": page_idx, "element_id": identifier})
        doc.write(file, encoding="utf-8", xml_declaration=True)
    return anchors


def print_digest(pages: list[Path], revision: str) -> str:
    """Provisional render fingerprint, masking the displayed Git revision.

    A comparison across releases must still be treated as a candidate for
    reprinting, not as proof that a musician's paper is interchangeable.
    """
    sha = hashlib.sha256()
    for path in pages:
        data = path.read_bytes().replace(revision.encode(), b"<git-revision>")
        sha.update(struct.pack(">I", len(data)))
        sha.update(data)
    return sha.hexdigest()


def main() -> None:
    naming = b.current_names()
    parts = b.instruments()
    combined = b.combined_parts()
    if VIEWER.exists():
        shutil.rmtree(VIEWER)
    VIEWER.mkdir(parents=True)
    shutil.copy2(ROOT / "viewer" / "index.html", VIEWER / "index.html")
    timeline = make_timeline(b.AUDIO / (naming["mix"] + ".midi"))
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
    views = {}
    notation = {}
    for view_id, source, kind, part in sources:
        pages = render_svg(source, view_id, naming)
        anchors = tag_svg(pages, timeline)
        if kind == "individual":
            music_file = ROOT / "build" / "midi" / (b.part_name(part, naming) + ".midi")
            music_hash = music_digest(music_file)
        elif kind == "combined":
            # Resolve musical dependencies from the part's own LilyPond
            # include statements, not a hardcoded list of instrument names.
            includes = re.findall(
                r'\\include\s+"(?:\\.\\./)+music/([^"]+)"',
                part.read_text(encoding="utf-8"),
            )
            sources = [
                ROOT / "music" / name for name in includes
                if name not in ("global.ily", "paired.ily")
            ]
            if not sources or any(not path.is_file() for path in sources):
                raise RuntimeError("Combined part music sources missing: " + str(part))
            music_hash = digest(json.dumps(
                [digest(path.read_bytes()) for path in sources],
                separators=(",", ":"),
            ).encode())
        else:
            music_hash = music_digest(b.AUDIO / (naming["mix"] + ".midi"))
        print_hash = print_digest(pages, naming["revision"])
        views[view_id] = {
            "kind": kind,
            "source": str(source.relative_to(ROOT)),
            "pages": [str(file.relative_to(VIEWER)) for file in pages],
            "measure_anchors": anchors,
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
            "Every measure ID is shared across all score and part views.",
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
        if view["anchors_found"] != len(timeline["measures"]):
            print(f"WARNING: {name}: recovered {view['anchors_found']} / "
                  f"{len(timeline['measures'])} SVG measure anchors; "
                  "unmatched measures remain available in the JSON/CSV clock")
    print("SVG and synchronization data:", len(views), "views,",
          len(timeline["measures"]), "measures")
    for key, view in views.items():
        print(f"  {key}: {len(view['pages'])} SVG page(s); {view['anchors_found']} measure anchors")


if __name__ == "__main__":
    main()
