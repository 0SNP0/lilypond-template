"use strict";
const assert=require("node:assert/strict");
const {hasMediaBuffer}=require("../viewer/portal/audio-buffer.js");
function media(start,end,readyState=4,options={}){
  return {readyState,seeking:false,duration:100,...options,buffered:{
    length:1,start:()=>start,end:()=>end
  }};
}
assert.equal(hasMediaBuffer(media(0,5),0),true);
assert.equal(hasMediaBuffer(media(0,0.4),0),false);
assert.equal(hasMediaBuffer(media(0,10,2),0),false);
assert.equal(hasMediaBuffer(media(0,10,4,{seeking:true}),0),false);
assert.equal(hasMediaBuffer(media(0,10,4,{error:{code:2}}),0),false);
assert.equal(hasMediaBuffer(media(4.99,9),5),true);
assert.equal(hasMediaBuffer(media(0,10),12),false);
assert.equal(hasMediaBuffer(media(98,100,4,{duration:100}),99.5),true);
assert.equal(hasMediaBuffer({...media(0,10),buffered:{length:0}},0),false);
console.log("Multitrack buffering gate tests: OK");
