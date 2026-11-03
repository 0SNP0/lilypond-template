\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/trumpet-3.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpet in B-flat III" tagline = ##f }
\score { \new Staff \with { midiInstrument = "trumpet" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \trumpetThreeMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "trumpet" } << { \globalPlayback } { \rehearsalMarksPlayback } { \transpose c bes, \trumpetThreeMusicPlayback } >> \midi { } }
