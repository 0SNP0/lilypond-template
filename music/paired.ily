% Single source of truth: only music/<instrument>.ily contains note events.
% Each paired desk is constructed from the two solo music streams.
% Keep printed and playback forms separate to honor D.C. al Fine.

% The shared staff uses regular rest placement whenever both flutes rest.
% Individual overlap cases are corrected locally in flute-1.ily.
oboesTogether = \partCombine #'(0 . 0)
  { << { \oboeOneMusicCombined } { \partCombineApart s2.*152 } >> }
  { \oboeTwoMusicCombined }
oboesTogetherPlayback = << \new Voice { \voiceOne \oboeOneMusicPlayback } \new Voice { \voiceTwo \oboeTwoMusicPlayback } >>

% Combined clarinet staff only: centered shared rests, default otherwise.
clarinetsRestLayout = {
  \deskRestCenter s2.*36
  \deskRestAuto s2.*16
  \deskRestCenter s2.*16
  \deskRestAuto s2.*34
  \deskRestCenter s2.*2
  \deskRestAuto s2.*2
  \deskRestCenter s2.*2
  \deskRestAuto s2.*2
  \deskRestCenter s2.
  \deskRestAuto s2.*13
  \deskRestCenter s2.*3
  \deskRestAuto s2.*17
  \deskRestCenter s2.*3
  \deskRestAuto s2.*5
}
clarinetsModeTimeline = {
  % 1-48: two voices; the label at 48 is unnecessary.
  \partCombineApart s2.*48
  % 49-52: identical a2 phrase.
  \partCombineSoloI s2.*4
  \partCombineApart s2.*16
  % Rehearsal 15, bars 69-76: first clarinet only.
  \partCombineSoloI s2.*8
  % Rehearsal 16: independent voices, no redundant label.
  \partCombineApart s2.*8
  % Rehearsal 17, bars 85-92: first clarinet only.
  \partCombineSoloI s2.*8
  % 93-94: both clarinets, explicit label.
  \partCombineApart s2.*2
  % 95-100: both voices; upper voice must retain its full-bar rests.
  \partCombineApart s2.*6
  \partCombineApart s2.*11
  % 112-114: second clarinet only.
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