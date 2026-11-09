% PROVISIONAL solo split of MusicXML oboes-1-2. Review pitches, chords, solo/a2.
oboeOneOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*4 |
 gis''4-. ^\markup \italic { "I" } \mf e''8-. dis''8-. cis''4~ |
 cis''8 dis''8-. e''8-. fis''8-. gis''8-. cis'''8-. |
 e'''4-. dis'''4-. cis'''4-. |
 a''2. |
  % Bars 9-12
 gis''4( cis'''2) |
 fis''4( cis'''2) |
 e''4( dis''4 cis''4 |
 fis''4 e''4 dis''4 |
  % Bars 13-16
 gis''4) e''8-. dis''8-. cis''4~ |
 cis''8 dis''8-. e''8-. fis''8-. gis''8-. cis'''8-. |
 e'''4-. dis'''4-. cis'''4-. |
 cis'''4-. r4 r4 |
  % Bars 17-20
 R2.*36 |
 cis''2. _\markup \italic { "espr." }( \f |
 e''2.) |
 a'2.( |
 cis''2.) |
  % Bars 57-60
 fis'2. |
 e''4(( d''4. a'8 |
 cis''2. |
 b'2.)) |
  % Bars 61-64
 a'2.(( \f |
 cis''2.)) |
 fis'2.( |
 a'2.) |
  % Bars 65-68
 d''2.~ |
 d''4 cis''4( d''4 |
 fis''4 e''4. cis''8 |
 d''2.) |
  % Bars 69-72
 cis''2. |
 cis''2. |
 fis''2.( |
 e''2.) |
  % Bars 73-76
 d''2. |
 cis''4( b'4. cis''8 |
 b'2. |
 a'2.) |
  % Bars 77-80
 gis'4-. \ff r8 cis''8-. e''4-. |
 gis''4-. r8 fis''8-. e''4-. |
 cis''4-. r8 fis''8-. a''4-. |
 a''4-. r8 b''8-. a''4-. |
  % Bars 81-84
 gis''4-. r8 fis''8-. e''4-. |
 \tag #'combined { \partCombineApart }
 dis''4-. r8 e''8-. dis''4-. |
 cis''4 r4 r4 |
 \tag #'combined { \partCombineAutomatic }
 R2.*17 |
 gis''8( \ff a''8 gis''8 fis''8 dis''8 bis'8 |
 gis'4) r4 \f r4 |
 \tag #'combined { \partCombineApart }
 R2.*2 |
 gis''8( \ff a''8 gis''8 fis''8 dis''8 bis'8 |
 gis'4) r4 r4 |
 R2.*2 |
 cis'''8( \ff d'''8 cis'''8 b''8 gis''8 eis''8 |
 cis''4) r4 r4 |
 R2.*4 |
 \tag #'combined { \partCombineAutomatic }
 e''8( \ff gis''8) gis''4-. fis''4-. |
 e''4-. r4 r4 |
}

oboeOneBridge = {
  % Bars 117-120
 b'4. _\markup \italic { "espr." }( \p ^\markup \italic { "I" } cis''8 gis'8 cis''8 |
 b'4) gis''4. gis''8 |
 gis''2.( |
 cis''2.) |
  % Bars 121-124
 gis''4.( fis''8 e''8 dis''8 |
 cis''4 fis''4. cis''8 |
 b'2.~ |
 b'4) gis'4( \p a'4 |
  % Bars 125-128
 b'4-.) b'4-. b'4-. |
 b'4-. a'4. b'8 |
 a'2 gis'4~ |
 gis'2~ gis'8 r8 |
  % Bars 129-132
 r4 \mf r4 r4 |
 R2.*3 |
 R2. \p |
 R2.*2 |
 R2. \> |
  % Bars 137-140
 b'4. _\markup \italic { "espr." }( \mp \pp cis''8 \mp \pp gis'8 cis''8 |
 b'4) gis''4. gis''8 |
 gis''2.( ^\markup \italic { "I" } |
 cis''2.) |
  % Bars 141-144
 gis''4.( fis''8 e''8 dis''8 |
 cis''4 fis''4. cis''8 |
 b'2.~ |
 b'4) gis'4( \p a'4 |
  % Bars 145-148
 b'4-.) b'4-. b'4-. |
 b'4-. \< b'4( cis''4 |
 dis''4-.) \mp dis''4-. dis''4-. |
 dis''4-. r4 r4 |
  % Bars 149-152
 R2.*4 |
}

oboeOneMusic = \keepWithTag #'solo { \oboeOneOpening \oboeOneBridge }
oboeOneMusicCombined = \keepWithTag #'combined { \oboeOneOpening \oboeOneBridge }
oboeOneMusicPlayback = \scorePlayback
  { \keepWithTag #'solo \oboeOneOpening } \oboeOneBridge
