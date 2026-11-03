\version "2.26.0"
\include "metadata.ily"
\include "music/global.ily"
\include "music/piccolo.ily"
\include "music/flutes-1-2.ily"
\include "music/flute-1.ily"
\include "music/flute-2.ily"
\include "music/oboes-1-2.ily"
\include "music/oboe-1.ily"
\include "music/oboe-2.ily"
\include "music/english-horn.ily"
\include "music/clarinets-in-a-1-2.ily"
\include "music/clarinet-in-a-1.ily"
\include "music/clarinet-in-a-2.ily"
\include "music/bassoons-1-2.ily"
\include "music/bassoon-1.ily"
\include "music/bassoon-2.ily"
\include "music/contrabassoon.ily"
\include "music/horns-1-3.ily"
\include "music/horn-1.ily"
\include "music/horn-3.ily"
\include "music/horns-2-4.ily"
\include "music/horn-2.ily"
\include "music/horn-4.ily"
\include "music/trumpets-1-2.ily"
\include "music/trumpet-1.ily"
\include "music/trumpet-2.ily"
\include "music/trumpet-3.ily"
\include "music/trombones-1-2.ily"
\include "music/trombone-1.ily"
\include "music/trombone-2.ily"
\include "music/trombone-3-and-tuba.ily"
\include "music/trombone-3.ily"
\include "music/tuba.ily"
\include "music/snare-drum.ily"
\include "music/cymbals.ily"
\include "music/bass-drum.ily"
\include "music/violins-1.ily"
\include "music/violins-2.ily"
\include "music/violas.ily"
\include "music/violoncellos.ily"
\include "music/contrabasses.ily"

\include "music/paired.ily"

ensembleScore = <<
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Piccolo" shortInstrumentName = "Picc." midiInstrument = "piccolo" } { << { \global } { \rehearsalMarks } { \tag #'written { \piccoloMusic } \tag #'concert { \transpose c c' \piccoloMusic } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Flutes I–II" shortInstrumentName = "Fl. I–II" midiInstrument = "flute" } { << { \global } { \tag #'written { \flutesTogether } \tag #'concert { \transpose c c \flutesTogether } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Oboes I–II" shortInstrumentName = "Ob. I–II" midiInstrument = "oboe" } { << { \global } { \tag #'written { \oboesTogether } \tag #'concert { \transpose c c \oboesTogether } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "English Horn" shortInstrumentName = "Eng. Hn." midiInstrument = "english horn" } { << { \global } { \tag #'written { \englishHornMusic } \tag #'concert { \transpose c f, \englishHornMusic } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Clarinets in A I–II" shortInstrumentName = "Cl. A I–II" midiInstrument = "clarinet" } { << { \global } { \tag #'written { \clarinetsInATogether } \tag #'concert { \transpose c a, \clarinetsInATogether } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Bassoons I–II" shortInstrumentName = "Bsn. I–II" midiInstrument = "bassoon" } { << { \global } { \tag #'written { \bassoonsTogether } \tag #'concert { \transpose c c \bassoonsTogether } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Contrabassoon" shortInstrumentName = "Cbsn." midiInstrument = "contrabassoon" } { << { \global } { \tag #'written { \contrabassoonMusic } \tag #'concert { \clef "bass_8" \transpose c c, \contrabassoonMusic } } >> }
  >>
  \new StaffGroup <<
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Horns in F I/III" shortInstrumentName = "Hn. I/III" midiInstrument = "french horn" } { << { \global } { \tag #'written { \hornsOneThreeTogether } \tag #'concert { \transpose c f, \hornsOneThreeTogether } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Horns in F II/IV" shortInstrumentName = "Hn. II/IV" midiInstrument = "french horn" } { << { \global } { \tag #'written { \hornsTwoFourTogether } \tag #'concert { \transpose c f, \hornsTwoFourTogether } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Trumpets in B-flat I–II" shortInstrumentName = "Tpt. I–II" midiInstrument = "trumpet" } { << { \global } { \tag #'written { \trumpetsTogether } \tag #'concert { \transpose c bes, \trumpetsTogether } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Trumpet in B-flat III" shortInstrumentName = "Tpt. III" midiInstrument = "trumpet" } { << { \global } { \tag #'written { \trumpetThreeMusic } \tag #'concert { \transpose c bes, \trumpetThreeMusic } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Trombones I–II" shortInstrumentName = "Tbn. I–II" midiInstrument = "trombone" } { << { \global } { \tag #'written { \trombonesTogether } \tag #'concert { \transpose c c \trombonesTogether } } >> }
    \new Staff \with { \consists Merge_rests_engraver instrumentName = \markup \fontsize #-1 "Trombone III / Tuba" shortInstrumentName = "Tbn. III/Tba." midiInstrument = "tuba" } { << { \global } { \tag #'written { \tromboneThreeTubaTogether } \tag #'concert { \transpose c c \tromboneThreeTubaTogether } } >> }
  >>
  \new StaffGroup <<
    \new DrumStaff \with { instrumentName = \markup \fontsize #-1 "Snare Drum" shortInstrumentName = "Sn. Dr." } { << { \global } { \snareDrumMusic } >> }
    \new DrumStaff \with { instrumentName = \markup \fontsize #-1 "Cymbals" shortInstrumentName = "Cym." } { << { \global } { \cymbalsMusic } >> }
    \new DrumStaff \with { instrumentName = \markup \fontsize #-1 "Bass Drum" shortInstrumentName = "B. Dr." } { << { \global } { \bassDrumMusic } >> }
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violins I" shortInstrumentName = "Vlns. I" midiInstrument = "violin" } { << { \global } { \tag #'written { \violinsOneMusic } \tag #'concert { \transpose c c \violinsOneMusic } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violins II" shortInstrumentName = "Vlns. II" midiInstrument = "violin" } { << { \global } { \tag #'written { \violinsTwoMusic } \tag #'concert { \transpose c c \violinsTwoMusic } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violas" shortInstrumentName = "Vlas." midiInstrument = "viola" } { << { \global } { \tag #'written { \violasMusic } \tag #'concert { \transpose c c \violasMusic } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violoncellos" shortInstrumentName = "Vcs." midiInstrument = "cello" } { << { \global } { \tag #'written { \violoncellosMusic } \tag #'concert { \transpose c c \violoncellosMusic } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Contrabasses" shortInstrumentName = "Cbs." midiInstrument = "contrabass" } { << { \global } { \tag #'written { \contrabassesMusic } \tag #'concert { \clef "bass_8" \transpose c c, \contrabassesMusic } } >> }
  >>
>>
