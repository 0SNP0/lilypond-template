\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trombone-1.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \tromboneOneMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "trombone" } << { \globalPlayback } { \rehearsalMarksPlayback } { \tromboneOneMusicPlayback } >> \midi { } }
