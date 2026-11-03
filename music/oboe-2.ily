% PROVISIONAL solo split of MusicXML oboes-1-2. Review pitches, chords, solo/a2.
oboeTwoOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1-4
 R2. |
 R2. |
 R2. |
  R2. |
  % Bars 5-8
 R2. |
  R2. |
  R2. |
  R2. |
  % Bars 9-12
  R2. |
  R2. |
  R2. |
  R2. |
  % Bars 13-16
  R2. |
  R2. |
  R2. |
  R2. |
  % Bars 17-20
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 21-24
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 25-28
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 29-32
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 33-36
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 37-40
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 41-44
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 45-48
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 49-52
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 53-56
 a'2.( \f |
 cis''2.) |
 fis'2.( |
 gis'2.) |
  % Bars 57-60
 d'2. |
 cis''4(( b'4. fis'8 |
 a'2. |
 gis'2.)) |
  % Bars 61-64
 fis'2.(( \f |
 gis'2.)) |
 cis'2.( |
 fis'2.) |
  % Bars 65-68
 b'2.~ |
 b'4 ais'4( b'4 |
 d''4 cis''4. ais'8 |
 b'2.) |
  % Bars 69-72
 a'2.( |
 gis'2.) |
 cis''2. |
 cis''2. |
  % Bars 73-76
 a'2. |
 gis'4( fis'4. gis'8 |
 fis'2.) |
 fis'2. |
  % Bars 77-80
 e'4-. \ff r8 gis'8-. cis''4-. |
 e''4-. r8 dis''8-. cis''4-. |
 a'4-. r8 cis''8-. fis''4-. |
 fis''4-. r8 gis''8-. fis''4-. |
  % Bars 81-84
 e''4-. r8 dis''8-. cis''4-. |
 bis'4 r4 bis'4 |
 cis''4 s2 |
 R2. |
  % Bars 85-88
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 89-92
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 93-96
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 97-100
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 101-104
 gis'2.~( \ff |
 gis'4 a'2) \f |
 gis'4( cis''2) |
 gis'4( cis''2) |
  % Bars 105-108
 gis'2.~( \ff |
 gis'4 a'2) |
 gis'4( cis''2) |
 gis'4( e''2) |
  % Bars 109-112
 cis''2.~( \ff |
 cis''4 d''2) |
 a''2.~ |
 a''4 fis''4 \ff gis''4 |
  % Bars 113-116
 a''4 gis''4 fis''4 |
 e''4 cis''4 a'4 |
 gis'8( \ff e''8) e''4-. dis''4-. |
 cis''4-. s2 |
}

oboeTwoBridge = {
  % Bars 117-120
 R2. |
  R2. |
  R2. |
  R2. |
  % Bars 121-124
  R2. |
  R2. |
  R2. |
 r4 e'4( \p fis'4 |
  % Bars 125-128
 gis'4-.) gis'4-. gis'4-. |
 gis'4-. fis'4. gis'8 |
 fis'2 e'4~ |
 e'2~ e'8 s8 |
  % Bars 129-132
 b'4-. \mf b'4-. b'4-. |
 b'4-. ais'4.( b'8 |
 cis''2 b'4~ |
 b'2.) |
  % Bars 133-136
 gis'2.~ \p |
 gis'2. |
 gis'2.~ |
 gis'2.~ \> |
  % Bars 137-140
 gis'4 \mp \pp r4 \mp \pp r4 |
 R2. |
 R2. |
  R2. |
  % Bars 141-144
  R2. |
  R2. |
  R2. |
 r4 e'4( \p fis'4 |
  % Bars 145-148
 gis'4-.) gis'4-. gis'4-. |
 gis'4-. \< gis'4( ais'4 |
 b'4-.) \mp b'4-. b'4-. |
 b'4-. s2 |
  % Bars 149-152
 R2. |
 R2. |
 R2. |
 R2. |
}

oboeTwoMusic = { \oboeTwoOpening \oboeTwoBridge }
oboeTwoMusicPlayback = \scorePlayback \oboeTwoOpening \oboeTwoBridge
