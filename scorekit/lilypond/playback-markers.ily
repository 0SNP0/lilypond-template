% Optional, reusable MIDI navigation anchors for the ScoreKit viewer.
% Include this file in the score project, then put \scorekitPlaybackStart
% at the beginning of each printed passage that can be entered after a jump.
% Native LilyPond volta/segno unfolding duplicates these marks automatically.
% Only use this command in MIDI-only music: it emits a MIDI rehearsal marker.
scorekitPlaybackStart =
#(define-music-function (printed-bar) (positive?)
   #{
     \mark \markup #(string-append "scorekit-bar:" (number->string printed-bar))
   #})
