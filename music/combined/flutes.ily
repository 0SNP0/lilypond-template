% Desk-only flute presentation. The solo source files remain authoritative.
% Both orchestral and desk print scores import these same definitions.

flutesTogether = \partCombine #'(0 . 0)
  { \fluteOneMusicCombined }
  { \fluteTwoMusicCombined }
flutesTogetherPlayback = \partCombine #'(0 . 0)
  { \fluteOneMusicPlayback }
  { \fluteTwoMusicPlayback }

flutesDeskCues = {
  s2.*76
  \once \override NoteColumn.ignore-collision = ##t
  \once \omit NoteHead
  \once \omit Stem
  \once \omit Dots
  gis''2.^\markup \italic { "I" } _\markup \italic { "II" }
  s2.*33
  \once \override NoteColumn.ignore-collision = ##t
  \once \omit NoteHead
  \once \omit Stem
  \once \omit Dots
  a'''2.^\markup \italic { "a2" }
  s2.*41
}
