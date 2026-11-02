% Shared, concert-pitch desk music. LilyPond's part combiner uses
% ONE notehead + ONE stem when players I and II are in exact unison;
% otherwise the two independent voices retain opposing stem directions.
% #'(0 . 0) combines unisons only: different pitches are NOT silently
% merged into chords. "a2" marks passages played together.
% Use \partCombineApart / \partCombineAutomatic in the source phrases if
% automatic decisions need to be overridden for a particular passage.
% The original music/*.ily files also feed separate player PDFs and MIDI.

flutesTogether = \partCombine #'(0 . 0)
  { \global \introMark \fluteOneMusic }
  { \global \fluteTwoMusic }

clarinetsTogether = \partCombine #'(0 . 0)
  { \global \introMark \clarinetOneMusic }
  { \global \clarinetTwoMusic }

trumpetsTogether = \partCombine #'(0 . 0)
  { \global \introMark \trumpetOneMusic }
  { \global \trumpetTwoMusic }

trombonesTogether = \partCombine #'(0 . 0)
  { \global \introMark \tromboneOneMusic }
  { \global \tromboneTwoMusic }
