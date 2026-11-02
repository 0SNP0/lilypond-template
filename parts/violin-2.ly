\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/violin-2.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/violin-2.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Violin II"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new Staff \with { midiInstrument = "violin" } { \compressMMRests { \global \introMark \violinTwoMusic } }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new Staff \with { midiInstrument = "violin" } { \global \introMark \violinTwoMusic }
  \midi { }
}
