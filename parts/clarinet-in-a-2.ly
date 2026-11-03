\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/clarinet-in-a-2.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinet in A II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \clarinetInATwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "clarinet" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c a, \clarinetInATwoMusicPlayback } >> \midi { } }
