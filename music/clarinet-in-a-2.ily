% PROVISIONAL solo split of MusicXML clarinets-in-a-1-2. Review chords and solo/a2 labels.
clarinetInATwoOpening = {
  \clef treble
  \key g \major
  \time 3/4
  % Bars 1-4
 R2.*36 |
 b'8( \tag #'combined { \once \override DynamicText.stencil = ##f } \f c''8 b'8 a'8 fis'8 dis'8 |
 b4)
  r4
  r4 |
 
 R2. |
 
 R2. |
  % Bars 41-44
 b'8( c''8 b'8 a'8 fis'8 dis'8 |
 b4)
  r4
  r4 |
 
 R2. |
 
 R2. |
  % Bars 45-48
 e''8( f''8 e''8 d''8 b'8 gis'8 |
 e'4) r4 r4 |
 r4 r4 r4 |
 r4 r4 r4 |
  % Bars 49-52
 R2.*28 |
 g'4-. \tag #'combined { \once \override DynamicText.stencil = ##f } \ff r8 b'8-. e''4-. |
 g''4-. r8 fis''8-. e''4-. |
 c''4-. r8 e''8-. a''4-. |
 a''4-. r8 b''8-. a''4-. |
  % Bars 81-84
 g''4-. r8 fis''8-. e''4-. |
 dis''4 r4 dis''4 |
 e''4 s2 |
 R2.*9 |
 e''2.~ |
 e''4 f''4. e''8 |
 c'''2.~ |
 c'''4 a''4( b''4 |
  % Bars 97-100
 c'''4 b''4 a''4 |
 g''4 fis''4 e''4 |
 d''4 c''4 b'4 |
 a'4 g'4. fis'8 |
  % Bars 101-104
 b'8 \tag #'combined { \once \override DynamicText.stencil = ##f } \ff c''8 b'8 a'8 fis'8 dis'8 |
 b4) s2 |
 R2.*2 |
 b'8( \tag #'combined { \once \override DynamicText.stencil = ##f } \ff c''8 b'8 a'8 fis'8 dis'8 |
 b4) s2 |
 R2.*2 |
 e''8( \tag #'combined { \once \override DynamicText.stencil = ##f } \ff f''8 e''8 d''8 b'8 gis'8 |
 e'4) s2 |
 R2. |
 r4 ^\markup \italic { "II" } a''4 \ff b''4 |
  % Bars 113-116
 c'''4 b''4 a''4 |
 g''4 e''4 c''4 |
 b'8( \tag #'combined { \once \override DynamicText.stencil = ##f } \ff g''8) g''4-. fis''4-. |
 e''4-. s2 |
}

clarinetInATwoBridge = {
  % Bars 117-120
 g'2.( \tag #'combined { \once \override DynamicText.stencil = ##f } \pp |
 b'2. |
 g'2.~ |
 g'2.) |
  % Bars 121-124
 g'2.~( |
 g'2. |
 b'2.~ |
 b'4) r4 r4 |
  % Bars 125-128
 R2.*3 |
 r4 b'4( \tag #'combined { \once \override DynamicText.stencil = ##f } \mf cis''4 |
  % Bars 129-132
 d''4-.) d''4-. d''4-. |
 d''4-. cis''4.( d''8 |
 cis''2 b'4~ |
 b'2.) |
  % Bars 133-136
 b'2.~ \p |
 b'2. |
 b'2.~ \tag #'combined { \once \override DynamicText.stencil = ##f } \mp |
 b'2. \> |
  % Bars 137-140
 g'2.( \tag #'combined { \once \override DynamicText.stencil = ##f } \pp |
 b'2. |
 g'2.~ |
 g'2.) |
  % Bars 141-144
 g'2.~( |
 g'2. |
 b'2.~ |
 b'4) r4 r4 |
  % Bars 145-148
 R2.*3 |
 r4 e'4(( \tag #'combined { \once \override DynamicText.stencil = ##f } \mp fis'4 |
  % Bars 149-152
 g'4-.)) g'4-. g'4-. |
 g'4-. fis'2 |
 g'2.~ |
 g'4 s2 |
}

clarinetInATwoMusic = \keepWithTag #'solo { \clarinetInATwoOpening \clarinetInATwoBridge }
clarinetInATwoMusicCombined = \keepWithTag #'combined { \clarinetInATwoOpening \clarinetInATwoBridge }
clarinetInATwoMusicPlayback = \scorePlayback
  { \keepWithTag #'solo \clarinetInATwoOpening } \clarinetInATwoBridge
