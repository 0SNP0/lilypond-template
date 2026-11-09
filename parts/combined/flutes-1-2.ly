\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/flute-1.ily"
\include "../../music/flute-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flutes I–II" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \partCombine #'(0 . 0) { \fluteOneMusic } { \fluteTwoMusic } } { \flutesADueCue } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \fluteOneMusic } { \fluteTwoMusic } } >> \midi { } }
