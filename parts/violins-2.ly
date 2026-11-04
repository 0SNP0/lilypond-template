\version "2.26.0"
\include "articulate.ly"
\include "../metadata.ily"
\include "../music/violins-2.ily"
\include "../music/global.ily"
% Start at this size and enlarge until exactly two A4 pages fit.
#(define partStaffSize 22)
#(define partTargetPages 2)
\include "../scorekit/lilypond/layout/part.ily"
\paper { ragged-bottom = ##f ragged-last-bottom = ##f }
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Violins II" tagline = ##f }
\score { \new Staff \with { midiInstrument = "violin" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \violinsTwoMusic } >> \partPrintLayout }
\score { \articulate \new Staff \with { midiInstrument = "violin" } << { \globalPlayback } { \rehearsalMarksPlayback } { \violinsTwoMusicPlayback } >> \midi { } }
