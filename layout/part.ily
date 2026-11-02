\include "shared.ily"
% The engraving engine may retry dense parts with smaller staves, but
% default direct Frescobaldi previews keep the full 20 pt staff.
#(set-global-staff-size
  (let ((n (getenv "ENSEMBLE_PART_STAFF_SIZE")))
    (if (and n (string->number n))
        (string->number n)
        20)))
\paper {
  #(set-paper-size "a4")
  top-margin = 15\mm
  bottom-margin = 15\mm
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
    #'((basic-distance . 9) (minimum-distance . 6)
       (padding . 1) (stretchability . 0))
  oddHeaderMarkup = \ensembleHeader
  evenHeaderMarkup = \ensembleHeader
  oddFooterMarkup = \ensembleFooter
  evenFooterMarkup = \ensembleFooter
  bookTitleMarkup = \ensembleBookTitle
}
% Set page-count inside a specific part .ly if it must occupy N pages.
