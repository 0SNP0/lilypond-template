% PROVISIONAL solo split of MusicXML trombones-1-2. Review chords and solo/a2 labels.
tromboneTwoOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*52 |
 r4 cis'4-. \tag #'solo { \mf } \tag #'combined { \once \override DynamicText.stencil = ##f \mf } cis'4-. |
 r4 cis'4-. cis'4-. |
 r4 a4-. a4-. |
 r4 gis4-. gis4-. |
  % Bars 57-60
 r4 fis4-. fis4-. |
 r4 fis4-. fis4-. |
 r4 a4-. a4-. |
 r4 gis4-. gis4-. |
  % Bars 61-64
 r4 a4-. a4-. |
 r4 gis4-. gis4-. |
 r4 fis4-. fis4-. |
 r4 a4-. a4-. |
  % Bars 65-68
 r4 fis4-. fis4-. |
 r4 fis4-. fis4-. |
 r4 fis4-. fis4-. |
 r4 fis4-. fis4-. |
  % Bars 69-72
 r4 cis'4-. cis'4-. |
 r4 cis'4-. cis'4-. |
 r4 a4-. a4-. |
 r4 gis4-. gis4-. |
  % Bars 73-76
 r4 fis4-. fis4-. |
 r4 fis4-. fis4-. |
 r4 b4-. b4-. |
 r4 a4-. a4-. |
  % Bars 77-80
 gis4-. \tag #'solo { \sf } \tag #'combined { \once \override DynamicText.stencil = ##f \sf } r4 r4 |
 R2.*30 |
 gis2. |
  % Bars 109-112
 R2.*6 |
 gis4-. \tag #'solo { \f } \tag #'combined { \once \override DynamicText.stencil = ##f \f } r4 gis4-. |
 gis4-. r4 r4 |
}

tromboneTwoBridge = {
  % Bars 117-120
 R2.*36 |
}

tromboneTwoMusicCombined = \keepWithTag #'combined { \tromboneTwoOpening \tromboneTwoBridge }
tromboneTwoMusic = \keepWithTag #'solo { \tromboneTwoOpening \tromboneTwoBridge }
tromboneTwoMusicPlayback = \scorePlayback { \keepWithTag #'solo \tromboneTwoOpening } \tromboneTwoBridge
