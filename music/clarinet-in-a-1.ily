% PROVISIONAL solo split of MusicXML clarinets-in-a-1-2. Review chords and solo/a2 labels.
clarinetInAOneOpening = {
  \clef treble
  \key g \major
  \time 3/4
  % Bars 1-4
 R2.*36 |
 b'2.~( \f |
 b'4 c''2) |
 
 b'4( e''2) |
 b'4( e''2) |
 
  % Bars 41-44
 b'2.~( |
 b'4 c''2) |
 
 b'4( e''2) |
 b'4( e''2) |
 
  % Bars 45-48
 e''2.~ |
 
 e''4 f''4.( e''8 |
 c'''2.~ |
 c'''4) a''4( b''4 |
 
  % Bars 49-52
 c'''4 b''4 a''4 |
 g''4 e''4 c''4) |
 b'4( g''4-.) fis''4-. |
 e''4-. r4 r4 |
  % Bars 53-56
 R2.*16 |
 e''2. _\markup \italic { "espr." }(  \f |
 g''2.) |
 c'''2.( |
 b''2.) |
  % Bars 73-76
 a''2. |
 % Keep the actual notes and slur in both outputs. Hide only the
 % spanner on the shared staff, where partCombine otherwise extends it.
 
 g''4( f''4. g''8 |
 f''2. |
 e''2.) |
  % Bars 77-80
 b'4-. \ff r8 e''8-. g''4-. |
 b''4-. r8 a''8-. g''4-. |
 e''4-. r8 a''8-. c'''4-. |
 c'''4-. r8 d'''8-. c'''4-. |
  % Bars 81-84
 b''4-. r8 a''8-. g''4-. |
 
 fis''4-. r8 g''8-. fis''4-. |
 e''4 r4 r4 |
 
 R2. |
  % Bars 85-88
 b'2.~( \f  |
 b'4-_ c''2) |
 b'4( e''2) |
 b'4( e''2) |
  % Bars 89-92
 b'2.~( |
 b'4 c''2) |
 b'4( e''2) |
 b'4( g''2) |
  % Bars 93-96
 
 e''2.~ |
 e''4 r4 r4 |
 
 R2. |
 R2. |
 R2. |
 R2. |
 R2. |
 R2. |
 
 b''8( \ff c'''8 b''8 a''8 fis''8 dis''8 |
 b'4) r4 r4 |
 
 R2.*2 |
 b''8( \ff c'''8 b''8 a''8 fis''8 dis''8 |
 b'4) r4 r4 |
 R2.*2 |
 e'''8( \ff f'''8 e'''8 d'''8 b''8 gis''8 |
 e''4) r4 r4 |
 R2.*4 |
 g''8( \ff b''8) b''4-. a''4-. |
 g''4-. r4 r4 |
}

clarinetInAOneBridge = {
  % Bars 117-120
 b'2.( \pp |
 d''2. |
 c''2.~ |
 c''2.) |
  % Bars 121-124
 c''2.~( |
 c''2. |
 d''2.~ |
 d''4) r4 r4 |
  % Bars 125-128
 R2.*3 |
 r4 d''4( \mf e''4 |
  % Bars 129-132
 fis''4-.) fis''4-. fis''4-. |
 fis''4-. e''4.( fis''8 |
 e''2 d''4~ |
 d''2.) |
  % Bars 133-136
 d''4.( \p e''8 \mf b'8 e''8 |
 d''2.) |
 d''4.( \mp e''8 b'8 e''8 |
 d''2.) \> |
  % Bars 137-140
 b'2.( \pp |
 d''2. |
 c''2.~ |
 c''2.) |
  % Bars 141-144
 c''2.~( |
 c''2. |
 d''2.~ |
 d''4) r4 r4 |
  % Bars 145-148
 R2.*3 |
 r4 g'4(( \mp a'4 |
  % Bars 149-152
 b'4-.)) b'4-. b'4-. |
 b'4-. a'4.( b'8 |
 g'2.~ |
 g'4) r4 r4 |
}

clarinetInAOneMusic = \keepWithTag #'solo { \clarinetInAOneOpening \clarinetInAOneBridge }
clarinetInAOneMusicCombined = \keepWithTag #'combined { \clarinetInAOneOpening \clarinetInAOneBridge }
clarinetInAOneMusicPlayback = \scorePlayback
  { \keepWithTag #'solo \clarinetInAOneOpening } \clarinetInAOneBridge

% Printed labels on the combined desk only; no invisible noteheads.
clarinetsDeskCues = {
  s2.*47
  \textMark \markup \italic "I" s2.
  s2.*28
  \textMark \markup \italic "I,II" s2.
  s2.*15
  \textMark \markup \italic "I,II" s2.
  s2.*21
  \textMark \markup \italic "I,II" s2.
  s2.*37
}
