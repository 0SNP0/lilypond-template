\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/clarinet-in-a-1.ily"
\include "../../music/clarinet-in-a-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\include "../../scorekit/lilypond/combined-rests.ily"
% Desk-only rest placement timeline. Edit here, not in either solo part.
% Defaults preserve LilyPond's collision avoidance. For a genuinely
% shared rest, replace the relevant s2. with \deskRestCenter s2.;
% for a rest in only one voice, use \deskRestUpper #6 or
% \deskRestLower #-6, followed by \deskRestAuto at the next bar.
clarinetsRestLayout = { \deskRestAuto s2.*152 }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \clarinetInAOneMusicCombined } { \partCombineApart s2.*48 \partCombineUnisono s2.*4 \partCombineApart s2.*16 \partCombineSoloI s2.*8 \partCombineApart s2.*8 \partCombineSoloI s2.*8 \partCombineApart s2.*2 \partCombineSoloII s2.*6 \partCombineApart s2.*11 \partCombineSoloII s2.*3 \partCombineApart s2.*38 } >> } { \clarinetInATwoMusicCombined } } { \clarinetsDeskCues } { \clarinetsRestLayout } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \clarinetInAOneMusic } { \partCombineApart s2.*152 } >> } { \clarinetInATwoMusic } } >> \midi { } }
