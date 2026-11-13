\version "2.26.0"
\include "../../metadata.ily"
\include "../../music/clarinet-in-a-1.ily"
\include "../../music/clarinet-in-a-2.ily"
\include "../../music/global.ily"
\include "../../scorekit/lilypond/layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Clarinets in A I–II" tagline = ##f }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { \compressEmptyMeasures << \new Voice { \voiceOne \clarinetInAOneMusicCombined } \new Voice { \voiceTwo \clarinetInATwoMusicCombined } >> } { \clarinetsDeskCues } >> \partPrintLayout }
\score { \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f } << { \global } { \rehearsalMarks } { << \new Voice { \voiceOne \clarinetInAOneMusic } \new Voice { \voiceTwo \clarinetInATwoMusic } >> } >> \midi { } }
