% PROVISIONAL solo split of MusicXML bassoons-1-2. Review pitches, chords, solo/a2.
bassoonTwoOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*52 |
 a2. \tag #'combined { \once \override DynamicText.stencil = ##f } \f |
 gis2. |
 fis2. |
 e2. |
  % Bars 57-60
 d2. |
 b,2. |
 e,2. |
 e,2. |
  % Bars 61-64
 a,2. |
 gis,2. |
 fis2. |
 e2. |
  % Bars 65-68
 d2. |
 a,2. |
 fis,2. |
 b,2. |
  % Bars 69-72
 a2. |
 gis2. |
 fis2. |
 e2. |
  % Bars 73-76
 d2. |
 e,2. |
 eis,2. |
 fis,2. |
  % Bars 77-80
 gis,4 \tag #'combined { \once \override DynamicText.stencil = ##f } \ff r4 gis,4 |
 gis,4 r4 gis,4 |
 fis,4 r4 fis,4 |
 fis,4 r4 fis,4 |
  % Bars 81-84
 gis,4 r4 gis,4 |
 gis,4 r4 gis,4 |
 cis4-. gis,4-. e,4-. |
 cis,4-. r4 r4 |
  % Bars 85-88
 R2.*16 |
 dis4 ^\markup \italic { "a2" } \tag #'combined { \once \override DynamicText.stencil = ##f } \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 105-108
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 109-112
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 113-116
 dis4 r4 r4 |
 e4 r4 r4 |
 gis,4 r4 gis,4 |
 cis4 s2 |
}

bassoonTwoBridge = {
  % Bars 117-120
 \clef tenor e'2.~( \tag #'combined { \once \override DynamicText.stencil = ##f } \pp |
 e'2. |
 cis'2.~ |
 cis'2.) |
  % Bars 121-124
 cis'2.~ |
 cis'2. |
 e'2.~ |
 e'4 r4 r4 |
  % Bars 125-128
 e'4-. e'4-. e'4-. |
 dis'4-. dis'4. dis'8 |
 dis'2 e'4~ |
 e'2~ e'8 r8 |
  % Bars 129-132
 R2.*8 |
 e'2.~( \tag #'combined { \once \override DynamicText.stencil = ##f } \pp |
 e'2. |
 cis'2.~ |
 cis'2.) |
  % Bars 141-144
 cis'2.~( |
 cis'2. |
 e'2.~ |
 e'4) r4 r4 |
  % Bars 145-148
 e'4-. \tag #'combined { \once \override DynamicText.stencil = ##f } \mp e'4-. e'4-. |
 e'4-. r4 r4 |
 e'4-. e'4-. e'4-. |
 e'4-. r4 r4 |
  % Bars 149-152
 \clef bass a4-. a4-. a4-. |
 a4-. a4 r4 |
 gis2.~ |
 gis4 r4 r4 |
}

bassoonTwoMusicCombined = \keepWithTag #'combined { \bassoonTwoOpening \bassoonTwoBridge }
bassoonTwoMusic = \keepWithTag #'solo { \bassoonTwoOpening \bassoonTwoBridge }
bassoonTwoMusicPlayback = \scorePlayback { \keepWithTag #'solo \bassoonTwoOpening } \bassoonTwoBridge
