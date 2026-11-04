\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trumpet-1.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpet in B-flat I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \trumpetOneMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "trumpet" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c bes, \trumpetOneMusicPlayback } >> \midi { } }
