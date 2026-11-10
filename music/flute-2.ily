% PROVISIONAL solo split of MusicXML flutes-1-2. Review chords and solo/a2 labels.
fluteTwoOpening = {
  \clef treble
  \key e \major
  \time 3/4
  % Bars 1-4
 R2.*76 |
 e''4-. \ff r8 gis''8-. cis'''4-. |
 e'''4-. r8 dis'''8-. cis'''4-. |
 a''4-. r8 cis'''8-. fis'''4-. |
 fis'''4-. r8 gis'''8-. fis'''4-. |
  % Bars 81-84
 e'''4-. r8 dis'''8-. cis'''4-. |
 bis''4 r4 bis''4 |
 cis'''4 s2 |
 R2.*17 |
 gis''2.~( |
 \tag #'solo { gis''4 a''2) }
 \tag #'combined { gis''4^\markup \italic { "II" } a''2) } |
 gis''4( cis'''2) |
 gis''4( cis'''2) |
  % Bars 105-108
 gis''2.~( |
 gis''4 a''2) |
 gis''4( cis'''2) |
 gis''4( e'''2) |
  % Bars 109-112
 cis'''2.~ |
 cis'''4 d'''2 |
  % Both flutes play the same notes in measures 111-114.
 a'''2.~ |
 a'''4 fis'''4 \ff gis'''4 |
 a'''4 gis'''4 fis'''4 |
 e'''4 cis'''4 a''4 |
 gis''8( \ff e'''8) e'''4-. dis'''4-. |
 cis'''4-. s2 |
}

fluteTwoBridge = {
  % Bars 117-120
 R2.*17 |
 gis''2.~ |
 gis''2. |
 gis''2.~ |
  % Bars 137-140
 gis''4 s2 |
 R2.*15 |
}

fluteTwoMusic = \keepWithTag #'solo { \fluteTwoOpening \fluteTwoBridge }
fluteTwoMusicCombined = \keepWithTag #'combined { \fluteTwoOpening \fluteTwoBridge }
fluteTwoMusicPlayback = \scorePlayback
  { \keepWithTag #'solo \fluteTwoOpening } \fluteTwoBridge
