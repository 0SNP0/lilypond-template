\version "2.26.0"

% Standalone, previewable native LilyPond proof for all four desk modes.
% Each source fragment is used in the solo part and in the shared score.
% Mode switches and layout corrections exist ONLY in this desk view.

upperBothA = \relative c'' { c4 d e f }
lowerBothA = \relative c'' { c4 b a g }
upperFirst = \relative c'' { g4 a b c }
lowerFirst = { r1 }
upperSecond = { r1 }
lowerSecond = \relative c'' { c4 d e f }
upperDuet = \relative c'' { g4 a b c }
lowerDuet = \relative c'' { g4 a b c }
upperBothB = { r1 }
lowerBothB = \relative c'' { c4 d e f }

upperMusic = {
  \time 4/4
  \upperBothA | \upperFirst | \upperSecond | \upperDuet | \upperBothB |
}
lowerMusic = {
  \time 4/4
  \lowerBothA | \lowerFirst | \lowerSecond | \lowerDuet | \lowerBothB |
}

% Desk-only commands: never included in upperMusic or lowerMusic.
deskBothA = <<
  { \voiceOne \upperBothA }
  \\
  { \voiceTwo \lowerBothA }
>>
deskFirst = { \oneVoice \mark \markup \box "I" \upperFirst }
deskSecond = { \oneVoice \mark \markup \box "II" \lowerSecond }
deskDuet = { \oneVoice \mark \markup \box "a2" \upperDuet }
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
  \deskBothA | \deskFirst | \deskSecond | \deskDuet | \deskBothB |
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
