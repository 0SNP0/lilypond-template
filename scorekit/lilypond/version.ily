% Shared Git-version footer for any LilyPond score project.
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

