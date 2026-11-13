"""Regression tests for the native LilyPond flute desk mode map."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
MUSIC = ROOT / "music"


def source_bars(path, section):
    text = path.read_text(encoding="utf-8")
    match = re.search(rf"(?ms)^flute(?:One|Two){section} = \\{{(.*?)^\\}}", text)
    if match is None:
        raise AssertionError(f"Missing flute {section}: {path}")
    bars = []
    for line in match.group(1).splitlines():
        line = line.strip()
        if not line.endswith("|"):
            continue
        repeat = re.fullmatch(r"R2\.\*(\d+)\s*\|", line)
        if repeat:
            bars.extend(["R2."] * int(repeat.group(1)))
        else:
            bars.append(line[:-1].strip())
    return bars


class FluteCombinedModes(unittest.TestCase):
    def test_a2_music_is_identical(self):
        upper = source_bars(MUSIC / "flute-1.ily", "Opening")
        lower = source_bars(MUSIC / "flute-2.ily", "Opening")
        self.assertEqual(len(upper), 116)
        self.assertEqual(len(lower), 116)
        for measure in range(111, 115):
            self.assertEqual(upper[measure - 1], lower[measure - 1],
                             f"a2 is not identical in bar {measure}")

    def test_solo_i_and_ii_are_really_silent_in_other_part(self):
        upper = source_bars(MUSIC / "flute-1.ily", "Opening")
        lower = source_bars(MUSIC / "flute-2.ily", "Opening")
        self.assertEqual(lower[15], "R2.")
        for measure in range(102, 111):
            self.assertTrue(
                upper[measure - 1].startswith(r"\tag #'solo { R2. }"),
                f"Flute I is not silent at bar {measure}")

    def test_mode_timeline_is_complete(self):
        text = (MUSIC / "combined/flutes.ily").read_text(encoding="utf-8")
        opening = text.split("flutesModeOpening = {", 1)[1].split("}", 1)[0]
        bridge = text.split("flutesModeBridge = {", 1)[1].split("}", 1)[0]
        def total(music):
            return sum(int(n or 1) for n in re.findall(r"s2\.(?:\*(\d+))?", music))
        self.assertEqual(total(opening), 116)
        self.assertEqual(total(bridge), 36)
        for mode in (r"\partCombineApart", r"\partCombineSoloI",
                     r"\partCombineSoloII", r"\partCombineUnisono"):
            self.assertIn(mode, opening)


if __name__ == "__main__":
    unittest.main()
