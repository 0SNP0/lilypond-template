% Horns in F I & III: source MusicXML P8, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
hornsOneThreeOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1–4
 <dis' dis''>8 _\markup \italic { "marc." }-_ \f <dis' dis''>8-_ <dis' dis''>4-_ r4 |
 <dis' dis''>8-^ <dis' dis''>8-^ <dis' dis''>4-^ r4 |
 <dis' dis''>8-^ <dis' dis''>8-^ <dis' dis''>4-^ r4 |
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
 gis'2.->( ^\markup \italic { "I" } \f |
 gis'2.~) \f |
 gis'2.( |
  % Bars 49–52
 gis'4) \mf r4 r4 |
 R2. |
 b'4( \mf dis''4-.) cis''4-. |
 b'4-. r4 r4 |
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
 <gis' dis''>4-. \ff r4 <gis' dis''>4-. |
 <gis' dis''>4-. r4 <gis' dis''>4-. |
 <gis' e''>4-. r4 <gis' e''>4-. |
 <gis' e''>4-. r4 <gis' e''>4-. |
  % Bars 81–84
 <gis' dis''>4-. r4 <gis' dis''>4-. |
 <fisis' dis''>4-. r4 <fisis' dis''>4-. |
 <gis' dis''>4-. r4 r4 |
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
 r4 <fisis' dis''>4-. \ff <fisis' dis''>4-. |
 r4 <fisis' dis''>4-. <fisis' dis''>4-. |
 r4 <gis' dis''>4-. <gis' dis''>4-. |
 r4 <gis' dis''>4-. <gis' dis''>4-. |
  % Bars 105–108
 r4 <fisis' dis''>4-. <fisis' dis''>4-. |
 r4 <fisis' dis''>4-. <fisis' dis''>4-. |
 r4 <gis' dis''>4-. <gis' dis''>4-. |
 r4 <gis' dis''>4-. <gis' dis''>4-. |
  % Bars 109–112
 r4 <gis' dis''>4-. <gis' dis''>4-. |
 r4 <gis' dis''>4-. <gis' dis''>4-. |
 r4 <gis' e''>4-. <gis' e''>4-. |
 r4 <gis' e''>4-. <gis' e''>4-. |
  % Bars 113–116
 <gis' e''>4-> \ff r4 r4 |
 <gis' e''>4-> r4 r4 |
 R2. |
 R2. |
}

hornsOneThreeBridge = {
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

hornsOneThreeMusic = { \hornsOneThreeOpening \hornsOneThreeBridge }
hornsOneThreeMusicPlayback = { \hornsOneThreeOpening \hornsOneThreeBridge \hornsOneThreeOpening }
