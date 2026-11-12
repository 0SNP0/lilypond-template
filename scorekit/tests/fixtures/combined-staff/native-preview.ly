\version "2.26.0"

% Standalone LilyPond-first engraving experiment.
% Compile directly: lilypond -o native-preview native-preview.ly
% Neither source part contains engraving-only corrections.

upperMusic = \relative c'' {
  \time 4/4
  c4 d e f |
  R1 |
  g4 a b c |
  c4 d e f |
}
lowerMusic = \relative c'' {
  \time 4/4
  c4 b a g |
  c4 d e f |
  R1 |
  c4 d e f |
}

% This is a visual proof of the two-voice mode, NOT yet a complete
% implementation of I / II / a2 switching.
combinedUpper = {
  \voiceOne
  \upperMusic
}
combinedLower = {
  \voiceTwo
  \lowerMusic
}

\book {
  \bookOutputName "native-preview"
  \score {
    \new Staff \with {
      instrumentName = "I,II"
      \consists Merge_rests_engraver
    } <<
      \new Voice = "upper" { \combinedUpper }
      \new Voice = "lower" { \combinedLower }
    >>
    \layout { }
  }
  \score {
    \new Staff \with { instrumentName = "I" } { \upperMusic }
    \layout { }
  }
  \score {
    \new Staff \with { instrumentName = "II" } { \lowerMusic }
    \layout { }
  }
}
