\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/horn-3.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Horn in F III" tagline = ##f }
\score { \new Staff \with { midiInstrument = "french horn" } << { \global } { \rehearsalMarks } { \hornThreeMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "french horn" } << { \global } { \rehearsalMarks } { \transpose c f, \hornThreeMusic } >> \midi { } }
