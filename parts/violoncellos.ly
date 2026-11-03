\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violoncellos.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violoncellos" tagline = ##f }
\score { \compressEmptyMeasures \new Staff \with { midiInstrument = "cello" } << { \global } { \rehearsalMarks } { \violoncellosMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "cello" } << { \globalPlayback } { \rehearsalMarksPlayback } { \violoncellosMusicPlayback } >> \midi { } }
