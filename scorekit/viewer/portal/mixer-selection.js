"use strict";
/** In a static score site the complete mix is exclusive with its component
 * stems: selecting either side removes the other to avoid doubling audio.
 */
function isCompleteAudioTrack(track) {
  return Boolean(track && (track.is_full_mix===true ||
    track.id==="mix" || track.id==="orchestra"));
}
function normalizeAudioSelection(ids, tracks) {
  const available=new Set((tracks||[]).map(t=>t.id));
  const chosen=[...new Set(ids||[])].filter(id=>available.has(id));
  const full=chosen.find(id=>isCompleteAudioTrack((tracks||[]).find(t=>t.id===id)));
  return full?[full]:chosen;
}
function toggleAudioSelection(current, id, enabled, tracks) {
  const track=(tracks||[]).find(t=>t.id===id);
  if(!track)return normalizeAudioSelection(current,tracks);
  const selected=new Set(current||[]);
  if(enabled){
    if(isCompleteAudioTrack(track))selected.clear();
    else for(const item of tracks||[])
      if(isCompleteAudioTrack(item))selected.delete(item.id);
    selected.add(id);
  }else selected.delete(id);
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
  module.exports={isCompleteAudioTrack,normalizeAudioSelection,toggleAudioSelection,defaultAudioSelection};
