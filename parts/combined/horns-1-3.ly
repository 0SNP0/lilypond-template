\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horns-1-3.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F I & III" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsOneThreeMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsOneThreeMusic } >> \midi { } }
