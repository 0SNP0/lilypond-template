% Snare Drum: source MusicXML P14, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
snareDrumOpening = \drummode {
  \clef percussion
  \time 3/4
  % Bars 1–4
 sn8-^ \f sn8-^ sn4-^ r4 |
 sn8-^ \f sn8-^ sn4-^ r4 |
 sn8-^ \f sn8-^ sn4-^ r4 |
 R2.*49 |
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
 R2.*36 |
}

snareDrumMusic = { \snareDrumOpening \snareDrumBridge }
snareDrumMusicPlayback = \scorePlayback \snareDrumOpening \snareDrumBridge
