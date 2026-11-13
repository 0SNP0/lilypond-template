\version "2.26.0"
\include "metadata.ily"
\include "music/global.ily"
\include "music/piccolo.ily"
\include "music/flute-1.ily"
\include "music/flute-2.ily"
\include "music/oboe-1.ily"
\include "music/oboe-2.ily"
\include "music/english-horn.ily"
\include "music/clarinet-in-a-1.ily"
\include "music/clarinet-in-a-2.ily"
\include "music/bassoon-1.ily"
\include "music/bassoon-2.ily"
\include "music/contrabassoon.ily"
\include "music/horn-1.ily"
\include "music/horn-3.ily"
\include "music/horn-2.ily"
\include "music/horn-4.ily"
\include "music/trumpet-1.ily"
\include "music/trumpet-2.ily"
\include "music/trumpet-3.ily"
\include "music/trombone-1.ily"
\include "music/trombone-2.ily"
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

\include "music/combined/flutes.ily"
\include "music/paired.ily"
\include "music/drum-kit.ily"

orchestraScore = <<
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Piccolo" shortInstrumentName = "Picc." midiInstrument = "piccolo" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \rehearsalMarks } \tag #'concert { \rehearsalMarks } \tag #'playback { \rehearsalMarksPlayback } } { \tag #'written { \clef treble \piccoloMusic } \tag #'concert { \clef "treble^8" \transpose c c' \piccoloMusic } \tag #'playback { \clef "treble^8" \transpose c c' \piccoloMusicPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##t soloText = "I" soloIIText = "II" aDueText = "a2" instrumentName = \markup \fontsize #-1 "Flutes I–II" shortInstrumentName = "Fl. I–II" midiInstrument = "flute" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \flutesTogether } \tag #'concert { \transpose c c \flutesTogether } \tag #'playback { \transpose c c \flutesTogetherPlayback } } { \tag #'written { \flutesDeskCues } \tag #'concert { \flutesDeskCues } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Oboes I–II" shortInstrumentName = "Ob. I–II" midiInstrument = "oboe" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \oboesTogether } \tag #'concert { \transpose c c \oboesTogether } \tag #'playback { \transpose c c \oboesTogetherPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "English Horn" shortInstrumentName = "Eng. Hn." midiInstrument = "english horn" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \englishHornMusic } \tag #'concert { \transpose c f, \englishHornMusic } \tag #'playback { \transpose c f, \englishHornMusicPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Clarinets in A I–II" shortInstrumentName = "Cl. A I–II" midiInstrument = "clarinet" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \clarinetsInATogether } \tag #'concert { \transpose c a, \clarinetsInATogether } \tag #'playback { \transpose c a, \clarinetsInATogetherPlayback } } { \tag #'written { \clarinetsDeskCues } \tag #'concert { \transpose c a, \clarinetsDeskCues } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Bassoons I–II" shortInstrumentName = "Bsn. I–II" midiInstrument = "bassoon" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \bassoonsTogether } \tag #'concert { \transpose c c \bassoonsTogether } \tag #'playback { \transpose c c \bassoonsTogetherPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Contrabassoon" shortInstrumentName = "Cbsn." midiInstrument = "bassoon" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \clef bass \contrabassoonMusic } \tag #'concert { \clef "bass_8" \transpose c c, \contrabassoonMusic } \tag #'playback { \clef "bass_8" \transpose c c, \contrabassoonMusicPlayback } } >> }
  >>
  \new StaffGroup <<
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Horns in F I/III" shortInstrumentName = "Hn. I/III" midiInstrument = "french horn" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \hornsOneThreeTogether } \tag #'concert { \transpose c f, \hornsOneThreeTogether } \tag #'playback { \transpose c f, \hornsOneThreeTogetherPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Horns in F II/IV" shortInstrumentName = "Hn. II/IV" midiInstrument = "french horn" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \hornsTwoFourTogether } \tag #'concert { \transpose c f, \hornsTwoFourTogether } \tag #'playback { \transpose c f, \hornsTwoFourTogetherPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Trumpets in B-flat I–II" shortInstrumentName = "Tpt. I–II" midiInstrument = "trumpet" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \trumpetsTogether } \tag #'concert { \transpose c bes, \trumpetsTogether } \tag #'playback { \transpose c bes, \trumpetsTogetherPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Trumpet in B-flat III" shortInstrumentName = "Tpt. III" midiInstrument = "trumpet" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \trumpetThreeMusic } \tag #'concert { \transpose c bes, \trumpetThreeMusic } \tag #'playback { \transpose c bes, \trumpetThreeMusicPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Trombones I–II" shortInstrumentName = "Tbn. I–II" midiInstrument = "trombone" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \trombonesTogether } \tag #'concert { \transpose c c \trombonesTogether } \tag #'playback { \transpose c c \trombonesTogetherPlayback } } >> }
    \new Staff \with { \consists Merge_rests_engraver printPartCombineTexts = ##f instrumentName = \markup \fontsize #-1 "Trombone III / Tuba" shortInstrumentName = "Tbn. III/Tba." midiInstrument = "tuba" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \tromboneThreeTubaTogether } \tag #'concert { \transpose c c \tromboneThreeTubaTogether } \tag #'playback { \transpose c c \tromboneThreeTubaTogetherPlayback } } >> }
  >>
  \new StaffGroup <<
    \new DrumStaff \with {
      instrumentName = \markup \fontsize #-1 "Drum Kit"
      shortInstrumentName = "D. Kit"
    } <<
      { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } }
      { \tag #'written { \drumKitMusic } \tag #'concert { \drumKitMusic } \tag #'playback { \drumKitPlayback } }
    >>
  >>
  \new StaffGroup <<
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violins I" shortInstrumentName = "Vlns. I" midiInstrument = "violin" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \violinsOneMusic } \tag #'concert { \transpose c c \violinsOneMusic } \tag #'playback { \transpose c c \violinsOneMusicPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violins II" shortInstrumentName = "Vlns. II" midiInstrument = "violin" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \violinsTwoMusic } \tag #'concert { \transpose c c \violinsTwoMusic } \tag #'playback { \transpose c c \violinsTwoMusicPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violas" shortInstrumentName = "Vlas." midiInstrument = "viola" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \violasMusic } \tag #'concert { \transpose c c \violasMusic } \tag #'playback { \transpose c c \violasMusicPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Violoncellos" shortInstrumentName = "Vcs." midiInstrument = "cello" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \violoncellosMusic } \tag #'concert { \transpose c c \violoncellosMusic } \tag #'playback { \transpose c c \violoncellosMusicPlayback } } >> }
    \new Staff \with { instrumentName = \markup \fontsize #-1 "Contrabasses" shortInstrumentName = "Cbs." midiInstrument = "contrabass" } { << { \tag #'written { \global } \tag #'concert { \global } \tag #'playback { \globalPlayback } } { \tag #'written { \clef bass \contrabassesMusic } \tag #'concert { \clef "bass_8" \transpose c c, \contrabassesMusic } \tag #'playback { \clef "bass_8" \transpose c c, \contrabassesMusicPlayback } } >> }
  >>
>>
