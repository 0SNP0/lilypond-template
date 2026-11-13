\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trumpet-1.ily"
\include "../../music/trumpet-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trumpets in B-flat I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures << \new Voice { \voiceOne \trumpetOneMusic } \new Voice { \voiceTwo \trumpetTwoMusic } >> } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { << \new Voice { \voiceOne \trumpetOneMusic } \new Voice { \voiceTwo \trumpetTwoMusic } >> } >> \midi { } }
