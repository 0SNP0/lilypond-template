% PROVISIONAL solo split of MusicXML trombones-1-2. Review chords and solo/a2 labels.
tromboneOneOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*52 |
 r4 e'4-. \mf e'4-. |
 r4 e'4-. e'4-. |
 r4 cis'4-. cis'4-. |
 r4 cis'4-. cis'4-. |
  % Bars 57-60
 r4 a4-. a4-. |
 r4 a4-. a4-. |
 r4 cis'4-. cis'4-. |
 r4 d'4-. d'4-. |
  % Bars 61-64
 r4 cis'4-. cis'4-. |
 r4 cis'4-. cis'4-. |
 r4 a4-. a4-. |
 r4 cis'4-. cis'4-. |
  % Bars 65-68
 r4 a4-. a4-. |
 r4 a4-. a4-. |
 r4 ais4-. ais4-. |
 r4 b4-. b4-. |
  % Bars 69-72
 r4 e'4-. e'4-. |
 r4 e'4-. e'4-. |
 r4 cis'4-. cis'4-. |
 r4 cis'4-. cis'4-. |
  % Bars 73-76
 r4 a4-. a4-. |
 r4 a4-. a4-. |
 r4 d'4-. d'4-. |
 r4 cis'4-. cis'4-. |
  % Bars 77-80
 cis'4-. \sf r4 r4 |
 R2.*24 |
 gis2.~ \f ^\markup \italic { "I" } |
 gis2.~ |
 gis2.~ |
  % Bars 105-108
 gis4 r4 r4 |
 gis2.~ \f |
 gis2.~ |
 gis2.~ |
  % Bars 109-112
 gis4 r4 r4 |
 R2.*5 |
 cis'4-. \f r4 bis4-. |
 cis'4-. r4 r4 |
}

tromboneOneBridge = {
  % Bars 117-120
 R2.*36 |
}

tromboneOneMusic = { \tromboneOneOpening \tromboneOneBridge }
tromboneOneMusicPlayback = \scorePlayback \tromboneOneOpening \tromboneOneBridge
