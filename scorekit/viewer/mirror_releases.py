#!/usr/bin/env python3
"""Mirror public release viewer ZIPs and unpack MP3s for same-origin Pages.

GitHub Releases remain the canonical download location. Pages publishes a
bounded read-only cache for selected catalog repos/versions so browsers do not
need CORS access to github.com release asset redirects.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path
from urllib.request import Request, urlopen

FRAMEWORK = Path(__file__).resolve().parents[1]
PROJECT = FRAMEWORK.parent
REPO_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
TAG_RE = re.compile(r"^[A-Za-z0-9_.-]+$")


def repo_name(item: object) -> str:
    raw = item if isinstance(item, str) else item.get("url") if isinstance(item, dict) else None
    if not isinstance(raw, str):
        raise ValueError("Invalid catalog entry")
    value = re.sub(r"\.git/?$", "", raw.strip().rstrip("/"))
    value = re.sub(r"^https://github\.com/", "", value, flags=re.I)
    if not REPO_RE.fullmatch(value):
        raise ValueError(f"Invalid GitHub repository in catalog: {raw}")
    return value


def releases(repo: str, limit: int) -> list[dict]:
    url = f"https://api.github.com/repos/{repo}/releases?per_page={max(limit * 3, 10)}"
    headers = {"Accept": "application/vnd.github+json",
               "User-Agent": "ScoreKit-Pages-mirror"}
    token = os.environ.get("GH_TOKEN") or os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    with urlopen(Request(url, headers=headers), timeout=45) as response:
        data = json.load(response)
    return [r for r in data if not r.get("draft")][:limit]


def asset_of(release: dict, kind: str) -> dict | None:
    pattern = re.compile(rf"-{kind}-[^/]+\.zip$", re.I)
    return next((a for a in release.get("assets", []) if pattern.search(a["name"])), None)


def get_release_file(repo: str, tag: str, asset: dict, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["gh", "release", "download", tag, "--repo", repo,
         "--pattern", asset["name"], "--dir", str(destination), "--clobber"],
        check=True,
    )
    result = destination / asset["name"]
    if not result.is_file() or result.stat().st_size != asset["size"]:
        raise RuntimeError(f"Asset download incomplete: {repo} {tag} {asset['name']}")


def mirror(output: Path, max_releases: int, max_site_mib: int) -> dict:
    catalog_path = PROJECT / "catalog.json"
    catalog = json.loads(catalog_path.read_text(encoding="utf-8")) if catalog_path.exists() else []
    if not isinstance(catalog, list):
        raise ValueError("catalog.json must be a list")
    output = output.resolve()
    if not (output / "viewer/index.html").is_file():
        raise FileNotFoundError("Build website first: scorekit/viewer/build_site.py")
    root = output / "assets"
    index = {"schema": 1, "repositories": {}}
    cap = max_site_mib * 1024 * 1024
    total = sum(p.stat().st_size for p in output.rglob("*") if p.is_file())
    for item in catalog:
        repo = repo_name(item)
        found: dict[str, dict] = {}
        for release in releases(repo, max_releases):
            tag = release["tag_name"]
            if not TAG_RE.fullmatch(tag):
                print(f"Skipping tag with unsafe path characters: {repo} {tag}")
                continue
            viewer = asset_of(release, "viewer")
            audio = asset_of(release, "audio")
            if viewer is None:
                print(f"Skipping {repo} {tag}: no viewer ZIP")
                continue
            tag_dir = root / repo / tag
            with tempfile.TemporaryDirectory(prefix="scorekit-assets-") as tmp:
                temp = Path(tmp)
                get_release_file(repo, tag, viewer, temp)
                viewer_file = temp / viewer["name"]
                # Build a complete version atomically before adding to index.
                proposed = total + viewer_file.stat().st_size + (audio["size"] if audio else 0)
                if proposed > cap:
                    print(f"Skipping {repo} {tag}: Pages mirror budget exceeded")
                    continue
                tag_dir.mkdir(parents=True, exist_ok=True)
                mirror_zip = tag_dir / viewer["name"]
                shutil.copy2(viewer_file, mirror_zip)
                current = {"viewer": f"../assets/{repo}/{tag}/{viewer['name']}"}
                total += viewer_file.stat().st_size
                if audio is not None:
                    get_release_file(repo, tag, audio, temp)
                    with zipfile.ZipFile(temp / audio["name"]) as z:
                        for info in z.infolist():
                            if info.is_dir() or not info.filename.startswith("audio/"):
                                continue
                            relative = Path(info.filename)
                            if relative.is_absolute() or ".." in relative.parts or relative.suffix.lower() != ".mp3":
                                raise ValueError(f"Unsafe or unexpected audio asset: {info.filename}")
                            path = tag_dir / relative
                            path.parent.mkdir(parents=True, exist_ok=True)
                            with z.open(info) as source, path.open("wb") as target:
                                shutil.copyfileobj(source, target)
                            total += path.stat().st_size
                    current["audio_base"] = f"../assets/{repo}/{tag}/"
                found[tag] = current
                print(f"Mirrored {repo}@{tag}: viewer ZIP + {('MP3 files' if audio else 'no audio')}")
        if found:
            index["repositories"][repo] = found
    if total > cap:
        raise RuntimeError(f"Pages mirror exceeds {max_site_mib} MiB")
    path = output / "viewer/mirrors.json"
    path.write_text(json.dumps(index, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Same-origin mirror: {len(index['repositories'])} repositories, {total / 1048576:.1f} MiB")
    return index


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--output", type=Path, default=PROJECT / "_site")
    p.add_argument("--max-releases", type=int, default=2)
    p.add_argument("--max-site-mib", type=int, default=650)
    args = p.parse_args()
    if args.max_releases < 1 or args.max_site_mib < 1:
        p.error("limits must be positive")
    mirror(args.output, args.max_releases, args.max_site_mib)


if __name__ == "__main__":
    main()
