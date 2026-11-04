\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/contrabassoon.ily"
\include "../music/global.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Contrabassoon" tagline = ##f }
\score { \new Staff \with { midiInstrument = "bassoon" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \clef bass \contrabassoonMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "bassoon" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c c, \contrabassoonMusicPlayback } >> \midi { } }
