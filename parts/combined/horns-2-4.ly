\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/horn-2.ily"
\include "../../music/horn-4.ily"
\include "../../music/paired.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F II & IV" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsTwoFourTogether } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \hornsTwoFourTogether } >> \midi { } }
