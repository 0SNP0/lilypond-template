\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/horn-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horn in F I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "french horn" } << { \global } { \rehearsalMarks } { \hornOneMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "french horn" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c f, \hornOneMusicPlayback } >> \midi { } }
