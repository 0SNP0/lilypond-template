% English Horn: source MusicXML P4, 152 printed measures, 268 playback measures, written pitch
% One measure per line, numbered blocks for Frescobaldi/VS Code.
englishHornOpening = {
  \clef treble
  \key b \major
  \time 3/4
  % Bars 1–4
 R2.*52 |
 b'2. _\markup \italic { "espr." }( \f |
 dis''2.) |
 gis'2.( |
 b'2.) |
  % Bars 57–60
 e'2. |
 dis''4( cis''4. gis'8 |
 b'2. |
 a'2.) |
  % Bars 61–64
 gis'2.( |
 b'2.) |
 e'2.( |
 gis'2.) |
  % Bars 65–68
 cis''2.~ |
 cis''4 cis''2( |
 eis''4) eis''4.( b'8 |
 cis''2.) |
  % Bars 69–72
 b'2. |
 b'2. |
 e''2.( |
 dis''2.) |
  % Bars 73–76
 cis''2. |
 b'4( a'4. b'8 |
 a'2. |
 gis'2.~ |
  % Bars 77–80
 gis'4) r4 r4 |
 R2.*23 |
 dis''8( \ff e''8 dis''8 cis''8 ais'8 fisis'8 |
 dis'4) r4 r4 |
 R2.*2 |
 dis''8( \ff e''8 dis''8 cis''8 ais'8 fisis'8 |
 dis'4) r4 r4 |
 R2.*2 |
 gis''8( \ff a''8 gis''8 fis''8 dis''8 bis'8 |
 gis'4) r4 r4 |
 R2.*4 |
 b'8( \ff dis''8) dis''4-. cis''4-. |
 b'4-. r4 r4 |
}

englishHornBridge = {
  % Bars 117–120
 R2.*12 |
 dis''4-. \mf dis''4-. dis''4-. |
 cisis''4 cisis''4.( cisis''8 |
 cisis''2 dis''4~ |
 dis''2.) |
  % Bars 133–136
 ais'2.~ \p |
 ais'2. |
 ais'2.~ |
 ais'2.~ \> |
  % Bars 137–140
 ais'4 \pp r4 r4 |
 R2.*15 |
}

englishHornMusic = { \englishHornOpening \englishHornBridge }
englishHornMusicPlayback = \scorePlayback \englishHornOpening \englishHornBridge
