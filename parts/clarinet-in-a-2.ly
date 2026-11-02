\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/clarinet-in-a-2.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinet in A II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \clarinetInATwoMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "clarinet" } << { \global } { \rehearsalMarks } { \transpose c a, \clarinetInATwoMusic } >> \midi { } }
