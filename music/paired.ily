% Single source of truth: only music/<instrument>.ily contains note events.
% Each paired desk is constructed from the two solo music streams.
% Keep printed and playback forms separate to honor D.C. al Fine.

% The shared staff uses regular rest placement whenever both flutes rest.
% Individual overlap cases are corrected locally in flute-1.ily.
oboesTogether = << \new Voice { \voiceOne \oboeOneMusicCombined } \new Voice { \voiceTwo \oboeTwoMusic } >>
oboesTogetherPlayback = << \new Voice { \voiceOne \oboeOneMusicPlayback } \new Voice { \voiceTwo \oboeTwoMusicPlayback } >>

clarinetsInATogether = <<
  \new Voice { \voiceOne \clarinetInAOneMusicCombined }
  \new Voice { \voiceTwo \clarinetInATwoMusicCombined }
>>
clarinetsInATogetherPlayback = <<
  \new Voice { \voiceOne \clarinetInAOneMusicPlayback }
  \new Voice { \voiceTwo \clarinetInATwoMusicPlayback }
>>


bassoonsTogether = << \new Voice { \voiceOne \bassoonOneMusic } \new Voice { \voiceTwo \bassoonTwoMusic } >>
bassoonsTogetherPlayback = << \new Voice { \voiceOne \bassoonOneMusicPlayback } \new Voice { \voiceTwo \bassoonTwoMusicPlayback } >>

hornsOneThreeTogether = << \new Voice { \voiceOne \hornOneMusic } \new Voice { \voiceTwo \hornThreeMusic } >>
hornsOneThreeTogetherPlayback = << \new Voice { \voiceOne \hornOneMusicPlayback } \new Voice { \voiceTwo \hornThreeMusicPlayback } >>

hornsTwoFourTogether = << \new Voice { \voiceOne \hornTwoMusic } \new Voice { \voiceTwo \hornFourMusic } >>
hornsTwoFourTogetherPlayback = << \new Voice { \voiceOne \hornTwoMusicPlayback } \new Voice { \voiceTwo \hornFourMusicPlayback } >>

trumpetsTogether = << \new Voice { \voiceOne \trumpetOneMusic } \new Voice { \voiceTwo \trumpetTwoMusic } >>
trumpetsTogetherPlayback = << \new Voice { \voiceOne \trumpetOneMusicPlayback } \new Voice { \voiceTwo \trumpetTwoMusicPlayback } >>

trombonesTogether = << \new Voice { \voiceOne \tromboneOneMusic } \new Voice { \voiceTwo \tromboneTwoMusic } >>
trombonesTogetherPlayback = << \new Voice { \voiceOne \tromboneOneMusicPlayback } \new Voice { \voiceTwo \tromboneTwoMusicPlayback } >>

tromboneThreeTubaTogether = << \new Voice { \voiceOne \tromboneThreeMusic } \new Voice { \voiceTwo \tubaMusic } >>
tromboneThreeTubaTogetherPlayback = << \new Voice { \voiceOne \tromboneThreeMusicPlayback } \new Voice { \voiceTwo \tubaMusicPlayback } >>
