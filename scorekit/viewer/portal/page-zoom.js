"use strict";
/** At 100% the entire SVG page fits both the height and width of the viewport.
 * Larger scales intentionally allow scrolling without distorting the score.
 */
function pageWidthForViewport(width,height,aspect,percent=100) {
  const w=Number(width),h=Number(height),ratio=Number(aspect),zoom=Number(percent);
  if(![w,h,ratio,zoom].every(Number.isFinite) ||
     w<=0 || h<=0 || ratio<=0 || zoom<=0)return 0;
  return Math.max(1,Math.floor(Math.min(w,h*ratio)*(zoom/100)));
}
if(typeof module!=="undefined" && module.exports)
  module.exports={pageWidthForViewport};
