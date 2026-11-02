\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/violas.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/violas.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Violas"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new Staff \with { midiInstrument = "viola" } { \clef alto \compressMMRests { \global \introMark \violaMusic } }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new Staff \with { midiInstrument = "viola" } { \clef alto \global \introMark \violaMusic }
  \midi { }
}
