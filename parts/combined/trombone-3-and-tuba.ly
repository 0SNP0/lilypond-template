\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trombone-3.ily"
\include "../../music/tuba.ily"
\include "../../music/paired.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone III / Tuba" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \tromboneThreeTubaTogether } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \tromboneThreeTubaTogether } >> \midi { } }
