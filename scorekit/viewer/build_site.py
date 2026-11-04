#!/usr/bin/env python3
"""Build the current score project's own website using the ScoreKit engine."""
from __future__ import annotations
import argparse
import shutil
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
    (output / ".nojekyll").touch()
    if not (output / "index.html").exists():
        (output / "index.html").write_text(
            '<!doctype html><html lang="ru"><meta charset="utf-8">'
            '<title>ScoreKit</title><a href="./viewer/">Просмотрщик партитуры</a></html>\n',
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
