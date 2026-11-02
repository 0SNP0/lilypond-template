\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/horn-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horn in F I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "french horn" } << { \global } { \rehearsalMarks } { \hornOneMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "french horn" } << { \global } { \rehearsalMarks } { \transpose c f, \hornOneMusic } >> \midi { } }
