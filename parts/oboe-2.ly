\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/oboe-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboe II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "oboe" } << { \global } { \rehearsalMarks } { \oboeTwoMusic } >> \layout { } }
\score { \articulate \new Staff \with { midiInstrument = "oboe" } << { \global } { \rehearsalMarks } { \oboeTwoMusic } >> \midi { } }
