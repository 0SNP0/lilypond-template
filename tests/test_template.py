import importlib.util
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("orchestra_builder", ROOT / "scripts" / "build.py")
builder = importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)


class ProjectTests(unittest.TestCase):
    def setUp(self):
        self.p = builder.project()

    def test_21_parts_and_sources(self):
        self.assertEqual(len(self.p["instruments"]), 21)
        builder.check_manifest(self.p)

    def test_custom_instrument_structure(self):
        instruments = {i["id"]: i for i in self.p["instruments"]}
        self.assertEqual(len(instruments["15-piano"]["staves"]), 2)
        self.assertEqual(len(instruments["16-accordion"]["staves"]), 2)
        self.assertEqual(instruments["06-bass-clarinet"]["transpose_to"], "d'")
        self.assertEqual(instruments["08-alto-sax"]["transpose_to"], "a")
        self.assertEqual(instruments["09-tenor-sax"]["transpose_to"], "d'")
        self.assertEqual(instruments["21-double-bass"]["transpose_to"], "c'")

    def test_printed_score_and_concert_pitch(self):
        normal = builder.make_document(self.p)
        concert = builder.make_document(self.p, concert=True)
        self.assertIn("\\transpose c d'", normal)
        self.assertNotIn("\\transpose c d'", concert)
        self.assertIn('set-paper-size "a4"', normal)
        self.assertIn('ragged-last-bottom = ##t', normal)
        self.assertNotIn('set-paper-size "a3"', normal)
        self.assertIn("instrumentName = \\markup \\fontsize #-3", normal)
        self.assertNotIn("Clarinet in B-flat I", normal)
        self.assertIn("indent = 18\\\\mm", normal)
        self.assertIn("ensembleCompactBookTitle", normal)
        self.assertIn("\\new DrumStaff", normal)
        self.assertEqual(normal.count("\\include \"music/"), 22)

    def test_midi_channel_allocation(self):
        audio = builder.make_document(self.p, midi=True)
        self.assertIn("midiChannelMapping = #'instrument", audio)
        self.assertNotIn("\\transpose", audio)
        melodic_timbres = {i['midi'] for i in self.p['instruments'] if i['group'] != 'percussion'}
        self.assertLessEqual(len(melodic_timbres), 15)

    def test_part_title_and_paper(self):
        clarinet = self.p['instruments'][3]
        part = builder.make_document(self.p, clarinet)
        self.assertIn('set-paper-size "a4"', part)
        self.assertIn("\\compressMMRests", part)
        self.assertNotIn("instrumentName =", part)
        self.assertNotIn("shortInstrumentName =", part)
        self.assertIn("indent = 0\\\\mm", part)
        self.assertIn("stretchability . 0", part)
        self.assertIn("\\transpose c d", part)

    def test_all_instrument_labels_english(self):
        for item in self.p["instruments"]:
            self.assertTrue(item["name"].isascii(), item["id"])
            self.assertTrue(item["short"].isascii(), item["id"])
        self.assertEqual(self.p["layout"]["score_paper"], "a4")
        self.assertEqual(self.p["layout"]["parts_paper"], "a4")

    def test_per_part_pagination_override(self):
        import copy
        p = copy.deepcopy(self.p)
        p["layout"]["part_overrides"] = {
            "04-clarinet-1": {
                "target_pages": 2,
                "systems_per_page": 4,
                "system_count": 8,
                "staff_space_mm": 1.5,
            }
        }
        builder.check_manifest(p)
        clarinet = p["instruments"][3]
        part = builder.make_document(p, clarinet)
        other = builder.make_document(p, p["instruments"][2])
        self.assertIn("page-count = #2", part)
        self.assertIn("systems-per-page = #4", part)
        self.assertIn("system-count = #8", part)
        self.assertNotIn("page-count = #2", other)
        self.assertIn('set-paper-size "a4"', part)

    def test_compact_score_does_not_shrink_parts(self):
        self.assertEqual(builder.edition_layout(self.p)["staff_space_mm"], 1.05)
        self.assertEqual(builder.edition_layout(self.p, self.p["instruments"][0])["staff_space_mm"], 1.75)
        self.assertTrue(builder.edition_layout(self.p, self.p["instruments"][0])["ragged_bottom"])
        self.assertTrue(builder.edition_layout(self.p, self.p["instruments"][0])["ragged_last_bottom"])

    def test_score_overrides_and_invalid_paper(self):
        import copy
        p = copy.deepcopy(self.p)
        p["layout"]["score_overrides"] = {"full-score": {"target_pages": 5}}
        self.assertIn("page-count = #5", builder.make_document(p))
        self.assertNotIn("page-count = #5", builder.make_document(p, concert=True))
        p["layout"]["score_paper"] = "a3"
        with self.assertRaises(RuntimeError):
            builder.check_manifest(p)

    @unittest.skipUnless(importlib.util.find_spec("pypdf"), "pypdf optional")
    def test_actual_pdf_pages_and_a4_detection(self):
        import copy
        import tempfile
        from pypdf import PdfWriter
        p = copy.deepcopy(self.p)
        p["layout"]["part_overrides"] = {"04-clarinet-1": {"target_pages": 2}}
        with tempfile.TemporaryDirectory() as directory:
            original = builder.PDF
            try:
                builder.PDF = Path(directory)
                ids = ["full-score", "concert-score"] + [i["id"] for i in p["instruments"]]
                for name in ids:
                    writer = PdfWriter()
                    for _ in range(2 if name == "04-clarinet-1" else 1):
                        writer.add_blank_page(width=595.28, height=841.89)
                    with (builder.PDF / f"{name}.pdf").open("wb") as handle:
                        writer.write(handle)
                counts = builder.pdf_page_report(p, strict=True)
                self.assertEqual(counts["04-clarinet-1"], 2)
                self.assertEqual(counts["full-score"], 1)
                bad_pdf = builder.PDF / "01-flute-1.pdf"
                writer = PdfWriter()
                writer.add_blank_page(width=612, height=792)
                with bad_pdf.open("wb") as handle:
                    writer.write(handle)
                with self.assertRaisesRegex(RuntimeError, "not A4"):
                    builder.pdf_page_report(p, strict=True)
            finally:
                builder.PDF = original

    def test_names_safe_in_ly(self):
        self.assertEqual(builder.lily_string('A "title"'), '"A \\"title\\""')


if __name__ == '__main__':
    unittest.main()
