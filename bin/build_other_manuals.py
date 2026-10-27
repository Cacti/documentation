#!/usr/bin/env python3
"""Build text editions and replacements for historical contributed manuals.

Copyright (c) 2004-2026 The Cacti Group. GPL-2.0-or-later.
Run through build_pdf_docs.py --companions using its committed dependency lock.
"""
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import textwrap
from urllib.parse import unquote, urlsplit

from check_navigation import ordered_pages
from markdown_it import MarkdownIt


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def local(root, name):
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise ValueError('Missing or escaping edition source: ' + name)
    return path


def schema_reference(root):
    folder = root / 'resources/manuals'
    provenance = json.loads((folder / 'schema-source.json').read_text())
    source = folder / 'source/cacti.sql'
    if digest(source) != provenance['sha256']:
        raise ValueError('Schema source checksum differs from its provenance')
    sql = source.read_text()
    tables = re.findall(r'^CREATE TABLE `([^`]+)` \(\n(.*?);[ \t]*$', sql, re.M | re.S)
    if not tables or len(tables) != len(re.findall(r'^CREATE TABLE ', sql, re.M)):
        raise ValueError('Cannot account for every CREATE TABLE statement')
    lines = ['# Cacti development database schema reference', '',
             'This is a reference for the base schema at the pinned Cacti develop',
             'revision below, not an upgrade script or a complete installation dump.',
             'Plugin tables and changes applied by later upgrade code are outside',
             'this snapshot. Logical relationships are not inferred as foreign keys.', '',
             f"Source revision: `{provenance['revision']}`.", '',
             '[Upstream schema][schema-source].', '',
             f'Tables: {len(tables)}. Source SHA-256: `{provenance["sha256"]}`.', '',
             'The SQL download contains only the original CREATE TABLE statements.',
             'It omits seed rows, session settings, and database alteration statements.',
             'Use the schema bundled with your exact Cacti release for a new',
             'installation. Never import this reference over an existing database.', '']
    ddl = []
    for name, body in tables:
        statement = f'CREATE TABLE `{name}` (\n{body};'
        ddl.append(statement)
        lines += [f'## {name}', '', '```sql', statement, '```', '']
    lines += ['[schema-source]:', f"  <{provenance['repository']}/blob/{provenance['revision']}/cacti.sql>", '',
              '---', '', 'Copyright (c) 2004-2026 The Cacti Group', '']
    rendered = []
    fenced = False
    for line in "\n".join(lines).split("\n"):
        if line.startswith('```'):
            fenced = not fenced
        if not fenced and len(line) > 79 and not line.startswith('  <'):
            rendered.extend(textwrap.wrap(line, width=79, break_long_words=False, break_on_hyphens=False))
        else:
            rendered.append(line.rstrip())
    (folder / 'Schema-Reference.md').write_text('\n'.join(rendered))
    return provenance, tables, '\n\n'.join(ddl) + '\n'


class Text(HTMLParser):
    """Retain examples, image descriptions, and link destinations in UTF-8 text."""
    def __init__(self):
        super().__init__()
        self.parts = []
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag in {'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'pre', 'tr', 'blockquote'}:
            if not (tag == 'p' and self.parts and self.parts[-1].endswith('* ')):
                self.parts.append('\n\n')
        if tag == 'li':
            self.parts.append('\n* ')
        if tag in {'td', 'th'}:
            self.parts.append('\t')
        if tag in {'br', 'hr'}:
            self.parts.append('\n')
        if tag == 'a':
            self.links.append(attrs.get('href', ''))
        if tag == 'img':
            self.parts.append('[Image: ' + attrs.get('alt', '') + '] <' + attrs.get('src', '') + '>')

    def handle_endtag(self, tag):
        if tag == 'a':
            self.parts.append(' <' + self.links.pop() + '>')

    def handle_data(self, data):
        if not data.strip() and self.parts and self.parts[-1].endswith('* '):
            return
        self.parts.append(data)


def plain(source, root, revision):
    root, source = root.resolve(), source.resolve()
    md = MarkdownIt('commonmark', {'html': False}).enable(['table', 'strikethrough'])
    content = re.sub(r'<a\s+(?:id|name)=["\'][^"\']+["\']\s*>\s*</a>', '', source.read_text())
    tokens = md.parse(content)
    for token in tokens:
        for child in token.children or []:
            attr = 'href' if child.type == 'link_open' else 'src' if child.type == 'image' else None
            if attr:
                href = child.attrGet(attr) or ''
                url = urlsplit(href)
                if not url.scheme and not url.netloc:
                    target = local(root, str(source.parent.relative_to(root) / unquote(url.path))) if url.path else source
                    child.attrSet(attr, 'https://github.com/Cacti/documentation/blob/' + revision + '/' +
                                  target.relative_to(root).as_posix() + ('#' + url.fragment if url.fragment else ''))
    output = Text()
    output.feed(md.renderer.render(tokens, md.options, {}))
    return '\n'.join(line.rstrip() for line in ''.join(output.parts).strip().splitlines()) + '\n'


def build(root, revision, built, pdf_builder):
    root = root.resolve()
    folder = root / 'resource/manuals'
    folder.mkdir(parents=True, exist_ok=True)
    (folder / 'build-manifest.json').touch()
    provenance, tables, ddl = schema_reference(root)
    (folder / 'cacti-schema.sql').write_text('-- Reference only; not an installation or upgrade script.\n' + ddl)
    pages = ordered_pages(root)
    specs = json.loads((root / 'resources/manuals/editions.json').read_text())
    manifest = {'source_revision': revision, 'manual_version': 'unreleased Cacti 1.3 develop',
                'build_date': built, 'schema_source': provenance, 'schema_tables': len(tables),
                'build_inputs': {name: digest(root / name) for name in
                                 ('bin/build_other_manuals.py', 'bin/build_pdf_docs.py',
                                  'bin/build_pdf_docs.py.lock', 'bin/check_navigation.py',
                                  'resources/css/pdf.css', 'resources/manuals/editions.json',
                                  'resources/manuals/archive-inventory.json')}, 'editions': {}}
    editions = [{'id': 'manual', 'pages': 'all', 'guide': None, 'language': 'en'}, *specs]
    for spec in editions:
        (folder / (spec['id'] + '.txt')).touch()
    prepared = []
    for spec in editions:
        selected = pages if spec['pages'] == 'all' else [local(root, name) for name in spec['pages']]
        if spec['guide']:
            selected = [local(root, 'resources/manuals/' + spec['guide']), *selected]
        title = selected[0].read_text().splitlines()[0].lstrip('# ')
        prepared.append((spec, selected, title))
        info = {'language': spec['language'], 'sources': {str(p.relative_to(root)): digest(p) for p in selected}}
        if spec['id'] != 'manual':
            pdf = folder / (spec['id'] + '.pdf')
            pdf_builder(pdf, revision, built, paths=selected, title=title, language=spec['language'])
        manifest['editions'][spec['id']] = info
    for spec, selected, title in prepared:
        output = folder / (spec['id'] + '.txt')
        output.write_text(f'{title}\nUnreleased Cacti 1.3 develop\nSource: {revision}\nBuilt: {built}\n\n' +
                          '\n\n'.join(plain(path, root, revision) for path in selected))
    manifest['files'] = {p.name: digest(p) for p in sorted(folder.iterdir()) if p.suffix in {'.pdf', '.txt', '.sql'}}
    (folder / 'build-manifest.json').write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + '\n')
    return manifest
