\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/tuba.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Tuba" tagline = ##f }
\score { \new Staff \with { midiInstrument = "tuba" } << { \global } { \rehearsalMarks } { \tubaMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "tuba" } << { \global } { \rehearsalMarks } { \tubaMusic } >> \midi { } }
