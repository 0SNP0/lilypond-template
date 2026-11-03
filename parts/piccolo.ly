\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/piccolo.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Piccolo" tagline = ##f }
\score { \new Staff \with { midiInstrument = "piccolo" } << { \global } { \rehearsalMarks } { \clef treble \piccoloMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "piccolo" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c c' \piccoloMusicPlayback } >> \midi { } }
