% One print part and one MIDI stem. Notes stay editable only in
% snare-drum.ily, cymbals.ily and bass-drum.ily (three independent rhythms).
% These voices intentionally use a single physical DrumStaff.
percussionKitMusic = <<
  \new DrumVoice { \voiceOne \snareDrumMusic }
  \new DrumVoice { \voiceThree \omit MultiMeasureRest \cymbalsMusic }
  \new DrumVoice { \voiceTwo \omit MultiMeasureRest \bassDrumMusic }
>>
percussionKitPlayback = <<
  \new DrumVoice { \voiceOne \snareDrumMusicPlayback }
  \new DrumVoice { \voiceThree \cymbalsMusicPlayback }
  \new DrumVoice { \voiceTwo \bassDrumMusicPlayback }
>>
