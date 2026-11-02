\version "2.26.0"
\include "../metadata.ily"
\include "../music/contrabassoon.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Contrabassoon" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \contrabassoonMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \contrabassoonMusic } >> \midi { } }
