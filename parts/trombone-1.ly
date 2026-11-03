\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trombone-1.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone I" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \tromboneOneMusic } >> \layout { } }
\score { \articulate \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \tromboneOneMusic } >> \midi { } }
