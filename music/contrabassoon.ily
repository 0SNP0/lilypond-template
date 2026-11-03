% Contrabassoon: source MusicXML P7, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
contrabassoonOpening = {
  \key e \major
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
 gis,4 r4 gis,4 |
 cis4 r4 r4 |
}

contrabassoonBridge = {
  % Bars 117–120
 e2.~ \pp |
 e2.~ |
 e2.~ |
 e2. |
  % Bars 121–124
 e2.~ |
 e2.~ |
 e2.~ |
 e2.~ |
  % Bars 125–128
 e4 r4 r4 |
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
 e2.~ \pp |
 e2.~ |
 e2.~ |
 e2. |
  % Bars 141–144
 e2.~ |
 e2.~ |
 e2.~ |
 e2. |
  % Bars 145–148
 e2.~ |
 e2.~ |
 e2.~ |
 e2.~ |
  % Bars 149–152
 e4 r4 r4 |
 R2. |
 e2.~ |
 e4 r4 r4 |
}

contrabassoonMusic = { \contrabassoonOpening \contrabassoonBridge }
contrabassoonMusicPlayback = { \contrabassoonOpening \contrabassoonBridge \contrabassoonOpening }
