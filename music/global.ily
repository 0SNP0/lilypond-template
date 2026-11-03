% Written score: 152 unique measures, then Da Capo al Fine.
% Playback: opening 116 + middle 36 + opening 116 = 268 measures.
global = { \time 3/4 s2.*152 \bar "||" }
globalPlayback = { \time 3/4 s2.*268 }

rehearsalMarks = {
  \tempo 2. = 66
  % Bars 1–5
  s2.*4 |
  % Bar 5
\mark \markup \box \bold \abs-fontsize #14 "10" s2. |
  % Bars 6–21
  s2.*15 |
  % Bar 21
\mark \markup \box \bold \abs-fontsize #14 "11" s2. |
  % Bars 22–37
  s2.*15 |
  % Bar 37
\mark \markup \box \bold \abs-fontsize #14 "12" s2. |
  % Bars 38–53
  s2.*15 |
  % Bar 53
\mark \markup \box \bold \abs-fontsize #14 "13" s2. |
  % Bars 54–61
  s2.*7 |
  % Bar 61
\mark \markup \box \bold \abs-fontsize #14 "14" s2. |
  % Bars 62–69
  s2.*7 |
  % Bar 69
\mark \markup \box \bold \abs-fontsize #14 "15" s2. |
  % Bars 70–77
  s2.*7 |
  % Bar 77
\mark \markup \box \bold \abs-fontsize #14 "16" s2. |
  % Bars 78–85
  s2.*7 |
  % Bar 85
\mark \markup \box \bold \abs-fontsize #14 "17" s2. |
  % Bars 86–101
  s2.*15 |
  % Bar 101
\mark \markup \box \bold \abs-fontsize #14 "18" s2. |
  % Bars 102–116
  s2.*14 |
  % Bar 116
s2. \textEndMark \markup \bold "Fine" |
  % Bar 117
\mark \markup \box \bold \abs-fontsize #14 "19" s2. |
  % Bars 118–125
  s2.*7 |
  % Bar 125
\mark \markup \box \bold \abs-fontsize #14 "20" s2. |
  % Bars 126–137
  s2.*11 |
  % Bar 137
\mark \markup \box \bold \abs-fontsize #14 "21" s2. |
  % Bars 138–145
  s2.*7 |
  % Bar 145
\mark \markup \box \bold \abs-fontsize #14 "22" s2. |
  % Bars 146–152
  s2.*6 |
  % Bar 152
s2. \textEndMark \markup \bold "D.C. al Fine" |
}
rehearsalMarksPlayback = {
  \tempo 2. = 66
  s2.*268
}
