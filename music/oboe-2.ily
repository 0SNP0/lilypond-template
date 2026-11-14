% PROVISIONAL solo split of MusicXML oboes-1-2. Review pitches, chords, solo/a2.
oboeTwoOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*52 |
 a'2.( \tag #'solo { \f } \tag #'combined { \once \override DynamicText.stencil = ##f \f } |
 cis''2.) |
 fis'2.( |
 gis'2.) |
  % Bars 57-60
 d'2. |
 cis''4(( b'4. fis'8 |
 a'2. |
 gis'2.)) |
  % Bars 61-64
 fis'2.(( |
 gis'2.)) |
 cis'2.( |
 fis'2.) |
  % Bars 65-68
 b'2.~ |
 b'4 ais'4( b'4 |
 d''4 cis''4. ais'8 |
 b'2.) |
  % Bars 69-72
 a'2.( |
 gis'2.) |
 cis''2. |
 cis''2. |
  % Bars 73-76
 a'2. |
 gis'4( fis'4. gis'8 |
 fis'2.) |
 fis'2. |
  % Bars 77-80
 e'4-. \tag #'solo { \ff } \tag #'combined { \once \override DynamicText.stencil = ##f \ff } r8 gis'8-. cis''4-. |
 e''4-. r8 dis''8-. cis''4-. |
 a'4-. r8 cis''8-. fis''4-. |
 fis''4-. r8 gis''8-. fis''4-. |
  % Bars 81-84
 e''4-. r8 dis''8-. cis''4-. |
 bis'4 r4 bis'4 |
 cis''4 s2 |
 R2.*17 |
 gis'2.~( \tag #'solo { \ff } \tag #'combined { \once \override DynamicText.stencil = ##f \ff } |
 gis'4 a'2) \f |
 gis'4( cis''2) |
 gis'4( cis''2) |
  % Bars 105-108
 gis'2.~( \tag #'solo { \ff } \tag #'combined { \once \override DynamicText.stencil = ##f \ff } |
 gis'4 a'2) |
 gis'4( cis''2) |
 gis'4( e''2) |
  % Bars 109-112
 cis''2.~( \tag #'solo { \ff } \tag #'combined { \once \override DynamicText.stencil = ##f \ff } |
 cis''4 d''2) |
 a''2.~ |
 a''4 fis''4 \ff gis''4 |
  % Bars 113-116
 a''4 gis''4 fis''4 |
 e''4 cis''4 a'4 |
 gis'8( \tag #'solo { \ff } \tag #'combined { \once \override DynamicText.stencil = ##f \ff } e''8) e''4-. dis''4-. |
 cis''4-. s2 |
}

oboeTwoBridge = {
  % Bars 117-120
 R2.*7 |
 r4 e'4( \tag #'solo { \p } \tag #'combined { \once \override DynamicText.stencil = ##f \p } fis'4 |
  % Bars 125-128
 gis'4-.) gis'4-. gis'4-. |
 gis'4-. fis'4. gis'8 |
 fis'2 e'4~ |
 e'2~ e'8 s8 |
  % Bars 129-132
 b'4-. \tag #'solo { \mf } \tag #'combined { \once \override DynamicText.stencil = ##f \mf } b'4-. b'4-. |
 b'4-. ais'4.( b'8 |
 cis''2 b'4~ |
 b'2.) |
  % Bars 133-136
 gis'2.~ \tag #'solo { \p } \tag #'combined { \once \override DynamicText.stencil = ##f \p } |
 gis'2. |
 gis'2.~ |
 gis'2.~ \> |
  % Bars 137-140
 gis'4 \mp \pp r4 \mp \pp r4 |
 R2.*6 |
 r4 e'4( \tag #'solo { \p } \tag #'combined { \once \override DynamicText.stencil = ##f \p } fis'4 |
  % Bars 145-148
 gis'4-.) gis'4-. gis'4-. |
 gis'4-. \< gis'4( ais'4 |
 b'4-.) \tag #'solo { \mp } \tag #'combined { \once \override DynamicText.stencil = ##f \mp } b'4-. b'4-. |
 b'4-. s2 |
  % Bars 149-152
 R2.*4 |
}

oboeTwoMusicCombined = \keepWithTag #'combined { \oboeTwoOpening \oboeTwoBridge }
oboeTwoMusic = \keepWithTag #'solo { \oboeTwoOpening \oboeTwoBridge }
oboeTwoMusicPlayback = \scorePlayback { \keepWithTag #'solo \oboeTwoOpening } \oboeTwoBridge
