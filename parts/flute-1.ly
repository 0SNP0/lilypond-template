\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/flute-1.ily"
\include "../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flute I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "flute" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \fluteOneMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "flute" } << { \globalPlayback } { \rehearsalMarksPlayback } { \fluteOneMusicPlayback } >> \midi { } }
