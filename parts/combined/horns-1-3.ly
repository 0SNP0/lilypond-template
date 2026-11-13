\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horn-1.ily"
\include "../../music/horn-3.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F I & III" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \hornOneMusic } { \partCombineApart s2.*152 } >> } { \hornThreeMusic } } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \hornOneMusic } { \partCombineApart s2.*152 } >> } { \hornThreeMusic } } >> \midi { } }
