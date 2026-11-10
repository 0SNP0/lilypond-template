# Experimental MIDI-based notation route

The score project's LilyPond sources define its music, including printed
repeats and MIDI playback. This optional mechanism extracts *which printed
measure is playing* from MIDI instead of duplicating the traversal in JSON.

## Status

This is **experimental**, not a replacement for the working
\`music/playback-map.json\` in the current score. No file from the score
project is migrated automatically. The current renderer, MP3 pipeline,
packaging and release/Pages workflows remain unchanged.

## MIDI anchors

Include \`scorekit/lilypond/playback-markers.ily\` in a MIDI-only LilyPond
score and put \`\\scorekitPlaybackStart #N\` at the start of the first
printed measure and each passage after a jump (such as D.C., D.S., Coda or a
different volta ending). An anchor identifies a **printed measure number**;
the following measures are numbered consecutively until the next anchor.
Anchor commands should travel *inside* native LilyPond repeat expressions so
that LilyPond's repeat unfolding emits them on every visit.

\`Mark_performer\` converts LilyPond rehearsal marks to MIDI marker meta events
(type FF 06). ScoreKit reads events prefixed \`scorekit-bar:\`. Other rehearsal
markers are ignored.

For example, the performed route 1, 2, 3, 1, 2, 4 (a pair of volta endings)
needs anchors 1 at the beginning, 1 at the return, and 4 at the second ending.
There is no need to label every bar.

## Validation and compatibility

The new MIDI markers are **optional**. Without markers, the existing
\`music/playback-map.json\` logic operates exactly as before. With markers,
ScoreKit requires that the first anchor identify printed bar 1, that all
anchors lie precisely on measure boundaries, and that any pre-existing JSON
playback route agrees exactly. A mismatch **fails the build**; it is not
silently resolved in favor of either route.

\`timeline.json\`, which the current viewer already reads, retains exactly
the same field names. The user-facing viewer does not need modifications.

## Known limitations / next steps

- The MIDI marker syntax and repeat unfolding must be tested with pinned
  LilyPond 2.26.0 in CI (an integration test covers basic volta).
- D.C./D.S./Coda/alternative *end-to-end* LilyPond specimens are still needed;
  pure-Python route tests alone are not sufficient.
- This first implementation supports markers at full measure boundaries only:
  pickups and jumps into the middle of a bar require an explicit design.
- ScoreKit cannot infer a printed bar number from arbitrary MIDI notes without
  some stable identity/marker linking performance to notation.
- Determine printed-measure count independently when no explicit JSON map is
  present and there are unplayed ending bars.
- The project retains control over music-specific repeat notation and
  regression assertions. A future adoption should remove redundant route
  declarations only after identical timeline and audio results are verified.
