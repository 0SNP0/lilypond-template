"""Universal audio defaults for printed views.

Part-specific information lives in the parent score's LilyPond includes,
or optionally in music/view-audio-map.json. ScoreKit contains no fixed
instrument lists, pairing rules or composer's arrangements.
"""
from __future__ import annotations

import json
import re
from pathlib import Path


def load_audio_overrides(root: Path) -> dict[str, list[str]]:
    file = root / "music" / "view-audio-map.json"
    if not file.is_file():
        return {}
    result = json.loads(file.read_text(encoding="utf-8"))
    if not isinstance(result, dict):
        raise ValueError("view-audio-map.json must be an object")
    for key, ids in result.items():
        if not isinstance(key, str) or not key or not isinstance(ids, list) or not ids or (
                not all(isinstance(item, str) and item for item in ids)):
            raise ValueError(f"Invalid audio tracks for view {key!r}")
    return result


def infer_audio_ids(view_id: str, kind: str, source: Path,
                    audio_ids: set[str],
                    overrides: dict[str, list[str]] | None = None) -> list[str]:
    """Choose all sound sources for a view, verifying they exist.

    A combined LilyPond part normally includes its constituent music/*.ily
    files, so its playback defaults can be inferred without hardcoding names.
    """
    overrides = overrides or {}
    if view_id in overrides:
        ids = overrides[view_id]
    elif kind == "combined":
        text = source.read_text(encoding="utf-8")
        includes = re.findall(
            r'\\include\s+"(?:[^"\r\n]*/)?music/([^"/]+)\.ily"',
            text,
        )
        ids = list(dict.fromkeys(stem for stem in includes if stem in audio_ids))
        if len(ids) < 2:
            ids = ["mix"] if "mix" in audio_ids else []
    elif kind == "individual":
        ids = [source.stem]
    else:
        ids = ["mix"] if "mix" in audio_ids else []

    if len(ids) != len(set(ids)):
        raise ValueError(f"Duplicate audio tracks in view {view_id}: {ids}")
    missing = set(ids) - audio_ids
    if missing:
        raise ValueError(f"View {view_id} references missing audio tracks: {sorted(missing)}")
    if "mix" in ids and len(ids) > 1:
        raise ValueError(f"View {view_id} cannot combine full mix with separate tracks")
    return list(ids)
