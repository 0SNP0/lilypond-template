\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/flute-1.ily"
\include "../../music/flute-2.ily"
\include "../../music/global.ily"
\include "../../music/combined/flutes.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Flutes I–II" tagline = ##f }
\score { \new Staff \with { printPartCombineTexts = ##t soloText = "I" soloIIText = "II" aDueText = "a2" } << { \global } { \rehearsalMarks } { \compressEmptyMeasures \flutesTogether } { \flutesDeskCues } >> \partPrintLayout }
\score { \new Staff \with { printPartCombineTexts = ##t soloText = "I" soloIIText = "II" aDueText = "a2" } << { \global } { \rehearsalMarks } { \flutesTogetherPlayback } >> \midi { } }
