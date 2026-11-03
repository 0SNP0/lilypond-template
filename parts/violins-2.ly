\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violins-2.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violins II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "violin" } << { \global } { \rehearsalMarks } { \violinsTwoMusic } >> \layout { } }
\score { \articulate \new Staff \with { midiInstrument = "violin" } << { \global } { \rehearsalMarks } { \violinsTwoMusic } >> \midi { } }
