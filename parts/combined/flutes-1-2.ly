\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/flute-1.ily"
\include "../../music/flute-2.ily"
\include "../../music/paired.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flutes I–II" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \flutesTogether } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \flutesTogether } >> \midi { } }
