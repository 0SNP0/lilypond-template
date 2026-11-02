\version "2.26.0"
\include "../metadata.ily"
\include "../music/cymbals.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Cymbals" tagline = ##f }
\score { \new DrumStaff << { \global } { \cymbalsMusic } >> \layout { } }
\score { \new DrumStaff { \cymbalsMusic } \midi { } }
