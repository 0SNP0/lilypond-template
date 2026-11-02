\include "shared.ily"
% Count actual five-line staves in orchestra.ily, including each keyboard staff.
#(define (ea-count-staves m)
  (if (not (ly:music? m))
      0
      (+ (if (memq (ly:music-property m 'context-type #f)
                   '(Staff DrumStaff RhythmicStaff TabStaff)) 1 0)
         (ea-count-staves (ly:music-property m 'element #f))
         (apply + (map ea-count-staves
                       (filter ly:music? (ly:music-property m 'elements '())))))))

#(define ea-staff-count (max 1 (ea-count-staves ensembleScore)))
#(define ea-automatic-size
  (min 1.75 (max 0.55 (/ 235.0 (* 9.0 ea-staff-count)))))
% The build tool can reduce this via -e if a page still compresses.
#(define ea-print-size
  (if (defined? 'ea-score-size-override)
      ea-score-size-override
      ea-automatic-size))
#(set-global-staff-size (* 20.0 (/ ea-print-size 1.7573)))

\paper {
  #(set-paper-size "a4")
  top-margin = 15\mm
  bottom-margin = 15\mm
  left-margin = 15\mm
  right-margin = 15\mm
  indent = 18\mm
  short-indent = 18\mm
  print-first-page-number = ##t
  print-page-number = ##t
  ragged-bottom = ##f
  ragged-last-bottom = ##f
  page-breaking = #ly:optimal-breaking
  oddHeaderMarkup = \ensembleHeader
  evenHeaderMarkup = \ensembleHeader
  oddFooterMarkup = \ensembleFooter
  evenFooterMarkup = \ensembleFooter
  bookTitleMarkup = \ensembleScoreTitle
}

scoreCompactLayout = \layout {
  \context {
    \Score
    \override StaffGrouper.staff-staff-spacing.basic-distance = #7
    \override StaffGrouper.staff-staff-spacing.minimum-distance = #6
    \override StaffGrouper.staff-staff-spacing.padding = #0.5
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #9
    \override StaffGrouper.staffgroup-staff-spacing.minimum-distance = #7
    \override StaffGrouper.staffgroup-staff-spacing.padding = #0.8
  }
}
