% PROVISIONAL solo split of MusicXML trombone-3-and-tuba. Review pitches, chords, solo/a2.
tromboneThreeOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1-4
 gis,8 _\markup \italic { "marc." }-_ \f ^\markup \italic { "III" } gis,8-_ gis,4 r4 |
 gis,8-_ gis,8-_ gis,4 r4 |
 gis,8-_ gis,8-_ gis,4 r4 |
 R2.*49 |
 a4 \mf r4 r4 |
 gis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 57-60
 d4 r4 r4 |
 b,4 r4 r4 |
 e,4 r4 r4 |
 e,4 r4 r4 |
  % Bars 61-64
 a,4 r4 r4 |
 gis,4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 65-68
 d4 r4 r4 |
 a,4 r4 r4 |
 fis,4 r4 r4 |
 b,4 r4 r4 |
  % Bars 69-72
 a4 r4 r4 |
 gis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 73-76
 d4 r4 r4 |
 e,4 r4 r4 |
 eis,4 r4 r4 |
 fis,4 r4 r4 |
  % Bars 77-80
 gis,4 \sf r4 r4 |
 R2.*37 |
 gis,4-. \f r4 gis,4-. |
 cis4-. r4 r4 |
}

tromboneThreeBridge = {
  % Bars 117-120
 R2.*36 |
}

tromboneThreeMusic = { \tromboneThreeOpening \tromboneThreeBridge }
tromboneThreeMusicPlayback = \scorePlayback \tromboneThreeOpening \tromboneThreeBridge
