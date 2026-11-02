\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/piano.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/piano.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Piano"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new PianoStaff <<
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef treble \global \introMark \pianoRightMusic }
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef bass \global \pianoLeftMusic }
  >>
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new PianoStaff <<
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef treble \global \introMark \pianoRightMusic }
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef bass \global \pianoLeftMusic }
  >>
  \midi { }
}
