"use strict";
const assert=require("node:assert/strict");
const {regionForPrinted}=require("../viewer/portal/measure-spans.js");
function region(number,page,y,last) {
  return {measure_id:"measure-"+String(number).padStart(4,"0"),
    page,y,x:0,width:10,last_printed_measure:last};
}
const view={measure_areas:[
  region(37,1,32.3,52),
  region(53,1,49.2,53),
  region(54,1,49.2,60),
  region(61,2,15,61),
]};
for(let n=37;n<=52;n++)
  assert.equal(regionForPrinted(n,view),view.measure_areas[0],
    "System-ending 16-bar rest must remain selected at bar "+n);
for(let n=54;n<=60;n++)
  assert.equal(regionForPrinted(n,view),view.measure_areas[2],
    "Rest spanning page break must stay highlighted at bar "+n);
assert.equal(regionForPrinted(53,view),view.measure_areas[1]);
assert.equal(regionForPrinted(61,view),view.measure_areas[3]);
assert.equal(regionForPrinted(36,view),null);
assert.equal(regionForPrinted(0,view),null);
assert.equal(regionForPrinted(62,view),null);
const old={measure_areas:[region(37,1,30),region(53,1,50)]};
assert.equal(regionForPrinted(38,old),null,
  "Legacy manifests must not fabricate regions across system breaks");
console.log("Multimeasure rest highlights survive system and page breaks.");
