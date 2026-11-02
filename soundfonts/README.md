# Soundfonts

Put your legally usable SoundFont here (optional):

- `MS_Basic.sf3` — MS Basic, the MuseScore Studio General MIDI SoundFont (MIT; retain required attribution when redistributing).
- `FluidR3_GM.sf2` — FluidR3, a fallback General MIDI SoundFont.

The file is ignored by Git; do not commit large sound libraries into a template.

The CI runner installs Ubuntu's `fluid-soundfont-gm` package and uses its
`/usr/share/sounds/sf2/FluidR3_GM.sf2`. To change the CI bank, explicitly
install a pinned bank with a checksum, ensure its license permits CI usage,
and set `SOUNDFONT` in the workflow.

MuseSounds (MuseSampler libraries) are NOT SoundFonts; they cannot be loaded by
FluidSynth or used as a conventional DAW plugin. MuseScore Studio can render
them from its own notation environment. This project does not claim support
for MuseSounds in headless CI.
