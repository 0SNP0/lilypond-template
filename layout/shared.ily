% Common A4 paper and headers for preview, local build and CI.
ensembleHeader = \markup {
  \overlay {
    \fill-line {
      \abs-fontsize #10 \fromproperty #'header:instrument
      \null
      \abs-fontsize #10 \fromproperty #'page:page-number-string
    }
    \fill-line { \null \abs-fontsize #10 \fromproperty #'header:title \null }
  }
}

ensembleFooter = \markup {
  \fill-line { \null \abs-fontsize #10 \footerLabel \null }
}

ensemblePartTitle = \markup {
  \column {
    \vspace #1
    \fill-line {
      \null
      \center-column {
        \abs-fontsize #25 \bold \fromproperty #'header:title
        \abs-fontsize #14 \fromproperty #'header:subtitle
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
        \abs-fontsize #21 \bold \fromproperty #'header:title
        \abs-fontsize #12 \fromproperty #'header:subtitle
      }
      \null
    }
    \vspace #0.3
    \fill-line {
      \null
      \right-column {
        \abs-fontsize #10 \fromproperty #'header:composer
        \abs-fontsize #10 \fromproperty #'header:arranger
      }
    }
  }
}
