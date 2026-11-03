\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/trombone-3.ily"
\include "../../music/tuba.ily"
\include "../../music/global.ily"
\include "../../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone III / Tuba" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \tromboneThreeMusic } { \tubaMusic } } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \partCombine #'(0 . 0) { \tromboneThreeMusic } { \tubaMusic } } >> \midi { } }
