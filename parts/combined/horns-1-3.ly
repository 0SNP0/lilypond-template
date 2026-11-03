\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horn-1.ily"
\include "../../music/horn-3.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F I & III" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \hornOneMusic } { \hornThreeMusic } } >> \layout { } }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \hornOneMusic } { \hornThreeMusic } } >> \midi { } }
