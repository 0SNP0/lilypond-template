\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/oboe-2.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboe II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "oboe" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \oboeTwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "oboe" } << { \globalPlayback } { \rehearsalMarksPlayback } { \oboeTwoMusicPlayback } >> \midi { } }
