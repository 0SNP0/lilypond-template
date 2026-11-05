"""Work-independent regression tests for navigation and MIDI repeat timbre."""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from build import validate_repeat_timbres
from check_music_structure import validate_navigation_map
from export import _svg_measure_regions, _clean_svg, annotate_measure_spans
from score_indent import derived_indents, label_x_from_svg, layout_left_margin
import xml.etree.ElementTree as ET


class RepeatTimbreTests(unittest.TestCase):
    @staticmethod
    def timeline():
        return {"ticks_per_quarter": 384, "measures": [
            {"number": 1, "printed_number": 1, "start_tick": 0, "end_tick": 384},
            {"number": 2, "printed_number": 2, "start_tick": 384, "end_tick": 768},
            {"number": 3, "printed_number": 1, "start_tick": 768, "end_tick": 1152},
        ]}

    @staticmethod
    def notes(restore=True):
        events = [
            (0, "channel", 0, bytes([0xC0, 40])),
            (100, "channel", 0, bytes([0x90, 60, 90])),
            (384, "channel", 0, bytes([0xC0, 45])),
            (484, "channel", 0, bytes([0x90, 62, 90])),
            (868, "channel", 0, bytes([0x90, 60, 90])),
        ]
        if restore:
            events.append((768, "channel", 0, bytes([0xC0, 40])))
        return sorted(events)

    def test_restored_program(self):
        validate_repeat_timbres(self.notes(), 384, self.timeline(), "strings")

    def test_sticky_program_is_rejected(self):
        with self.assertRaisesRegex(RuntimeError, "Repeated MIDI bar 1"):
            validate_repeat_timbres(self.notes(False), 384, self.timeline(), "strings")

    def test_navigation_map(self):
        spec = {"navigation": [
            {"after_measure": 2, "label": "Fine"},
            {"after_measure": 3, "label": "D.C. al Fine",
             "jump_to": 1, "stop_after": 2},
        ]}
        sections = [{"start": 1, "end": 2}, {"start": 3, "end": 3},
                    {"start": 1, "end": 2}]
        validate_navigation_map(spec, 3, sections)
        with self.assertRaises(ValueError):
            validate_navigation_map(spec, 3, sections[:-1])


class MeasureGeometryTests(unittest.TestCase):
    """A number printed at a right boundary belongs to the next system."""

    def test_first_bar_of_next_system_is_not_previous_bar(self):
        staves = [(10.,14.,10.,100.),(30.,34.,20.,100.)]
        bars = [(10.,10.),(50.,10.),(100.,10.),
                (20.,30.),(70.,30.),(100.,30.)]
        labels = [(1,10.,10.),(2,50.,10.),(3,100.,10.),
                  (4,70.,30.)]
        areas, carry = _svg_measure_regions(
            staves,bars,labels,"individual",1
        )
        region = next(a for a in areas if a["measure_id"]=="measure-0003")
        self.assertEqual((region["x"],region["y"],region["width"]),
                         (20.,29.6,50.))
        self.assertIsNone(carry)
        self.assertEqual(len([a for a in areas if a["measure_id"]=="measure-0003"]),1)

    def test_system_start_carries_across_page(self):
        a,carry=_svg_measure_regions(
            [(10.,14.,10.,100.)],[(10.,10.),(50.,10.),(100.,10.)],
            [(1,10.,10.),(2,50.,10.),(3,100.,10.)],
            "individual",1
        )
        self.assertEqual(carry,3)
        self.assertFalse(any(x["measure_id"]=="measure-0003" for x in a))
        b,carry=_svg_measure_regions(
            [(15.,19.,20.,100.)],[(20.,15.),(60.,15.),(100.,15.)],
            [(4,60.,15.)],"individual",2,carry
        )
        self.assertIsNone(carry)
        self.assertEqual([(x["page"],x["x"],x["width"]) for x in b
                          if x["measure_id"]=="measure-0003"],[(2,20.,40.)])


class MultiMeasureSpanTests(unittest.TestCase):
    """A rest stays highlighted through its full printed duration."""

    def test_rest_at_end_of_system(self):
        areas = [
            {"measure_id": "measure-0037", "page": 1, "y": 32.3},
            {"measure_id": "measure-0053", "page": 1, "y": 49.2},
            {"measure_id": "measure-0054", "page": 1, "y": 49.2},
        ]
        annotate_measure_spans(areas, 54)
        self.assertEqual([a["last_printed_measure"] for a in areas],
                         [52, 53, 54])

    def test_rest_across_page_and_until_last_bar(self):
        areas = [
            {"measure_id": "measure-0101", "page": 1, "y": 93.0},
            {"measure_id": "measure-0115", "page": 2, "y": 12.0},
            {"measure_id": "measure-0137", "page": 2, "y": 30.0},
        ]
        annotate_measure_spans(areas, 152)
        self.assertEqual([a["last_printed_measure"] for a in areas],
                         [114, 136, 152])

    def test_export_order_cannot_change_spans(self):
        areas = [
            {"measure_id": "measure-0103", "page": 1},
            {"measure_id": "measure-0101", "page": 1},
            {"measure_id": "measure-0105", "page": 1},
        ]
        annotate_measure_spans(areas, 105)
        self.assertEqual({a["measure_id"]:a["last_printed_measure"]
                          for a in areas},
                         {"measure-0101":102, "measure-0103":104,
                          "measure-0105":105})

    def test_duplicate_regions_are_rejected(self):
        areas = [{"measure_id":"measure-0001"},
                 {"measure_id":"measure-0001"}]
        with self.assertRaisesRegex(ValueError, "Invalid printed measure sequence|repeated"):
            annotate_measure_spans(areas, 4)


class SvgRehearsalMarksTests(unittest.TestCase):
    """Keep boxed numeric rehearsal marks while stripping page title text."""

    def test_high_boxed_rehearsal_number_survives(self):
        ns = "http://www.w3.org/2000/svg"
        def element(name, parent, **attrs):
            return ET.SubElement(parent, f"{{{ns}}}{name}", attrs)
        root=ET.Element(f"{{{ns}}}svg", {"viewBox":"0 0 120 180",
                                           "width":"210.00mm","height":"297.00mm"})
        box=element("g",root,transform="translate(25, 22)")
        element("rect",box,width="0.1",height="2.8",y="-1.4")
        label=element("g",root,transform="translate(25, 22)")
        element("text",label).text="10"
        headline=element("g",root,transform="translate(20, 2)")
        element("text",headline).text="Book title to remove"
        distant=element("g",root,transform="translate(60, 20)")
        element("text",distant).text="Heading to remove"
        _clean_svg(root,[(30.,34.,10.,105.)],"v1.2.3")
        labels=["".join(x.itertext()).strip() for x in root]
        self.assertIn("10",labels)
        self.assertNotIn("Book title to remove",labels)
        self.assertNotIn("Heading to remove",labels)
        viewbox=list(map(float,root.get("viewBox").split()))
        self.assertLess(viewbox[1],22)

    def test_rehearsal_number_unboxed_remains_subject_to_trim(self):
        ns="http://www.w3.org/2000/svg"
        root=ET.Element(f"{{{ns}}}svg",{"viewBox":"0 0 120 180"})
        text=ET.SubElement(root,f"{{{ns}}}g",{"transform":"translate(25, 22)"})
        ET.SubElement(text,f"{{{ns}}}text").text="10"
        _clean_svg(root,[(30.,34.,10.,105.)],"v1.2.3")
        self.assertEqual([x for x in root if x.tag.endswith("g")],[])


class ScoreIndentTests(unittest.TestCase):
    def test_real_score_layout_margin_is_used(self):
        self.assertEqual(layout_left_margin("left-margin = 6\\mm"), 6.0)
        self.assertEqual(layout_left_margin("  left-margin = 12.5\\mm"), 12.5)

    def test_measured_name_positions_calibrate_without_guessing_font(self):
        # A 10 mm indent reduction moved real ink by only 5 mm.
        # The old 1:1 assumption would leave 5 mm of unnecessary gutter.
        first,later=derived_indents(
            (45,28), (17.71,12.13), (12.71,7.13), 6
        )
        self.assertEqual((first,later),(23.58,17.74))

    def test_calibration_rejects_nonresponsive_label_coordinates(self):
        with self.assertRaisesRegex(RuntimeError, "displacement"):
            derived_indents((45,28),(20,10),(20,10),6)

    def test_label_extraction_from_lilypond_svg(self):
        import tempfile
        with tempfile.TemporaryDirectory() as d:
            path=Path(d)/"page-001.svg"
            path.write_text(
                '<svg xmlns="http://www.w3.org/2000/svg">'
                '<g transform="translate(23.14, 90)">'
                '<text>Clarinets in A I–II</text></g>'
                '</svg>',encoding="utf-8"
            )
            self.assertEqual(label_x_from_svg(path,{"Clarinets in A I–II"}),23.14)


if __name__ == "__main__":
    unittest.main()
