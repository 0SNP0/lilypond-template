\version "2.26.0"
\include "../metadata.ily"
\include "../music/bassoons-1-2.ily"
\paper { #(set-paper-size "a4") top-margin=15\mm bottom-margin=15\mm left-margin=15\mm right-margin=15\mm ragged-last-bottom=##t }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoons I–II" tagline = ##f }
\score { \new Staff { \bassoonsOneTwoMusic } \layout { } }
