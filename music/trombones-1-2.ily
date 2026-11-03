% Trombones I–II: source MusicXML P12, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
trombonesOneTwoOpening = {
  \clef bass
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
 r4 <cis' e'>4-. \mf <cis' e'>4-. |
 r4 <cis' e'>4-. <cis' e'>4-. |
 r4 <a cis'>4-. <a cis'>4-. |
 r4 <gis cis'>4-. <gis cis'>4-. |
  % Bars 57–60
 r4 <fis a>4-. <fis a>4-. |
 r4 <fis a>4-. <fis a>4-. |
 r4 <a cis'>4-. <a cis'>4-. |
 r4 <gis d'>4-. <gis d'>4-. |
  % Bars 61–64
 r4 <a cis'>4-. <a cis'>4-. |
 r4 <gis cis'>4-. <gis cis'>4-. |
 r4 <fis a>4-. <fis a>4-. |
 r4 <a cis'>4-. <a cis'>4-. |
  % Bars 65–68
 r4 <fis a>4-. <fis a>4-. |
 r4 <fis a>4-. <fis a>4-. |
 r4 <fis ais>4-. <fis ais>4-. |
 r4 <fis b>4-. <fis b>4-. |
  % Bars 69–72
 r4 <cis' e'>4-. <cis' e'>4-. |
 r4 <cis' e'>4-. <cis' e'>4-. |
 r4 <a cis'>4-. <a cis'>4-. |
 r4 <gis cis'>4-. <gis cis'>4-. |
  % Bars 73–76
 r4 <fis a>4-. <fis a>4-. |
 r4 <fis a>4-. <fis a>4-. |
 r4 <b d'>4-. <b d'>4-. |
 r4 <a cis'>4-. <a cis'>4-. |
  % Bars 77–80
 <gis cis'>4-. \sf r4 r4 |
 R2. |
 R2. |
 R2. |
  % Bars 81–84
 R2. |
 R2. |
 R2. |
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
 gis2.~ \f ^\markup \italic { "I" } |
 gis2.~ |
 gis2.~ |
  % Bars 105–108
 gis4 r4 r4 |
 gis2.~ \f |
 gis2.~ |
 << { \voiceOne gis2.~ } \\ { \voiceTwo gis2. } >> |
  % Bars 109–112
 gis4 r4 r4 |
 R2. |
 R2. |
 R2. |
  % Bars 113–116
 R2. |
 R2. |
 <gis cis'>4-. \f r4 <gis bis>4-. |
 <gis cis'>4-. r4 r4 |
}

trombonesOneTwoBridge = {
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

trombonesOneTwoMusic = { \trombonesOneTwoOpening \trombonesOneTwoBridge }
trombonesOneTwoMusicPlayback = { \trombonesOneTwoOpening \trombonesOneTwoBridge \trombonesOneTwoOpening }
