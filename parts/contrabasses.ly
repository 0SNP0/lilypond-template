\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/contrabasses.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Contrabasses" tagline = ##f }
\score { \compressEmptyMeasures \new Staff \with { midiInstrument = "contrabass" } << { \global } { \rehearsalMarks } { \clef bass \contrabassesMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "contrabass" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c c, \contrabassesMusicPlayback } >> \midi { } }
