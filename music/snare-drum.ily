% Snare Drum: source MusicXML P14, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
snareDrumOpening = \drummode {
  \clef percussion
  \time 3/4
  % Bars 1–4
 sn8-^ \f sn8-^ sn4-^ r4 |
 sn8-^ \f sn8-^ sn4-^ r4 |
 sn8-^ \f sn8-^ sn4-^ r4 |
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
 r4 \mf sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 57–60
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 61–64
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 65–68
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 69–72
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 73–76
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 77–80
 sn4 \f r4 sn4 |
 sn4 r4 sn4 |
 sn4 r4 sn4 |
 sn4 r4 sn4 |
  % Bars 81–84
 sn4 r4 sn4 |
 sn4 r4 sn4 |
 sn4 r4 r4 |
 R2. |
  % Bars 85–88
 r4 sn4 \mf sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 89–92
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 93–96
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 97–100
 sn4 r4 r4 |
 \acciaccatura { sn16 } sn4 r4 r4 |
 \acciaccatura { sn16 } sn4 r4 r4 |
 R2. |
  % Bars 101–104
 r4 sn4 \f sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 105–108
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 sn4 |
  % Bars 109–112
 r4 sn4 sn4 |
 r4 sn4 sn4 |
 r4 sn4 \< sn4 |
 r4 sn4 sn4 |
  % Bars 113–116
 sn4 \mf r4 r4 |
 \acciaccatura { sn16 } sn4 r4 r4 |
 \acciaccatura { sn16 } sn8 \f sn8 sn4 sn4 |
 \acciaccatura { sn16 } sn4 r4 r4 |
}

snareDrumBridge = \drummode {
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

snareDrumMusic = { \snareDrumOpening \snareDrumBridge }
snareDrumMusicPlayback = \scorePlayback \snareDrumOpening \snareDrumBridge
