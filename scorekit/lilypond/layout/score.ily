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
#(define ea-staff-count (max 1 (ea-count-staves orchestraScore)))
% Smaller orchestras can use bigger notes. Dense A4 orchestral scores
% must not get progressively smaller just to save paper.
% Fit the size to the actual number of orchestral staves.  The builder
% starts with this size and only retries a smaller one if A4 is overfull.
#(define ea-natural-staff-size
   (cond ((<= ea-staff-count 6) 20)
         ((<= ea-staff-count 10) 18)
         ((<= ea-staff-count 14) 16)
         ((<= ea-staff-count 18) 15)
         ((<= ea-staff-count 22) 14)
         (else 12.5)))
#(define ea-staff-size-override (getenv "SCORE_STAFF_SIZE"))
#(define ea-print-staff-size
   (if (and ea-staff-size-override
            (string->number ea-staff-size-override))
       (string->number ea-staff-size-override)
       ea-natural-staff-size))
#(set-global-staff-size ea-print-staff-size)

\paper {
  #(set-paper-size "a4")
  top-margin = 7\mm
  bottom-margin = 7\mm
  left-margin = 6\mm
  right-margin = 6\mm
  % Full names on the first system; short labels after the first break.
  % The builder measures label positions with native LilyPond SVG first.
  % PDF and SVG then use exactly the same derived first/continuation indents.
  % Direct-editor previews retain sensible conservative fallback values.
  indent = #(let ((n (getenv "SCORE_INDENT_MM")))
              (if (and n (string->number n))
                  (* (string->number n) mm) (* 30 mm)))
  short-indent = #(let ((n (getenv "SCORE_SHORT_INDENT_MM")))
                    (if (and n (string->number n))
                        (* (string->number n) mm) (* 19 mm)))
  print-first-page-number = ##t
  print-page-number = ##t
  % Do not vertically stretch a single system or force another system onto A4.
  ragged-bottom = ##f
  ragged-last-bottom = ##f
  page-breaking = #ly:optimal-breaking
  oddHeaderMarkup = \scorePageHeader
  evenHeaderMarkup = \scorePageHeader
  oddFooterMarkup = \scorePageFooter
  evenFooterMarkup = \scorePageFooter
  bookTitleMarkup = \scoreBookTitle
}

scoreCompactLayout = \layout {
  \context {
    \Score
    % One boxed number per bar, centered below the complete orchestra.
    % Uses the same measure numbers as the JSON/SVG playback clock.
    centerBarNumbers = ##t
    barNumberVisibility = #all-bar-numbers-visible
    \override CenteredBarNumber.stencil =
      #(make-stencil-boxer 0.08 0.20 ly:text-interface::print)
    \override CenteredBarNumber.font-size = #0
    \override CenteredBarNumberLineSpanner.direction = #DOWN
    \override CenteredBarNumberLineSpanner.padding = #0.4
    \override StaffGrouper.staff-staff-spacing.basic-distance = #5.5
    \override StaffGrouper.staff-staff-spacing.minimum-distance = #4.5
    \override StaffGrouper.staff-staff-spacing.padding = #0.5
    \override StaffGrouper.staffgroup-staff-spacing.basic-distance = #7
    \override StaffGrouper.staffgroup-staff-spacing.minimum-distance = #5.5
    \override StaffGrouper.staffgroup-staff-spacing.padding = #0.5
  }
  \context {
    \Staff
    \override InstrumentName.self-alignment-X = #RIGHT
    \override InstrumentName.padding = #0.25
  }
  \context {
    \DrumStaff
    \override InstrumentName.self-alignment-X = #RIGHT
    \override InstrumentName.padding = #0.25
  }
}
