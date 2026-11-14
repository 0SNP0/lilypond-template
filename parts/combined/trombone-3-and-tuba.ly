\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trombone-3.ily"
\include "../../music/tuba.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone III / Tuba" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \tromboneThreeMusic } { \partCombineApart s2.*152 } >> } { \tubaMusicCombined } } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \tromboneThreeMusic } { \partCombineApart s2.*152 } >> } { \tubaMusic } } >> \midi { } }
