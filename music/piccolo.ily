% Piccolo: source MusicXML P1, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
piccoloOpening = {
  \key e \major
  \time 3/4
  % Bars 1–4
 R2. ^\markup \italic { "Tempo di valse allegro" } |
 R2.*75 |
 gis''4-. \ff r8 cis'''8-. e'''4-. |
 gis'''4-. r8 fis'''8-. e'''4-. |
 cis'''4-. r8 fis'''8-. a'''4-. |
 a'''4-. r8 b'''8-. a'''4-. |
  % Bars 81–84
 gis'''4-. r8 fis'''8-. e'''4-. |
 dis'''4-. r8 e'''8-. dis'''4-. |
 cis'''4-. r4 r4 |
 R2.*31 |
 gis''8( \ff e'''8) e'''4-. dis'''4-. |
 cis'''4-. r4 r4 |
}

piccoloBridge = {
  % Bars 117–120
 R2.*36 |
}

piccoloMusic = { \piccoloOpening \piccoloBridge }
piccoloMusicPlayback = \scorePlayback \piccoloOpening \piccoloBridge
