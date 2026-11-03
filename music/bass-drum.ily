% Bass Drum: source MusicXML P16, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
bassDrumOpening = \drummode {
  \clef percussion
  \time 3/4
  % Bars 1–4
 R2.*52 |
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
 R2.*17 |
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
 R2.*36 |
}

bassDrumMusic = { \bassDrumOpening \bassDrumBridge }
bassDrumMusicPlayback = \scorePlayback \bassDrumOpening \bassDrumBridge
