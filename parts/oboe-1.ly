\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/oboe-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboe I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "oboe" } << { \global } { \rehearsalMarks } { \oboeOneMusic } >> \layout { } }
\score { \articulate \new Staff \with { midiInstrument = "oboe" } << { \globalPlayback } { \rehearsalMarksPlayback } { \oboeOneMusicPlayback } >> \midi { } }
