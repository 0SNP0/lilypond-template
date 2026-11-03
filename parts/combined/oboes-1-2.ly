\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/oboe-1.ily"
\include "../../music/oboe-2.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboes I–II" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \oboeOneMusic } { \oboeTwoMusic } } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \oboeOneMusic } { \oboeTwoMusic } } >> \midi { } }
