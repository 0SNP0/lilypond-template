\version "2.26.0"
\include "../metadata.ily"
\include "../music/violoncellos.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violoncellos" tagline = ##f }
\score { \new Staff << { \global } { \violoncellosMusic } >> \layout { } }
\score { \new Staff << { \global } { \violoncellosMusic } >> \midi { } }
