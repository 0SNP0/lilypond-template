"use strict";
/** A complete mix is a selectable background layer, not a mutually
 * exclusive mode: its gain and all instrument stems have independent levels.
 */
function isCompleteAudioTrack(track) {
  return Boolean(track && (track.is_full_mix===true ||
    track.id==="mix" || track.id==="orchestra"));
}
function effectiveTrackVolume(master, stem) {
  const clamp=value=>Math.max(0,Math.min(1,Number.isFinite(Number(value))?Number(value):0));
  return clamp(master)*clamp(stem);
}
function normalizeAudioSelection(ids, tracks) {
  const available=new Set((tracks||[]).map(t=>t.id));
  const chosen=[...new Set(ids||[])].filter(id=>available.has(id));
  return chosen;
}
function toggleAudioSelection(current, id, enabled, tracks) {
  const track=(tracks||[]).find(t=>t.id===id);
  if(!track)return normalizeAudioSelection(current,tracks);
  const selected=new Set(current||[]);
  if(enabled)selected.add(id);
  else selected.delete(id);
  return normalizeAudioSelection([...selected],tracks);
}
function defaultAudioSelection(view, tracks, viewId) {
  const allowed=new Set((tracks||[]).map(t=>t.id));
  const fromManifest=view?.audio_track_ids;
  if(Array.isArray(fromManifest)){
    return normalizeAudioSelection(fromManifest,tracks);
  }
  if(allowed.has(viewId))return [viewId];
  return normalizeAudioSelection([(tracks||[]).find(isCompleteAudioTrack)?.id],tracks);
}
if(typeof module!=="undefined" && module.exports)
  module.exports={isCompleteAudioTrack,normalizeAudioSelection,toggleAudioSelection,defaultAudioSelection,effectiveTrackVolume};
