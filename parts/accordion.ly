\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/accordion.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/accordion.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Accordion"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new PianoStaff <<
    \new Staff \with { midiInstrument = "accordion" } { \clef treble \global \introMark \accordionRightMusic }
    \new Staff \with { midiInstrument = "accordion" } { \clef bass \global \accordionLeftMusic }
  >>
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new PianoStaff <<
    \new Staff \with { midiInstrument = "accordion" } { \clef treble \global \introMark \accordionRightMusic }
    \new Staff \with { midiInstrument = "accordion" } { \clef bass \global \accordionLeftMusic }
  >>
  \midi { }
}
