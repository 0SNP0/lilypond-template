% Violas: source MusicXML P19, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
violasOpening = {
  \clef alto
  \key e \major
  \time 3/4
  % Bars 1–4
 R2.*4 |
 r4 ^\markup \italic { "div." } <gis cis'>4-_ \mf <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
  % Bars 9–12
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
  % Bars 13–16
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
  % Bars 17–20
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis cis'>4-_ <gis cis'>4-_ |
 <gis cis'>4 r4 r4 |
  % Bars 21–24
 r4 <gis bis>4-_ \mf <gis bis>4 |
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
  % Bars 25–28
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
  % Bars 29–32
 r4 <b cis'>4-_ <b cis'>4 |
 r4 <b cis'>4-_ <b cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
  % Bars 33–36
 <a cis'>4-> r4 r4 |
 <ais cis'>4-> r4 r4 |
 <a cis'>4-> r4 r4 |
 R2. |
  % Bars 37–40
 r4 <gis bis>4-_ \f <gis bis>4 |
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
  % Bars 41–44
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis bis>4-_ <gis bis>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
 r4 <gis cis'>4-_ <gis cis'>4 |
  % Bars 45–48
 r4 <b cis'>4-_ <b cis'>4 |
 r4 <b cis'>4-_ <b cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
 r4 <a cis'>4-_ <a cis'>4 |
  % Bars 49–52
 <a cis'>4 r4 r4 |
 <a cis'>4 r4 r4 |
 <gis cis'>4-_ r4 <gis bis>4-_ |
 <gis cis'>4 r4 r4 |
  % Bars 53–56
 << { \voiceOne e'2. _\markup \italic { "espr." } \f } \\ { \voiceTwo cis'2. } >> |
 << { \voiceOne gis'2. } \\ { \voiceTwo e'2. } >> |
 << { \voiceOne cis'2. } \\ { \voiceTwo a2. } >> |
 << { \voiceOne e'2. } \\ { \voiceTwo cis'2. } >> |
  % Bars 57–60
 << { \voiceOne a2. } \\ { \voiceTwo fis2. } >> |
 <e' gis'>4 <d' fis'>4. <a cis'>8 |
 << { \voiceOne e'2. } \\ { \voiceTwo cis'2. } >> |
 << { \voiceOne d'2. } \\ { \voiceTwo b2. } >> |
  % Bars 61–64
 << { \voiceOne cis'2. } \\ { \voiceTwo a2. } >> |
 << { \voiceOne e'2. } \\ { \voiceTwo cis'2. } >> |
 << { \voiceOne a2. } \\ { \voiceTwo fis2. } >> |
 << { \voiceOne cis'2. } \\ { \voiceTwo a2. } >> |
  % Bars 65–68
 << { \voiceOne fis'2.~ } \\ { \voiceTwo d'2.~ } >> |
 << { \voiceOne fis'4 fis'4 fis'4 } \\ { \voiceTwo d'4 cis'4 d'4 } >> |
 << { \voiceOne ais'4 ais'4. e'8 } \\ { \voiceTwo f'4 e'4. cis'8 } >> |
 << { \voiceOne fis'2. \< } \\ { \voiceTwo d'2. } >> |
  % Bars 69–72
 <cis' e'>2. \f |
 <cis' e'>2. |
 <fis' a'>2. |
 <e' gis'>2. |
  % Bars 73–76
 <d' fis'>2. |
 <cis' e'>4 <b d'>4. <cis' e'>8 |
 <b d'>2. |
 <a cis'>2. |
  % Bars 77–80
 <gis cis'>4 \ff r4 <gis cis'>4 |
 <gis cis'>4 r4 <gis cis'>4 |
 <a cis'>4 r4 <a cis'>4 |
 <a cis'>4 r4 <a cis'>4 |
  % Bars 81–84
 <gis cis'>4 r4 <gis cis'>4 |
 <gis bis>4 r4 <gis bis>4 |
 <gis cis'>4 r4 r4 |
 R2.*9 |
 << { \voiceOne \once \override MultiMeasureRest.staff-position = #10 R2. } \\ { \voiceTwo gis2. } >> |
 R2.*7 |
 gis'2. _\markup \italic { "espr." }~ \f |
 gis'4-_ a'4.( gis'8-_) |
 gis'4( cis''4. gis'8-_) |
 gis'4( cis''4. gis'8) |
  % Bars 105–108
 gis'2.~ |
 gis'4 a'4.( gis'8-_) |
 gis'4( cis''4. gis'8-_) |
 gis'4( e''4. cis''8) |
  % Bars 109–112
 cis''2.~ |
 cis''4 r4 r4 |
 R2.*4 |
 e'8 \ff gis'8 gis'4-. fis'4-. |
 e'4-. r4 r4 |
}

violasBridge = {
  % Bars 117–120
  \set Staff.midiInstrument = "pizzicato strings"
 r4 ^\markup \italic { "pizz." } b4 \p b4 |
 r4 b4 b4 |
 r4 cis'4 cis'4 |
 r4 cis'4 cis'4 |
  % Bars 121–124
 r4 cis'4 cis'4 |
 r4 cis'4 cis'4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 125–128
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 129–132
 r4 b4 b4 |
 r4 cis'4 cis'4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 133–136
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 137–140
 r4 b4 b4 |
 r4 b4 b4 |
 r4 cis'4 cis'4 |
 r4 cis'4 cis'4 |
  % Bars 141–144
 r4 cis'4 cis'4 |
 r4 cis'4 cis'4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 145–148
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
 r4 b4 b4 |
  % Bars 149–152
 r4 cis'4 cis'4 |
 r4 cis'4 cis'4 |
 r4 b4 b4 |
 b4 r4 r4 |
}

violasMusic = { \violasOpening \violasBridge }
violasMusicPlayback = \scorePlayback \violasOpening \violasBridge
