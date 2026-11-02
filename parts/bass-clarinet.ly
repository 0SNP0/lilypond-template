\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/bass-clarinet.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/bass-clarinet.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Bass Clarinet in B-flat"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new Staff \with { midiInstrument = "clarinet" } { \compressMMRests { \transpose c d' { \global \introMark \bassClarinetMusic } } }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new Staff \with { midiInstrument = "clarinet" } { \global \introMark \bassClarinetMusic }
  \midi { }
}
