\version "2.26.0"
% Canonical credits: Ensemble, Assemble is the orchestra, not the arranger.
workTitle = "The Snowstorm"
% Portable short basename for exports; the full title stays on the score.
workFileSlug = "sviridov-snowstorm-waltz"
workSubtitle = "Waltz"
composerCredit = "Georgy Sviridov"
lyricistCredit = ""
translatorCredit = ""
transcriberCredit = ""
arrangerCredit = ""
proofreaderCredit = ""
sourceCredit = "Imported from user-provided MusicXML; proofread before performance"
rightsCredit = "Copyright belongs to the respective rightsholders"
orchestraName = "Ensemble, Assemble"
\include "scorekit/lilypond/version.ily"
\include "scorekit/lilypond/playback-markers.ily"

% The work's single performance-form rule. Every instrumental Opening/Bridge
% is passed here; the order is defined once rather than repeated per player.
% The playback clock uses the same form; MIDI markers map visits to printed bars.
scorePlayback = #(define-music-function (opening bridge)
  (ly:music? ly:music?)
  #{ $opening $bridge $opening #})
