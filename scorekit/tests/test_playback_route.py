"""Work-independent playback routing and MIDI marker regression tests."""
from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from playback_route import marker_route
from export import midi_events


def anchor(bar: int, tick: int, track: int = 0):
    return (tick, "marker", track, f"scorekit-bar:{bar}".encode())


class PlaybackMarkerTests(unittest.TestCase):
    def test_no_markers_keeps_legacy_path(self):
        self.assertIsNone(marker_route([], [0, 384, 768]))

    def test_dc_al_fine(self):
        # 1,2,3,4,5,6,1,2,3 (D.C. al Fine at the end of bar 6).
        start = [i * 384 for i in range(9)]
        events = [anchor(1, 0), anchor(1, 6 * 384)]
        self.assertEqual(marker_route(events, start), ([1, 2, 3, 4, 5, 6, 1, 2, 3], 6))

    def test_segno_and_coda(self):
        # 1,2,3,4,5,6 -> 3,4 -> 7,8
        start = [i * 384 for i in range(10)]
        events = [anchor(1, 0), anchor(3, 6 * 384), anchor(7, 8 * 384)]
        self.assertEqual(marker_route(events, start),
                         ([1, 2, 3, 4, 5, 6, 3, 4, 7, 8], 8))

    def test_volta_with_alternatives(self):
        # Printed 1,2,(3 first ending),(4 second ending)
        # Performed 1,2,3,1,2,4
        starts = [i * 480 for i in range(6)]
        events = [anchor(1, 0), anchor(1, 3 * 480), anchor(4, 5 * 480)]
        self.assertEqual(marker_route(events, starts), ([1, 2, 3, 1, 2, 4], 4))

    def test_legacy_map_is_verified(self):
        starts = [0, 384, 768]
        events = [anchor(1, 0), anchor(1, 768)]
        self.assertEqual(marker_route(events, starts, legacy_route=[1, 2, 1],
                                      legacy_printed=2), ([1, 2, 1], 2))
        with self.assertRaisesRegex(ValueError, "disagree"):
            marker_route(events, starts, legacy_route=[1, 2, 3])

    def test_missing_initial_anchor_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "start at printed bar 1"):
            marker_route([anchor(2, 384)], [0, 384])

    def test_non_barline_marker_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "outside measure boundaries"):
            marker_route([anchor(1, 0), anchor(4, 128)], [0, 384])

    def test_conflicting_markers_are_rejected(self):
        with self.assertRaisesRegex(ValueError, "Conflicting"):
            marker_route([anchor(1, 0), anchor(2, 0)], [0, 384])

    def test_duplicated_identical_marks_are_accepted(self):
        self.assertEqual(marker_route([anchor(1, 0), anchor(1, 0, 2)],
                                      [0, 384]), ([1, 2], 2))

    def test_malformed_scorekit_marker_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "Invalid ScoreKit"):
            marker_route([(0, "marker", 0, b"scorekit-bar:zero")], [0])

    def test_unrelated_rehearsal_marks_are_ignored(self):
        self.assertIsNone(marker_route([(0, "marker", 0, b"Allegro")], [0]))

    @unittest.skipUnless(shutil.which("lilypond"), "LilyPond is unavailable")
    def test_lilypond_volta_emits_repeatable_markers(self):
        # Integration check: the actual pinned LilyPond should emit the
        # markers used by ScoreKit, not merely the synthetic test bytes.
        include = (Path(__file__).resolve().parents[1]
                   / "lilypond/playback-markers.ily").as_posix()
        source = (r'\version "2.26.0"' + "\n"
                  + f'\\include "{include}"' + "\n"
                  + r'music = { \time 1/4 \repeat volta 2 { '
                  + r'\scorekitPlaybackStart #1 c4 '
                  + r'\scorekitPlaybackStart #2 d4 } }' + "\n"
                  + r'\score { \unfoldRepeats \music \midi { } }' + "\n")
        with tempfile.TemporaryDirectory() as tmp:
            file = Path(tmp) / "repeat.ly"
            file.write_text(source, encoding="utf-8")
            run = subprocess.run(
                ["lilypond", "-dno-print-pages", "-o", str(Path(tmp) / "repeat"),
                 str(file)],
                capture_output=True, text=True,
            )
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            midi = Path(tmp) / "repeat.midi"
            self.assertTrue(midi.is_file())
            _division, actual = midi_events(midi)
        anchors = [(tick, data) for tick, kind, _track, data in actual
                   if kind == "marker" and data.startswith(b"scorekit-bar:")]
        self.assertEqual([data for _tick, data in anchors],
                         [b"scorekit-bar:1", b"scorekit-bar:2",
                          b"scorekit-bar:1", b"scorekit-bar:2"])

    @unittest.skipUnless(shutil.which("lilypond"), "LilyPond is unavailable")
    def test_lilypond_da_capo_al_fine(self):
        # LilyPond native segno/Fine: perform bars 1,2,3,1,2.
        include = (Path(__file__).resolve().parents[1]
                   / "lilypond/playback-markers.ily").as_posix()
        source = (r'\version "2.26.0"' + "\n"
                  + f'\\include "{include}"' + "\n"
                  + r'music = { \time 1/4 \repeat segno 2 { '
                  + r'\scorekitPlaybackStart #1 c4 '
                  + r'\scorekitPlaybackStart #2 d4 '
                  + r'\volta 2 \fine '
                  + r'\volta 1 { \scorekitPlaybackStart #3 e4 } '
                  + r'} }' + "\n"
                  + r'\score { \unfoldRepeats \music \midi { } }' + "\n")
        with tempfile.TemporaryDirectory() as tmp:
            file = Path(tmp) / "dc.ly"
            file.write_text(source, encoding="utf-8")
            run = subprocess.run(
                ["lilypond", "-dno-print-pages", "-o", str(Path(tmp) / "dc"),
                 str(file)],
                capture_output=True, text=True,
            )
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            _division, actual = midi_events(Path(tmp) / "dc.midi")
        anchors = [data for _tick, kind, _track, data in actual
                   if kind == "marker" and data.startswith(b"scorekit-bar:")]
        self.assertEqual(anchors, [b"scorekit-bar:1", b"scorekit-bar:2",
                                   b"scorekit-bar:3", b"scorekit-bar:1",
                                   b"scorekit-bar:2"])

    def assert_lilypond_route(self, music: str, expected: list[int],
                             printed: int) -> None:
        """Compile a real MIDI file and check both pitches and printed-bar route.

        MIDI note-on positions independently confirm the playback duration:
        the expected route alone must not conceal missing/extra measures.
        Test sources use one quarter note per printed bar.
        """
        include = (Path(__file__).resolve().parents[1]
                   / "lilypond/playback-markers.ily").as_posix()
        source = (r'\version "2.26.0"' + "\n"
                  + f'\\include "{include}"' + "\n"
                  + r'music = { \time 1/4 ' + music + " }\n"
                  + r'\score { \unfoldRepeats \music \midi { } }' + "\n")
        with tempfile.TemporaryDirectory() as tmp:
            file = Path(tmp) / "route.ly"
            file.write_text(source, encoding="utf-8")
            run = subprocess.run(
                ["lilypond", "-dno-print-pages", "-o", str(Path(tmp) / "route"),
                 str(file)],
                capture_output=True, text=True, timeout=60,
            )
            self.assertEqual(run.returncode, 0, run.stdout + run.stderr)
            division, events = midi_events(Path(tmp) / "route.midi")
        note_starts = sorted({
            tick for tick, typ, _track, data in events
            if typ == "channel" and (data[0] & 0xF0) == 0x90
            and len(data) >= 3 and data[2] > 0
        })
        self.assertEqual(note_starts, [i * division for i in range(len(expected))])
        resolved = marker_route(events, note_starts, legacy_printed=printed)
        self.assertEqual(resolved, (expected, printed))
        # No redundant anchor occurs in the middle of a MIDI measure.
        self.assertEqual(
            {tick for tick, typ, _track, data in events
             if typ == "marker" and data.startswith(b"scorekit-bar:")}
            - set(note_starts), set(),
        )

    @unittest.skipUnless(shutil.which("lilypond"), "LilyPond is unavailable")
    def test_lilypond_dal_segno_al_coda(self):
        # Intro 1-2; D.S. to bar 3 after playing 3-6; jump to Coda 7-8.
        # Based on the native LilyPond segno/coda alternatives syntax.
        music = r"""
          \scorekitPlaybackStart #1 c4
          \scorekitPlaybackStart #2 d4
          \repeat segno 2 {
            \scorekitPlaybackStart #3 e4
            \scorekitPlaybackStart #4 f4
            \alternative {
              \volta 1 {
                \scorekitPlaybackStart #5 g4
                \scorekitPlaybackStart #6 a4
              }
              \volta 2 \volta #'() {
                \section
                \sectionLabel "Coda"
              }
            }
          }
          \scorekitPlaybackStart #7 b4
          \scorekitPlaybackStart #8 c'4
          \fine
        """
        self.assert_lilypond_route(
            music, [1, 2, 3, 4, 5, 6, 3, 4, 7, 8], printed=8,
        )

    @unittest.skipUnless(shutil.which("lilypond"), "LilyPond is unavailable")
    def test_lilypond_four_pass_volta_with_nonconsecutive_endings(self):
        # 1st/3rd endings share printed bar 3, 2nd/4th share bar 4.
        # The 5th printed bar is performed once after all four passes.
        music = r"""
          \repeat volta 4 {
            \scorekitPlaybackStart #1 c4
            \scorekitPlaybackStart #2 d4
            \alternative {
              \volta 1,3 { \scorekitPlaybackStart #3 e4 }
              \volta 2,4 { \scorekitPlaybackStart #4 f4 }
            }
          }
          \scorekitPlaybackStart #5 g4
        """
        self.assert_lilypond_route(
            music, [1, 2, 3, 1, 2, 4, 1, 2, 3, 1, 2, 4, 5],
            printed=5,
        )

    def test_midi_meta_marker_is_read(self):
        # Format 0, 1 track, 480 ticks/quarter; marker then end-of-track.
        label = b"scorekit-bar:1"
        events = b"\x00\xff\x06" + bytes([len(label)]) + label + b"\x00\xff\x2f\x00"
        midi = (b"MThd\x00\x00\x00\x06\x00\x00\x00\x01\x01\xe0"
                + b"MTrk" + len(events).to_bytes(4, "big") + events)
        with tempfile.TemporaryDirectory() as tmp:
            file = Path(tmp) / "markers.midi"
            file.write_bytes(midi)
            division, actual = midi_events(file)
        self.assertEqual(division, 480)
        self.assertEqual(actual, [anchor(1, 0)])


if __name__ == "__main__":
    unittest.main()
