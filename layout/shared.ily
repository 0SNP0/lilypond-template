% Common A4 paper and headers for preview, local build and CI.
ensembleHeader = \markup {
  \overlay {
    \fill-line {
      \fontsize #-2 \fromproperty #'header:instrument
      \null
      \fontsize #-2 \fromproperty #'page:page-number-string
    }
    \fill-line { \null \fontsize #-2 \fromproperty #'header:title \null }
  }
}

ensembleFooter = \markup {
  \fill-line { \null \fontsize #-2 \footerLabel \null }
}

ensemblePartTitle = \markup {
  \column {
    \vspace #1
    \fill-line {
      \null
      \center-column {
        \fontsize #6 \bold \fromproperty #'header:title
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
        \fromproperty #'header:arranger
      }
    }
  }
}

ensembleScoreTitle = \markup {
  \column {
    \fill-line {
      \null
      \center-column {
        \fontsize #3 \bold \fromproperty #'header:title
        \fontsize #-1 \fromproperty #'header:subtitle
      }
      \null
    }
    \vspace #0.3
    \fill-line {
      \null
      \right-column {
        \fontsize #-2 \fromproperty #'header:composer
        \fontsize #-2 \fromproperty #'header:arranger
      }
    }
  }
}
