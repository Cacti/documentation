#!/usr/bin/env python3
"""Validate manual navigation without changing published page URLs.

Copyright (c) 2004-2026 The Cacti Group.
"""
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parent.parent
ENTRY_POINTS = ('README.md', 'Manual-Index.md', 'Project-Information.md')


def targets(text):
    definitions = dict(re.findall(r'^\[([^\]]+)\]:\s*(\S+)', text, re.M))
    result = re.findall(r'!?\[[^\]]*\]\(([^\s)]+)(?:\s+"[^"]*")?\)', text)
    for match in re.finditer(r'\[([^\]]+)\]\[([^\]]*)\]', text):
        key = match[2] or match[1]
        if key in definitions:
            result.append(definitions[key])
        else:
            result.append('MISSING-REFERENCE:' + key)
    return result


def anchors(text):
    result = set(re.findall(r'<a\s+(?:id|name)=[\'\"]([^\'\"]+)', text))
    counts = {}
    fenced = False
    for line in text.splitlines():
        if re.match(r'^\s*(```|~~~)', line):
            fenced = not fenced
        if fenced:
            continue
        heading = re.match(r'^#{1,6}\s+(.+?)\s*#*$', line)
        if heading:
            slug = re.sub(r'[^\w -]', '', heading[1].lower()).replace(' ', '-')
            count = counts.get(slug, 0)
            counts[slug] = count + 1
            result.add(slug + (f'-{count}' if count else ''))
    return result


def manual_pages(root):
    root = root.resolve()
    return set(root.glob('*.md')) | set((root / 'Architecture').glob('*.md'))


def validate(root):
    root = root.resolve()
    errors = []
    linked = set()
    checked = 0
    for name in ENTRY_POINTS:
        source = root / name
        if not source.is_file():
            errors.append({'source': name, 'target': name, 'reason': 'missing entry point'})
            continue
        for href in targets(source.read_text()):
            url = urlsplit(href)
            if url.scheme and not href.startswith('MISSING-REFERENCE:'):
                continue
            checked += 1
            target = (root / unquote(url.path).lstrip('/')).resolve() if url.path.startswith('/') else (source.parent / unquote(url.path)).resolve()
            if not url.path:
                target = source
            reason = None
            if href.startswith('MISSING-REFERENCE:'):
                reason = 'undefined link reference'
            elif not target.is_relative_to(root):
                reason = 'target escapes manual root'
            elif not target.is_file():
                reason = 'missing target'
            elif url.fragment and target.suffix == '.md' and unquote(url.fragment) not in anchors(target.read_text()):
                reason = 'missing heading fragment'
            if reason:
                errors.append({'source': name, 'target': href, 'reason': reason})
            else:
                linked.add(target)
    pages = manual_pages(root)
    unlinked = sorted(str(path.relative_to(root)) for path in pages - linked - {root / name for name in ENTRY_POINTS})
    mapping = root / 'UriMap.json'
    if mapping.exists() and (root / 'README.md').exists():
        homepage_anchors = anchors((root / 'README.md').read_text())
        for href in json.loads(mapping.read_text()).values():
            if href.startswith('/README.md#') and unquote(href.split('#', 1)[1]) not in homepage_anchors:
                errors.append({'source': 'UriMap.json', 'target': href, 'reason': 'missing legacy homepage fragment'})
    return {'manual_pages': len(pages), 'checked_local_links': checked, 'errors': errors, 'unlinked_pages': unlinked}


def ordered_pages(root):
    root = root.resolve()
    report = validate(root)
    if report['errors'] or report['unlinked_pages']:
        raise ValueError('Manual navigation is incomplete: ' + json.dumps(report))
    pages = [root / 'README.md', root / 'Manual-Index.md']
    for href in targets((root / 'Manual-Index.md').read_text()):
        url = urlsplit(href)
        if url.scheme or not url.path.endswith('.md'):
            continue
        target = (root / unquote(url.path)).resolve()
        if target not in pages:
            pages.append(target)
    pages += sorted(manual_pages(root) - set(pages))
    return pages


def main():
    root = ROOT.resolve()
    report = validate(root)
    if len(sys.argv) > 1:
        selected = (root / sys.argv[1]).resolve()
        if not selected.is_relative_to(root) or selected not in manual_pages(root):
            report['errors'].append({'source': 'argument', 'target': sys.argv[1], 'reason': 'not a manual page'})
        elif str(selected.relative_to(root)) in report['unlinked_pages']:
            report['errors'].append({'source': 'argument', 'target': sys.argv[1], 'reason': 'unlinked manual page'})
    (root / 'navigation-report.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    return 1 if report['errors'] or report['unlinked_pages'] else 0


if __name__ == '__main__':
    raise SystemExit(main())
