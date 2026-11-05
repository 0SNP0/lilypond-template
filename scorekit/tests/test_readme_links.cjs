"use strict";
const assert = require("node:assert/strict");
const {readmeLinkTarget} = require("../viewer/portal/readme-links.js");
const repo = "0SNP0/lilypond-template", tag = "v0.1.7";
assert.equal(readmeLinkTarget("score.ly",repo,tag),
  "https://github.com/0SNP0/lilypond-template/blob/v0.1.7/score.ly");
assert.equal(readmeLinkTarget("music/",repo,tag),
  "https://github.com/0SNP0/lilypond-template/tree/v0.1.7/music");
assert.equal(readmeLinkTarget("orchestra.ily",repo,tag),
  "https://github.com/0SNP0/lilypond-template/blob/v0.1.7/orchestra.ily");
assert.equal(readmeLinkTarget("docs/PROJECT_GUIDE.md#local",repo,tag),
  "https://github.com/0SNP0/lilypond-template/blob/v0.1.7/docs/PROJECT_GUIDE.md#local");
assert.equal(readmeLinkTarget("https://example.org/info",repo,tag),
  "https://example.org/info");
assert.equal(readmeLinkTarget("javascript:alert(1)",repo,tag),null);
assert.equal(readmeLinkTarget("../somewhere",repo,tag),null);
assert.equal(readmeLinkTarget("%2e%2e/secret",repo,tag),null);
assert.equal(readmeLinkTarget("//example.org/unsafe",repo,tag),null);
console.log("README source links resolve to the published GitHub tag.");
