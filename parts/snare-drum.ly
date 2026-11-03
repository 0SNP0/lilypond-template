\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/snare-drum.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Snare Drum" tagline = ##f }
\score { \new DrumStaff << { \global } { \rehearsalMarks } { \snareDrumMusic } >> \layout { } }
\score { \articulate \new DrumStaff << { \globalPlayback } { \rehearsalMarksPlayback } { \snareDrumMusicPlayback } >> \midi { } }
