\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trombone-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone II" tagline = ##f }
\score { \compressEmptyMeasures \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \tromboneTwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "trombone" } << { \globalPlayback } { \rehearsalMarksPlayback } { \tromboneTwoMusicPlayback } >> \midi { } }
