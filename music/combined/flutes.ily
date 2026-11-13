% Native LilyPond-only mode map for the actual Flutes I-II desk.
% All decisions are local to this file; individual parts are unchanged.
% Printed measure numbers refer to the 152 unique bars of this score.
%
% I,II is the default: independent voices and opposing stems.
% I / II: only that instrument is printed; the other is silent.
% a2: one notehead and stem; both parts MUST have the same music.
%
% Flute I alone: bar 16.
% Flute II alone: bars 102-110.
% a2: bars 111-114 (the two source note streams agree there).
% All remaining bars: I,II.
flutesModeOpening = {
  \partCombineApart s2.*15
  \partCombineSoloI s2.
  \partCombineApart s2.*85
  \partCombineSoloII s2.*9
  \partCombineUnisono s2.*4
  \partCombineApart s2.*2
}
flutesModeBridge = { \partCombineApart s2.*36 }
flutesModeTimeline = { \flutesModeOpening \flutesModeBridge }
flutesModeTimelinePlayback = \scorePlayback \flutesModeOpening \flutesModeBridge

% PartCombine control events travel in parallel with the first source
% voice. This allows LilyPond to re-engrave the current source immediately
% on every preview, without generating an intermediate .ily file.
flutesTogether = \partCombine #'(0 . 0)
  { << { \fluteOneMusicCombined } { \flutesModeTimeline } >> }
  { \fluteTwoMusicCombined }
flutesTogetherPlayback = \partCombine #'(0 . 0)
  { << { \fluteOneMusicPlayback } { \flutesModeTimelinePlayback } >> }
  { \fluteTwoMusicPlayback }

% No invisible dummy notes for labels. PartCombine's own text engraver
% supplies I, II and a2 at mode transitions.
flutesDeskCues = { s2.*152 }
