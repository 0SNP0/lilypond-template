\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trumpet-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpet in B-flat II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \trumpetTwoMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \transpose c bes, \trumpetTwoMusic } >> \midi { } }
