% Single source of truth: only music/<instrument>.ily contains note events.
% Each paired desk is constructed from the two solo music streams.
% Keep printed and playback forms separate to honor D.C. al Fine.

flutesTogether = \partCombine #'(0 . 0)
  { \fluteOneMusic }
  { \fluteTwoMusic }
flutesTogetherPlayback = \partCombine #'(0 . 0)
  { \fluteOneMusicPlayback }
  { \fluteTwoMusicPlayback }

oboesTogether = \partCombine #'(0 . 0)
  { \oboeOneMusic }
  { \oboeTwoMusic }
oboesTogetherPlayback = \partCombine #'(0 . 0)
  { \oboeOneMusicPlayback }
  { \oboeTwoMusicPlayback }

clarinetsInATogether = \partCombine #'(0 . 0)
  { \clarinetInAOneMusic }
  { \clarinetInATwoMusic }
clarinetsInATogetherPlayback = \partCombine #'(0 . 0)
  { \clarinetInAOneMusicPlayback }
  { \clarinetInATwoMusicPlayback }

bassoonsTogether = \partCombine #'(0 . 0)
  { \bassoonOneMusic }
  { \bassoonTwoMusic }
bassoonsTogetherPlayback = \partCombine #'(0 . 0)
  { \bassoonOneMusicPlayback }
  { \bassoonTwoMusicPlayback }

hornsOneThreeTogether = \partCombine #'(0 . 0)
  { \hornOneMusic }
  { \hornThreeMusic }
hornsOneThreeTogetherPlayback = \partCombine #'(0 . 0)
  { \hornOneMusicPlayback }
  { \hornThreeMusicPlayback }

hornsTwoFourTogether = \partCombine #'(0 . 0)
  { \hornTwoMusic }
  { \hornFourMusic }
hornsTwoFourTogetherPlayback = \partCombine #'(0 . 0)
  { \hornTwoMusicPlayback }
  { \hornFourMusicPlayback }

trumpetsTogether = \partCombine #'(0 . 0)
  { \trumpetOneMusic }
  { \trumpetTwoMusic }
trumpetsTogetherPlayback = \partCombine #'(0 . 0)
  { \trumpetOneMusicPlayback }
  { \trumpetTwoMusicPlayback }

trombonesTogether = \partCombine #'(0 . 0)
  { \tromboneOneMusic }
  { \tromboneTwoMusic }
trombonesTogetherPlayback = \partCombine #'(0 . 0)
  { \tromboneOneMusicPlayback }
  { \tromboneTwoMusicPlayback }

tromboneThreeTubaTogether = \partCombine #'(0 . 0)
  { \tromboneThreeMusic }
  { \tubaMusic }
tromboneThreeTubaTogetherPlayback = \partCombine #'(0 . 0)
  { \tromboneThreeMusicPlayback }
  { \tubaMusicPlayback }
