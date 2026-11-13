# Combined instrumental desks (native LilyPond)

The actual orchestral score uses **one authoritative music source per instrument**.
The combined score and combined desk parts reuse those sources directly.
No Python-generated music file is needed for live LilyPond preview.

## Current score

- `music/combined/flutes.ily`: editable measure-aligned mode timeline
  for Flutes I–II, used by both `orchestra.ily` and
  `parts/combined/flutes-1-2.ly`.
- `music/paired.ily`: all eight other paired desks use independent voices
  by default, enforced by a native `\\partCombineApart` control stream.
- `music/flute-1.ily` and `music/flute-2.ily`: independent original notes,
  rests and dynamics; no fake noteheads or combined-only rest suppression.
- `scorekit/tests/test_flutes_combined_modes.py`: verifies timeline duration,
  actual silence in I/II ranges and exact a2 equality in bars 111–114.
- `scorekit/tests/fixtures/combined-staff/mode-map.ly`: small independent
  native LilyPond fixture exercising forced I, II, a2 and two-voice mode.

## How to change flute modes

Edit only `music/combined/flutes.ily`:

- `\\partCombineApart s2.*N`: I,II, independent voices; stems up/down.
- `\\partCombineSoloI s2.*N`: show only I; II must be silent.
- `\\partCombineSoloII s2.*N`: show only II; I must be silent.
- `\\partCombineUnisono s2.*N`: show one notehead/stem for a2.

`s2.` represents one measure in the present 3/4 score. The two control
sections have 116 and 36 measures respectively. The playback timeline
uses the same `\\scorePlayback` repeat structure as the music itself.

**Do not use a2 for different dynamics, articulations or notes.**
The current flute a2 region (111–114) is checked against both original
sources; when editing the region, extend the tests and verify it visually.

## Engraving and preview

`\\partCombine` remains the LilyPond engraver. `Merge_rests_engraver`
is attached to combined orchestral staves; the standalone native fixture
also exercises it. PartCombine's own labels replace the former invisible
dummy-note labels for the flute desk.

The generic paired desks currently use I,II throughout; only the flute
desk has explicit I, II and a2 transitions. Their source-level historical
corrections have **not all been migrated** to desk-only modules. This is
a remaining limitation, not an implemented feature.

A separate `Native desk smoke` workflow compiles both fixtures using the
project's pinned LilyPond 2.26.0. The normal `Build score` workflow
compiles the full current orchestral score and parts. CI compilation
alone does not guarantee visual collision freedom: review PDFs before
merging and use desk-local `MultiMeasureRest.staff-position` overrides
when LilyPond's default rest placement is inadequate.
