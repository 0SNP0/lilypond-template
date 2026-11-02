\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/bassoon-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoon II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "bassoon" } << { \global } { \rehearsalMarks } { \bassoonTwoMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "bassoon" } << { \global } { \rehearsalMarks } { \bassoonTwoMusic } >> \midi { } }
