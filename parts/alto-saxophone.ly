\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/alto-saxophone.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/alto-saxophone.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Alto Saxophone in E-flat"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new Staff \with { midiInstrument = "alto sax" } { \compressMMRests { \transpose c a { \global \introMark \altoSaxMusic } } }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new Staff \with { midiInstrument = "alto sax" } { \global \introMark \altoSaxMusic }
  \midi { }
}
