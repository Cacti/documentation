"""Regression tests for the current manual editions and archival boundary."""
import hashlib
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import build_other_manuals as manuals


class Editions(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.folder = self.root / 'resources/manuals'
        (self.folder / 'source').mkdir(parents=True)
        for name in ['README.md', 'Manual-Index.md', 'Project-Information.md']:
            (self.root / name).write_text('# ' + name + '\n\n[Project](Project-Information.md)\n')
        (self.folder / 'Guide.md').write_text('# Türkçe Русский Deutsch\n\nEnglish appendix.\n')
        self.source = self.folder / 'source/cacti.sql'
        self.source.write_text('CREATE TABLE `one` (\n  `id` int,\n  KEY (`id`))\nENGINE=InnoDB;\n'
                               'INSERT INTO one VALUES (1);\n'
                               'CREATE TABLE `two` (\n `text` varchar(32)\n) ENGINE=InnoDB;\n')
        self.provenance()
        specs = [{'id': 'translated', 'pages': 'all', 'guide': 'Guide.md', 'language': 'tr'},
                 {'id': 'platform', 'pages': ['Project-Information.md'], 'guide': None, 'language': 'en'}]
        (self.folder / 'editions.json').write_text(json.dumps(specs))
        for name in ['bin/build_other_manuals.py', 'bin/build_pdf_docs.py',
                     'bin/build_pdf_docs.py.lock', 'bin/check_navigation.py',
                     'resources/css/pdf.css', 'resources/manuals/archive-inventory.json']:
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('fixture')

    def provenance(self):
        (self.folder / 'schema-source.json').write_text(json.dumps({
            'sha256': hashlib.sha256(self.source.read_bytes()).hexdigest(),
            'repository': 'https://github.com/Cacti/cacti', 'revision': 'abc123'}))

    def test_schema_preserves_all_table_declarations_but_no_seed_rows(self):
        provenance, tables, ddl = manuals.schema_reference(self.root)
        self.assertEqual(len(tables), 2)
        self.assertIn('KEY (`id`))\nENGINE=InnoDB;', ddl)
        self.assertNotIn('INSERT INTO', ddl)
        self.assertIn('abc123', (self.folder / 'Schema-Reference.md').read_text())
        self.assertEqual(provenance['sha256'], manuals.digest(self.source))

    def test_schema_fails_closed_for_changed_or_unrecognized_input(self):
        self.source.write_text('CREATE TABLE unquoted (id int);\n')
        with self.assertRaisesRegex(ValueError, 'checksum'):
            manuals.schema_reference(self.root)
        self.provenance()
        with self.assertRaisesRegex(ValueError, 'every CREATE'):
            manuals.schema_reference(self.root)
        self.source.write_text('SELECT 1;\n')
        self.provenance()
        with self.assertRaisesRegex(ValueError, 'every CREATE'):
            manuals.schema_reference(self.root)

    def test_text_retains_examples_unicode_tables_and_link_destinations(self):
        (self.root / 'image.png').write_bytes(b'fixture')
        page = self.root / 'README.md'
        page.write_text('''# Türkçe Русский Deutsch

<a id="compatibility"></a>

[Chapter](Project-Information.md#heading) [same](#here) [external](https://cacti.net/)

![Example measurements](image.png)

1. First

2. Second

> Quoted text

| Name | Value |
| --- | --- |
| Router | 42 |

```sh
  php poller.php --debug
printf 'a  b'
```

---

<script>alert(1)</script>
''')
        text = manuals.plain(page, self.root, 'revision')
        for value in ['Türkçe Русский Deutsch', '* First', '* Second', '\tRouter', '\t42',
                      '  php poller.php --debug', "printf 'a  b'", 'Quoted text',
                      'Project-Information.md#heading>', 'README.md#here>',
                      '<https://cacti.net/>', '[Image: Example measurements]', 'image.png>',
                      '<script>alert(1)</script>']:
            self.assertIn(value, text)
        self.assertNotIn('compatibility', text)

    def test_local_sources_cannot_escape_or_disappear(self):
        for path in ['missing.md', '../outside.md']:
            with self.assertRaisesRegex(ValueError, 'Missing or escaping'):
                manuals.local(self.root, path)
        outside = Path(self.tmp.name).parent / 'cacti-outside-manual.md'
        outside.write_text('private')
        self.addCleanup(outside.unlink)
        (self.root / 'linked.md').symlink_to(outside)
        with self.assertRaises(ValueError):
            manuals.local(self.root, 'linked.md')
        (self.root / 'README.md').write_text('[bad](../cacti-outside-manual.md)')
        with self.assertRaises(ValueError):
            manuals.plain(self.root / 'README.md', self.root, 'revision')

    def test_build_selects_complete_appendices_and_hashes_actual_outputs(self):
        calls = []

        def pdf(output, revision, built, **kwargs):
            calls.append((output.name, revision, built, kwargs))
            output.write_bytes(b'%PDF-fixture')

        result = manuals.build(self.root, 'revision', '2026-10-26', pdf)
        self.assertEqual(len(calls), 2)
        self.assertEqual(calls[0][3]['language'], 'tr')
        self.assertEqual(len(calls[0][3]['paths']), 4)
        self.assertEqual(len(calls[1][3]['paths']), 1)
        self.assertEqual(result['schema_tables'], 2)
        self.assertEqual(len(result['editions']['manual']['sources']), 3)
        output = self.root / 'resource/manuals'
        for name, expected in result['files'].items():
            self.assertEqual(manuals.digest(output / name), expected)
        self.assertIn('Source: revision', (output / 'manual.txt').read_text())
        self.assertIn('English appendix.', (output / 'translated.txt').read_text())
        self.assertEqual(json.loads((output / 'build-manifest.json').read_text()), result)

    def test_text_parser_handles_missing_optional_attributes(self):
        parser = manuals.Text()
        parser.feed('<p>A<br>B<hr><a>link</a><img><h6>Title</h6><table><tr><th>X</th><td>Y</td></tr></table>')
        self.assertIn('link <>[Image: ] <>', ''.join(parser.parts))


if __name__ == '__main__':
    unittest.main()
