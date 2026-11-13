\version "2.26.0"
% Verify part-combine control events can be kept separate from solo streams.
a = { \time 4/4 c''4 d'' e'' f'' | g''4 a'' b'' c''' | R1 | g''4 a'' b'' c''' | c''4 d'' e'' f'' | }
b = { \time 4/4 c''4 b' a' g' | R1 | c''4 d'' e'' f'' | g''4 a'' b'' c''' | R1 | }
controls = {
  \partCombineApart s1 |
  \partCombineSoloI s1 |
  \partCombineSoloII s1 |
  \partCombineUnisono s1 |
  \partCombineApart s1 |
}
\score {
  \new Staff \with {
    \consists Merge_rests_engraver
    soloText = "I"
    soloIIText = "II"
    aDueText = "a2"
  } {
    \partCombine #'(0 . 0)
      { << { \a } { \controls } >> }
      { \b }
  }
  \layout { }
}
