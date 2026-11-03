\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/bassoon-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoon I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "bassoon" } << { \global } { \rehearsalMarks } { \bassoonOneMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "bassoon" } << { \globalPlayback } { \rehearsalMarksPlayback } { \bassoonOneMusicPlayback } >> \midi { } }
