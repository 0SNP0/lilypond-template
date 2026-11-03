\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violas.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violas" tagline = ##f }
\score { \new Staff \with { midiInstrument = "viola" } << { \global } { \rehearsalMarks } { \violasMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "viola" } << { \globalPlayback } { \rehearsalMarksPlayback } { \violasMusicPlayback } >> \midi { } }
