#!/usr/bin/env python3
"""Check the real PDF/text publication outputs, not mocked renderer results."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from build_other_manuals import local, plain, schema_reference
from build_pdf_docs import chapter_id
from check_navigation import ordered_pages
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[2]
FOLDER = ROOT / 'resource/manuals'


def hashes(folder, entries):
    for name, expected in entries.items():
        actual = hashlib.sha256(local(folder, name).read_bytes()).hexdigest()
        if actual != expected:
            raise ValueError('Publication checksum mismatch: ' + name)


def pdf(path, pages):
    reader = PdfReader(path, strict=True)
    destinations = reader.named_destinations
    for source in pages:
        if chapter_id(source) not in destinations:
            raise ValueError(f'{path.name}: missing chapter {source.name}')
    for page in reader.pages:
        for reference in page.get('/Annots', []):
            annotation = reference.get_object()
            destination = annotation.get('/Dest')
            action = annotation.get('/A', {})
            if action.get('/S') == '/GoTo':
                destination = action.get('/D')
            if isinstance(destination, str) and destination not in destinations:
                raise ValueError(f'{path.name}: broken internal destination {destination}')
    return reader


def main():
    manifest = json.loads((FOLDER / 'build-manifest.json').read_text())
    hashes(FOLDER, manifest['files'])
    hashes(ROOT, manifest['build_inputs'])
    specs = json.loads((ROOT / 'resources/manuals/editions.json').read_text())
    specs = [{'id': 'manual', 'pages': 'all', 'guide': None, 'language': 'en'}, *specs]
    expected_files = {'cacti-schema.sql', 'manual.txt'}
    for spec in specs[1:]:
        expected_files.update({spec['id'] + '.pdf', spec['id'] + '.txt'})
    if set(manifest['files']) != expected_files:
        raise ValueError('Missing or unexpected edition output')
    complete = ordered_pages(ROOT)
    evidence = {'source_revision': manifest['source_revision'], 'editions': {}, 'complete': False}
    for spec in specs:
        entry = manifest['editions'][spec['id']]
        selected = complete if spec['pages'] == 'all' else [ROOT / name for name in spec['pages']]
        if spec['guide']:
            selected = [ROOT / 'resources/manuals' / spec['guide'], *selected]
        if set(entry['sources']) != {p.relative_to(ROOT).as_posix() for p in selected}:
            raise ValueError('Edition has an incomplete appendix: ' + spec['id'])
        hashes(ROOT, entry['sources'])
        text = (FOLDER / (spec['id'] + '.txt')).read_text()
        for page in selected:
            if plain(page, ROOT, manifest['source_revision']) not in text:
                raise ValueError('Missing text chapter: ' + str(page))
        path = ROOT / 'resource/pdf/cacti-manual.pdf' if spec['id'] == 'manual' else FOLDER / (spec['id'] + '.pdf')
        reader = pdf(path, selected)
        if spec['guide']:
            title = selected[0].read_text().splitlines()[0].lstrip('# ')
            if title not in reader.pages[0].extract_text():
                raise ValueError('Missing localized PDF cover text: ' + spec['id'])
        evidence['editions'][spec['id']] = {'chapters': len(selected), 'pdf_pages': len(reader.pages),
                                          'pdf_destinations': len(reader.named_destinations), 'text_bytes': len(text.encode())}
    _, tables, ddl = schema_reference(ROOT)
    if len(tables) != manifest['schema_tables'] or ddl not in (FOLDER / 'cacti-schema.sql').read_text():
        raise ValueError('Schema output differs from the pinned source')
    archives = json.loads((ROOT / 'resources/manuals/archive-inventory.json').read_text())['originals']
    if len(archives) != 11 or any(p['status'] != 'archive' for p in archives):
        raise ValueError('Original contributed manual inventory is incomplete')
    # This guide contains the populated graph screenshot and its explicit caption.
    guide = PdfReader(FOLDER / 'install-linux.pdf')
    page = next(i for i, p in enumerate(guide.pages, 1) if 'historical example measurements' in p.extract_text())
    previews = ROOT / 'manual-artifacts'
    previews.mkdir(exist_ok=True)
    subprocess.run(['pdftoppm', '-f', str(page), '-singlefile', '-scale-to', '1440', '-png',
                    str(FOLDER / 'install-linux.pdf'), str(previews / 'linux-populated-graph')], check=True)
    evidence.update({'complete': True, 'schema_tables': len(tables), 'archived_originals': len(archives),
                     'preview_pdf_page': page})
    (previews / 'publication-evidence.json').write_text(json.dumps(evidence, indent=2) + '\n')
    print(json.dumps(evidence, indent=2))


if __name__ == '__main__':
    main()
