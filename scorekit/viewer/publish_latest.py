#!/usr/bin/env python3
"""Publish only the latest score release as same-origin static Pages files.

The site and its source score are the SAME repository. Release ZIPs remain
archival downloads; the site gets directly addressable SVG and MP3 files.
"""
from __future__ import annotations

import argparse
import base64
import json
import os
import re
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path, PurePosixPath
from urllib.parse import quote

FRAMEWORK = Path(__file__).resolve().parents[1]
PROJECT = FRAMEWORK.parent
REPO_PATTERN = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")

def execute(*args: str, required: bool = True) -> str:
    process = subprocess.run(["gh", *args], capture_output=True, text=True)
    if process.returncode:
        if required:
            raise RuntimeError(f"gh {' '.join(args)}: {process.stderr.strip()[-900:]}")
        return ""
    return process.stdout

def project_repo(explicit: str | None = None) -> str:
    repo = explicit or os.environ.get("GITHUB_REPOSITORY") or os.environ.get("GH_REPO")
    if not repo:
        origin = subprocess.run(
            ["git", "-C", str(PROJECT), "remote", "get-url", "origin"],
            capture_output=True, text=True
        )
        if origin.returncode == 0:
            match = re.search(r"(?:github\.com[/:])([^/:\s]+/[^/\s]+?)(?:\.git)?$", origin.stdout.strip())
            repo = match.group(1) if match else None
    if not repo or not REPO_PATTERN.fullmatch(repo):
        raise ValueError("Provide --repo OWNER/REPOSITORY or GITHUB_REPOSITORY")
    return repo

def latest_release(repo: str) -> dict:
    release = json.loads(execute("api", f"repos/{repo}/releases/latest"))
    if release.get("draft") or release.get("prerelease"):
        raise RuntimeError("Latest release is draft or prerelease")
    return release

def release_asset(release: dict, kind: str) -> dict:
    regex = re.compile(rf"-{kind}-[^/]+\.zip$", re.I)
    assets = [a for a in release["assets"] if regex.search(a["name"])]
    if len(assets) != 1:
        raise RuntimeError(f"Expected one {kind} ZIP in release {release['tag_name']}")
    return assets[0]

def download_asset(repo: str, release: dict, asset: dict, directory: Path) -> Path:
    execute("release", "download", release["tag_name"], "--repo", repo,
            "--pattern", asset["name"], "--dir", str(directory), "--clobber")
    file = directory / asset["name"]
    if not file.is_file() or file.stat().st_size != asset["size"]:
        raise RuntimeError(f"Wrong downloaded size for {asset['name']}")
    return file

def safe_member(name: str, prefix: str) -> PurePosixPath:
    path = PurePosixPath(name)
    if name.startswith("/") or "\\" in name or ".." in path.parts or not path.parts or path.parts[0] != prefix:
        raise ValueError(f"Unexpected archive member: {name}")
    return path

def extract_zip(archive: Path, target: Path, prefix: str,
                allowed_suffixes: set[str], budget: list[int]) -> None:
    with zipfile.ZipFile(archive) as z:
        for item in z.infolist():
            if item.is_dir() or not item.filename.startswith(prefix + "/"):
                continue
            path = safe_member(item.filename, prefix)
            if path.suffix.lower() not in allowed_suffixes:
                continue
            budget[0] -= item.file_size
            if budget[0] < 0:
                raise RuntimeError("Published site would exceed configured Pages size budget")
            dest = target.joinpath(*path.parts)
            dest.parent.mkdir(parents=True, exist_ok=True)
            with z.open(item) as src, dest.open("wb") as dst:
                shutil.copyfileobj(src, dst)

def validate_published(project: Path, expected_tag: str) -> dict:
    root = project / "viewer/latest"
    manifest = json.loads((root / "viewer/manifest.json").read_text(encoding="utf-8"))
    timeline = json.loads((root / "viewer/timeline.json").read_text(encoding="utf-8"))
    if not isinstance(manifest.get("views"), dict) or not manifest["views"]:
        raise ValueError("No score views in the viewer manifest")
    if not isinstance(timeline.get("measures"), list) or not timeline["measures"]:
        raise ValueError("No timeline in the release")
    for name, view in manifest["views"].items():
        for raw in view["pages"]:
            path = safe_member("viewer/" + raw, "viewer")
            if not (root / Path(*path.parts)).is_file():
                raise FileNotFoundError(f"SVG missing for {name}: {raw}")
    for track in manifest["audio_tracks"]:
        path = safe_member(track["path"].removeprefix("../"), "audio")
        if path.suffix.lower() != ".mp3" or not (root / Path(*path.parts)).is_file():
            raise FileNotFoundError(f"MP3 missing for {track['id']}: {track['path']}")
    return manifest

def publish(output: Path, repo: str, max_site_mib: int = 650) -> dict:
    output = output.resolve()
    if not (output / "viewer/index.html").is_file():
        raise FileNotFoundError("Build the website first: scorekit/viewer/build_site.py")
    release = latest_release(repo)
    viewer = release_asset(release, "viewer")
    audio = release_asset(release, "audio")
    latest = output / "viewer/latest"
    if latest.exists():
        shutil.rmtree(latest)
    latest.mkdir(parents=True)
    current = sum(p.stat().st_size for p in output.rglob("*") if p.is_file())
    budget = [max_site_mib * 1024 * 1024 - current]
    with tempfile.TemporaryDirectory(prefix="scorekit-release-") as tmp:
        temp = Path(tmp)
        viewer_zip = download_asset(repo, release, viewer, temp)
        audio_zip = download_asset(repo, release, audio, temp)
        extract_zip(viewer_zip, latest, "viewer", {".svg", ".json"}, budget)
        extract_zip(audio_zip, latest, "audio", {".mp3"}, budget)
    manifest = validate_published(output, release["tag_name"])
    tag = release["tag_name"]
    # Versioned README is displayed alongside the rendered notation.
    readme = execute("api", f"repos/{repo}/contents/README.md?ref={quote(tag, safe='')}",
                     required=False)
    if readme:
        try:
            body = json.loads(readme)
            if body.get("encoding") == "base64":
                (latest / "README.md").write_bytes(base64.b64decode(body["content"]))
        except (ValueError, KeyError):
            print("Release README unavailable; omit it")
    info = {
        "schema": "scorekit-project-site-v1",
        "repo": repo,
        "tag": tag,
        "release_url": release["html_url"],
        "title": manifest.get("work_title") or manifest.get("work_slug") or repo,
        "orchestra": manifest.get("orchestra_name", ""),
        "data_base": "./latest/",
        "readme_available": (latest / "README.md").exists(),
    }
    (output / "viewer/latest.json").write_text(
        json.dumps(info, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"Published only {repo}@{tag}, {len(manifest['views'])} score views, "
          f"{len(manifest['audio_tracks'])} MP3 tracks, "
          f"{(max_site_mib * 1024 * 1024 - budget[0]) / 1048576:.1f} MiB total")
    return info

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=PROJECT / "_site")
    parser.add_argument("--repo", help="owner/repository; defaults to GITHUB_REPOSITORY")
    parser.add_argument("--max-site-mib", type=int, default=650)
    args = parser.parse_args()
    if args.max_site_mib < 1:
        parser.error("--max-site-mib must be positive")
    publish(args.output, project_repo(args.repo), args.max_site_mib)

if __name__ == "__main__":
    main()
