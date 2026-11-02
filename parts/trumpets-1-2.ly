\version "2.26.0"
\include "../metadata.ily"
\include "../music/trumpets-1-2.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpets in B-flat I–II" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \trumpetsOneTwoMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \trumpetsOneTwoMusic } >> \midi { } }
