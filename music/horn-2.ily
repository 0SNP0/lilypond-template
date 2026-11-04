% PROVISIONAL solo split of MusicXML horns-2-4. Review pitches, chords, solo/a2.
hornTwoOpening = {
  \clef treble
  \key c \major
  \time 3/4
  % Bars 1-4
 dis''8 _\markup \italic { "marc." }-_ \f dis''8-_ dis''4-_ r4 |
 dis''8-_ dis''8-_ dis''4-_ r4 |
 dis''8-_ dis''8-_ dis''4-_ r4 |
 R2.*73 |
 b'4-. \ff r4 b'4-. |
 b'4-. r4 b'4-. |
 cis''4-. r4 cis''4-. |
 cis''4-. r4 cis''4-. |
  % Bars 81-84
 b'4-. r4 b'4-. |
 cis''4-. r4 cis''4-. |
 b'4-. r4 r4 |
 R2.*17 |
 r4 cis''4-. \ff cis''4-. |
 r4 cis''4-. cis''4-. |
 r4 b'4-. b'4-. |
 r4 b'4-. b'4-. |
  % Bars 105-108
 r4 cis''4-. cis''4-. |
 r4 cis''4-. cis''4-. |
 r4 b'4-. b'4-. |
 r4 b'4-. b'4-. |
  % Bars 109-112
 r4 bis'4-. bis'4-. |
 r4 bis'4-. bis'4-. |
 r4 cis''4-. cis''4-. |
 r4 cis''4-. cis''4-. |
  % Bars 113-116
 cis''4-> \ff r4 r4 |
 cis''4-> r4 r4 |
 R2.*2 |
}

hornTwoBridge = {
  % Bars 117-120
 R2.*36 |
}

hornTwoMusic = { \hornTwoOpening \hornTwoBridge }
hornTwoMusicPlayback = \scorePlayback \hornTwoOpening \hornTwoBridge
