\version "2.26.0"
% Open THIS file in Frescobaldi or VS Code to preview the full score.
\include "orchestra.ily"
\include "music/global.ily"
\include "layout/score.ily"
\include "articulate.ly"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Full Score"
  copyright = \rightsCredit
  tagline = ##f
}

\score {
  \keepWithTag #'written \ensembleScore
  \scoreCompactLayout
}

% Concert pitch MIDI; written transpositions are only for printed score.
\score {
  \articulate \keepWithTag #'concert \ensembleScore
  \midi { \context { \Score midiChannelMapping = #'instrument } }
}
