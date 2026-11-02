# Waltz from The Snowstorm — MusicXML import

This is a separate work branch from the reusable orchestra template.
The attached user-supplied MusicXML contains **268 measures and 21
original score parts** (many parts represent paired instruments).

The source archive in notation.part*.txt is a one-time compressed snapshot
of the derived, independently editable LilyPond documents, **not a
regeneration step for future editing**. A branch-only GitHub Action expands
it and commits score.ly, concert-score.ly, music/*.ily and parts/*.ly.
Once source/IMPORTED exists, the action will not overwrite edits.

IMPORTANT: The conversion is a **first-pass notation import**:
staff pitches, written transpositions, note/chord durations and most
notation events are mapped. Verify all parts against MusicXML manually,
especially orchestral dynamics, percussion, tuplets, cross-voice
ornaments, pedaling, slurs and multi-instrument desks. Initial import
is not represented as a finalized performing edition.
