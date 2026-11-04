# One-off import from MuseScore Studio

The canonical project format is LilyPond music in `music/*.ily`, in concert pitch.
Do **not** automatically regenerate hand-edited `.ily` from `.mscz` on each
build: `musicxml2ly` conversion is not lossless.

To import a MuseScore score once:

1. Open `.mscz` in MuseScore Studio. Use **File → Export → MusicXML**.
2. Alternatively, from Windows terminal: `MuseScore4.exe -o import.musicxml original.mscz` (path may vary).
3. Use LilyPond's bundled `musicxml2ly`: `musicxml2ly -o imported-score.ly import.musicxml`.
4. Review key signatures, octaves, B-flat/E-flat transpositions, instrument ranges, staves and drums.
5. Split the imported material into `music/*.ily` in concert pitch, then check every part PDF.

Importing MusicXML is a migration step, not a round-trip editing mechanism.
