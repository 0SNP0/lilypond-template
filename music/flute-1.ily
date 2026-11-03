% PROVISIONAL solo split of MusicXML flutes-1-2. Review chords and solo/a2 labels.
fluteOneOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*15 |
 \acciaccatura { a'''16 } a'''2.-> \f ^\markup \italic { "I" } |
  % Bars 17-20
 gis'''4( e'''4 cis'''4 |
 gis''4 \acciaccatura { b''16 } a''4.) gis''8 |
 cis'''2.~ |
 cis'''4) r4 r4 |
  % Bars 21-24
 R2.*48 |
 cis'''2. _\markup \italic { "espr." }( ^\markup \italic { "I" } \f |
 e'''2.) |
 a'''2.( |
 gis'''2.) |
  % Bars 73-76
 fis'''2. |
 e'''4( \f d'''4. e'''8 |
 d'''2. |
 cis'''2.) |
  % Bars 77-80
 gis''4-. \ff r8 cis'''8-. e'''4-. |
 gis'''4-. r8 fis'''8-. e'''4-. |
 cis'''4-. r8 fis'''8-. a'''4-. |
 a'''4-. r8 b'''8-. a'''4-. |
  % Bars 81-84
 gis'''4-. r8 fis'''8-. e'''4-. |
 dis'''4-. r8 e'''8-. dis'''4-. |
 cis'''4 r4 r4 |
 R2. |
  % Bars 85-88
 gis''2.~( \f ^\markup \italic { "I" } |
 gis''4 \acciaccatura { gis''16 } a''2) |
 gis''4( cis'''2) |
 gis''4( cis'''2) |
  % Bars 89-92
 gis''2.~( |
 gis''4 a''2) |
 gis''4( cis'''2) |
 gis''4( e'''2) |
  % Bars 93-96
 cis'''2.~( |
 cis'''4 d'''4. cis'''8 |
 a'''2.~ |
 a'''4) fis'''4( gis'''4 |
  % Bars 97-100
 a'''4 gis'''4 fis'''4 |
 e'''4 dis'''4 cis'''4 |
 b''4 a''4 gis''4 |
 fis''4 e''4. dis''8 |
  % Bars 101-104
 gis''4) r4 r4 |
 R2.*9 |
 a'''2.~ |
 a'''4 fis'''4 \ff gis'''4 |
  % Bars 113-116
 a'''4 gis'''4 fis'''4 |
 e'''4 cis'''4 a''4 |
 e'''8( \ff gis'''8) gis'''4-. fis'''4-. |
 e'''4-. r4 r4 |
}

fluteOneBridge = {
  % Bars 117-120
 R2.*17 |
 b''4.( \mf cis'''8 \f gis''8 cis'''8 |
 b''2.) \mf |
 b''4.( \mp cis'''8 \mf gis''8 cis'''8 |
  % Bars 137-140
 b''4) r4 r4 |
 R2.*15 |
}

fluteOneMusic = { \fluteOneOpening \fluteOneBridge }
fluteOneMusicPlayback = \scorePlayback \fluteOneOpening \fluteOneBridge
