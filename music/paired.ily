% Single source of truth: only music/<instrument>.ily contains note events.
% Each paired desk is constructed from the two solo music streams.
% Keep printed and playback forms separate to honor D.C. al Fine.

% The shared staff uses regular rest placement whenever both flutes rest.
% Individual overlap cases are corrected locally in flute-1.ily.
oboesTogether = \partCombine #'(0 . 0)
  { << { \oboeOneMusicCombined } { \partCombineApart s2.*152 } >> }
  { \oboeTwoMusic }
oboesTogetherPlayback = \partCombine #'(0 . 0)
  { << { \oboeOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \oboeTwoMusicPlayback }

clarinetsInATogether = \partCombine #'(0 . 0)
  { << { \clarinetInAOneMusicCombined } { \partCombineApart s2.*152 } >> }
  { \clarinetInATwoMusicCombined }
clarinetsInATogetherPlayback = \partCombine #'(0 . 0)
  { << { \clarinetInAOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \clarinetInATwoMusicPlayback }

bassoonsTogether = \partCombine #'(0 . 0)
  { << { \bassoonOneMusic } { \partCombineApart s2.*152 } >> }
  { \bassoonTwoMusic }
bassoonsTogetherPlayback = \partCombine #'(0 . 0)
  { << { \bassoonOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \bassoonTwoMusicPlayback }

hornsOneThreeTogether = \partCombine #'(0 . 0)
  { << { \hornOneMusic } { \partCombineApart s2.*152 } >> }
  { \hornThreeMusic }
hornsOneThreeTogetherPlayback = \partCombine #'(0 . 0)
  { << { \hornOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \hornThreeMusicPlayback }

hornsTwoFourTogether = \partCombine #'(0 . 0)
  { << { \hornTwoMusic } { \partCombineApart s2.*152 } >> }
  { \hornFourMusic }
hornsTwoFourTogetherPlayback = \partCombine #'(0 . 0)
  { << { \hornTwoMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \hornFourMusicPlayback }

trumpetsTogether = \partCombine #'(0 . 0)
  { << { \trumpetOneMusic } { \partCombineApart s2.*152 } >> }
  { \trumpetTwoMusic }
trumpetsTogetherPlayback = \partCombine #'(0 . 0)
  { << { \trumpetOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \trumpetTwoMusicPlayback }

trombonesTogether = \partCombine #'(0 . 0)
  { << { \tromboneOneMusic } { \partCombineApart s2.*152 } >> }
  { \tromboneTwoMusic }
trombonesTogetherPlayback = \partCombine #'(0 . 0)
  { << { \tromboneOneMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \tromboneTwoMusicPlayback }

tromboneThreeTubaTogether = \partCombine #'(0 . 0)
  { << { \tromboneThreeMusic } { \partCombineApart s2.*152 } >> }
  { \tubaMusic }
tromboneThreeTubaTogetherPlayback = \partCombine #'(0 . 0)
  { << { \tromboneThreeMusicPlayback } { \partCombineApart s2.*268 } >> }
  { \tubaMusicPlayback }
