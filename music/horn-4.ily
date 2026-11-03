% PROVISIONAL solo split of MusicXML horns-2-4. Review pitches, chords, solo/a2.
hornFourOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 dis'8-_ \f dis'8-_ dis'4-_ r4 |
 dis'8-_ dis'8-_ dis'4-_ r4 |
 dis'8-_ dis'8-_ dis'4-_ r4 |
 R2.*42 |
 d''2. |
 R2.*30 |
 dis'4-. \ff r4 dis'4-. |
 dis'4-. r4 dis'4-. |
 e'4-. r4 e'4-. |
 e'4-. r4 e'4-. |
  % Bars 81-84
 dis'4-. r4 dis'4-. |
 dis'4-. r4 dis'4-. |
 dis'4-. r4 r4 |
 R2.*17 |
 r4 dis'4-. \ff dis'4-. |
 r4 dis'4-. dis'4-. |
 r4 dis'4-. dis'4-. |
 r4 dis'4-. dis'4-. |
  % Bars 105-108
 r4 dis'4-. dis'4-. |
 r4 dis'4-. dis'4-. |
 r4 dis'4-. dis'4-. |
 r4 dis'4-. dis'4-. |
  % Bars 109-112
 r4 fis'4-. fis'4-. |
 r4 fis'4-. fis'4-. |
 r4 e'4-. e'4-. |
 r4 e'4-. e'4-. |
  % Bars 113-116
 e'4-> \ff r4 r4 |
 e'4-> r4 r4 |
 R2.*2 |
}

hornFourBridge = {
  % Bars 117-120
 R2.*36 |
}

hornFourMusic = { \hornFourOpening \hornFourBridge }
hornFourMusicPlayback = \scorePlayback \hornFourOpening \hornFourBridge
