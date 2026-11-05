"use strict";
/** A physical rectangle can represent many printed measures (R1*16).
 * Unlike note spacing, this range must survive system and page breaks.
 * The server exporter supplies last_printed_measure from the next visible
 * bar number. Older manifests retain the same-system conservative fallback.
 */
function regionForPrinted(measure, view) {
  if(!Number.isInteger(measure) || measure<1)return null;
  const areas=Array.isArray(view?.measure_areas)?view.measure_areas:[];
  const start=area=>{
    const match=/^measure-(\d+)$/.exec(area?.measure_id||"");
    return match?Number(match[1]):NaN;
  };
  const exact=areas.find(area=>start(area)===measure);
  if(exact)return exact;
  const ranged=areas.find(area=>
    start(area)<measure && Number.isInteger(area.last_printed_measure) &&
    measure<=area.last_printed_measure
  );
  if(ranged)return ranged;
  // Backwards compatibility with releases before span metadata existed.
  // Do not extend legacy guesses across systems or pages, where we cannot
  // distinguish a missing graphic from a compressed multimeasure rest.
  const prior=areas.filter(area=>start(area)<measure)
    .sort((a,b)=>start(b)-start(a))[0];
  const next=areas.filter(area=>start(area)>measure)
    .sort((a,b)=>start(a)-start(b))[0];
  return prior && next && prior.page===next.page &&
    Math.abs(prior.y-next.y)<.8 ? prior : null;
}
if(typeof module!=="undefined" && module.exports)
  module.exports={regionForPrinted};
