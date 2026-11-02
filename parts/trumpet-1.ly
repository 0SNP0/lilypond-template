\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trumpet-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpet in B-flat I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \trumpetOneMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \transpose c bes, \trumpetOneMusic } >> \midi { } }
