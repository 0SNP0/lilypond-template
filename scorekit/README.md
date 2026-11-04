# ScoreKit · LilyPond score-building framework

Work-agnostic orchestral score automation. The parent Git repository is a score edition; this folder contains build/export scripts, CI composite actions, LilyPond engraving templates, viewer code, and shared documentation. It can later become a Git submodule at the same path.

See [Guide](docs/PROJECT_GUIDE.md) for usage. Run `python3 scorekit/scripts/build.py build` from the score repository root (the builder resolves the project from its own location). The parent project must provide `score.ly`, `concert-score.ly`, `orchestra.ily`, `metadata.ily`, `music/` and `parts/`. Optional work-specific validation settings live in `music/playback-map.json`.
