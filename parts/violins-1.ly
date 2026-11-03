\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violins-1.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violins I" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \violinsOneMusic } >> \layout { } }
\score { \articulate \new Staff << { \global } { \rehearsalMarks } { \violinsOneMusic } >> \midi { } }
