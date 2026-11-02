% Shared edition style. Paper size, margins and staff size are supplied by build.py.
% Page header: edition/part (left), work (middle), page number (right).
ensemblePageHeader = \markup {
  \fill-line {
    \fontsize #-2 \fromproperty #'header:instrument
    \fontsize #-2 \fromproperty #'header:title
    \fontsize #-2 \fromproperty #'page:page-number-string
  }
}

% Every page identifies its Git revision; detailed copyright appears on first page.
ensemblePageFooter = \markup {
  \center-column {
    \fontsize #-2 \buildLabel
    \fontsize #-3 \fromproperty #'header:copyright
  }
}

% Title block at the top of the first music page (not a blank cover page).
ensembleBookTitle = \markup {
  \column {
    \vspace #1
    \fill-line {
      \null
      \center-column {
        \fontsize #6 \bold \fromproperty #'header:title
        \vspace #0.35
        \fontsize #2 \fromproperty #'header:subtitle
      }
      \null
    }
    \vspace #1
    \fill-line {
      \left-column {
        \fromproperty #'header:poet
        \fromproperty #'header:translator
      }
      \null
      \right-column {
        \fromproperty #'header:composer
        \fromproperty #'header:transcriber
        \fromproperty #'header:arrangedBy
      }
    }
    \vspace #1
  }
}

% Compact title for the full 23-staff score on A4 (parts retain full title).
ensembleCompactBookTitle = \markup {
  \column {
    \fill-line {
      \null
      \center-column {
        \fontsize #3 \bold \fromproperty #'header:title
        \fontsize #0 \fromproperty #'header:subtitle
      }
      \null
    }
    \vspace #0.3
    \fill-line {
      \null
      \right-column {
        \fontsize #-2 \fromproperty #'header:composer
        \fontsize #-2 \fromproperty #'header:transcriber
        \fontsize #-2 \fromproperty #'header:arrangedBy
      }
    }
    \vspace #0.3
  }
}
