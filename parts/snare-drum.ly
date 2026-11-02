\version "2.26.0"
\include "../metadata.ily"
\include "../music/snare-drum.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Snare Drum" tagline = ##f }
\score { \new DrumStaff << { \global } { \snareDrumMusic } >> \layout { } }
\score { \new DrumStaff { \snareDrumMusic } \midi { } }
