\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/cello.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/cello.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Cello"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new Staff \with { midiInstrument = "cello" } { \clef bass \compressMMRests { \global \introMark \celloMusic } }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new Staff \with { midiInstrument = "cello" } { \clef bass \global \introMark \celloMusic }
  \midi { }
}
