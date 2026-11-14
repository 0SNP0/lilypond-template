% Desk-only manual rest placement controls.
% Include from parts/combined/*.ly, NEVER from the solo source files.
%
% Place a command immediately before the affected measure in the
% same time-aligned skip voice as the partCombine mode map:
%
%   \deskRestCenter s2.             % both instruments rest
%   \deskRestUpper #6 s2.           % upper instrument alone rests
%   \deskRestLower #-6 s2.          % lower instrument alone rests
%
% Use \deskRestAuto to resume LilyPond's default placement.
% The controls affect only this combined Staff. They change no note/rest
% durations and have no effect on independent parts or MIDI.
%
% A full-measure rest may be engraved as Rest or MultiMeasureRest,
% depending on LilyPond's skipBars/partCombine decisions. Set both.
deskRestPosition =
#(define-music-function (position) (number?)
   #{
     \override Staff.Rest.staff-position = #position
     \override Staff.MultiMeasureRest.staff-position = #position
   #})
deskRestAuto = {
  \revert Staff.Rest.staff-position
  \revert Staff.MultiMeasureRest.staff-position
}
deskRestCenter = { \deskRestPosition #0 }
deskRestUpper =
#(define-music-function (position) (number?)
   #{ \deskRestPosition #position #})
deskRestLower =
#(define-music-function (position) (number?)
   #{ \deskRestPosition #position #})
