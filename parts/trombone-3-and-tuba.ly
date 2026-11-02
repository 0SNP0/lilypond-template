\version "2.26.0"
\include "../metadata.ily"
\include "../music/trombone-3-and-tuba.ily"
\include "../music/global.ily"
\include "../layout/part.ily"
\header { title = \workTitle subtitle = \workSubtitle composer = \composerCredit instrument = "Trombone III / Tuba" tagline = ##f }
\score { \new Staff << { \global } { \tromboneThreeAndTubaMusic } >> \layout { } }
\score { \new Staff { \tromboneThreeAndTubaMusic } \midi { } }
