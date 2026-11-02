\version "2.24.3"
% Canonical credits: Ensemble, Assemble is the orchestra, not the arranger.
workTitle = "Orchestral Sketch"
workSubtitle = "An original eight-bar orchestral example"
composerCredit = "Original demonstration music"
lyricistCredit = ""
translatorCredit = ""
transcriberCredit = ""
arrangerCredit = "Template contributor — replace for your arrangement"
proofreaderCredit = ""
sourceCredit = "Original demo, no external score used"
rightsCredit = "Original demonstration music; replace credits and rights for real arrangements"
ensembleName = "Ensemble, Assemble"
% A Git revision is visible even in direct Frescobaldi/VS Code previews.
% The batch builder passes the version via ENSEMBLE_SCORE_VERSION, avoiding
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
buildRevision = #(let ((from-build (getenv "ENSEMBLE_SCORE_VERSION")))
                   (if (and from-build (> (string-length from-build) 0))
                       from-build
                       (ea-git-revision)))
footerLabel = #(string-append ensembleName " · " buildRevision)
