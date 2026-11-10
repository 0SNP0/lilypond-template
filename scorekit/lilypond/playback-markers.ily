% Optional, work-independent navigation anchors for ScoreKit MIDI export.
% Include this file only in the MIDI score. Put \scorekitPlaybackStart #N
% at the first played measure and wherever playback jumps to another
% printed measure. Anchors inside LilyPond repeat constructs get unfolded
% with the music; they must never appear in the printed score.
%
% ScoreKit reads the resulting MIDI marker meta events (FF 06). This does
% not replace a project's standard LilyPond repeat notation.
scorekitPlaybackStart =
#(define-music-function (printed-bar) (positive?)
   #{
     \mark \markup #(string-append "scorekit-bar:" (number->string printed-bar))
   #})
