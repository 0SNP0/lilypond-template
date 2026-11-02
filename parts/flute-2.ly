\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/flute-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flute II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "flute" } << { \global } { \rehearsalMarks } { \fluteTwoMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "flute" } << { \global } { \rehearsalMarks } { \fluteTwoMusic } >> \midi { } }
