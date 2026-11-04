% Violoncellos: source MusicXML P20, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
violoncellosOpening = {
  % Reset the MIDI program on every return to the Opening (D.C. al Fine).
  % This is playback state only; it does not add a printed arco label.
  \set Staff.midiInstrument = "cello"
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1–4
 R2.*4 |
 cis4 \mf r4 r4 |
 e4 r4 r4 |
 a,4 r4 r4 |
 fis,4 r4 r4 |
  % Bars 9–12
 e4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
 dis4 r4 r4 |
  % Bars 13–16
 cis4 r4 r4 |
 b,4 r4 r4 |
 a,4 r4 r4 |
 fis,4 r4 r4 |
  % Bars 17–20
 e4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 gis,4-_ |
 cis4 r4 r4 |
  % Bars 21–24
 dis4 \mf r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 25–28
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 29–32
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 33–36
 dis4-> r4 r4 |
 e4-> r4 r4 |
 fis4-> r4 r4 |
 R2. |
  % Bars 37–40
 dis4 \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 41–44
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 45–48
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 49–52
 dis4 r4 r4 |
 e4 r4 r4 |
 gis,4 r4 gis,4 |
 cis4 r4 r4 |
  % Bars 53–56
 a2. _\markup \italic { "espr." } \f |
 gis2. |
 fis2. |
 e2. |
  % Bars 57–60
 d2. |
 b,2. |
 e,2. |
 e,2. |
  % Bars 61–64
 a,2. |
 gis,2. |
 fis2. |
 e2. |
  % Bars 65–68
 d2. |
 a,2. |
 fis,2. |
 b,2. |
  % Bars 69–72
 a2. |
 gis2. |
 fis2. |
 e2. |
  % Bars 73–76
 d2. |
 e,2. |
 eis,2. |
 fis,2. |
  % Bars 77–80
 gis,4 \ff r4 gis,4 |
 gis,4 r4 gis,4 |
 fis,4 r4 fis,4 |
 fis,4 r4 fis,4 |
  % Bars 81–84
 gis,4 r4 gis,4 |
 gis,4 r4 gis,4 |
 cis4 r4 r4 |
 R2. |
  % Bars 85–88
 dis4 \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 89–92
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 93–96
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 97–100
 dis4 r4 r4 |
 e4 r4 r4 |
 fis4 r4 r4 |
 R2. |
  % Bars 101–104
 dis4 \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 105–108
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 109–112
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 113–116
 dis4 r4 r4 |
 e4 r4 r4 |
 gis,4 \ff r4 gis,4 |
 cis4 r4 r4 |
}

violoncellosBridge = {
  % Bars 117–120
  \set Staff.midiInstrument = "pizzicato strings"
 r4 ^\markup \italic { "pizz." } gis4 \p gis4 |
 r4 gis4 gis4 |
 r4 a4 a4 |
 r4 a4 a4 |
  % Bars 121–124
 r4 a4 a4 |
 r4 a4 a4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 125–128
 r4 gis4 gis4 |
 r4 a4 a4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 129–132
 r4 gis4 gis4 |
 r4 fisis4 fisis4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 133–136
 r4 gis4 gis4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 137–140
 r4 gis4 gis4 |
 r4 gis4 gis4 |
 r4 a4 a4 |
 r4 a4 a4 |
  % Bars 141–144
 r4 a4 a4 |
 r4 a4 a4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 145–148
 r4 gis4 gis4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
 r4 gis4 gis4 |
  % Bars 149–152
 r4 a4 a4 |
 r4 a4 a4 |
 r4 gis4 gis4 |
 gis4 r4 r4 |
}

violoncellosMusic = { \violoncellosOpening \violoncellosBridge }
violoncellosMusicPlayback = \scorePlayback \violoncellosOpening \violoncellosBridge
