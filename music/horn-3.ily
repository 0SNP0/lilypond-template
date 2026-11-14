% PROVISIONAL solo split of MusicXML horns-1-3. Review pitches, chords, solo/a2.
hornThreeOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 dis'8 \tag #'combined { \once \override DynamicText.stencil = ##f } \f dis'8 dis'4 r4 |
 dis'8 dis'8 dis'4 r4 |
 dis'8 dis'8 dis'4 r4 |
 R2.*73 |
 gis'4-. \tag #'combined { \once \override DynamicText.stencil = ##f } \ff r4 gis'4-. |
 gis'4-. r4 gis'4-. |
 gis'4-. r4 gis'4-. |
 gis'4-. r4 gis'4-. |
  % Bars 81-84
 gis'4-. r4 gis'4-. |
 fisis'4-. r4 fisis'4-. |
 gis'4-. r4 r4 |
 R2.*17 |
 r4 fisis'4-. \tag #'combined { \once \override DynamicText.stencil = ##f } \ff fisis'4-. |
 r4 fisis'4-. fisis'4-. |
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
  % Bars 105-108
 r4 fisis'4-. fisis'4-. |
 r4 fisis'4-. fisis'4-. |
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
  % Bars 109-112
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
 r4 gis'4-. gis'4-. |
  % Bars 113-116
 gis'4-> \tag #'combined { \once \override DynamicText.stencil = ##f } \ff r4 r4 |
 gis'4-> r4 r4 |
 R2.*2 |
}

hornThreeBridge = {
  % Bars 117-120
 R2.*36 |
}

hornThreeMusicCombined = \keepWithTag #'combined { \hornThreeOpening \hornThreeBridge }
hornThreeMusic = \keepWithTag #'solo { \hornThreeOpening \hornThreeBridge }
hornThreeMusicPlayback = \scorePlayback { \keepWithTag #'solo \hornThreeOpening } \hornThreeBridge
