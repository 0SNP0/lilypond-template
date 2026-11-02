\version "2.24.3"
% Combined printed desk for players I and II; individual parts remain
% in ../flute-1.ly and ../flute-2.ly (analogous for the other pairs).
\include "../../metadata.ily"
\include "../../music/global.ily"
\include "../../music/flute-1.ily"
\include "../../music/flute-2.ily"
\include "../../music/clarinet-1.ily"
\include "../../music/clarinet-2.ily"
\include "../../music/trumpet-1.ily"
\include "../../music/trumpet-2.ily"
\include "../../music/trombone-1.ily"
\include "../../music/trombone-2.ily"
\include "../../music/paired.ily"
\include "../../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Trumpets in B-flat I–II"
  copyright = \rightsCredit
  tagline = ##f
}

% One physical staff for both players, marked by opposing stem directions.
% For independent page control add \paper { page-count = #2 } here.
\score {
  \new Staff \with { midiInstrument = "trumpet" } { \transpose c d \trumpetsTogether }
  \layout { }
}
