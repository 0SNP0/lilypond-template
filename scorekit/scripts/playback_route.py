"""Recover the printed measure route from MIDI rehearsal markers.

No work-specific repeat or instrument names occur here. LilyPond writes MIDI
marker meta events for \mark commands through Mark_performer. Mark the start
of a passage with scorekit-bar:N; intermediate measures increment naturally.
This is opt-in until its LilyPond integration is validated independently.
"""
from __future__ import annotations

import re

ANCHOR = re.compile(r"^scorekit-bar:([1-9][0-9]*)$")


def marker_route(
    events: list[tuple[int, str, int, bytes]],
    bar_starts: list[int],
    *,
    legacy_route: list[int] | None = None,
    legacy_printed: int | None = None,
) -> tuple[list[int], int] | None:
    """Return (played -> printed measure numbers, printed count), or None.

    Markers belong to exact MIDI bar starts and must start at bar 1.
    Repeated sections need new markers only at discontinuities. If there is
    an existing work-specific map, fail rather than silently disagree with it.
    """
    markers: dict[int, int] = {}
    saw_scorekit_marker = False
    for tick, kind, _track, data in events:
        if kind != "marker":
            continue
        label = data.decode("utf-8", errors="replace").strip()
        if not label.startswith("scorekit-bar:"):
            continue
        saw_scorekit_marker = True
        match = ANCHOR.fullmatch(label)
        if not match:
            raise ValueError(f"Invalid ScoreKit MIDI marker {label!r}")
        number = int(match.group(1))
        if tick in markers and markers[tick] != number:
            raise ValueError(f"Conflicting ScoreKit markers at tick {tick}")
        markers[tick] = number
    if not saw_scorekit_marker:
        return None
    if not bar_starts or len(set(bar_starts)) != len(bar_starts):
        raise ValueError("MIDI bar starts must be nonempty and unique")
    if bar_starts[0] != 0:
        raise ValueError("MIDI bar starts must begin at tick zero")
    unexpected = set(markers) - set(bar_starts)
    if unexpected:
        raise ValueError(f"ScoreKit MIDI markers outside measure boundaries: {sorted(unexpected)}")
    if markers.get(0) != 1:
        raise ValueError("ScoreKit MIDI route must start at printed bar 1")
    route = []
    current = 0
    for tick in bar_starts:
        current = markers.get(tick, current + 1)
        route.append(current)
    printed = legacy_printed if legacy_printed is not None else max(route)
    if any(bar > printed for bar in route):
        raise ValueError("ScoreKit MIDI marker exceeds printed measure count")
    if legacy_route is not None and route != legacy_route:
        mismatch = next((i for i, (left, right) in enumerate(
            zip(route, legacy_route), 1) if left != right),
            min(len(route), len(legacy_route)) + 1)
        raise ValueError(
            f"MIDI navigation markers disagree with playback-map.json at playback bar {mismatch}"
        )
    return route, printed
