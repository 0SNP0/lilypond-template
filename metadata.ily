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
% A Git revision is visible even in direct Frescobaldi/VS Code previews.
% The batch builder passes the version via SCORE_BUILD_REVISION, avoiding
% brittle -e Scheme variable scopes across LilyPond versions.
#(use-modules (ice-9 popen) (ice-9 rdelim))
#(define (ea-git-revision)
   (catch #t
     (lambda ()
       (let* ((port (open-pipe* OPEN_READ
                                "git" "describe" "--tags" "--always"
                                "--abbrev=8" "--match" "v[0-9]*"))
              (value (read-line port)))
         (close-pipe port)
         (if (and (string? value) (> (string-length value) 0))
             value
             "unversioned")))
     (lambda args "unversioned")))
buildRevision = #(let ((from-build (getenv "SCORE_BUILD_REVISION")))
                   (if (and from-build (> (string-length from-build) 0))
                       from-build
                       (ea-git-revision)))
footerLabel = #(string-append orchestraName " · " buildRevision)

% The work's single performance-form rule. Every instrumental Opening/Bridge
% is passed here; the order is defined once rather than repeated per player.
% Printed Fine / D.C. and playback-map.json must agree with this form.
scorePlayback = #(define-music-function (opening bridge)
  (ly:music? ly:music?)
  #{ $opening $bridge $opening #})
