\version "2.26.0"
\include "../metadata.ily"
\include "../music/oboes-1-2.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboes I–II" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \oboesOneTwoMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \oboesOneTwoMusic } >> \midi { } }
