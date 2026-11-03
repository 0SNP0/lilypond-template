% Piccolo: source MusicXML P1, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
piccoloOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1–4
 R2. ^\markup \italic { "Tempo di valse allegro" } |
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
 R2. |
 R2. |
  % Bars 77–80
 gis''4-. \ff r8 cis'''8-. e'''4-. |
 gis'''4-. r8 fis'''8-. e'''4-. |
 cis'''4-. r8 fis'''8-. a'''4-. |
 a'''4-. r8 b'''8-. a'''4-. |
  % Bars 81–84
 gis'''4-. r8 fis'''8-. e'''4-. |
 dis'''4-. r8 e'''8-. dis'''4-. |
 cis'''4-. r4 r4 |
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
 gis''8( \ff e'''8) e'''4-. dis'''4-. |
 cis'''4-. r4 r4 |
}

piccoloBridge = {
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

piccoloMusic = { \piccoloOpening \piccoloBridge }
piccoloMusicPlayback = { \piccoloOpening \piccoloBridge \piccoloOpening }
