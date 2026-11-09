"""Protect navigation coverage, old fragments, and PDF chapter order."""
from contextlib import redirect_stdout
import importlib.util
import io
import json
from pathlib import Path
import runpy
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.dont_write_bytecode = True
SCRIPT = Path(__file__).resolve().parents[1] / 'check_navigation.py'
SPEC = importlib.util.spec_from_file_location('navigation', SCRIPT)
NAV = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(NAV)


class NavigationTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        (self.root / 'README.md').write_text('# Home\n<a id="old-home"></a>\n[Index](Manual-Index.md#tasks)\n[Credits](Project-Information.md)\n')
        (self.root / 'Manual-Index.md').write_text('# Manual Index\n## Tasks\n[Guide](Guide.md)\n')
        (self.root / 'Project-Information.md').write_text('# Credits\n[Home](README.md)\n')
        (self.root / 'Guide.md').write_text('# Guide\n## Example\n')
        (self.root / 'UriMap.json').write_text(json.dumps({'legacy': '/README.md#old-home'}))

    def report(self):
        return NAV.validate(self.root)

    def append(self, text):
        path = self.root / 'Manual-Index.md'
        path.write_text(path.read_text() + text)

    def test_reference_links_images_and_shortcut_references(self):
        self.assertEqual(NAV.targets('[Page][p] [p][] ![Image](images/a.png)\n[p]: Guide.md'),
                         ['images/a.png', 'Guide.md', 'Guide.md'])
        self.append('[Missing][undefined]\n')
        self.assertEqual(self.report()['errors'][0]['reason'], 'undefined link reference')

    def test_headings_aliases_duplicates_and_fenced_examples(self):
        self.assertEqual(NAV.anchors('# Same\n# Same\n<a name="legacy"></a>\n```md\n# Not a heading\n```\n'),
                         {'same', 'same-1', 'legacy'})

    def test_complete_index_passes(self):
        report = self.report()
        self.assertEqual(report['manual_pages'], 4)
        self.assertEqual(report['errors'], [])
        self.assertEqual(report['unlinked_pages'], [])

    def test_missing_entry_point_or_target_fails(self):
        (self.root / 'Project-Information.md').unlink()
        self.assertTrue(any(row['reason'] == 'missing entry point' for row in self.report()['errors']))
        self.append('[Missing](Missing.md)\n')
        self.assertTrue(any(row['reason'] == 'missing target' for row in self.report()['errors']))

    def test_escaped_paths_and_missing_fragments_fail(self):
        self.append('[Outside](../outside.md)\n[Bad anchor](Guide.md#missing)\n')
        reasons = {row['reason'] for row in self.report()['errors']}
        self.assertEqual(reasons, {'target escapes manual root', 'missing heading fragment'})

    def test_local_fragment_absolute_manual_path_and_external_link(self):
        self.append('[Here](#tasks)\n[Root](/Guide.md#example)\n[External](https://www.cacti.net/)\n')
        self.assertEqual(self.report()['errors'], [])

    def test_new_manual_page_must_be_indexed(self):
        (self.root / 'New.md').write_text('# New\n')
        self.assertEqual(self.report()['unlinked_pages'], ['New.md'])
        with self.assertRaises(ValueError):
            NAV.ordered_pages(self.root)

    def test_legacy_fragment_must_survive_reorganization(self):
        (self.root / 'UriMap.json').write_text(json.dumps({'legacy': '/README.md#removed'}))
        self.assertEqual(self.report()['errors'][0]['reason'], 'missing legacy homepage fragment')
        (self.root / 'UriMap.json').unlink()
        self.assertEqual(self.report()['errors'], [])

    def test_pdf_uses_index_order_instead_of_alphabetical_fallback(self):
        (self.root / 'Zebra.md').write_text('# Zebra\n')
        (self.root / 'example.pdf').touch()
        self.append('[Last](Zebra.md)\n[Again](Guide.md)\n[Download](example.pdf)\n[Online](https://www.cacti.net/)\n')
        result = [path.name for path in NAV.ordered_pages(self.root)]
        self.assertEqual(result, ['README.md', 'Manual-Index.md', 'Guide.md', 'Zebra.md', 'Project-Information.md'])

    def test_cli_checks_selected_page_and_writes_fixed_report(self):
        with patch.object(NAV, 'ROOT', self.root), patch.object(sys, 'argv', ['navigation', 'Guide.md']), redirect_stdout(io.StringIO()):
            self.assertEqual(NAV.main(), 0)
        self.assertEqual(json.loads((self.root / 'navigation-report.json').read_text())['errors'], [])
        for selected in ('../outside.md', 'Unknown.md'):
            with patch.object(NAV, 'ROOT', self.root), patch.object(sys, 'argv', ['navigation', selected]), redirect_stdout(io.StringIO()):
                self.assertEqual(NAV.main(), 1)
        (self.root / 'New.md').write_text('# New\n')
        with patch.object(NAV, 'ROOT', self.root), patch.object(sys, 'argv', ['navigation', 'New.md']), redirect_stdout(io.StringIO()):
            self.assertEqual(NAV.main(), 1)

    def test_script_entry_point_checks_the_actual_manual(self):
        with patch.object(sys, 'argv', ['navigation']), redirect_stdout(io.StringIO()), self.assertRaises(SystemExit) as result:
            runpy.run_path(str(SCRIPT), run_name='__main__')
        self.assertEqual(result.exception.code, 0)


if __name__ == '__main__':
    unittest.main()
