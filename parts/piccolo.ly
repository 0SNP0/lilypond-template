\version "2.26.0"
\include "../metadata.ily"
\include "../music/piccolo.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Piccolo" tagline = ##f }
\score { \new Staff << { \global } { \rehearsalMarks } { \piccoloMusic } >> \layout { } }
\score { \new Staff << { \global } { \rehearsalMarks } { \transpose c c' \piccoloMusic } >> \midi { } }
