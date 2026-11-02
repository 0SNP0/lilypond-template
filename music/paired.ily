% MusicXML duo split first pass; manually validate all instrumental voices.
flutesTogether = \partCombine #'(0 . 0) { \partCombineApart \fluteOneMusic } { \fluteTwoMusic }
clarinetsInATogether = \partCombine #'(0 . 0) { \partCombineApart \clarinetInAOneMusic } { \clarinetInATwoMusic }
trumpetsTogether = \partCombine #'(0 . 0) { \partCombineApart \trumpetOneMusic } { \trumpetTwoMusic }
trombonesTogether = \partCombine #'(0 . 0) { \partCombineApart \tromboneOneMusic } { \tromboneTwoMusic }
oboesTogether = \partCombine #'(0 . 0) { \partCombineApart \oboeOneMusic } { \oboeTwoMusic }
bassoonsTogether = \partCombine #'(0 . 0) { \partCombineApart \bassoonOneMusic } { \bassoonTwoMusic }
hornsOneThreeTogether = \partCombine #'(0 . 0) { \partCombineApart \hornOneMusic } { \hornThreeMusic }
hornsTwoFourTogether = \partCombine #'(0 . 0) { \partCombineApart \hornTwoMusic } { \hornFourMusic }
tromboneThreeTubaTogether = \partCombine #'(0 . 0) { \partCombineApart \tromboneThreeMusic } { \tubaMusic }
