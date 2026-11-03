\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/clarinet-in-a-1.ily"
\include "../../music/clarinet-in-a-2.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \compressEmptyMeasures \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \clarinetInAOneMusic } { \clarinetInATwoMusic } } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \clarinetInAOneMusic } { \clarinetInATwoMusic } } >> \midi { } }
