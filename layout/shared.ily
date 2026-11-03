% Custom predicate defined here rather than relying on version-specific
% internal title helpers: hide the work title on the first page only.
#(define (ea-not-first-page layout props arg)
   (if (not (= (chain-assoc-get 'page:page-number props -1)
               (ly:output-def-lookup layout 'first-page-number)))
       (interpret-markup layout props arg)
       empty-stencil))

% One title design for both conductor scores and individual parts.
% Text sizes are absolute, so shrinking a full score's staff does not
% shrink its title, credits, headers or footers.
scorePageHeader = \markup {
  \overlay {
    \fill-line {
      \abs-fontsize #10 \fromproperty #'header:instrument
      \null
      \abs-fontsize #10 \fromproperty #'page:page-number-string
    }
    \fill-line {
      \null
      % The first page already has the work title in the title block.
      \on-the-fly #ea-not-first-page
        \abs-fontsize #10 \fromproperty #'header:title
      \null
    }
  }
}

scorePageFooter = \markup {
  \fill-line { \null \abs-fontsize #10 \footerLabel \null }
}

% Elegant book-serif typography. Crucially, title/subtitle and credits
% occupy SEPARATE vertical rows: right-aligned credits never sit over
% the center-aligned work title. Use the same markup for score and parts.
scoreBookTitle = \markup {
  \override #'(fonts . ((serif . "TeX Gyre Pagella"))) {
    \column {
      \vspace #0.8
      \fill-line {
        \null
        \center-column {
          \serif \bold \abs-fontsize #23
            \fromproperty #'header:title
          \vspace #0.35
          \serif \italic \abs-fontsize #12
            \fromproperty #'header:subtitle
        }
        \null
      }
      \vspace #1.4
      \fill-line {
        \left-column {
          \serif \abs-fontsize #10 \fromproperty #'header:poet
          \serif \abs-fontsize #10 \fromproperty #'header:translator
        }
        \null
        \right-column {
          \serif \abs-fontsize #10 \fromproperty #'header:composer
          \serif \abs-fontsize #10 \fromproperty #'header:transcriber
          \serif \abs-fontsize #10 \fromproperty #'header:arranger
        }
      }
      \vspace #0.7
    }
  }
}
