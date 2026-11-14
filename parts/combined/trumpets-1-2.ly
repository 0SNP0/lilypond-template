\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trumpet-1.ily"
\include "../../music/trumpet-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpets in B-flat I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \trumpetOneMusic } { \partCombineApart s2.*152 } >> } { \trumpetTwoMusicCombined } } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \trumpetOneMusic } { \partCombineApart s2.*152 } >> } { \trumpetTwoMusic } } >> \midi { } }
