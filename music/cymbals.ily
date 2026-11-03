% Cymbals: source MusicXML P15, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
cymbalsOpening = \drummode {
  \clef percussion
  \time 3/4
  % Bars 1–4
 R2.*74 |
 R2. ^\markup \italic { "with stick for snare drum" } |
 R2. |
  % Bars 77–80
 cymc4 _\markup \italic { "secco" }-! \tweak transparent ##t \f r4 cymc4-! |
 cymc4-! r4 cymc4-! |
 cymc4-! r4 cymc4-! |
 cymc4-! r4 cymc4-! |
  % Bars 81–84
 cymc4 r4 cymc4 |
 cymc4 r4 cymc4 |
 cymc4 r4 r4 |
 R2.*33 |
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
cymbalsMusicPlayback = \scorePlayback \cymbalsOpening \cymbalsBridge
