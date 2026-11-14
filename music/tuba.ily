% PROVISIONAL solo split of MusicXML trombone-3-and-tuba. Review pitches, chords, solo/a2.
tubaOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*3 |
 fis,4-. ^\markup \italic { "Tuba sola" } \mf e,4-. dis,4-. |
  % Bars 5-8
 cis,4-. r4 r4 |
 R2.*47 |
 a,4 \tag #'combined { \once \override DynamicText.stencil = ##f } \mf r4 r4 |
 gis,4 r4 r4 |
 fis,4 r4 r4 |
 e,4 r4 r4 |
  % Bars 57-60
 d,4 r4 r4 |
 b,,4 r4 r4 |
 e,,4 r4 r4 |
 e,,4 r4 r4 |
  % Bars 61-64
 a,,4 r4 r4 |
 gis,,4 r4 r4 |
 fis,4 r4 r4 |
 e,4 r4 r4 |
  % Bars 65-68
 d,4 r4 r4 |
 a,,4 r4 r4 |
 fis,,4 r4 r4 |
 b,,4 r4 r4 |
  % Bars 69-72
 a,4 r4 r4 |
 gis,4 r4 r4 |
 fis,4 r4 r4 |
 e,4 r4 r4 |
  % Bars 73-76
 d,4 r4 r4 |
 e,,4 r4 r4 |
 eis,,4 r4 r4 |
 fis,,4 r4 r4 |
  % Bars 77-80
 gis,,4 \tag #'combined { \once \override DynamicText.stencil = ##f } \sf r4 r4 |
 R2.*5 |
 cis4-. ^\markup \italic { "Tuba sola" } \mf gis,4-. e,4-. |
 cis,4-. r4 r4 |
  % Bars 85-88
 R2.*13 |
 gis2. |
 R2.*16 |
 gis,,4-. \tag #'combined { \once \override DynamicText.stencil = ##f } \f r4 gis,,4-. |
 cis,4-. r4 r4 |
}

tubaBridge = {
  % Bars 117-120
 R2.*36 |
}

tubaMusicCombined = \keepWithTag #'combined { \tubaOpening \tubaBridge }
tubaMusic = \keepWithTag #'solo { \tubaOpening \tubaBridge }
tubaMusicPlayback = \scorePlayback { \keepWithTag #'solo \tubaOpening } \tubaBridge
