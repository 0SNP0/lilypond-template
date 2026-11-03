% Bass Drum: source MusicXML P16, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
bassDrumOpening = \drummode {
  \clef percussion
  \time 3/4
  % Bars 1–4
 R2. |
 R2. |
 R2. |
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
 bd4 \tweak transparent ##t \mf r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 57–60
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 61–64
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 65–68
 bd4 r4 r4 |
 << { \voiceOne bd4 r4 r4 } \\ { \voiceTwo bd2. } >> |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 69–72
 << { \voiceOne bd4 r4 r4 } \\ { \voiceTwo bd2. } >> |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 73–76
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 77–80
 bd4 \tweak transparent ##t \f r4 r4 |
 R2. |
 bd4 r4 r4 |
 R2. |
  % Bars 81–84
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 R2. |
  % Bars 85–88
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 89–92
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 93–96
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 97–100
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 101–104
 bd4 \mf r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 105–108
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 109–112
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 r4 r4 |
  % Bars 113–116
 bd4 r4 r4 |
 bd4 r4 r4 |
 bd4 \mf r4 bd4 |
 bd4 r4 r4 |
}

bassDrumBridge = \drummode {
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

bassDrumMusic = { \bassDrumOpening \bassDrumBridge }
bassDrumMusicPlayback = \scorePlayback \bassDrumOpening \bassDrumBridge
