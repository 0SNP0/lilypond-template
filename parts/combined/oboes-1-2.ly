\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/oboe-1.ily"
\include "../../music/oboe-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Oboes I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures << \new Voice { \voiceOne \oboeOneMusicCombined } \new Voice { \voiceTwo \oboeTwoMusic } >> } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { << \new Voice { \voiceOne \oboeOneMusic } \new Voice { \voiceTwo \oboeTwoMusic } >> } >> \midi { } }
