# ScoreKit · LilyPond score-building framework

Work-agnostic orchestral score automation. The parent Git repository is a score edition; this folder contains build/export scripts, CI composite actions, LilyPond engraving templates, viewer code, and shared documentation. It can later become a Git submodule at the same path.

See [Guide](docs/PROJECT_GUIDE.md) for usage. Run `python3 scorekit/scripts/build.py build` from the score repository root (the builder resolves the project from its own location). The parent project must provide `score.ly`, `concert-score.ly`, `orchestra.ily`, `metadata.ily`, `music/` and `parts/`. Optional work-specific validation settings live in `music/playback-map.json`.

## Pinned LilyPond version

LilyPond is **not** upgraded automatically. The single source of truth is
[`config/lilypond-version.txt`](config/lilypond-version.txt), currently `2.26.0`.
Both PDF and media CI jobs install that exact version using
[`actions/install-lilypond/action.yml`](actions/install-lilypond/action.yml).
To upgrade LilyPond, change only the version string in this file, then
check the PDF and full media jobs. An invalid version or unexpected binary
version fails the build rather than silently changing engravings.
