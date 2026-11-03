% Trombone III / Tuba: source MusicXML P13, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
tromboneThreeAndTubaOpening = {
  \clef bass
  \key e \major
  \time 3/4
  % Bars 1–4
 gis,8-_ \f ^\markup \italic { "III" } gis,8-_ gis,4 r4 |
 gis,8-_ gis,8-_ gis,4 r4 |
 gis,8-_ gis,8-_ gis,4 r4 |
 fis,4-. ^\markup \italic { "Tuba sola" } \mf e,4-. dis,4-. |
  % Bars 5–8
 cis,4-. r4 r4 |
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
 <a, a>4 \mf r4 r4 |
 <gis, gis>4 r4 r4 |
 <fis, fis>4 r4 r4 |
 <e, e>4 r4 r4 |
  % Bars 57–60
 <d, d>4 r4 r4 |
 <b,, b,>4 r4 r4 |
 <e,, e,>4 r4 r4 |
 <e,, e,>4 r4 r4 |
  % Bars 61–64
 <a,, a,>4 r4 r4 |
 <gis,, gis,>4 r4 r4 |
 <fis, fis>4 r4 r4 |
 <e, e>4 r4 r4 |
  % Bars 65–68
 <d, d>4 r4 r4 |
 <a,, a,>4 r4 r4 |
 <fis,, fis,>4 r4 r4 |
 <b,, b,>4 r4 r4 |
  % Bars 69–72
 <a, a>4 r4 r4 |
 <gis, gis>4 r4 r4 |
 <fis, fis>4 r4 r4 |
 <e, e>4 r4 r4 |
  % Bars 73–76
 <d, d>4 r4 r4 |
 <e,, e,>4 r4 r4 |
 <eis,, eis,>4 r4 r4 |
 <fis,, fis,>4 r4 r4 |
  % Bars 77–80
 <gis,, gis,>4 \sf r4 r4 |
 R2. |
 R2. |
 R2. |
  % Bars 81–84
 R2. |
 R2. |
 cis4-. ^\markup \italic { "Tuba sola" } \mf gis,4-. e,4-. |
 cis,4-. r4 r4 |
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
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo gis2. } >> |
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
 <gis,, gis,>4-. \f r4 <gis,, gis,>4-. |
 <cis, cis>4-. r4 r4 |
}

tromboneThreeAndTubaBridge = {
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

tromboneThreeAndTubaMusic = { \tromboneThreeAndTubaOpening \tromboneThreeAndTubaBridge }
tromboneThreeAndTubaMusicPlayback = { \tromboneThreeAndTubaOpening \tromboneThreeAndTubaBridge \tromboneThreeAndTubaOpening }
