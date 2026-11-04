"use strict";
const $ = id => document.getElementById(id);
let repo="", releases=[], selectedRelease=null, viewerZip=null, audioZip=null;
let manifest=null, timeline=null, viewerRoot="", token=0, currentAudio=null, lastScrolledPage="";
let mirrorsPromise=null;
const pageUrls=[], audioUrls=new Map();
const status = s => $("status").textContent=s;

function validateRepo(text){
  let v=text.trim().replace(/\/$/,"").replace(/\.git$/i,"");
  v=v.replace(/^https:\/\/github\.com\//i,"");
  if(!/^[\w.-]+\/[\w.-]+$/.test(v))throw Error("Используйте owner/repository или адрес github.com/owner/repository");
  return v;
}
function options(select,rows){
  select.replaceChildren();
  for(const [value,label] of rows){const el=document.createElement("option");el.value=value;el.textContent=label;select.append(el)}
}
function resetMedia(){
  token++;$("audio").pause();$("audio").removeAttribute("src");$("audio").load();
  for(const u of pageUrls)URL.revokeObjectURL(u);pageUrls.length=0;
  for(const u of audioUrls.values())URL.revokeObjectURL(u);audioUrls.clear();
  $("pages").replaceChildren();$("view").disabled=$("track").disabled=true;
  $("seek").disabled=true;lastScrolledPage="";
  viewerZip=null;audioZip=null;manifest=null;timeline=null;viewerRoot="";currentAudio=null;
}
function zipEntry(zip,path){
  const normalized=path.replace(/^\/+/,"").replace(/\\/g,"/");
  if(zip.file(normalized))return zip.file(normalized);
  const found=Object.keys(zip.files).find(p=>p.endsWith("/"+normalized) && !zip.files[p].dir);
  return found?zip.file(found):null;
}
async function getZip(source){
  if(typeof JSZip==="undefined")throw Error("JSZip не загрузился. Для локального просмотра необходимо подключение к CDN.");
  if(source instanceof File)return JSZip.loadAsync(source);
  const url=source.local_url||source.browser_download_url;
  const response=await fetch(url);
  if(!response.ok)throw Error("Не удалось скачать "+(source.name||url)+" (HTTP "+response.status+")");
  return JSZip.loadAsync(await response.arrayBuffer());
}
async function mirrorIndex(){
  if(!mirrorsPromise){
    mirrorsPromise=fetch("./mirrors.json",{cache:"no-store"})
      .then(r=>r.ok?r.json():{repositories:{}})
      .catch(()=>({repositories:{}}));
  }
  return mirrorsPromise;
}
async function mirroredRelease(){
  const data=await mirrorIndex();
  const entries=Object.entries(data.repositories||{});
  const matching=entries.find(([name])=>name.toLowerCase()===repo.toLowerCase());
  return matching?.[1]?.[selectedRelease?.tag_name]||null;
}
function matchingAsset(kind){
  return selectedRelease?.assets?.find(a=>new RegExp("-"+kind+"-[^/]*\\.zip$","i").test(a.name));
}
function link(text,url){
  const a=document.createElement("a");a.href=url;a.target="_blank";a.rel="noopener";a.textContent=text;
  $("downloads").append(a,document.createTextNode("  "));
}
function persist(){
  const url=new URL(location.href);
  if(repo)url.searchParams.set("repo",repo);
  if(selectedRelease)url.searchParams.set("tag",selectedRelease.tag_name);
  if(manifest)url.searchParams.set("view",$("view").value);
  history.replaceState(null,"",url);
}
async function listReleases(value){
  try{
    resetMedia();repo=validateRepo(value);$("repo").value=repo;
    status("Читаю опубликованные версии "+repo+"…");
    const response=await fetch("https://api.github.com/repos/"+repo+"/releases?per_page=100");
    if(!response.ok)throw Error("GitHub API: HTTP "+response.status+" (приватный репозиторий без авторизации или ограничение запросов)");
    releases=(await response.json()).filter(r=>!r.draft);
    options($("release"),releases.map((r,i)=>[String(i),r.tag_name+(r.prerelease?" (preview)":"")]));
    $("release").disabled=!releases.length;
    if(!releases.length){status("В репозитории нет опубликованных GitHub Releases");return}
    const requested=new URLSearchParams(location.search).get("tag");
    const index=releases.findIndex(r=>r.tag_name===requested);
    $("release").value=String(index<0?0:index);
    await chooseRelease();
  }catch(e){status("Ошибка: "+e.message)}
}
async function chooseRelease(){
  resetMedia();selectedRelease=releases[Number($("release").value)];
  if(!selectedRelease)return;
  $("downloads").replaceChildren();
  link("Релиз GitHub",selectedRelease.html_url);
  for(const kind of ["viewer","audio"]){
    const asset=matchingAsset(kind);
    if(asset)link("Скачать "+asset.name,asset.browser_download_url);
  }
  persist();
  loadReadme();
  const asset=matchingAsset("viewer");
  if(!asset){status("В релизе нет архива SVG/JSON просмотрщика");return}
  const mirror=await mirroredRelease();
  const source=mirror?.viewer?{name:asset.name,local_url:mirror.viewer}:asset;
  status("Получаю SVG/JSON: "+asset.name+" ("+(asset.size/1048576).toFixed(1)+" МиБ)…");
  try{
    await openViewerZip(await getZip(source));
  }catch(e){
    status("Не удалось открыть архив браузером: "+e.message+
      (mirror?" (проверьте сборку Pages и зеркальные файлы).":
       ". Для этой версии ещё нет копии на сайте. Скачайте ZIP из Releases и выберите локально."));
  }
}
async function loadReadme(){
  try{
    const url="https://raw.githubusercontent.com/"+repo+"/"+encodeURIComponent(selectedRelease.tag_name)+"/README.md";
    const response=await fetch(url);
    $("readme").textContent=response.ok?await response.text():"README выбранной версии отсутствует";
  }catch(e){$("readme").textContent="README недоступен: "+e.message}
}
async function openViewerZip(zip){
  resetMedia();
  viewerZip=zip;
  const file=zipEntry(zip,"viewer/manifest.json");
  if(!file)throw Error("В ZIP нет viewer/manifest.json");
  viewerRoot=file.name.slice(0,-"manifest.json".length);
  manifest=JSON.parse(await file.async("string"));
  const timing=zipEntry(zip,"viewer/timeline.json");
  if(!timing)throw Error("В ZIP нет viewer/timeline.json");
  timeline=JSON.parse(await timing.async("string"));
  if(!manifest.views||!Array.isArray(timeline.measures))throw Error("Неподдерживаемый формат ScoreKit");
  const rows=Object.entries(manifest.views).map(([id,v])=>[
    id,(v.kind==="score"?"Партитура":v.kind==="concert-score"?"Концертный строй":
       v.kind==="combined"?"Объединённая":"Партия")+" · "+id
  ]);
  options($("view"),rows);
  const params=new URLSearchParams(location.search);
  if(manifest.views[params.get("view")])$("view").value=params.get("view");
  options($("track"),[["","Выберите аудиодорожку"],...(manifest.audio_tracks||[]).map(t=>[t.id,t.label])]);
  $("view").disabled=false;$("track").disabled=false;
  $("seek").max=String(timeline.measures.length-1);$("seek").value="0";$("seek").disabled=false;
  $("heading").textContent=[manifest.work_title,manifest.orchestra_name,manifest.revision].filter(Boolean).join(" · ");
  status("Загружены ноты: "+rows.length+" представлений. Выберите дорожку, чтобы скачать звук.");
  await showView();
}
async function showView(){
  if(!manifest)return;
  const n=++token, view=manifest.views[$("view").value];
  if(!view)return;
  persist();$("pages").replaceChildren();
  for(const url of pageUrls)URL.revokeObjectURL(url);pageUrls.length=0;
  $("pagehint").textContent=view.pages.length+" стр. · "+view.anchors_found+" найденных меток тактов";
  for(let i=0;i<view.pages.length;i++){
    if(token!==n)return;
    const path=viewerRoot+view.pages[i].replace(/^\/+/,"");
    const entry=viewerZip.file(path)||zipEntry(viewerZip,path);
    if(!entry)throw Error("В архиве отсутствует "+path);
    const blob=new Blob([await entry.async("uint8array")],{type:"image/svg+xml"});
    const src=URL.createObjectURL(blob);pageUrls.push(src);
    const wrapper=document.createElement("div");wrapper.className="sheet";wrapper.dataset.page=String(i+1);
    const image=document.createElement("img");image.src=src;image.alt="Страница "+(i+1);
    image.loading=i===0?"eager":"lazy";wrapper.append(image);
    const a=document.createElement("a");a.textContent="SVG · страница "+(i+1);a.href=src;
    a.download=$("view").value+"-page-"+String(i+1).padStart(3,"0")+".svg";
    wrapper.append(a);$("pages").append(wrapper);
  }
  updateClock();
}
async function chooseTrack(){
  const track=(manifest?.audio_tracks||[]).find(t=>t.id===$("track").value);
  if(!track)return;
  const requested=track.id,n=token;
  try{
    const target=track.path.replace(/^(\.\.\/)+/,"");
    const mirror=selectedRelease?await mirroredRelease():null;
    const localAudio=$("audio-file").files[0];
    let chosenSource=null;
    if(!localAudio && mirror?.audio_base){
      chosenSource=new URL(mirror.audio_base+target,location.href).href;
      // Individual MP3s are served by Pages and streamed directly by the
      // media element; no full audio ZIP or blob download is required.
    }else{
      if(!audioZip){
        const asset=matchingAsset("audio");
        if(!localAudio&&!asset)throw Error("Для локального комплекта укажите аудио ZIP");
        status("Загружаю MP3 ZIP, первый раз для этой версии…");
        audioZip=await getZip(localAudio||asset);
      }
      const entry=zipEntry(audioZip,target);
      if(!entry)throw Error("В аудиоархиве нет "+target);
      if(!audioUrls.has(target)){
        const blob=new Blob([await entry.async("uint8array")],{type:"audio/mpeg"});
        audioUrls.set(target,URL.createObjectURL(blob));
      }
      chosenSource=audioUrls.get(target);
    }
    if(n!==token||requested!==$("track").value)return;
    const player=$("audio"),time=player.currentTime,wasPlaying=!player.paused;
    player.src=chosenSource;player.load();
    player.addEventListener("loadedmetadata",()=>{
      player.currentTime=Math.min(time,Number.isFinite(player.duration)?player.duration:time);
      if(wasPlaying)player.play().catch(()=>{});
    },{once:true});
    status("Дорожка готова: "+track.label+
      (mirror?.audio_base&&!localAudio?". MP3 передаётся напрямую с сайта.":". ZIP аудио остаётся в памяти."));
  }catch(e){status("Ошибка звука: "+e.message)}
}
function updateClock(){
  if(!timeline||!timeline.measures.length)return;
  const ms=$("audio").currentTime*1000,measures=timeline.measures;
  let low=0,high=measures.length;
  while(low<high){const mid=(low+high)>>1;if(measures[mid].start_ms<=ms)low=mid+1;else high=mid}
  const bar=measures[Math.max(0,low-1)];
  $("seek").value=String(Math.max(0,low-1));
  const currentView=manifest.views[$("view").value];
  const matching=currentView?.measure_anchors?.find(a=>a.measure_id===bar.printed_measure_id);
  if(matching && !$("audio").paused){
    const page=$('pages').querySelector('.sheet[data-page="'+matching.page+'"]');
    if(page && !page.matches(":hover") && page.dataset.page!==lastScrolledPage){
      lastScrolledPage=page.dataset.page;
      page.scrollIntoView({behavior:"smooth",block:"nearest"});
    }
  }
  $("position").textContent="Такт "+bar.printed_number+" / "+timeline.printed_measures+
    (bar.number>timeline.printed_measures?" · реприза":"");
}
function zoom(){
  $("pages").style.gridTemplateColumns=
    "repeat(auto-fit,minmax(min(100%,"+$("zoom").value+"px),1fr))";
}
$("find").onclick=()=>listReleases($("repo").value);
$("repo").onkeydown=e=>{if(e.key==="Enter")listReleases($("repo").value)};
$("release").onchange=chooseRelease;
$("viewer-file").onchange=async()=>{
  if(!$("viewer-file").files.length)return;
  try{
    selectedRelease=null;repo="";$("downloads").replaceChildren();
    await openViewerZip(await getZip($("viewer-file").files[0]));
  }catch(e){status("Ошибка ZIP: "+e.message)}
};
$("audio-file").onchange=()=>{audioZip=null};
$("view").onchange=()=>showView().catch(e=>status("Ошибка SVG: "+e.message));
$("track").onchange=chooseTrack;$("audio").ontimeupdate=updateClock;
$("zoom").onchange=zoom;zoom();
$("seek").oninput=()=>{
  const position=timeline?.measures?.[Number($("seek").value)];
  if(position)$("audio").currentTime=position.start_ms/1000;
};
fetch("./catalog.json").then(r=>r.ok?r.json():[]).then(data=>{
  if(!Array.isArray(data))return;
  $("catalog").textContent=data.length?"":"Каталог пока пуст";
  for(const item of data){
    const url=typeof item==="string"?item:item.url;
    const button=document.createElement("button");button.textContent=typeof item==="string"?url:item.label||url;
    button.onclick=()=>listReleases(url);$("catalog").append(button);
  }
}).catch(()=>{$("catalog").textContent="Каталог пока не задан"});
const requested=new URLSearchParams(location.search).get("repo");
if(requested)listReleases(requested);
