% Trumpet in B-flat III: source MusicXML P11, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
trumpetThreeOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1–4
 f'8 _\markup \italic { "marc." }-_ \f f'8-_ f'4 r4 |
 ges'8-_ ges'8-_ ges'4 r4 |
 f'8-_ f'8-_ f'4-^ r4 |
 R2.*49 |
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2.*12 |
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2.*10 |
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2.*7 |
 r4 bes4-. \f bes4-. |
 r4 bes4-. bes4-. |
 r4 bes4-. bes4-. |
 r4 bes4-. bes4-. |
  % Bars 89–92
 r4 bes4-. bes4-. |
 r4 bes4-. bes4-. |
 r4 bes4-. bes4-. |
 r4 bes4-. bes4-. |
  % Bars 93–96
 r4 des'4-. des'4-. |
 r4 des'4-. des'4-. |
 r4 ces'4-. ces'4-. |
 r4 ces'4-. ces'4-. |
  % Bars 97–100
 ces'4-. r4 r4 |
 c'4-. r4 r4 |
 ces'4-. r4 r4 |
 R2.*2 |
 ais'2.~ \f ^\markup \italic { "III" } |
 ais'2.~ |
 ais'2.~ |
  % Bars 105–108
 ais'4 r4 r4 |
 ais'2.~ \f |
 ais'2.~ |
 ais'2.~ |
  % Bars 109–112
 ais'4 r4 r4 |
 R2.*7 |
}

trumpetThreeBridge = {
  % Bars 117–120
 R2.*36 |
}

trumpetThreeMusic = { \trumpetThreeOpening \trumpetThreeBridge }
trumpetThreeMusicPlayback = \scorePlayback \trumpetThreeOpening \trumpetThreeBridge
