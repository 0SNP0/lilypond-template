#!/usr/bin/env python3
"""Build the current score project's own website using the ScoreKit engine."""
from __future__ import annotations
import argparse
import json
import shutil
from urllib.parse import urlsplit
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
PROJECT = FRAMEWORK.parent
PORTAL = FRAMEWORK / "viewer/portal"

def build_site(project: Path, output: Path) -> Path:
    project, output = project.resolve(), output.resolve()
    if output in (project, FRAMEWORK, PORTAL) or not (PORTAL / "index.html").is_file():
        raise ValueError("Unsafe site destination or missing ScoreKit viewer")
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    pages = project / "site"
    if pages.is_dir():
        shutil.copytree(pages, output, dirs_exist_ok=True)
    shutil.copytree(PORTAL, output / "viewer", dirs_exist_ok=True)
    # ScoreKit's default catalog URL may be overridden by this score's site.
    # Leave unset for now: the navigation control is displayed but disabled.
    default_catalog = FRAMEWORK / "config" / "catalog-url.txt"
    project_catalog = pages / "catalog-url.txt"
    selection = project_catalog if project_catalog.is_file() else default_catalog
    catalog_url = ""
    if selection.is_file():
        catalog_url = next((line.strip() for line in selection.read_text(
            encoding="utf-8").splitlines() if line.strip() and
            not line.lstrip().startswith("#")), "")
    if catalog_url:
        parsed = urlsplit(catalog_url)
        if parsed.scheme not in ("https", "http") or not parsed.netloc or (
                parsed.username or parsed.password):
            raise ValueError("Catalog URL must be an absolute HTTP(S) URL")
    (output / "viewer" / "config.json").write_text(
        json.dumps({"catalog_url": catalog_url}, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    (output / ".nojekyll").touch()
    if not (output / "index.html").exists():
        # The viewer is the default landing page for every score project.
        # Projects can still provide their own site/index.html override.
        (output / "index.html").write_text(
            '<!doctype html><html lang="ru"><meta charset="utf-8">'
            '<meta http-equiv="refresh" content="0;url=./viewer/">'
            '<title>ScoreKit Viewer</title>'
            '<script>location.replace("./viewer/" + location.search + location.hash)</script>'
            '<a href="./viewer/">Просмотрщик партитуры</a></html>\n',
            encoding="utf-8",
        )
    print(f"Project website: {output} · Viewer: {output / 'viewer'}")
    return output

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", type=Path, default=PROJECT)
    parser.add_argument("--output", type=Path, default=PROJECT / "_site")
    args = parser.parse_args()
    build_site(args.project_root, args.output)

if __name__ == "__main__":
    main()
