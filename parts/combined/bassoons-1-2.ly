\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/bassoon-1.ily"
\include "../../music/bassoon-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Bassoons I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures << \new Voice { \voiceOne \bassoonOneMusic } \new Voice { \voiceTwo \bassoonTwoMusic } >> } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { << \new Voice { \voiceOne \bassoonOneMusic } \new Voice { \voiceTwo \bassoonTwoMusic } >> } >> \midi { } }
