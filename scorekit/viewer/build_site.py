#!/usr/bin/env python3
"""Build a static website from its own pages/catalog and the ScoreKit viewer."""
from __future__ import annotations
import argparse
import json
import shutil
from pathlib import Path

FRAMEWORK = Path(__file__).resolve().parents[1]
PROJECT = FRAMEWORK.parent
PORTAL = FRAMEWORK / "viewer/portal"

def build_site(project: Path, output: Path) -> Path:
    project, output = project.resolve(), output.resolve()
    if output in (project, FRAMEWORK, PORTAL) or project in output.parents and output == project:
        raise ValueError("Unsafe output directory")
    catalog_file = project / "catalog.json"
    catalog = json.loads(catalog_file.read_text(encoding="utf-8")) if catalog_file.is_file() else []
    if not isinstance(catalog, list) or not all(
        isinstance(x, str) or isinstance(x, dict) and isinstance(x.get("url"), str)
        for x in catalog
    ):
        raise ValueError("catalog.json must be a list of URLs or {url,label} objects")
    if output.exists():
        shutil.rmtree(output)
    output.mkdir(parents=True)
    pages = project / "site"
    if pages.is_dir():
        shutil.copytree(pages, output, dirs_exist_ok=True)
    shutil.copytree(PORTAL, output / "viewer", dirs_exist_ok=True)
    (output / "viewer/catalog.json").write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    (output / ".nojekyll").touch()
    if not (output / "index.html").exists():
        (output / "index.html").write_text(
            '<!doctype html><html lang="ru"><meta charset="utf-8">'
            '<title>ScoreKit</title><a href="./viewer/">Просмотрщик партитур</a></html>\n',
            encoding="utf-8",
        )
    print(f"Site: {output}; viewer: {output / 'viewer'}; catalog: {len(catalog)} links")
    return output

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-root", type=Path, default=PROJECT)
    parser.add_argument("--output", type=Path, default=PROJECT / "_site")
    args = parser.parse_args()
    build_site(args.project_root, args.output)

if __name__ == "__main__":
    main()
