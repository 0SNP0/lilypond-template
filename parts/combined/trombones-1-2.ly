\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trombone-1.ily"
\include "../../music/trombone-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombones I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \tromboneOneMusic } { \partCombineApart s2.*152 } >> } { \tromboneTwoMusic } } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \tromboneOneMusic } { \partCombineApart s2.*152 } >> } { \tromboneTwoMusic } } >> \midi { } }
