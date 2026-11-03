\include "shared.ily"
% A4 is mandatory for the whole orchestra and for individual parts.
% The score uses a fixed, readable staff size. NEVER shrink it in a build retry:
% an orchestral score with 21 staves needs one system per portrait A4 page.
#(define (ea-count-staves m)
  (if (not (ly:music? m))
      0
      (+ (if (memq (ly:music-property m 'context-type #f)
                   '(Staff DrumStaff RhythmicStaff TabStaff)) 1 0)
         (ea-count-staves (ly:music-property m 'element #f))
         (apply + (map ea-count-staves
                       (filter ly:music? (ly:music-property m 'elements '())))))))
#(define ea-staff-count (max 1 (ea-count-staves ensembleScore)))
% Smaller ensembles can use bigger notes. Dense A4 orchestral scores
% must not get progressively smaller just to save paper.
#(define ea-print-staff-size
   (cond ((<= ea-staff-count 8) 20)
         ((<= ea-staff-count 14) 17)
         (else 14)))
#(set-global-staff-size ea-print-staff-size)

\paper {
  #(set-paper-size "a4")
  top-margin = 7\mm
  bottom-margin = 7\mm
  left-margin = 6\mm
  right-margin = 6\mm
  % Full names on the first system; short labels after the first break.
  indent = 43\mm
  short-indent = 18\mm
  print-first-page-number = ##t
  print-page-number = ##t
  % Do not vertically stretch a single system or force another system onto A4.
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  page-breaking = #ly:optimal-breaking
  oddHeaderMarkup = \ensembleHeader
  evenHeaderMarkup = \ensembleHeader
  oddFooterMarkup = \ensembleFooter
  evenFooterMarkup = \ensembleFooter
  bookTitleMarkup = \ensembleBookTitle
}

scoreCompactLayout = \layout {
  \context {
    \Score
    \override StaffGrouper.staff-staff-spacing.basic-distance = #5.5
    \override StaffGrouper.staff-staff-spacing.minimum-distance = #4.5
    \override StaffGrouper.staff-staff-spacing.padding = #0.5
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #7
    \override StaffGrouper.staffgroup-staff-spacing.minimum-distance = #5.5
    \override StaffGrouper.staffgroup-staff-spacing.padding = #0.5
  }
}
