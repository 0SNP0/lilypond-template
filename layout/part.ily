\include "shared.ily"
% Compact, vertically safe title for individual parts only.
% Title, subtitle and credits occupy separate rows, with no overlays.
partBookTitle = \markup {
  \override #'(fonts . ((serif . "TeX Gyre Pagella"))) {
    \column {
      \fill-line {
        \null
        \center-column {
          \serif \bold \abs-fontsize #19 \fromproperty #'header:title
          \vspace #0.08
          \serif \italic \abs-fontsize #11 \fromproperty #'header:subtitle
        }
        \null
      }
      \vspace #0.35
      \fill-line {
        \null
        \right-column {
          \serif \abs-fontsize #9 \fromproperty #'header:composer
          \serif \abs-fontsize #9 \fromproperty #'header:arranger
        }
      }
    }
  }
}
% The engraving engine may retry dense parts with smaller staves, but
% default direct Frescobaldi previews keep the full 20 pt staff.
#(set-global-staff-size
  (let ((n (getenv "PART_STAFF_SIZE")))
    (if (and n (string->number n))
        (string->number n)
        20)))
\paper {
  #(set-paper-size "a4")
  top-margin = 11\mm
  bottom-margin = 12\mm
  left-margin = 15\mm
  right-margin = 15\mm
  indent = 0\mm
  short-indent = 0\mm
  print-first-page-number = ##t
  print-page-number = ##t
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  page-breaking = #ly:optimal-breaking
  system-system-spacing =
    #'((basic-distance . 12) (minimum-distance . 9)
       (padding . 1) (stretchability . 0))
  markup-system-spacing =
    #'((basic-distance . 7) (minimum-distance . 5)
       (padding . 1) (stretchability . 0))
  oddHeaderMarkup = \scorePageHeader
  evenHeaderMarkup = \scorePageHeader
  oddFooterMarkup = \scorePageFooter
  evenFooterMarkup = \scorePageFooter
  bookTitleMarkup = \partBookTitle
}
% Set page-count inside a specific part .ly if it must occupy N pages.
