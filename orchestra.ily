% THE ORCHESTRA ORDER IS DEFINED HERE, NOT IN FILE NAMES.
% Concert-pitch music lives in music/*.ily. Edit this file to reorder staves.
\include "metadata.ily"
\include "music/global.ily"
\include "music/flute-1.ily"
\include "music/flute-2.ily"
\include "music/oboe.ily"
\include "music/clarinet-1.ily"
\include "music/clarinet-2.ily"
\include "music/bass-clarinet.ily"
\include "music/soprano-saxophone.ily"
\include "music/alto-saxophone.ily"
\include "music/tenor-saxophone.ily"
\include "music/trumpet-1.ily"
\include "music/trumpet-2.ily"
\include "music/trombone-1.ily"
\include "music/trombone-2.ily"
\include "music/drum-kit.ily"
\include "music/piano.ily"
\include "music/accordion.ily"
\include "music/violins-1.ily"
\include "music/violins-2.ily"
\include "music/violas.ily"
\include "music/violoncellos.ily"
\include "music/contrabasses.ily"
\include "music/paired.ily"

ensembleScore = <<
  % Woodwinds
  \new StaffGroup <<
    % Flutes I–II: one staff, voice I up-stems and voice II down-stems.
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Fl. I–II" shortInstrumentName = \markup \abs-fontsize #9.5 "Fl. I–II" midiInstrument = "flute" } \flutesTogether
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Ob." shortInstrumentName = \markup \abs-fontsize #9.5 "Ob." midiInstrument = "oboe" } { \global \oboeMusic }
    % Clarinets in B-flat I–II: one staff, voice I up-stems and voice II down-stems.
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Cl. I–II" shortInstrumentName = \markup \abs-fontsize #9.5 "Cl. I–II" midiInstrument = "clarinet" } { \tag #'written { \transpose c d \clarinetsTogether } \tag #'concert { \clarinetsTogether } }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "B. Cl." shortInstrumentName = \markup \abs-fontsize #9.5 "B. Cl." midiInstrument = "clarinet" } { \tag #'written { \transpose c d' { \global \bassClarinetMusic } } \tag #'concert { \global \bassClarinetMusic } }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "S. Sax." shortInstrumentName = \markup \abs-fontsize #9.5 "S. Sax." midiInstrument = "soprano sax" } { \tag #'written { \transpose c d { \global \sopranoSaxMusic } } \tag #'concert { \global \sopranoSaxMusic } }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "A. Sax." shortInstrumentName = \markup \abs-fontsize #9.5 "A. Sax." midiInstrument = "alto sax" } { \tag #'written { \transpose c a { \global \altoSaxMusic } } \tag #'concert { \global \altoSaxMusic } }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "T. Sax." shortInstrumentName = \markup \abs-fontsize #9.5 "T. Sax." midiInstrument = "tenor sax" } { \tag #'written { \transpose c d' { \global \tenorSaxMusic } } \tag #'concert { \global \tenorSaxMusic } }
  >>
  % Brass
  \new StaffGroup <<
    % Trumpets in B-flat I–II: one staff, voice I up-stems and voice II down-stems.
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Tpt. I–II" shortInstrumentName = \markup \abs-fontsize #9.5 "Tpt. I–II" midiInstrument = "trumpet" } { \tag #'written { \transpose c d \trumpetsTogether } \tag #'concert { \trumpetsTogether } }
    % Trombones I–II: one staff, voice I up-stems and voice II down-stems.
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Tbn. I–II" shortInstrumentName = \markup \abs-fontsize #9.5 "Tbn. I–II" midiInstrument = "trombone" } { \clef bass \trombonesTogether }
  >>
  % Percussion
  \new StaffGroup <<
    \new DrumStaff \with { instrumentName = \markup \abs-fontsize #9.5 "D. Kit" shortInstrumentName = \markup \abs-fontsize #9.5 "D. Kit" } { \drumsGlobal \drumKitMusic }
  >>
  % Keyboards and Accordion
  \new StaffGroup <<
    \new PianoStaff \with { instrumentName = \markup \abs-fontsize #9.5 "Pno." shortInstrumentName = \markup \abs-fontsize #9.5 "Pno." } <<
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef treble \global \pianoRightMusic }
    \new Staff \with { midiInstrument = "acoustic grand" } { \clef bass \global \pianoLeftMusic }
  >>
    \new PianoStaff \with { instrumentName = \markup \abs-fontsize #9.5 "Acc." shortInstrumentName = \markup \abs-fontsize #9.5 "Acc." } <<
    \new Staff \with { midiInstrument = "accordion" } { \clef treble \global \accordionRightMusic }
    \new Staff \with { midiInstrument = "accordion" } { \clef bass \global \accordionLeftMusic }
  >>
  >>
  % Strings
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Vlns. I" shortInstrumentName = \markup \abs-fontsize #9.5 "Vlns. I" midiInstrument = "violin" } { \global \violinOneMusic }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Vlns. II" shortInstrumentName = \markup \abs-fontsize #9.5 "Vlns. II" midiInstrument = "violin" } { \global \violinTwoMusic }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Vlas." shortInstrumentName = \markup \abs-fontsize #9.5 "Vlas." midiInstrument = "viola" } { \clef alto \global \violaMusic }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Vcs." shortInstrumentName = \markup \abs-fontsize #9.5 "Vcs." midiInstrument = "cello" } { \clef bass \global \celloMusic }
    \new Staff \with { instrumentName = \markup \abs-fontsize #9.5 "Cbs." shortInstrumentName = \markup \abs-fontsize #9.5 "Cbs." midiInstrument = "contrabass" } { \clef bass \tag #'written { \transpose c c' { \global \doubleBassMusic } } \tag #'concert { \global \doubleBassMusic } }
  >>
>>
