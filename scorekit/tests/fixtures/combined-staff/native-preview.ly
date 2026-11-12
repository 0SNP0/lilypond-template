\version "2.26.0"

% Standalone, previewable native LilyPond proof for all four desk modes.
% Each source fragment is used in the solo part and in the shared score.
% Mode switches and layout corrections exist ONLY in this desk view.

upperBothA = \relative c'' { c4 d e f }
lowerBothA = \relative c'' { c4 b a g }
upperFirst = \relative c'' { g4 a b c }
lowerFirst = { R1 }
upperSecond = { R1 }
lowerSecond = \relative c'' { c4 d e f }
upperA2 = \relative c'' { g4 a b c }
lowerA2 = \relative c'' { g4 a b c }
upperBothB = { R1 }
lowerBothB = \relative c'' { c4 d e f }

upperMusic = {
  \time 4/4
  \upperBothA | \upperFirst | \upperSecond | \upperA2 | \upperBothB |
}
lowerMusic = {
  \time 4/4
  \lowerBothA | \lowerFirst | \lowerSecond | \lowerA2 | \lowerBothB |
}

% Desk-only commands: never included in upperMusic or lowerMusic.
deskBothA = <<
  { \voiceOne \upperBothA }
  \\
  { \voiceTwo \lowerBothA }
>>
deskFirst = { \oneVoice \mark \markup \box "I" \upperFirst }
deskSecond = { \oneVoice \mark \markup \box "II" \lowerSecond }
deskA2 = { \oneVoice \mark \markup \box "a2" \upperA2 }
deskBothB = <<
  {
    \voiceOne
    % Desk-only fallback for a whole-bar rest against the lower notes.
    \once \override MultiMeasureRest.staff-position = #6
    \upperBothB
  }
  \\
  { \voiceTwo \lowerBothB }
>>

combinedMusic = {
  \time 4/4
  \deskBothA | \deskFirst | \deskSecond | \deskA2 | \deskBothB |
  \oneVoice
}

\book {
  \bookOutputName "native-preview"
  \score {
    \new Staff \with {
      instrumentName = "I–II"
      \consists Merge_rests_engraver
    } { \combinedMusic }
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
