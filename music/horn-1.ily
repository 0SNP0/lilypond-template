% PROVISIONAL solo split of MusicXML horns-1-3. Review pitches, chords, solo/a2.
hornOneOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 dis''8 _\markup \italic { "marc." }-_ \f dis''8-_ dis''4-_ r4 |
 dis''8-^ dis''8-^ dis''4-^ r4 |
 dis''8-^ dis''8-^ dis''4-^ r4 |
 R2.*42 |
 gis'2.->( ^\markup \italic { "I" } \f |
 gis'2.~) \f |
 gis'2.( |
  % Bars 49-52
 gis'4) \mf r4 r4 |
 R2. |
 b'4( \mf dis''4-.) cis''4-. |
 b'4-. r4 r4 |
  % Bars 53-56
 R2.*24 |
 dis''4-. \ff r4 dis''4-. |
 dis''4-. r4 dis''4-. |
 e''4-. r4 e''4-. |
 e''4-. r4 e''4-. |
  % Bars 81-84
 dis''4-. r4 dis''4-. |
 dis''4-. r4 dis''4-. |
 dis''4-. r4 r4 |
 R2.*17 |
 r4 dis''4-. \ff dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
  % Bars 105-108
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
  % Bars 109-112
 r4 dis''4-. dis''4-. |
 r4 dis''4-. dis''4-. |
 r4 e''4-. e''4-. |
 r4 e''4-. e''4-. |
  % Bars 113-116
 e''4-> \ff r4 r4 |
 e''4-> r4 r4 |
 R2.*2 |
}

hornOneBridge = {
  % Bars 117-120
 R2.*36 |
}

hornOneMusic = { \hornOneOpening \hornOneBridge }
hornOneMusicPlayback = \scorePlayback \hornOneOpening \hornOneBridge
