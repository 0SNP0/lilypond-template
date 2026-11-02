\version "2.26.0"
\include "orchestra.ily"
\paper { #(set-paper-size "a4") top-margin=4\mm bottom-margin=4\mm left-margin=3\mm right-margin=3\mm ragged-last-bottom=##f }
#(set-global-staff-size 9)
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit tagline = ##f }
\score { \keepWithTag #'written \sviridovScore \layout { } }
\score { \keepWithTag #'concert \sviridovScore \midi { } }
