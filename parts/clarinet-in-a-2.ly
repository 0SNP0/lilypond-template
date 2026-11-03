\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/clarinet-in-a-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinet in A II" tagline = ##f }
\score { \compressEmptyMeasures \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \clarinetInATwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "clarinet" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c a, \clarinetInATwoMusicPlayback } >> \midi { } }
