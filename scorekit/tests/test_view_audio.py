"""Regression coverage for reusable combined-score audio mapping."""
import json
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from view_audio import infer_audio_ids, load_audio_overrides


class ViewAudioMappingTests(unittest.TestCase):
    def test_pair_inferred_from_music_includes(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "horns-2-4.ly"
            source.write_text(
                '\\include "../../music/horn-2.ily"\n'
                '\\include "../../music/horn-4.ily"\n'
                '\\include "../../music/global.ily"\n',
                encoding="utf-8",
            )
            tracks = infer_audio_ids("combined-horns-2-4", "combined", source,
                                     {"mix", "horn-2", "horn-4"})
            self.assertEqual(tracks, ["horn-2", "horn-4"])

    def test_missing_mapping_falls_back_to_full_mix(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "unknown.ly"
            source.write_text("no specific music includes", encoding="utf-8")
            self.assertEqual(infer_audio_ids(
                "combined-unknown", "combined", source, {"mix", "horn-2"}
            ), ["mix"])

    def test_project_override(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "music").mkdir()
            (root / "music" / "view-audio-map.json").write_text(
                json.dumps({"combined-voices": ["voice-1", "voice-2"]}),
                encoding="utf-8",
            )
            overrides = load_audio_overrides(root)
            self.assertEqual(infer_audio_ids(
                "combined-voices", "combined", root / "unused.ly",
                {"mix", "voice-1", "voice-2"}, overrides
            ), ["voice-1", "voice-2"])

    def test_bad_track_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(ValueError, "missing audio tracks"):
                infer_audio_ids(
                    "combined-voices", "combined", Path(directory) / "unused.ly",
                    {"mix", "voice-1"}, {"combined-voices": ["voice-1", "voice-2"]}
                )

    def test_full_mix_and_stem_cannot_be_default(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(ValueError, "cannot combine"):
                infer_audio_ids(
                    "score", "score", Path(directory) / "unused.ly",
                    {"mix", "voice-1"}, {"score": ["mix", "voice-1"]}
                )


if __name__ == "__main__":
    unittest.main()
