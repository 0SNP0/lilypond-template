% CONSERVATIVE paired desks: no automatic single-note unison / "a2".
% The default \partCombineApart keeps both voices separate even if
% one individual note happens to match.
%
% MANUAL WHOLE-MEASURE UNISON:
% In music/flute-1.ily, clarinet-1.ily, trumpet-1.ily or trombone-1.ily,
% insert \partCombineUnisono before the first note of a measure if and
% only if BOTH players have identical pitches, durations and rests for
% the ENTIRE measure. At the beginning of the next differing measure,
% insert \partCombineApart. The first player's original music variable
% is used for both combined score and solo PDF; the commands do not
% affect the solo staff, which has no part combiner.
%
% Automatic mode can be explicitly re-enabled with
% \partCombineAutomatic, but it can mark isolated notes "a2" again.
% For editable examples see docs/PART_COMBINING.md.
% #'(0 . 0) prevents non-unisons from becoming combined chords.

flutesTogether = \partCombine #'(0 . 0)
  { \partCombineApart \global \introMark \fluteOneMusic }
  { \global \fluteTwoMusic }

clarinetsTogether = \partCombine #'(0 . 0)
  { \partCombineApart \global \introMark \clarinetOneMusic }
  { \global \clarinetTwoMusic }

trumpetsTogether = \partCombine #'(0 . 0)
  { \partCombineApart \global \introMark \trumpetOneMusic }
  { \global \trumpetTwoMusic }

trombonesTogether = \partCombine #'(0 . 0)
  { \partCombineApart \global \introMark \tromboneOneMusic }
  { \global \tromboneTwoMusic }
