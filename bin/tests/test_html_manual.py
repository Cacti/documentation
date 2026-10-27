"""Regression checks for complete and safe HTML manual publication.

Copyright (C) 2004-2026 The Cacti Group. GPL-2.0-or-later.
"""
import importlib.util
import json
import io
from contextlib import redirect_stdout
import zipfile
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location('manual', Path(__file__).parents[1] / 'build_html_docs.py')
MANUAL = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MANUAL)


class HtmlManualTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name) / 'source'
        self.root.mkdir()
        self.output = self.root.parent / 'output'
        files = {
            'README.md': '# Manual\n\n[Requirements](Requirements.md#requirements)\n',
            'Manual-Index.md': '# All chapters\n\n[Setup](Requirements.md)\n',
            'Requirements.md': '# Requirements\n\n![Devices](images/devices.svg)\n',
            'Architecture/One.md': '# One\n\n[Home](../README.md)\n',
            'images/devices.svg': '<svg xmlns="http://www.w3.org/2000/svg"></svg>',
            'resource/query.php': '<?php echo "example";',
            'resources/css/Cacti-Github.css': 'body { color: black; }',
            'bin/build_html_docs.py': 'fixture',
            'bin/build_html_docs.py.lock': 'fixture lock',
            'resources/build/legacy-html-chapters.json': json.dumps({'chapters': {
                'requirements.html': {'target': 'Requirements.md', 'fragments': ['OLD', 'requirements']}}}),
        }
        for name, text in files.items():
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        self.assets = list(files)

    def build(self):
        with patch.object(MANUAL.subprocess, 'check_output', side_effect=['revision\n', '\0'.join(self.assets).encode()]):
            return MANUAL.build(self.root, self.output)

    def test_all_chapters_legacy_urls_bookmarks_and_assets_survive(self):
        report = self.build()
        self.assertEqual(report['chapters'], 4)
        self.assertEqual(report['html_pages'], 6)
        self.assertEqual(report['legacy_chapters'], 1)
        text = (self.output / 'requirements.html').read_text()
        self.assertIn('id="OLD"', text)
        self.assertEqual(text.count('id="requirements"'), 1)
        self.assertIn('unreleased Cacti 1.3', text)
        self.assertIn('href="../index.html"', (self.output / 'Architecture/One.html').read_text())
        self.assertEqual(MANUAL.validate(self.output), 6)
        self.assertTrue((self.output / 'resource/query.php.txt').exists())
        self.assertFalse((self.output / 'resource/query.php').exists())
        self.assertEqual((self.output / 'Cacti-Github.css').read_text(), 'body { color: black; }')
        self.assertEqual(len(report['sources']), 4)

    def test_localized_guide_has_its_document_language(self):
        path = self.root / 'resources/manuals/Guide-de.md'
        path.parent.mkdir(parents=True)
        path.write_text('# Handbuch\n')
        self.assets.append('resources/manuals/Guide-de.md')
        self.build()
        self.assertIn('<html lang="de">', (self.output / 'resources/manuals/Guide-de.html').read_text())
        self.assertIn('<html lang="en">', (self.output / 'index.html').read_text())

    def test_rebuild_removes_stale_pages_from_owned_output(self):
        self.build()
        (self.output / 'stale.html').write_text('old')
        self.build()
        self.assertFalse((self.output / 'stale.html').exists())

    def test_unrelated_outputs_cannot_be_deleted(self):
        self.output.mkdir()
        for marker in [None, {'generator': 'other'}]:
            if marker:
                (self.output / 'build-manifest.json').write_text(json.dumps(marker))
            with self.assertRaisesRegex(ValueError, 'unrelated'):
                (self.output / 'keep').write_text('keep')
                self.build()
            self.assertEqual((self.output / 'keep').read_text(), 'keep')

    def test_private_untracked_markdown_is_not_published(self):
        (self.root / 'Private.md').write_text('private draft')
        report = self.build()
        self.assertNotIn('Private.md', report['sources'])
        self.assertFalse((self.output / 'Private.html').exists())

    def test_source_directories_cannot_be_outputs(self):
        for path in [self.root, self.root.parent, self.root / 'images']:
            with self.subTest(path=path), self.assertRaises(ValueError):
                MANUAL.build(self.root, path)

    def test_failed_validation_preserves_previous_artifact(self):
        self.build()
        original = (self.output / 'index.html').read_bytes()
        (self.root / 'README.md').write_text('# Manual\n\n[Bad](Requirements.md#missing)')
        with self.assertRaisesRegex(ValueError, 'missing fragment'):
            self.build()
        self.assertEqual((self.output / 'index.html').read_bytes(), original)

    def test_missing_or_escaping_targets_fail(self):
        for href in ['missing.md', '../outside.md', '/%2e%2e/outside.md']:
            with self.subTest(href=href), self.assertRaises(ValueError):
                MANUAL.rewrite(href, self.root / 'README.md', self.root)

    def test_rewrites_links_queries_fragments_and_safe_downloads(self):
        cases = {'../README.md#top': '../Table-of-Contents.html#top',
                 '/Requirements.md?x=1#requirements': '../requirements.html?x=1#requirements',
                 '../resource/query.php': '../resource/query.php.txt', '#heading': '#heading',
                 'https://example.org/a.md': 'https://example.org/a.md', '//example.org/a.md': '//example.org/a.md'}
        for href, expected in cases.items():
            with self.subTest(href=href):
                self.assertEqual(MANUAL.rewrite(href, self.root / 'Architecture/One.md', self.root), expected)
        with self.assertRaises(ValueError):
            MANUAL.rewrite('javascript:alert(1)', self.root / 'README.md', self.root)

    def test_html_is_disabled_except_empty_compatibility_anchors(self):
        source = self.root / 'Requirements.md'
        source.write_text('# Requirements\n\n<a id="old"></a>\n\n'
                          '<script>alert(1)</script><img src=x onerror=alert(1)>\n\n'
                          '```html\n<a id="example"></a>\n```\n')
        _, text = MANUAL.render(source, self.root)
        self.assertIn('<a id="old"></a>', text)
        self.assertNotIn('<script>', text)
        self.assertNotIn('<img src=x', text)
        self.assertNotIn('<a id="example">', text)
        self.assertIn('&lt;script&gt;', text)

    def test_duplicate_headings_and_inline_anchors(self):
        source = self.root / 'Requirements.md'
        source.write_text('# Setup\n\n## Repeat\n\n## Repeat\n\nText <a id="compat"></a> end.\n')
        _, text = MANUAL.render(source, self.root)
        self.assertIn('id="repeat-1"', text)
        self.assertIn('id="compat"', text)

    def test_invalid_legacy_filename_fails(self):
        (self.root / 'resources/build/legacy-html-chapters.json').write_text(json.dumps({
            'chapters': {'../escape.html': {'target': 'README.md', 'fragments': []}}}))
        with self.assertRaisesRegex(ValueError, 'Invalid legacy filename'):
            self.build()

    def test_external_chapter_symlinks_and_directory_names_fail(self):
        outside = self.root.parent / 'outside.md'
        outside.write_text('private')
        link = self.root / 'Outside.md'
        link.symlink_to(outside)
        self.assets.append('Outside.md')
        with self.assertRaisesRegex(ValueError, 'Invalid chapter source'):
            self.build()
        link.unlink()
        link.mkdir()
        with self.assertRaisesRegex(ValueError, 'Invalid chapter source'):
            self.build()

    def test_external_asset_symlinks_fail(self):
        (self.root / 'images/outside').symlink_to(self.root.parent)
        self.assets.append('images/outside')
        with self.assertRaisesRegex(ValueError, 'Invalid asset'):
            self.build()

    def test_missing_generated_assets_and_escaping_links_fail(self):
        self.output.mkdir()
        for href in ['missing.png', '../outside']:
            (self.output / 'index.html').write_text('<a href="' + href + '">Bad</a>')
            with self.assertRaisesRegex(ValueError, 'missing target'):
                MANUAL.validate(self.output)

    def test_section_pages_select_the_matching_topic(self):
        body = '<h1 id="main">Main</h1><h2 id="one">One</h2><p>A</p><h2 id="two">Two</h2><p>B</p>'
        self.assertEqual(MANUAL.section(body, ''), body)
        first = MANUAL.section(body, 'one')
        self.assertIn('<h1 id="one">One</h1>', first)
        self.assertNotIn('<p>B</p>', first)
        self.assertIn('<p>B</p>', MANUAL.section(body, 'two'))
        with self.assertRaisesRegex(ValueError, 'Missing legacy section'):
            MANUAL.section(body, 'missing')

    def test_archive_is_reproducible_and_contains_safe_downloads(self):
        self.build()
        target = self.root.parent / 'manual.zip'
        MANUAL.archive(self.output, target)
        first = target.read_bytes()
        MANUAL.archive(self.output, target)
        self.assertEqual(first, target.read_bytes())
        with zipfile.ZipFile(target) as bundle:
            self.assertIn('index.html', bundle.namelist())
            self.assertIn('resource/query.php.txt', bundle.namelist())
            self.assertNotIn('resource/query.php', bundle.namelist())
        self.assertTrue(target.with_suffix('.zip.sha256').read_text().endswith('  manual.zip\n'))
        with self.assertRaises(ValueError):
            MANUAL.archive(self.output, self.output / 'recursive.zip')

    def test_cli_without_archive_builds_the_selected_output(self):
        with patch.object(MANUAL, 'ROOT', self.root), patch('sys.argv', ['build', '--output', str(self.output)]), \
                patch.object(MANUAL.subprocess, 'check_output', side_effect=['revision\n', '\0'.join(self.assets).encode()]), \
                redirect_stdout(io.StringIO()) as result:
            MANUAL.main()
        self.assertEqual(json.loads(result.getvalue())['chapters'], 4)
        self.assertTrue((self.output / 'index.html').exists())

    def test_titles_are_escaped_and_no_script_runtime_is_added(self):
        text = MANUAL.document('<img onerror=1>', '<p>Content</p>', '', 'revision')
        self.assertIn('&lt;img onerror=1&gt;', text)
        self.assertIn('Content-Security-Policy', text)
        self.assertNotIn('<script', text)


if __name__ == '__main__':
    unittest.main()
