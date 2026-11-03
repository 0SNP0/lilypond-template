\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/snare-drum.ily"
\include "../music/cymbals.ily"
\include "../music/bass-drum.ily"
\include "../music/percussion.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle
          composer = \composerCredit instrument = "Percussion" tagline = ##f }
\score { \compressEmptyMeasures
  \new DrumStaff << { \global } { \rehearsalMarks } \percussionKitMusic >>
  \partPrintLayout
}
\score {
  \new DrumStaff << { \globalPlayback } { \rehearsalMarksPlayback } \percussionKitPlayback >>
  \midi { }
}
