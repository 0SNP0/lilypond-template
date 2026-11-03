\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/bassoon-1.ily"
\include "../../music/bassoon-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoons I–II" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { \bassoonOneMusic } { \bassoonTwoMusic } } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \bassoonOneMusic } { \bassoonTwoMusic } } >> \midi { } }
