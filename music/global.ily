% Written score: 152 unique measures, then Da Capo al Fine.
% Playback: opening 116 + middle 36 + opening 116 = 268 measures.
% The printed Fine is at the end of measure 116; mark that boundary
% with a double barline in both scores and all individual/combined parts.
% It is visual only: MIDI still follows globalPlayback's 268 measures.
global = { \time 3/4 s2.*116 \bar "||" s2.*36 \bar "||" }
globalPlayback = { \time 3/4 \scorePlayback { s2.*116 } { s2.*36 } }

rehearsalMarks = {
  \tempo \markup { \italic "Tempo di valse allegro" } 2. = 66
  % Bars 1–4
  s2.*4 |
  % Bars 5–20
  \mark \markup \box \bold \abs-fontsize #14 "10" s2.*16 |
  % Bars 21–36
  \mark \markup \box \bold \abs-fontsize #14 "11" s2.*16 |
  % Bars 37–52
  \mark \markup \box \bold \abs-fontsize #14 "12" s2.*16 |
  % Bars 53–60
  \mark \markup \box \bold \abs-fontsize #14 "13" s2.*8 |
  % Bars 61–68
  \mark \markup \box \bold \abs-fontsize #14 "14" s2.*8 |
  % Bars 69–76
  \mark \markup \box \bold \abs-fontsize #14 "15" s2.*8 |
  % Bars 77–84
  \mark \markup \box \bold \abs-fontsize #14 "16" s2.*8 |
  % Bars 85–100
  \mark \markup \box \bold \abs-fontsize #14 "17" s2.*16 |
  % Bars 101–115
  \mark \markup \box \bold \abs-fontsize #14 "18" s2.*15 |
  % Bar 116
s2. \textEndMark \markup \bold "Fine" |
  % Bars 117–124
  \mark \markup \box \bold \abs-fontsize #14 "19" s2.*8 |
  % Bars 125–136
  \mark \markup \box \bold \abs-fontsize #14 "20" s2.*12 |
  % Bars 137–144
  \mark \markup \box \bold \abs-fontsize #14 "21" s2.*8 |
  % Bars 145–152: one uninterrupted spacer keeps the final rest compressible.
  \mark \markup \box \bold \abs-fontsize #14 "22"
  s2.*8 \textEndMark \markup \bold "D.C. al Fine" |
}
rehearsalMarksPlayback = {
  \tempo 2. = 66
  % Replay markers follow the same LilyPond performance form as every part.
  % The second visit to bar 1 is emitted automatically by \scorePlayback.
  \scorePlayback
    { \scorekitPlaybackStart #1 s2.*116 }
    { s2.*36 }
}
