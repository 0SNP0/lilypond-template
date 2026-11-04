\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/snare-drum.ily"
\include "../music/cymbals.ily"
\include "../music/bass-drum.ily"
\include "../music/drum-kit.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle
          composer = \composerCredit instrument = "Drum Kit" tagline = ##f }
\score {
  \new DrumStaff << { \global } { \rehearsalMarks } { \compressEmptyMeasures \drumKitMusic } >>
  \partPrintLayout
}
\score {
  \new DrumStaff << { \globalPlayback } { \rehearsalMarksPlayback } \drumKitPlayback >>
  \midi { }
}
