\version "2.26.0"
\include "../metadata.ily"
\include "../music/trumpet-3.ily"
\paper { #(set-paper-size "a4") top-margin=15\mm bottom-margin=15\mm left-margin=15\mm right-margin=15\mm ragged-last-bottom=##t }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpet in B-flat III" tagline = ##f }
\score { \new Staff { \trumpet3Music } \layout { } }
