\version "2.26.0"
\include "../metadata.ily"
\include "../music/global.ily"
\include "../music/trombone-3.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone III" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \tromboneThreeMusic } >> \layout { } }
\score { \new Staff \with { midiInstrument = "trombone" } << { \global } { \rehearsalMarks } { \tromboneThreeMusic } >> \midi { } }
