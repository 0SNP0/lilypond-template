# Ensemble Assemble — LilyPond orchestra template

A source-controlled orchestral arranging project: **LilyPond + Python build tool + GitHub Actions**. Native Windows builds work without WSL or Docker. CI runs on Linux.

## Output

Every successful build produces **23 A4 PDFs**:
- `dist/pdf/full-score.pdf` — transposed conductor score;
- `dist/pdf/concert-score.pdf` — concert-pitch score;
- `dist/pdf/01-flute-1.pdf` through `dist/pdf/21-double-bass.pdf` — one print-ready PDF per player/desk.

The example score is eight bars of original demonstration music, with all the requested instruments:
two flutes, oboe, two B-flat clarinets, B-flat bass clarinet, B-flat soprano saxophone, E-flat alto saxophone, B-flat tenor saxophone, two B-flat trumpets, two trombones, drum kit, piano, accordion, first and second violins, viola, cello, and double bass. Piano and accordion use grand staves. All instrument labels are in English.

All note data in `music/*.ily` is **concert pitch**. The printed parts are transposed automatically by `scripts/build.py`; MIDI uses concert pitch.

## Getting started on Windows

Install Python 3, Git for Windows, and a native Windows edition of LilyPond. Put `lilypond.exe` and `git.exe` on your PATH.

Open PowerShell in this repository:

```powershell
py -3 -m unittest discover -s tests -v
py -3 scripts/build.py build
py -3 scripts/build.py verify
```

Or double-click / run `build.cmd` for PDF + MIDI generation.

Optional PDF geometry and page-count inspection:

```powershell
py -3 -m pip install pypdf
py -3 scripts/build.py pages
```

For audio, additionally install FluidSynth and FFmpeg and obtain a licensed GM SoundFont. Place `MS_Basic.sf3` in `soundfonts/` or pass its full path:

```powershell
.\build-audio.cmd --soundfont "C:\SoundFonts\MS_Basic.sf3"
py -3 scripts/build.py package
```

## Linux CI / release workflow

Every push and pull request runs tests, compiles all PDFs, MIDI, FLAC and MP3, and uploads downloadable build artifacts retained for 14 days.

On a version tag matching `v*` (for example `v0.1.0`), a GitHub Release receives:
- all **23 individual PDF** files;
- `scores-pdf.zip` containing the score and all instrument parts;
- `audio.zip` containing orchestra MIDI, FLAC and MP3.

The archives also include `build-info.json` with version provenance. Generated `build/` and `dist/` are ignored by Git.

To release a tagged edition:

```bash
git tag -a v0.1.0 -m "First orchestral demo"
git push origin v0.1.0
```

Release creation runs automatically only **after a successful build**. Do not tag until the current CI run is green.

## Project layout

```text
music/                     Concert-pitch instrument source files
project.json                Credits, instrument manifest and page-layout overrides
layout/style.ily            Shared headers, footers and title
scripts/build.py            Cross-platform build / verification / packaging
tests/                      Unit tests
docs/IMPORT_FROM_MUSESCORE.md
soundfonts/                 Optional local soundfont (binary ignored)
.github/workflows/build.yml CI and tagged Releases
build/                      Generated source and Git metadata (ignored)
dist/pdf/                   PDF score and 21 parts (ignored)
dist/audio/                 MIDI, FLAC, MP3 (ignored)
dist/packages/              Release ZIPs (ignored)
```

All music is stored once in `music/` and reused in the score, parts and MIDI edition. Importing a MuseScore score is a **one-off MusicXML conversion**, not a round-trip editing loop; see the import guide.

## Layout policy and per-part pagination

Every edition uses **A4 portrait**, 15 mm margins. Instrument parts start at a 1.750 mm staff space. The full score uses 1.500 mm to fit the 23 staves onto A4 (review readability carefully). Staff space must remain between 1.500 and 1.750 mm.

Header: English part name at left, composition title centered, page number at right. Footer: `Ensemble_Assemble_V...` identifying the Git revision, plus copyright/attribution on page one. The first music page has a centered title/subtitle, composer/transcriber/arranger at right, lyricist/translator at left.

Vertical layout on the last page is justified by default (`ragged_last_bottom: false`), but individual part spacing may be changed. Use `project.json` → `layout` → `part_overrides` to tune each part independently:

```json
"part_overrides": {
  "04-clarinet-1": {
    "target_pages": 2,
    "systems_per_page": 5,
    "staff_space_mm": 1.75,
    "ragged_last_bottom": false
  }
}
```

This example is **illustrative**: do not add another `layout` object; edit the existing one. The included eight-bar sample has no page targets.

Supported per-edition options:
- `target_pages`: request a page count; verification **fails** if actual PDF count differs;
- `systems_per_page`: request a number of systems on each page;
- `system_count`: request total systems;
- `staff_space_mm`: 1.5–1.75;
- `ragged_bottom` and `ragged_last_bottom`: distribution of vertical whitespace;
- `page_spacing_weight`: tune automatic page breaking.

A page target cannot guarantee good engraving, and cannot justify illegible notes or impossible page turns. Review the PDF manually after changing overrides.

`layout.score_overrides` similarly supports `full-score` and `concert-score` editions separately. A3 is **not allowed** anywhere.

## Version in page footers

The build tool derives the printed version with `git describe --tags --always --abbrev=8` and checks all staged, unstaged and untracked source changes:

| Git state | Example |
| --- | --- |
| Exact annotated or lightweight tag | `Ensemble_Assemble_V1.2.0` |
| Three commits after tag | `Ensemble_Assemble_V1.2.0-3-g12345678` |
| Uncommitted local changes | `Ensemble_Assemble_V1.2.0-3-g12345678-dirty` |
| Never tagged | `Ensemble_Assemble_Vabc12345` |
| Uninitialized source ZIP | `Ensemble_Assemble_Vunversioned` |

CI checks that release tags point at HEAD and refuses dirty release builds.

## Audio rendering

LilyPond produces MIDI, which is rendered using FluidSynth + a General MIDI SoundFont at 48 kHz. The pipeline exports **FLAC** and high-quality **MP3**, plus the original MIDI.

On Linux CI the SoundFont is `FluidR3_GM.sf2` installed through Ubuntu's `fluid-soundfont-gm` package. For local Windows audio, `MS_Basic.sf3` from MuseScore Studio is a possible alternative if the FluidSynth build supports SF3. No SoundFont binaries are committed; check licenses and attribution for any distribution.

**MuseSounds / MuseSampler are not a SoundFont**, and are not used by this FluidSynth workflow. For the most realistic orchestral audio, consider an additional DAW/MuseScore Studio mastering stage with articulation-aware sound libraries and manual mixing; this CI render is intended mainly for rehearsal.

Standard MIDI has 15 melodic channels plus one percussion channel. This project uses LilyPond's `midiChannelMapping = #'instrument` so duplicated timbres share channels. When the orchestration uses more than 15 distinct melodic patches, generate separate stems and mix them instead.

## Attribution and licensing

The template and example sketch are MIT-licensed; this does not extend rights to arrangements of other works. Fill in `project.json` title, subtitle, composer, author, translator, transcriber, arranger and complete copyright/source/proofreader attribution before distributing real music.

## CI portability

The GitHub-specific file is only the runner/release adapter. Move to GitLab or Forgejo by invoking the same commands in their CI:

```bash
python3 -m unittest discover -s tests -v
python3 scripts/build.py build --audio
python3 scripts/build.py package
```
