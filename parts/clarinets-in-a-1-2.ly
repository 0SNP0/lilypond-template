\version "2.26.0"
\include "../metadata.ily"
\include "../music/clarinets-in-a-1-2.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff << { \global } { \clarinetsInAOneTwoMusic } >> \layout { } }
\score { \new Staff << { \global } { \clarinetsInAOneTwoMusic } >> \midi { } }
