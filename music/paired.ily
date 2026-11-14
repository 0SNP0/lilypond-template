% Single source of truth: only music/<instrument>.ily contains note events.
% Each paired desk is constructed from the two solo music streams.
% Keep printed and playback forms separate to honor D.C. al Fine.

% The shared staff uses regular rest placement whenever both flutes rest.
% Individual overlap cases are corrected locally in flute-1.ily.
oboesTogether = \partCombine #'(0 . 0)
  { << { \oboeOneMusicCombined } { \partCombineApart s2.*152 } >> }
  { \oboeTwoMusicCombined }
oboesTogetherPlayback = << \new Voice { \voiceOne \oboeOneMusicPlayback } \new Voice { \voiceTwo \oboeTwoMusicPlayback } >>

clarinetsModeTimeline = {
  \partCombineApart s2.*111
  \partCombineSoloII s2.*3
  \partCombineApart s2.*38
}
clarinetsInATogether = \partCombine #'(0 . 0)
  { << { \clarinetInAOneMusicCombined } { \clarinetsModeTimeline } >> }
  { \clarinetInATwoMusicCombined }
clarinetsInATogetherPlayback = << \new Voice { \voiceOne \clarinetInAOneMusicPlayback } \new Voice { \voiceTwo \clarinetInATwoMusicPlayback } >>

bassoonsTogether = \partCombine #'(0 . 0)
  { << { \bassoonOneMusic } { \partCombineApart s2.*152 } >> }
  { \bassoonTwoMusicCombined }
bassoonsTogetherPlayback = << \new Voice { \voiceOne \bassoonOneMusicPlayback } \new Voice { \voiceTwo \bassoonTwoMusicPlayback } >>

hornsOneThreeTogether = \partCombine #'(0 . 0)
  { << { \hornOneMusic } { \partCombineApart s2.*152 } >> }
  { \hornThreeMusicCombined }
hornsOneThreeTogetherPlayback = << \new Voice { \voiceOne \hornOneMusicPlayback } \new Voice { \voiceTwo \hornThreeMusicPlayback } >>

hornsTwoFourTogether = \partCombine #'(0 . 0)
  { << { \hornTwoMusic } { \partCombineApart s2.*152 } >> }
  { \hornFourMusicCombined }
hornsTwoFourTogetherPlayback = << \new Voice { \voiceOne \hornTwoMusicPlayback } \new Voice { \voiceTwo \hornFourMusicPlayback } >>

trumpetsTogether = << \new Voice { \voiceOne \trumpetOneMusic } \new Voice { \voiceTwo \trumpetTwoMusicCombined } >>

trumpetsTogetherPlayback = << \new Voice { \voiceOne \trumpetOneMusicPlayback } \new Voice { \voiceTwo \trumpetTwoMusicPlayback } >>

trombonesTogether = \partCombine #'(0 . 0)
  { << { \tromboneOneMusic } { \partCombineApart s2.*152 } >> }
  { \tromboneTwoMusicCombined }
trombonesTogetherPlayback = << \new Voice { \voiceOne \tromboneOneMusicPlayback } \new Voice { \voiceTwo \tromboneTwoMusicPlayback } >>

tromboneThreeTubaTogether = \partCombine #'(0 . 0)
  { << { \tromboneThreeMusic } { \partCombineApart s2.*152 } >> }
  { \tubaMusicCombined }
tromboneThreeTubaTogetherPlayback = << \new Voice { \voiceOne \tromboneThreeMusicPlayback } \new Voice { \voiceTwo \tubaMusicPlayback } >>