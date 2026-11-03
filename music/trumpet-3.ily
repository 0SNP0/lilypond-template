% Trumpet in B-flat III: source MusicXML P11, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
trumpetThreeOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1–4
 f'8-_ \f f'8-_ f'4 r4 |
 ges'8-_ ges'8-_ ges'4 r4 |
 f'8-_ f'8-_ f'4-^ r4 |
  R2. |
  % Bars 5–8
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 9–12
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 13–16
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 17–20
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 21–24
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 25–28
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 29–32
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 33–36
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 37–40
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 41–44
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 45–48
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 49–52
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 53–56
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2. |
 R2. |
 R2. |
  % Bars 57–60
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 61–64
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 65–68
 R2. |
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2. |
 R2. |
  % Bars 69–72
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 73–76
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 77–80
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo a'2. } >> |
 R2. |
 R2. |
 R2. |
  % Bars 81–84
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 85–88
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
 R2. |
  % Bars 101–104
 R2. |
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
 R2. |
 R2. |
 R2. |
  % Bars 113–116
 R2. |
 R2. |
 R2. |
 R2. |
}

trumpetThreeBridge = {
  % Bars 117–120
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 121–124
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 125–128
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 129–132
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 133–136
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 137–140
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 141–144
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 145–148
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 149–152
 R2. |
 R2. |
 R2. |
 R2. |
}

trumpetThreeMusic = { \trumpetThreeOpening \trumpetThreeBridge }
trumpetThreeMusicPlayback = { \trumpetThreeOpening \trumpetThreeBridge \trumpetThreeOpening }
