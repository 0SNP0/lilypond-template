\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/bassoon-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoon II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "bassoon" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \bassoonTwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "bassoon" } << { \globalPlayback } { \rehearsalMarksPlayback } { \bassoonTwoMusicPlayback } >> \midi { } }
