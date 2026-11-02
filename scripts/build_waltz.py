#!/usr/bin/env python3
"""First-pass Waltz PDF, MIDI, and MP3 build (independent of template manifest)."""
import json
import os
import re
import shutil
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
DIST=ROOT/"dist"
PDF=DIST/"pdf"
AUDIO=DIST/"audio"
PACKAGES=DIST/"packages"

def run(args,timeout=900):
    print("+"," ".join(map(str,args)),flush=True)
    subprocess.run([str(a) for a in args],cwd=ROOT,check=True,timeout=timeout)

def main():
    lily=shutil.which("lilypond")
    if not lily: raise RuntimeError("LilyPond executable missing")
    meta=(ROOT/"metadata.ily").read_text(encoding="utf-8")
    match=re.search(r'(?m)^workFileSlug\s*=\s*"([^"]+)"',meta)
    if not match: raise RuntimeError("Missing workFileSlug")
    slug=match.group(1)
    version=subprocess.check_output(["git","describe","--tags","--always","--long","--abbrev=8",
                                      "--match","v[0-9]*"],cwd=ROOT,text=True).strip()
    for folder in (PDF,AUDIO,PACKAGES):
        shutil.rmtree(folder,ignore_errors=True)
        folder.mkdir(parents=True)
    parts=sorted((ROOT/"parts").glob("*.ly"))
    if len(parts)!=21: raise RuntimeError(f"Expected 21 imported parts; got {len(parts)}")
    targets=[("score",ROOT/"score.ly"),("concert-score",ROOT/"concert-score.ly")]
    targets += [(p.stem,p) for p in parts]
    results=[]
    for name,source in targets:
        output=PDF/(f"{slug}-{name}-{version}")
        try:
            run([lily,"-dno-point-and-click","-o",output,source])
            path=Path(str(output)+".pdf")
            if not path.is_file() or path.stat().st_size<100: raise RuntimeError("PDF missing")
            results.append({"source":source.name,"pdf":path.name,"status":"ok"})
        except (RuntimeError,subprocess.CalledProcessError,subprocess.TimeoutExpired) as e:
            results.append({"source":source.name,"pdf":output.name+".pdf",
                            "status":"failed","error":str(e)})
            print("FAILED",source,e,flush=True)
    midi=PDF/(f"{slug}-score-{version}.midi")
    audio_status="unavailable"
    if midi.is_file():
        target=AUDIO/(f"{slug}-orchestra-{version}.midi")
        midi.rename(target)
        soundfont=Path(os.environ.get("SOUNDFONT","/usr/share/sounds/sf2/FluidR3_GM.sf2"))
        if shutil.which("fluidsynth") and shutil.which("ffmpeg") and soundfont.is_file():
            wav=AUDIO/"preview.wav"
            try:
                run(["fluidsynth","-ni","-g","0.3","-r","48000","-F",wav,soundfont,target],timeout=1200)
                run(["ffmpeg","-hide_banner","-loglevel","error","-y","-i",wav,
                     "-af","loudnorm=I=-16:TP=-1.5:LRA=11","-c:a","libmp3lame","-q:a","2",
                     AUDIO/(f"{slug}-orchestra-{version}.mp3")],timeout=1200)
                audio_status="ok"
            except (subprocess.CalledProcessError,subprocess.TimeoutExpired) as e:
                audio_status=str(e)
            finally: wav.unlink(missing_ok=True)
    with zipfile.ZipFile(PACKAGES/(f"{slug}-pdf-{version}.zip"),"w",zipfile.ZIP_DEFLATED) as z:
        for path in sorted(PDF.glob("*.pdf")):
            group="scores" if path.stem.startswith((f"{slug}-score-",f"{slug}-concert-score-")) else "parts"
            z.write(path,f"{group}/{path.name}")
    if list(AUDIO.glob("*.*")):
        with zipfile.ZipFile(PACKAGES/(f"{slug}-audio-{version}.zip"),"w",zipfile.ZIP_DEFLATED) as z:
            for path in sorted(AUDIO.glob("*.*")): z.write(path,f"audio/{path.name}")
    report={"edition":"first-pass / not proofread", "revision":version,
            "pdf_success":sum(x["status"]=="ok" for x in results),
            "pdf_expected":len(targets),"audio_status":audio_status,"files":results}
    (DIST/"build-report.json").write_text(json.dumps(report,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print(f"PDFs: {report['pdf_success']}/{report['pdf_expected']}; audio: {audio_status}",flush=True)
    if report["pdf_success"]!=report["pdf_expected"]: raise RuntimeError("PDF build incomplete; inspect build-report.json")

if __name__=="__main__":
    try: main()
    except (RuntimeError,subprocess.CalledProcessError,subprocess.TimeoutExpired) as e:
        sys.exit(f"ERROR: {e}")
