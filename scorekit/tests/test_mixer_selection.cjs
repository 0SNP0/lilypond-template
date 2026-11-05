"use strict";
const assert=require("node:assert/strict");
const {normalizeAudioSelection,toggleAudioSelection,defaultAudioSelection,effectiveTrackVolume}=
  require("../viewer/portal/mixer-selection.js");
const tracks=[
  {id:"mix",is_full_mix:true},
  {id:"flute-1"}, {id:"flute-2"}, {id:"violin-1"}
];
assert.deepEqual(toggleAudioSelection(["mix"],"flute-2",true,tracks),
  ["flute-2"]);
assert.deepEqual(toggleAudioSelection(["flute-1","flute-2"],"mix",true,tracks),
  ["mix"]);
assert.deepEqual(toggleAudioSelection(["flute-1","flute-2"],"flute-1",false,tracks),
  ["flute-2"]);
assert.deepEqual(normalizeAudioSelection(["flute-2","flute-1","flute-2"],tracks),
  ["flute-2","flute-1"]);
assert.deepEqual(defaultAudioSelection({kind:"combined",
  audio_track_ids:["flute-1","flute-2"]},tracks,"combined-flutes-1-2"),
  ["flute-1","flute-2"]);
assert.deepEqual(defaultAudioSelection({kind:"score",
  audio_track_ids:["mix"]},tracks,"score"),["mix"]);
assert.deepEqual(defaultAudioSelection({kind:"individual"},tracks,"flute-2"),
  ["flute-2"]);
assert.deepEqual(defaultAudioSelection({kind:"combined"},tracks,
  "combined-unknown"),["mix"]);  // Backward compatibility for older releases.
assert.equal(effectiveTrackVolume(0.5,1),0.5);
assert.equal(effectiveTrackVolume(0.5,0.4),0.2);
assert.equal(effectiveTrackVolume(0,0.8),0);
assert.equal(effectiveTrackVolume(1,0.6),0.6);
console.log("Audio selection, combined defaults, and global gain: OK");
