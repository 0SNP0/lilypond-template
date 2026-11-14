\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/clarinet-in-a-1.ily"
\include "../../music/clarinet-in-a-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \clarinetInAOneMusicCombined } { { \partCombineApart s2.*111 \partCombineSoloII s2.*3 \partCombineApart s2.*38 } } >> } { \clarinetInATwoMusicCombined } } { \clarinetsDeskCues } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \clarinetInAOneMusic } { \partCombineApart s2.*152 } >> } { \clarinetInATwoMusic } } >> \midi { } }
