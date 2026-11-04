#!/usr/bin/env python3
"""Run the current project's Pages-equivalent site locally from ScoreKit."""
from __future__ import annotations
import argparse
import functools
import http.server
import shutil
import tempfile
import threading
import webbrowser
from pathlib import Path

from build_site import PROJECT, build_site
from publish_latest import project_repo, publish, validate_published

def local_media(project: Path, site: Path) -> bool:
    """Use existing local build artifacts when available; no GitHub needed."""
    viewer, audio = project / "dist/viewer", project / "dist/audio"
    if not (viewer / "manifest.json").is_file() or not audio.is_dir():
        return False
    target = site / "viewer/latest"
    target.mkdir(parents=True, exist_ok=True)
    shutil.copytree(viewer, target / "viewer", dirs_exist_ok=True)
    shutil.copytree(audio, target / "audio", dirs_exist_ok=True)
    try:
        manifest = validate_published(site, "local")
    except (ValueError, KeyError, FileNotFoundError):
        shutil.rmtree(target)
        return False
    import json
    info = {
        "schema": "scorekit-project-site-v1",
        "repo": "",
        "tag": manifest.get("revision", "local"),
        "release_url": "",
        "title": manifest.get("work_title", "Локальная партитура"),
        "orchestra": manifest.get("orchestra_name", ""),
        "data_base": "./latest/",
        "readme_available": False,
    }
    (site / "viewer/latest.json").write_text(json.dumps(info, ensure_ascii=False), encoding="utf-8")
    return True

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT)
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--no-browser", action="store_true")
    parser.add_argument("--from-release", action="store_true",
                        help="Download the latest published release using GitHub CLI")
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="scorekit-project-site-") as tmp:
        site = build_site(args.project_root, Path(tmp) / "site")
        if args.from_release or not local_media(args.project_root, site):
            if args.from_release:
                publish(site, project_repo())
            else:
                print("No local dist/viewer + dist/audio found. "
                      "Use --from-release for the latest GitHub Release or build audio locally.")
        handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(site))
        with http.server.ThreadingHTTPServer(("127.0.0.1", args.port), handler) as http:
            url = f"http://127.0.0.1:{http.server_port}/viewer/"
            print(f"ScoreKit project viewer: {url}", flush=True)
            if not args.no_browser:
                timer = threading.Timer(0.5, lambda: webbrowser.open(url))
                timer.daemon = True
                timer.start()
            try:
                http.serve_forever()
            except KeyboardInterrupt:
                print("\nStopping project viewer.")

if __name__ == "__main__":
    main()
