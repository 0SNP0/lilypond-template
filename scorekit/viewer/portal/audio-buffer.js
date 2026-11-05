"use strict";
/** True only when media has decoded/buffered enough of the SAME time span
 * on every selected track. The guard includes the seek and stalled states.
 */
function hasMediaBuffer(media, position, aheadSeconds=1.25) {
  if(!media || media.error || media.seeking ||
      media.readyState<3 || !Number.isFinite(position))return false;
  const end=Number.isFinite(media.duration)?media.duration:Infinity;
  const required=Math.min(end,Math.max(0,position)+aheadSeconds);
  const ranges=media.buffered;
  if(!ranges || !ranges.length)return false;
  for(let i=0;i<ranges.length;i++){
    if(ranges.start(i)<=position+.10 && ranges.end(i)>=required-.05)
      return true;
  }
  return false;
}
if(typeof module!=="undefined" && module.exports)
  module.exports={hasMediaBuffer};
