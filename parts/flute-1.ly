\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/flute-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flute I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "flute" } << { \global } { \rehearsalMarks } { \fluteOneMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "flute" } << { \global } { \rehearsalMarks } { \fluteOneMusic } >> \midi { } }
