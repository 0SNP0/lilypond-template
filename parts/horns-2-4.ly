\version "2.26.0"
\include "../metadata.ily"
\include "../music/horns-2-4.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horns in F II & IV" tagline = ##f }
\score { \new Staff << { \global } { \hornsTwoFourMusic } >> \layout { } }
\score { \new Staff { \hornsTwoFourMusic } \midi { } }
