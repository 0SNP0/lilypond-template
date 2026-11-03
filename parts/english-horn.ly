\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/english-horn.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "English Horn" tagline = ##f }
\score { \new Staff \with { midiInstrument = "english horn" } << { \global } { \rehearsalMarks } { \englishHornMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "english horn" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c f, \englishHornMusicPlayback } >> \midi { } }
