\version "2.26.0"
\include "../metadata.ily"
\include "../music/bass-drum.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bass Drum" tagline = ##f }
\score { \new DrumStaff << { \global } { \rehearsalMarks } { \bassDrumMusic } >> \layout { } }
\score { \new DrumStaff << { \global } { \rehearsalMarks } { \bassDrumMusic } >> \midi { } }
