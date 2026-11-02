\version "2.26.0"
\include "metadata.ily"
\include "music/global.ily"
\include "music/piccolo.ily"
\include "music/flutes-1-2.ily"
\include "music/oboes-1-2.ily"
\include "music/english-horn.ily"
\include "music/clarinets-in-a-1-2.ily"
\include "music/bassoons-1-2.ily"
\include "music/contrabassoon.ily"
\include "music/horns-1-3.ily"
\include "music/horns-2-4.ily"
\include "music/trumpets-1-2.ily"
\include "music/trumpet-3.ily"
\include "music/trombones-1-2.ily"
\include "music/trombone-3-and-tuba.ily"
\include "music/snare-drum.ily"
\include "music/cymbals.ily"
\include "music/bass-drum.ily"
\include "music/violins-1.ily"
\include "music/violins-2.ily"
\include "music/violas.ily"
\include "music/violoncellos.ily"
\include "music/contrabasses.ily"

ensembleScore = <<
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Picc." shortInstrumentName = \markup \abs-fontsize #10 "Picc." midiInstrument = "piccolo" } { << { \global } { \rehearsalMarks } { \tag #'written { \piccoloMusic } \tag #'concert { \transpose c c' \piccoloMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Fl. I–II" shortInstrumentName = \markup \abs-fontsize #10 "Fl. I–II" midiInstrument = "flute" } { << { \global } { \tag #'written { \flutesOneTwoMusic } \tag #'concert { \transpose c c \flutesOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Ob. I–II" shortInstrumentName = \markup \abs-fontsize #10 "Ob. I–II" midiInstrument = "oboe" } { << { \global } { \tag #'written { \oboesOneTwoMusic } \tag #'concert { \transpose c c \oboesOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "E. Hn." shortInstrumentName = \markup \abs-fontsize #10 "E. Hn." midiInstrument = "english horn" } { << { \global } { \tag #'written { \englishHornMusic } \tag #'concert { \transpose c f, \englishHornMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Cl. A I–II" shortInstrumentName = \markup \abs-fontsize #10 "Cl. A I–II" midiInstrument = "clarinet" } { << { \global } { \tag #'written { \clarinetsInAOneTwoMusic } \tag #'concert { \transpose c a, \clarinetsInAOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Bsn. I–II" shortInstrumentName = \markup \abs-fontsize #10 "Bsn. I–II" midiInstrument = "bassoon" } { << { \global } { \tag #'written { \bassoonsOneTwoMusic } \tag #'concert { \transpose c c \bassoonsOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Cbsn." shortInstrumentName = \markup \abs-fontsize #10 "Cbsn." midiInstrument = "contrabassoon" } { << { \global } { \tag #'written { \contrabassoonMusic } \tag #'concert { \transpose c c, \contrabassoonMusic } } >> }
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Hn. I/III" shortInstrumentName = \markup \abs-fontsize #10 "Hn. I/III" midiInstrument = "french horn" } { << { \global } { \tag #'written { \hornsOneThreeMusic } \tag #'concert { \transpose c f, \hornsOneThreeMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Hn. II/IV" shortInstrumentName = \markup \abs-fontsize #10 "Hn. II/IV" midiInstrument = "french horn" } { << { \global } { \tag #'written { \hornsTwoFourMusic } \tag #'concert { \transpose c f, \hornsTwoFourMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Tpt. I–II" shortInstrumentName = \markup \abs-fontsize #10 "Tpt. I–II" midiInstrument = "trumpet" } { << { \global } { \tag #'written { \trumpetsOneTwoMusic } \tag #'concert { \transpose c bes, \trumpetsOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Tpt. III" shortInstrumentName = \markup \abs-fontsize #10 "Tpt. III" midiInstrument = "trumpet" } { << { \global } { \tag #'written { \trumpetThreeMusic } \tag #'concert { \transpose c bes, \trumpetThreeMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Tbn. I–II" shortInstrumentName = \markup \abs-fontsize #10 "Tbn. I–II" midiInstrument = "trombone" } { << { \global } { \tag #'written { \trombonesOneTwoMusic } \tag #'concert { \transpose c c \trombonesOneTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Tbn. III/Tba." shortInstrumentName = \markup \abs-fontsize #10 "Tbn. III/Tba." midiInstrument = "tuba" } { << { \global } { \tag #'written { \tromboneThreeAndTubaMusic } \tag #'concert { \transpose c c \tromboneThreeAndTubaMusic } } >> }
  >>
  \new StaffGroup <<
    \new DrumStaff \with { instrumentName = \markup \abs-fontsize #10 "Sn. Dr." shortInstrumentName = \markup \abs-fontsize #10 "Sn. Dr." } { << { \global } { \snareDrumMusic } >> }
    \new DrumStaff \with { instrumentName = \markup \abs-fontsize #10 "Cym." shortInstrumentName = \markup \abs-fontsize #10 "Cym." } { << { \global } { \cymbalsMusic } >> }
    \new DrumStaff \with { instrumentName = \markup \abs-fontsize #10 "B. Dr." shortInstrumentName = \markup \abs-fontsize #10 "B. Dr." } { << { \global } { \bassDrumMusic } >> }
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Vlns. I" shortInstrumentName = \markup \abs-fontsize #10 "Vlns. I" midiInstrument = "violin" } { << { \global } { \tag #'written { \violinsOneMusic } \tag #'concert { \transpose c c \violinsOneMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Vlns. II" shortInstrumentName = \markup \abs-fontsize #10 "Vlns. II" midiInstrument = "violin" } { << { \global } { \tag #'written { \violinsTwoMusic } \tag #'concert { \transpose c c \violinsTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Vlas." shortInstrumentName = \markup \abs-fontsize #10 "Vlas." midiInstrument = "viola" } { << { \global } { \tag #'written { \violasMusic } \tag #'concert { \transpose c c \violasMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Vcs." shortInstrumentName = \markup \abs-fontsize #10 "Vcs." midiInstrument = "cello" } { << { \global } { \tag #'written { \violoncellosMusic } \tag #'concert { \transpose c c \violoncellosMusic } } >> }
    \new Staff \with { instrumentName = \markup \abs-fontsize #10 "Cbs." shortInstrumentName = \markup \abs-fontsize #10 "Cbs." midiInstrument = "contrabass" } { << { \global } { \tag #'written { \contrabassesMusic } \tag #'concert { \transpose c c, \contrabassesMusic } } >> }
  >>
>>
