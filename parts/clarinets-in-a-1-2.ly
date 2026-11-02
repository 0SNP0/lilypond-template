\version "2.26.0"
\include "../metadata.ily"
\include "../music/clarinets-in-a-1-2.ily"
\paper { #(set-paper-size "a4") top-margin=15\mm bottom-margin=15\mm left-margin=15\mm right-margin=15\mm ragged-last-bottom=##t }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff { \clarinetsInAOneTwoMusic } \layout { } }
