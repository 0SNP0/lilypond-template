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
% Center ONLY verified shared whole-bar rests; preserve LilyPond's
% collision-aware placement when just one clarinet is resting.
% Measures are 3/4 (s2.); the durations sum to 152 measures.
clarinetsRestLayout = {
  \deskRestCenter s2.*36  % 1-36: both silent
  \deskRestAuto   s2.*16  % 37-52: independent music / a2
  \deskRestCenter s2.*16  % 53-68: both silent
  \deskRestAuto   s2.*26  % 69-94
  \deskRestUpper #6 s2.*6 % 95-100: upper clarinet rests, II plays
  \deskRestAuto   s2.*2   % 101-102
  \deskRestCenter s2.*2   % 103-104: both silent
  \deskRestAuto   s2.*2   % 105-106
  \deskRestCenter s2.*2   % 107-108: both silent
  \deskRestAuto   s2.*2   % 109-110
  \deskRestCenter s2.     % 111: both silent
  \deskRestAuto   s2.*13  % 112-124: II solo, then both
  \deskRestCenter s2.*3   % 125-127: both silent
  \deskRestAuto   s2.*17  % 128-144
  \deskRestCenter s2.*3   % 145-147: both silent
  \deskRestAuto   s2.*5   % 148-152
}
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { << { \clarinetInAOneMusicCombined } { \partCombineApart s2.*48 \partCombineSoloI s2.*4 \partCombineApart s2.*16 \partCombineSoloI s2.*8 \partCombineApart s2.*8 \partCombineSoloI s2.*8 \partCombineApart s2.*8 \partCombineApart s2.*11 \partCombineSoloII s2.*3 \partCombineApart s2.*38 } >> } { \clarinetInATwoMusicCombined } } { \clarinetsDeskCues } { \clarinetsRestLayout } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { << { \clarinetInAOneMusic } { \partCombineApart s2.*152 } >> } { \clarinetInATwoMusic } } >> \midi { } }
