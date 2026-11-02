\version "2.26.0"
\include "../metadata.ily"
\include "../music/violins-2.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violins II" tagline = ##f }
\score { \new Staff << { \global } { \violinsTwoMusic } >> \layout { } }
\score { \new Staff { \violinsTwoMusic } \midi { } }
