"use strict";
/* This viewer is bound to ONE score project, with ONE latest published release.
   All data, SVG, and MP3 URLs resolve against the same Pages origin. */
const $ = id => document.getElementById(id);
const message = text => $("message").textContent = text;
let info = null, manifest = null, timeline = null;
let pageGeneration = 0, lastPage = "", lastAudio = "";
const audio = $("audio");

function selectOptions(element, rows) {
  element.replaceChildren();
  for (const [value, title] of rows) {
    const option = document.createElement("option");
    option.value = value;
    option.textContent = title;
    element.appendChild(option);
  }
}
function viewLabel(id, view) {
  const types = {"score":"Партитура", "concert-score":"Концертный строй",
                 "individual":"Партия", "combined":"Объединённая партия"};
  return (types[view.kind] || "Ноты") + " · " + id.replaceAll("-", " ");
}
function trustedPath(input, prefix, suffix) {
  if (typeof input !== "string" || input.startsWith("/") ||
      input.includes("\\") || input.split("/").some(v => v === ".." || v === "." || !v) ||
      !input.startsWith(prefix) || !input.toLowerCase().endsWith(suffix)) {
    throw Error("Некорректный путь ресурса: " + input);
  }
  return input;
}
async function getJSON(path) {
  const response = await fetch(path, {cache: "no-store"});
  if (!response.ok) throw Error("HTTP " + response.status + ": " + path);
  return response.json();
}
async function boot() {
  try {
    info = await getJSON("./latest.json");
    if (info.schema !== "scorekit-project-site-v1") throw Error("Неподдерживаемый формат сайта");
    const base = "./latest/";
    [manifest, timeline] = await Promise.all([
      getJSON(base + "viewer/manifest.json"),
      getJSON(base + "viewer/timeline.json")
    ]);
    if (!manifest.views || !Object.keys(manifest.views).length ||
        !Array.isArray(timeline.measures) || !timeline.measures.length)
      throw Error("Отсутствуют данные партитуры и времени воспроизведения");
    $("heading").textContent = [info.title, info.orchestra].filter(Boolean).join(" · ");
    $("version").textContent = "Актуальная версия: " + info.tag;
    document.title = info.title + " — ScoreKit";
    if (info.release_url) {
      $("release").href = info.release_url;
      $("release").hidden = false;
    }
    selectOptions($("view"), Object.entries(manifest.views).map(([id,v]) => [id,viewLabel(id,v)]));
    selectOptions($("track"), [["","Выберите аудиодорожку"], ...manifest.audio_tracks.map(t=>[t.id,t.label])]);
    $("view").disabled = $("track").disabled = false;
    $("seek").max = String(timeline.measures.length - 1);
    $("seek").disabled = false;
    const initialView = new URL(location.href).searchParams.get("view");
    if (initialView && Object.hasOwn(manifest.views,initialView)) $("view").value = initialView;
    if (info.readme_available) {
      const r = await fetch("./latest/README.md");
      $("readme").textContent = r.ok ? await r.text() : "README недоступен";
    } else {
      $("readme").textContent = "README в релизе отсутствует";
    }
    message("Партитура загружена. Выберите ноты и звуковую дорожку.");
    await showView();
  } catch(e) { message("Не удалось загрузить партитуру: " + e.message); }
}
async function showView() {
  if (!manifest) return;
  const generation = ++pageGeneration;
  const viewId = $("view").value, view = manifest.views[viewId];
  if (!view) return;
  $("pages").replaceChildren();
  lastPage = "";
  $("pagehint").textContent = view.pages.length + " стр. · " +
     (view.anchors_found ?? 0) + " найденных меток тактов";
  const fragment = document.createDocumentFragment();
  for (let i=0; i<view.pages.length; ++i) {
    const path = trustedPath(view.pages[i], "svg/", ".svg");
    const wrap = document.createElement("div");
    wrap.className = "page";
    wrap.dataset.page = String(i+1);
    const img = document.createElement("img");
    img.alt = "Нотная страница " + (i+1);
    img.loading = i===0 ? "eager" : "lazy";
    img.decoding = "async";
    img.src = "./latest/viewer/" + path;
    const a = document.createElement("a");
    a.href = img.src;
    a.target = "_blank";
    a.rel = "noopener";
    a.textContent = "Открыть SVG · страница " + (i+1);
    wrap.append(img,a);
    fragment.append(wrap);
  }
  if (generation !== pageGeneration) return;
  $("pages").append(fragment);
  const url = new URL(location.href);
  url.searchParams.set("view",viewId);
  history.replaceState(null,"",url);
  updateTime();
}
function setTrack() {
  if (!manifest || !info) return;
  const track = manifest.audio_tracks.find(t=>t.id===$("track").value);
  if (!track) {audio.pause();audio.removeAttribute("src");audio.load();lastAudio="";return;}
  const raw = track.path.replace(/^(\.\.\/)+/,"");
  const path = trustedPath(raw, "audio/", ".mp3");
  const url = "./latest/" + path;
  const oldTime = audio.currentTime || 0, wasPlaying = !audio.paused;
  if (lastAudio === path) return;
  lastAudio = path;
  audio.src = url;
  audio.load();
  audio.addEventListener("loadedmetadata",()=>{
    audio.currentTime = Math.min(oldTime,Number.isFinite(audio.duration)?Math.max(0,audio.duration-0.05):oldTime);
    if (wasPlaying) audio.play().catch(()=>{});
  },{once:true});
  message("Дорожка: "+track.label+". Звук загружается напрямую с сайта по мере воспроизведения.");
}
function updateTime() {
  if (!manifest || !timeline?.measures?.length) return;
  const ms = audio.currentTime * 1000;
  const data = timeline.measures;
  let low=0, high=data.length;
  while(low<high){const mid=(low+high)>>1;if(data[mid].start_ms<=ms)low=mid+1;else high=mid;}
  const i=Math.max(0,low-1), m=data[i];
  $("seek").value=String(i);
  $("position").textContent="Такт "+m.printed_number+" / "+timeline.printed_measures+
    (m.number>timeline.printed_measures ? " · реприза" : "");
  const view=manifest.views[$("view").value];
  const anchor=view?.measure_anchors?.find(a=>a.measure_id===m.printed_measure_id);
  if(anchor && !audio.paused && String(anchor.page)!==lastPage){
    const page=$("pages").querySelector('.page[data-page="'+anchor.page+'"]');
    if(page && !page.matches(":hover")){
      lastPage=String(anchor.page);
      page.scrollIntoView({block:"nearest",behavior:"smooth"});
    }
  }
}
$("view").onchange=()=>showView().catch(e=>message(e.message));
$("track").onchange=setTrack;
audio.ontimeupdate=updateTime;
audio.onseeked=updateTime;
$("seek").oninput=()=>{
  const m=timeline?.measures?.[Number($("seek").value)];
  if(m)audio.currentTime=m.start_ms/1000;
};
$("zoom").onchange=()=>{
  $("pages").style.gridTemplateColumns=
    "repeat(auto-fit,minmax(min(100%,"+$("zoom").value+"px),1fr))";
};
boot();
