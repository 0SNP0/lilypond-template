\version "2.26.0"
% Concert pitch edition, sharing exactly the same orchestra.ily source.
\include "orchestra.ily"
\include "music/global.ily"
\include "layout/score.ily"

\header {
  title = \workTitle
  subtitle = \workSubtitle
  composer = \composerCredit
  poet = \lyricistCredit
  translator = \translatorCredit
  transcriber = \transcriberCredit
  arranger = \arrangerCredit
  instrument = "Concert Score"
  copyright = \rightsCredit
  tagline = ##f
}

\score {
  \keepWithTag #'concert \ensembleScore
  \scoreCompactLayout
}
