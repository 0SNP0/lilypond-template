% PROVISIONAL solo split of MusicXML trumpets-1-2. Review chords and solo/a2 labels.
trumpetTwoOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 bes'8-^ \f ^\markup \italic { "a2" } bes'8-^ bes'4-^ r4 |
 bes'8-^ \f bes'8-^ bes'4-^ r4 |
 aes'8-^ \f aes'8-^ aes'4-^ r4 |
 R2.*49 |
 r4 ^\markup \italic { "I, II" } b'4-. \mf b'4-. |
 r4 ais'4-. ais'4-. |
 r4 gis'4-. gis'4-. |
 r4 fis'4-. fis'4-. |
  % Bars 57-60
 r4 e'4-. e'4-. |
 r4 \mf e'4-. e'4-. |
 r4 \> gis'4-. gis'4-. |
 r4 fis'4-. fis'4-. |
  % Bars 61-64
 r4 \mf gis'4-. gis'4-. |
 r4 fis'4-. fis'4-. |
 r4 \< dis'4-. dis'4-. |
 r4 gis'4-. gis'4-. |
  % Bars 65-68
 r4 \mf e'4-. e'4-. |
 r4 e'4-. e'4-. |
 r4 \> fis'4-. fis'4-. |
 r4 \mf e'4-. e'4-. |
  % Bars 69-72
 r4 \mf b'4-. b'4-. |
 r4 ais'4-. ais'4-. |
 r4 gis'4-. gis'4-. |
 r4 fis'4-. fis'4-. |
  % Bars 73-76
 r4 e'4-. e'4-. |
 r4 e'4-. e'4-. |
 r4 ais'4-. ais'4-. |
 r4 gis'4-. gis'4-. |
  % Bars 77-80
 fis'4-. \sf r4 r4 |
 R2.*7 |
 r4 d'4-. \f d'4-. |
 r4 d'4-. d'4-. |
 r4 ees'4-. ees'4-. |
 r4 ees'4-. ees'4-. |
  % Bars 89-92
 r4 d'4-. d'4-. |
 r4 d'4-. d'4-. |
 r4 ees'4-. ees'4-. |
 r4 ees'4-. ees'4-. |
  % Bars 93-96
 r4 ees'4-. ees'4-. |
 r4 ees'4-. ees'4-. |
 r4 ees'4-. ees'4-. |
 r4 ees'4-. ees'4-. |
  % Bars 97-100
 ees'4-. \mf r4 r4 |
 ees'4-. r4 r4 |
 ees'4-. r4 r4 |
 R2.*9 |
 a'2. |
 dis'2.~ \f ^\markup \italic { "I, II" } |
 dis'2.~ |
 dis'2.~ |
  % Bars 113-116
 dis'4 r4 r4 |
 R2. |
 fis'4-. \f r4 gis'4-. |
 fis'4-. s2 |
}

trumpetTwoBridge = {
  % Bars 117-120
 R2.*36 |
}

trumpetTwoMusic = { \trumpetTwoOpening \trumpetTwoBridge }
trumpetTwoMusicPlayback = \scorePlayback \trumpetTwoOpening \trumpetTwoBridge
