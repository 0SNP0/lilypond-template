% Cymbals: source MusicXML P15, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
cymbalsOpening = \drummode {
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
 R2. |
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
 R2. |
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
 R2. ^\markup \italic { "with stick for snare drum" } |
 R2. |
  % Bars 77–80
 cymc4-! \f r4 cymc4-! |
 cymc4-! r4 cymc4-! |
 cymc4-! r4 cymc4-! |
 cymc4-! r4 cymc4-! |
  % Bars 81–84
 cymc4 r4 cymc4 |
 cymc4 r4 cymc4 |
 cymc4 r4 r4 |
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
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 105–108
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 109–112
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 113–116
 R2. |
 R2. |
 R2. |
 R2. |
}

cymbalsBridge = \drummode {
  % Bars 117–120
 r4 ^\markup \italic { "with stick for triangle" } cymc4-! \p cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 121–124
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 125–128
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 129–132
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 133–136
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 137–140
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 141–144
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 145–148
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
  % Bars 149–152
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 r4 cymc4-! cymc4-! |
 cymc4-! r4 r4 |
}

cymbalsMusic = { \cymbalsOpening \cymbalsBridge }
cymbalsMusicPlayback = { \cymbalsOpening \cymbalsBridge \cymbalsOpening }
