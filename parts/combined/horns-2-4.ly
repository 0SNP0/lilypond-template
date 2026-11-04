\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horn-2.ily"
\include "../../music/horn-4.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F II & IV" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { \hornTwoMusic } { \hornFourMusic } } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \hornTwoMusic } { \hornFourMusic } } >> \midi { } }
