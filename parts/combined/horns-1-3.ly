\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horn-1.ily"
\include "../../music/horn-3.ily"
\include "../../music/paired.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F I & III" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsOneThreeTogether } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsOneThreeTogether } >> \midi { } }
