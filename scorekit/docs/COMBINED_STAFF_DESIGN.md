# Native combined staff: experimental design

Status: exploratory, **not production-ready**. This branch does not replace
`music/paired.ily` or alter existing score/part rendering.

## Existing implementation and problems

- `music/paired.ily` constructs desks with `\\partCombine`.
- `music/flute-1.ily` and `music/flute-2.ily` use `solo`/`combined`
  tags and local engraving corrections. Those belong in the desk layer.
- `flutesDeskCues` uses invisible note objects to place mode labels.
- `parts/combined/flutes-1-2.ly` independently repeats the combining logic.

## Invariants

1. Each instrument's music remains the only authoritative note/rest stream.
2. Solo scores and MIDI use those streams directly.
3. Combined-only layout, including whole-measure rest displacement, is
   isolated from the solo sources.
4. The default I,II mode has independent voices, upper stems up and lower
   stems down; coincident noteheads may overlap, but stems remain separate.
5. Coincident rests are visually merged; an isolated whole-bar rest must not
   collide with the other voice, with desk-local overrides as fallback.
6. I and II show only the selected instrument and require the other to rest.
7. a2 prints one voice only if notes, rhythm, dynamics, articulations and
   other performance markings are identical. Otherwise use I,II.
8. Mode changes are bar-aligned initially; meter changes and repeats must
   be handled by musical time, not page layout.
9. LilyPond preview must work without a Python preprocessing step.

## Experiment

`scorekit/tests/fixtures/combined-staff/native-preview.ly` is a standalone
four-bar LilyPond file with two independent music variables, one shared
two-voice staff and two individual staffs. Compile with:

```sh
lilypond -o native-preview scorekit/tests/fixtures/combined-staff/native-preview.ly
```

This establishes the intended source separation and provides a preview
fixture. **It does not implement** per-bar I/II/a2 mode changes, automatic
rest collision detection, or semantic validation. No LilyPond executable
was available in the authoring environment, so the fixture has not yet
been rendered or visually verified.

## Next implementation gate

Prototype a Scheme music transformation that splits two source streams at
bar boundaries and produces per-bar engraving without changing the source
parts. Test mode labels using independent timed skips rather than fake
noteheads. Validate a2 equivalence and I/II silence before suppressing
any voice. Compare generated SVG/PDF for unisons, merged rests, collisions,
mode transitions, changing meters and repeats. Only migrate production
desks after a native preview and integration tests pass.
