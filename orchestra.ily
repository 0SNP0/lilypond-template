\version "2.26.0"
\include "metadata.ily"
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

sviridovScore = <<
  \new StaffGroup <<
    \new Staff \with { instrumentName = "Piccolo" shortInstrumentName = "Picc." midiInstrument = "piccolo" } { \tag #'written { \piccoloMusic } \tag #'concert { \transpose c c' \piccoloMusic } }
    \new Staff \with { instrumentName = "Flutes I–II" shortInstrumentName = "Fl. I–II" midiInstrument = "flute" } { \tag #'written { \flutesOneTwoMusic } \tag #'concert { \transpose c c \flutesOneTwoMusic } }
    \new Staff \with { instrumentName = "Oboes I–II" shortInstrumentName = "Ob. I–II" midiInstrument = "oboe" } { \tag #'written { \oboesOneTwoMusic } \tag #'concert { \transpose c c \oboesOneTwoMusic } }
    \new Staff \with { instrumentName = "English Horn" shortInstrumentName = "E. Hn." midiInstrument = "english horn" } { \tag #'written { \englishHornMusic } \tag #'concert { \transpose c f, \englishHornMusic } }
    \new Staff \with { instrumentName = "Clarinets in A I–II" shortInstrumentName = "Cl. A I–II" midiInstrument = "clarinet" } { \tag #'written { \clarinetsInAOneTwoMusic } \tag #'concert { \transpose c a, \clarinetsInAOneTwoMusic } }
    \new Staff \with { instrumentName = "Bassoons I–II" shortInstrumentName = "Bsn. I–II" midiInstrument = "bassoon" } { \tag #'written { \bassoonsOneTwoMusic } \tag #'concert { \transpose c c \bassoonsOneTwoMusic } }
    \new Staff \with { instrumentName = "Contrabassoon" shortInstrumentName = "Cbsn." midiInstrument = "contrabassoon" } { \tag #'written { \contrabassoonMusic } \tag #'concert { \transpose c c, \contrabassoonMusic } }
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = "Horns in F I & III" shortInstrumentName = "Hn. I/III" midiInstrument = "french horn" } { \tag #'written { \hornsOneThreeMusic } \tag #'concert { \transpose c f, \hornsOneThreeMusic } }
    \new Staff \with { instrumentName = "Horns in F II & IV" shortInstrumentName = "Hn. II/IV" midiInstrument = "french horn" } { \tag #'written { \hornsTwoFourMusic } \tag #'concert { \transpose c f, \hornsTwoFourMusic } }
    \new Staff \with { instrumentName = "Trumpets in B-flat I–II" shortInstrumentName = "Tpt. I–II" midiInstrument = "trumpet" } { \tag #'written { \trumpetsOneTwoMusic } \tag #'concert { \transpose c bes, \trumpetsOneTwoMusic } }
    \new Staff \with { instrumentName = "Trumpet in B-flat III" shortInstrumentName = "Tpt. III" midiInstrument = "trumpet" } { \tag #'written { \trumpetThreeMusic } \tag #'concert { \transpose c bes, \trumpetThreeMusic } }
    \new Staff \with { instrumentName = "Trombones I–II" shortInstrumentName = "Tbn. I–II" midiInstrument = "trombone" } { \tag #'written { \trombonesOneTwoMusic } \tag #'concert { \transpose c c \trombonesOneTwoMusic } }
    \new Staff \with { instrumentName = "Trombone III / Tuba" shortInstrumentName = "Tbn. III/Tba." midiInstrument = "tuba" } { \tag #'written { \tromboneThreeAndTubaMusic } \tag #'concert { \transpose c c \tromboneThreeAndTubaMusic } }
  >>
  \new StaffGroup <<
    \new DrumStaff \with { instrumentName = "Snare Drum" shortInstrumentName = "Sn. Dr." } { \snareDrumMusic }
    \new DrumStaff \with { instrumentName = "Cymbals" shortInstrumentName = "Cym." } { \cymbalsMusic }
    \new DrumStaff \with { instrumentName = "Bass Drum" shortInstrumentName = "B. Dr." } { \bassDrumMusic }
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = "Violins I" shortInstrumentName = "Vlns. I" midiInstrument = "violin" } { \tag #'written { \violinsOneMusic } \tag #'concert { \transpose c c \violinsOneMusic } }
    \new Staff \with { instrumentName = "Violins II" shortInstrumentName = "Vlns. II" midiInstrument = "violin" } { \tag #'written { \violinsTwoMusic } \tag #'concert { \transpose c c \violinsTwoMusic } }
    \new Staff \with { instrumentName = "Violas" shortInstrumentName = "Vlas." midiInstrument = "viola" } { \tag #'written { \violasMusic } \tag #'concert { \transpose c c \violasMusic } }
    \new Staff \with { instrumentName = "Violoncellos" shortInstrumentName = "Vcs." midiInstrument = "cello" } { \tag #'written { \violoncellosMusic } \tag #'concert { \transpose c c \violoncellosMusic } }
    \new Staff \with { instrumentName = "Contrabasses" shortInstrumentName = "Cbs." midiInstrument = "contrabass" } { \tag #'written { \contrabassesMusic } \tag #'concert { \transpose c c, \contrabassesMusic } }
  >>
>>
