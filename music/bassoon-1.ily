% PROVISIONAL solo split of MusicXML bassoons-1-2. Review pitches, chords, solo/a2.
bassoonOneOpening = {
  \clef bass
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
 gis2. _\markup \italic { "espr." }( \f ^\markup \italic { "I" } |
 gis2.~) \f |
 gis2.~ |
  % Bars 41-44
 gis4 r4 r4 |
 gis2.->( \f |
 gis2.~) \f |
 gis2.( |
  % Bars 45-48
 gis4) \mf r4 r4 |
 R2. |
 R2. |
 R2. |
  % Bars 49-52
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 53-56
 cis'2. _\markup \italic { "espr." }( \f |
 e'2.) |
 a2.( |
 cis'2.) |
  % Bars 57-60
 fis2. |
 e'4( d'4. a8 |
 cis'2. |
 b2.) |
  % Bars 61-64
 a2.( |
 cis'2.) |
 fis2.( |
 a2.) |
  % Bars 65-68
 d'2.~ |
 d'4 cis'4( d'4 |
 fis'4 e'4. cis'8 |
 d'2.) |
  % Bars 69-72
 cis'2. |
 cis'2. |
 fis'2.( |
 e'2.) |
  % Bars 73-76
 d'2. |
 cis'4( b4. cis'8 |
 b2. |
 a2.) |
  % Bars 77-80
 gis4 \ff r4 r4 |
 R2. |
 R2. |
 R2. |
  % Bars 81-84
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 85-88
 dis4 ^\markup \italic { "I" } \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 89-92
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 93-96
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 97-100
 dis4 r4 r4 |
 e4 r4 r4 |
 fis4 r4 r4 |
 R2. |
  % Bars 101-104
 dis4 ^\markup \italic { "a2" } \f r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 105-108
 dis4 r4 r4 |
 gis,4 r4 r4 |
 cis4 r4 r4 |
 e4 r4 r4 |
  % Bars 109-112
 cis4 r4 r4 |
 cis4 r4 r4 |
 fis4 r4 r4 |
 e4 r4 r4 |
  % Bars 113-116
 dis4 r4 r4 |
 e4 r4 r4 |
 e'8( gis'8) gis'4-. fis'4-. |
 e'4-. r4 r4 |
}

bassoonOneBridge = {
  % Bars 117-120
 \clef tenor gis'2.~( \pp |
 gis'2. |
 e'2.~ |
 e'2.) |
  % Bars 121-124
 e'2.~ |
 e'2. |
 gis'2.~ |
 gis'4 r4 r4 |
  % Bars 125-128
 gis'4-. gis'4-. gis'4-. |
 gis'4-. fis'4. gis'8 |
 a'2 gis'4~ |
 gis'2~ gis'8 r8 |
  % Bars 129-132
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 133-136
 R2. |
 R2. |
 R2. |
 R2. |
  % Bars 137-140
 gis'2.~( \pp |
 gis'2. |
 e'2.~ |
 e'2.) |
  % Bars 141-144
 e'2.~( |
 e'2. |
 gis'2.~ |
 gis'4) r4 r4 |
  % Bars 145-148
 gis'4-. \mp gis'4-. gis'4-. |
 gis'4-. r4 r4 |
 gis'4-. gis'4-. gis'4-. |
 gis'4-. r4 r4 |
  % Bars 149-152
 \clef bass cis'4-. cis'4-. cis'4-. |
 cis'4-. cis'4 r4 |
 b2.~ |
 b4 r4 r4 |
}

bassoonOneMusic = { \bassoonOneOpening \bassoonOneBridge }
bassoonOneMusicPlayback = \scorePlayback \bassoonOneOpening \bassoonOneBridge
