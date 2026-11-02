% Concert-pitch paired desks. Independent Voice contexts keep parts I (stems up)
% and II (stems down) distinct even at unisons, for both conductor scores
% and the paired PDFs. Individual part files still print each player alone.

flutesTogether = <<
  \new Voice = "flutesOne" { \voiceOne \global \introMark \fluteOneMusic }
  \new Voice = "flutesTwo" { \voiceTwo \global \fluteTwoMusic }
>>

clarinetsTogether = <<
  \new Voice = "clarinetsOne" { \voiceOne \global \introMark \clarinetOneMusic }
  \new Voice = "clarinetsTwo" { \voiceTwo \global \clarinetTwoMusic }
>>

trumpetsTogether = <<
  \new Voice = "trumpetsOne" { \voiceOne \global \introMark \trumpetOneMusic }
  \new Voice = "trumpetsTwo" { \voiceTwo \global \trumpetTwoMusic }
>>

trombonesTogether = <<
  \new Voice = "trombonesOne" { \voiceOne \global \introMark \tromboneOneMusic }
  \new Voice = "trombonesTwo" { \voiceTwo \global \tromboneTwoMusic }
>>
