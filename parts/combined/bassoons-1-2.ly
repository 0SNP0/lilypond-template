\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/bassoons-1-2.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoons I–II" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \bassoonsOneTwoMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \bassoonsOneTwoMusic } >> \midi { } }
