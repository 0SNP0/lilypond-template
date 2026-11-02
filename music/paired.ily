% MusicXML duo split first pass; manually validate all instrumental voices.
flutesTogether = \partCombine #'(0 . 0) { \partCombineApart \fluteOneMusic } { \fluteTwoMusic }
clarinetsInATogether = \partCombine #'(0 . 0) { \partCombineApart \clarinetInAOneMusic } { \clarinetInATwoMusic }
trumpetsTogether = \partCombine #'(0 . 0) { \partCombineApart \trumpetOneMusic } { \trumpetTwoMusic }
trombonesTogether = \partCombine #'(0 . 0) { \partCombineApart \tromboneOneMusic } { \tromboneTwoMusic }
