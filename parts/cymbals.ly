\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/cymbals.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Cymbals" tagline = ##f }
\score { \new DrumStaff << { \global } { \rehearsalMarks } { \cymbalsMusic } >> \layout { } }
\score { \articulate \new DrumStaff << { \globalPlayback } { \rehearsalMarksPlayback } { \cymbalsMusicPlayback } >> \midi { } }
