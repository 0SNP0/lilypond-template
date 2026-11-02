\version "2.26.0"
\include "../metadata.ily"
\include "../music/contrabasses.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Contrabasses" tagline = ##f }
\score { \new Staff << { \global } { \contrabassesMusic } >> \layout { } }
\score { \new Staff << { \global } { \contrabassesMusic } >> \midi { } }
