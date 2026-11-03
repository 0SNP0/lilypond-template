% PROVISIONAL solo split of MusicXML trumpets-1-2. Review chords and solo/a2 labels.
trumpetOneOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 bes'8 _\markup \italic { "marc." }-^ \f ^\markup \italic { "a2" } bes'8-^ bes'4-^ r4 |
 c''8-^ \f c''8-^ c''4-^ r4 |
 d''8-^ \f d''8-^ d''4-^ r4 |
 R2.*49 |
 r4 ^\markup \italic { "I, II" } dis''4-. \mf dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 b'4-. b'4-. |
 r4 ais'4-. ais'4-. |
  % Bars 57-60
 r4 gis'4-. gis'4-. |
 r4 \mf gis'4-. gis'4-. |
 r4 \> b'4-. b'4-. |
 r4 ais'4-. ais'4-. |
  % Bars 61-64
 r4 \mf b'4-. b'4-. |
 r4 ais'4-. ais'4-. |
 r4 \< gis'4-. gis'4-. |
 r4 b'4-. b'4-. |
  % Bars 65-68
 r4 \mf gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
 r4 \> gis'4-. gis'4-. |
 r4 \mf gis'4-. gis'4-. |
  % Bars 69-72
 r4 \mf dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 b'4-. b'4-. |
 r4 ais'4-. ais'4-. |
  % Bars 73-76
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
 r4 cis''4-. cis''4-. |
 r4 b'4-. b'4-. |
  % Bars 77-80
 ais'4-. \sf r4 r4 |
 R2.*7 |
 r4 aes'4-. \f aes'4-. |
 r4 aes'4-. aes'4-. |
 r4 ges'4-. ges'4-. |
 r4 ges'4-. ges'4-. |
  % Bars 89-92
 r4 aes'4-. aes'4-. |
 r4 aes'4-. aes'4-. |
 r4 ges'4-. ges'4-. |
 r4 ges'4-. ges'4-. |
  % Bars 93-96
 r4 g'4-. g'4-. |
 r4 g'4-. g'4-. |
 r4 aes'4-. aes'4-. |
 r4 aes'4-. aes'4-. |
  % Bars 97-100
 aes'4-. \mf r4 r4 |
 a'4-. r4 r4 |
 ges'4-. r4 r4 |
 R2.*10 |
 dis''2.~ \f ^\markup \italic { "I, II" } |
 dis''2.~ |
 dis''2.~ |
  % Bars 113-116
 dis''4 r4 r4 |
 R2. |
 ais'8-. \f ais'8-. ais'4-. ais'4-. |
 ais'4-. r4 r4 |
}

trumpetOneBridge = {
  % Bars 117-120
 R2.*36 |
}

trumpetOneMusic = { \trumpetOneOpening \trumpetOneBridge }
trumpetOneMusicPlayback = \scorePlayback \trumpetOneOpening \trumpetOneBridge
