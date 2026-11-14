\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/clarinet-in-a-1.ily"
\include "../../music/clarinet-in-a-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\include "../../scorekit/lilypond/combined-rests.ily"
% Time-aligned rest-placement overrides for the combined desk only.
% Bars 1-94: normal positioning; 95-100: II plays, I is silent.
% Never center I's rest on II's notes. The mode map suppresses I.
% To adjust a later measure: \deskRestUpper #6 or \deskRestLower #-6.
clarinetsRestLayout = {
  \deskRestAuto s2.*94
  \deskRestLower #-6 s2.*6
  \deskRestAuto s2.*52
}
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \clarinetInAOneMusicCombined } { \partCombineApart s2.*48 \partCombineUnisono s2.*4 \partCombineApart s2.*16 \partCombineSoloI s2.*8 \partCombineApart s2.*8 \partCombineSoloI s2.*8 \partCombineApart s2.*2 \partCombineSoloII s2.*6 \partCombineApart s2.*11 \partCombineSoloII s2.*3 \partCombineApart s2.*38 } >> } { \clarinetInATwoMusicCombined } } { \clarinetsDeskCues } { \clarinetsRestLayout } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \clarinetInAOneMusic } { \partCombineApart s2.*152 } >> } { \clarinetInATwoMusic } } >> \midi { } }
