\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violins-2.ily"
\include "../music/global.ily"
% Staff size in points. Tune 21, 22, 23, ... for readability.
#(define partStaffSize 22)
\include "../layout/part.ily"
\paper { page-count = #2 }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violins II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "violin" } << { \global } { \rehearsalMarks } { \violinsTwoMusic } >> \layout { } }
\score { \articulate \new Staff \with { midiInstrument = "violin" } << { \globalPlayback } { \rehearsalMarksPlayback } { \violinsTwoMusicPlayback } >> \midi { } }
