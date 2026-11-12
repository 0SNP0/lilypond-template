# MIDI markers for printed measure navigation

ScoreKit can recover the performed-to-printed measure route from MIDI marker
events emitted by LilyPond. The original LilyPond files remain the notation and
performance source of truth. The generated `dist/viewer/timeline.json` remains
the viewer's interface; the viewer, audio synthesis, Releases and Pages do not
need modification.

## How to use

The score project includes `scorekit/lilypond/playback-markers.ily` in a
LilyPond source, and places `\\scorekitPlaybackStart #N` in **MIDI-only**
music at the beginning of the first played bar and wherever playback jumps to
a different printed measure. The marker records the printed measure number;
following measures increment automatically until the next marker.

The same musical form should drive both the instrument music and the marker
clock. A `\\repeat volta`, `\\repeat segno`, or project-level performance
function can duplicate the markers along with the music. In particular,
the Snowstorm project uses its existing `\\scorePlayback` function for both.
The marker never appears in the printed score.

ScoreKit reads MIDI marker meta events (FF 06) whose text begins with
`scorekit-bar:`; other LilyPond rehearsal marks are ignored. Duplicate
identical markers from multiple staves are allowed.

## Validation

Without markers, ScoreKit retains backwards compatibility with an optional
`music/playback-map.json` containing `playback_sections` and `navigation`.

With markers, the route must start at printed bar 1 and all markers must be
on complete measure boundaries. Any legacy route must match exactly. If
the score still uses `music/playback-map.json`, it can contain just
`printed_measures`, an optional `expected_playback_measures` guard,
and work-specific editorial checks. It need **not** repeat navigation.
If there is no explicit route and the playback and printed counts differ,
missing markers fail the build rather than silently mislabeling the viewer.

LilyPond integration tests cover basic volta and D.C. al Fine; Python tests
cover D.S./Coda and alternate endings. Additional LilyPond integration tests
will be needed before claiming universal support for all repeat constructs.

## Limits

This approach assumes navigation at measure boundaries. It does not yet
handle anacrusis, mid-bar jumps, or arbitrary conflicting MIDI markers.
The full printed-measure count remains declared in project configuration
when endings can be unplayed. The output route must be validated against
each work's intended form before adopting this mechanism.
