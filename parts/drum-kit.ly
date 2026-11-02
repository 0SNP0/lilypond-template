\version "2.24.3"
% Standalone, directly previewable part; edit music in ../music/drum-kit.ily
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/drum-kit.ily"
\include "../layout/part.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Drum Kit"
  copyright = \rightsCredit
  tagline = ##f
}

% If necessary: add \paper { page-count = #2 } here, only for this part.
% No instrumentName: the part is identified in the page header.

\score {
  \new DrumStaff { \drumsGlobal \introMark \drumKitMusic }
  \layout { }
}

% Separate concert-pitch MIDI for independently rendered rehearsal audio.
\score {
  \new DrumStaff { \drumsGlobal \introMark \drumKitMusic }
  \midi { }
}
