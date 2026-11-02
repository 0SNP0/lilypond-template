\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/clarinet-in-a-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinet in A I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \clarinetInAOneMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \transpose c a, \clarinetInAOneMusic } >> \midi { } }
