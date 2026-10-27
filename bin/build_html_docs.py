#!/usr/bin/env python3
# /// script
# requires-python = ">=3.12"
# dependencies = ["markdown-it-py==4.0.0"]
# ///
"""Build every current manual chapter and the legacy HTML entry points.

Copyright (C) 2004-2026 The Cacti Group. GPL-2.0-or-later.
"""
import argparse
from collections import Counter
import hashlib
from html import escape
from html.parser import HTMLParser
import json
import os
import importlib.metadata
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import zipfile
from urllib.parse import unquote, urlsplit, urlunsplit

from markdown_it import MarkdownIt
from markdown_it.token import Token

ROOT = Path(__file__).resolve().parent.parent
ANCHOR = re.compile(r'<a\s+(?:id|name)=["\']([A-Za-z][\w.:-]*)["\']\s*>\s*</a>')


def slug(text):
    return re.sub(r'[^\w -]', '', text.lower()).replace(' ', '-')


def output_name(page):
    if page == Path('README.md'):
        return Path('Table-of-Contents.html')
    # These existing DocBook URLs differ only in case from Markdown filenames.
    # Use their legacy spelling consistently on case-sensitive and macOS disks.
    if page.stem.lower() in {'requirements', 'templates', 'variables', 'cdefs', 'debugging'}:
        return page.with_name(page.name.lower()).with_suffix('.html')
    return page.with_suffix('.html')


def inline_anchors(children):
    """Enable empty compatibility anchors while keeping arbitrary HTML disabled."""
    result = []
    for child in children:
        if child.type != 'text':
            result.append(child)
            continue
        offset = 0
        for match in ANCHOR.finditer(child.content):
            text = Token('text', '', 0)
            text.content = child.content[offset:match.start()]
            result.append(text)
            anchor = Token('html_inline', '', 0)
            anchor.content = '<a id="' + escape(match[1], quote=True) + '"></a>'
            result.append(anchor)
            offset = match.end()
        text = Token('text', '', 0)
        text.content = child.content[offset:]
        result.append(text)
    return result


def rewrite(href, source, root):
    root = root.resolve()
    source = source.resolve()
    url = urlsplit(href)
    if url.scheme and url.scheme not in {'http', 'https', 'mailto', 'ftp'}:
        raise ValueError('Unsupported URL scheme: ' + url.scheme)
    if url.scheme or url.netloc or not url.path:
        return href
    path = unquote(url.path)
    target = (root / path.lstrip('/')).resolve() if path.startswith('/') else (source.parent / path).resolve()
    if not target.is_relative_to(root) or not target.is_file():
        raise ValueError(f'{source.name}: missing or escaping target {href}')
    relative = target.relative_to(root)
    if target.suffix == '.md':
        relative = output_name(relative)
    elif target.suffix == '.php':
        relative = Path(str(relative) + '.txt')
    destination = Path(os.path.relpath(relative, output_name(source.relative_to(root)).parent))
    return urlunsplit(('', '', destination.as_posix(), url.query, url.fragment))


def rewrite_children(children, source, root):
    for child in children:
        attr = 'href' if child.type == 'link_open' else 'src' if child.type == 'image' else None
        if attr:
            child.attrSet(attr, rewrite(child.attrGet(attr) or '', source, root))


def render(source, root):
    md = MarkdownIt('commonmark', {'html': False}).enable(['table', 'strikethrough'])
    tokens = md.parse(source.read_text())
    headings = Counter()
    title = source.stem
    for index, token in enumerate(tokens):
        if token.type == 'heading_open':
            inline = tokens[index + 1]
            text = ''.join(child.content for child in inline.children or [] if child.type != 'html_inline')
            ident = slug(text)
            number = headings[ident]
            headings[ident] += 1
            token.attrSet('id', ident + (f'-{number}' if number else ''))
            if token.tag == 'h1':
                title = text
        if token.children:
            token.children = inline_anchors(token.children)
            rewrite_children(token.children, source, root)
    return title, md.renderer.render(tokens, md.options, {})


def section(body, fragment):
    if not fragment:
        return body
    start = re.search(r'<h([1-6]) id="' + re.escape(escape(fragment, quote=True)) + r'">', body)
    if not start:
        raise ValueError('Missing legacy section: ' + fragment)
    tail = body[start.end():]
    end = re.search(r'<h[1-' + start[1] + r'](?: |>)', tail)
    selected = body[start.start():start.end()] + (tail[:end.start()] if end else tail)
    # A compatibility page containing one section still needs a page title.
    return selected.replace('<h' + start[1] + ' ', '<h1 ', 1).replace('</h' + start[1] + '>', '</h1>', 1)


def document(title, body, prefix, revision, legacy=False):
    notice = '<p>This legacy chapter URL now presents the corresponding current chapter.</p>' if legacy else ''
    return (f'<!doctype html>\n<html lang="en"><head><meta charset="utf-8">'
            '<meta name="viewport" content="width=device-width, initial-scale=1">'
            '<meta http-equiv="Content-Security-Policy" content="default-src &#39;none&#39;; '
            'img-src &#39;self&#39; https:; style-src &#39;self&#39;; base-uri &#39;none&#39;; form-action &#39;none&#39;">'
            f'<title>{escape(title)} | Cacti development manual</title>'
            f'<link rel="stylesheet" href="{prefix}Cacti-Github.css"></head><body>'
            '<nav aria-label="Manual navigation">'
            f'<a href="{prefix}index.html">Cacti manual</a> · '
            f'<a href="{prefix}Manual-Index.html">All chapters</a> · '
            '<a href="https://github.com/Cacti/documentation/tree/1.2.x">Released Cacti 1.2 manual</a></nav>'
            '<p><strong>Version: unreleased Cacti 1.3 development manual.</strong> '
            'Use the released manual for Cacti 1.2 installations.</p>'
            f'{notice}<main>{body}</main><footer><p>Documentation source: {escape(revision)}. '
            'Copyright (c) 2004-2026 The Cacti Group.</p></footer></body></html>\n')


class Links(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        for name in ('href', 'src'):
            if name in attrs:
                self.links.append(attrs[name])


def link_error(href, source, output, pages):
    url = urlsplit(href)
    if url.scheme or url.netloc:
        return None
    target = (source.parent / unquote(url.path)).resolve() if url.path else source
    if not target.is_relative_to(output.resolve()) or not target.is_file():
        return f'{source.name}: missing target {href}'
    if url.fragment and target.suffix == '.html' and unquote(url.fragment) not in pages[target].ids:
        return f'{source.name}: missing fragment {href}'
    return None


def validate(output):
    pages = {}
    for path in output.rglob('*.html'):
        parser = Links()
        parser.feed(path.read_text())
        pages[path.resolve()] = parser
    errors = []
    for source, parser in pages.items():
        for href in parser.links:
            error = link_error(href, source, output, pages)
            if error:
                errors.append(error)
    if errors:
        raise ValueError('\n'.join(errors))
    return len(pages)


def validate_output(root, output):
    if output == root or output in root.parents or (output.is_relative_to(root) and output != root / 'html'):
        raise ValueError('Output must not replace the source tree')
    if output.exists() and any(output.iterdir()):
        marker = output / 'build-manifest.json'
        if not marker.is_file() or json.loads(marker.read_text()).get('generator') != 'cacti-static-manual':
            raise ValueError('Refusing to replace an unrelated directory')


def render_chapters(root, staging, pages, revision):
    rendered = {}
    for source in pages:
        if not source.resolve().is_relative_to(root) or not source.is_file():
            raise ValueError('Invalid chapter source: ' + source.name)
        name = source.relative_to(root)
        title, body = render(source, root)
        rendered[name.as_posix()] = (title, body)
        target = staging / output_name(name)
        target.parent.mkdir(parents=True, exist_ok=True)
        prefix = '../' * (len(name.parts) - 1)
        target.write_text(document(title, body, prefix, revision))
    return rendered


def render_legacy(staging, rendered, mapping, revision):
    for alias in ('index.html', 'README.html'):
        title, body = rendered['README.md']
        anchors = ''.join(f'<a id="{escape(name, quote=True)}"></a>' for name in mapping.get('homepage_fragments', []))
        (staging / alias).write_text(document(title, anchors + body, '', revision))
    for alias, entry in mapping['chapters'].items():
        if Path(alias).name != alias or not alias.endswith('.html'):
            raise ValueError('Invalid legacy filename: ' + alias)
        target = urlsplit(entry['target'])
        title, body = rendered[target.path]
        body = section(body, target.fragment)
        # Preserve incoming DocBook bookmarks even when modern sections differ.
        existing = Links()
        existing.feed(body)
        anchors = ''.join(f'<a id="{escape(name, quote=True)}"></a>' for name in entry['fragments'] if name not in existing.ids)
        (staging / alias).write_text(document(title, anchors + body, '', revision, legacy=True))


def copy_assets(root, staging, assets):
    for name in filter(None, assets):
        source = root / name
        if not source.resolve().is_relative_to(root) or not source.is_file():
            raise ValueError('Invalid asset: ' + name)
        target = staging / (name + '.txt' if source.suffix == '.php' else name)
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    shutil.copyfile(root / 'resources/css/Cacti-Github.css', staging / 'Cacti-Github.css')
    return list(filter(None, assets))


def build(root, output):
    root = root.resolve()
    output = output.resolve()
    validate_output(root, output)
    mapping = json.loads((root / 'resources/build/legacy-html-chapters.json').read_text())
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
    tracked = subprocess.check_output(['git', 'ls-files', '-z', '--', '*.md', 'images', 'resource',
                                       'resources', ':(exclude)resource/html/**'], cwd=root).decode().split('\0')
    pages = sorted(root / name for name in filter(None, tracked)
                   if Path(name).suffix == '.md' and Path(name).parent.as_posix() in {'.', 'Architecture', 'resources/build', 'resources/manuals'})
    assets = [name for name in tracked if name.startswith(('images/', 'resource/', 'resources/'))]
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='cacti-html-', dir=output.parent) as temporary:
        staging = Path(temporary)
        rendered = render_chapters(root, staging, pages, revision)
        render_legacy(staging, rendered, mapping, revision)
        assets = copy_assets(root, staging, assets)
        count = validate(staging)
        manifest = {'generator': 'cacti-static-manual', 'source_revision': revision,
                    'manual_version': 'develop', 'chapters': len(pages), 'html_pages': count,
                    'legacy_chapters': len(mapping['chapters']),
                    'renderer': importlib.metadata.version('markdown-it-py'),
                    'assets': {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in filter(None, assets)},
                    'build_inputs': {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in
                                     ['bin/build_html_docs.py', 'bin/build_html_docs.py.lock',
                                      'resources/build/legacy-html-chapters.json', 'resources/css/Cacti-Github.css']},
                    'sources': {p.relative_to(root).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest() for p in pages}}
        (staging / 'build-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
        if output.exists():
            shutil.rmtree(output)
        shutil.copytree(staging, output)
    return manifest


def archive(output, destination):
    """Package identical built files with stable timestamps and a checksum."""
    destination = destination.resolve()
    if destination.is_relative_to(output.resolve()):
        raise ValueError('Archive must be outside the manual directory')
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as bundle:
        for path in sorted(output.rglob('*')):
            if path.is_file():
                entry = zipfile.ZipInfo(path.relative_to(output).as_posix(), date_time=(1980, 1, 1, 0, 0, 0))
                entry.compress_type = zipfile.ZIP_DEFLATED
                entry.external_attr = 0o100644 << 16
                bundle.writestr(entry, path.read_bytes(), compresslevel=9)
    checksum = hashlib.sha256(destination.read_bytes()).hexdigest()
    destination.with_suffix(destination.suffix + '.sha256').write_text(checksum + '  ' + destination.name + '\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'html')
    parser.add_argument('--archive', type=Path)
    args = parser.parse_args()
    report = build(ROOT, args.output)
    if args.archive:
        archive(args.output, args.archive)
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
