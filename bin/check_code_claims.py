#!/usr/bin/env python3
"""Check manual statements that are derived from the Cacti source tree.

Copyright (c) 2004-2026 The Cacti Group. GPL-2.0-or-later.

Usage: bin/check_code_claims.py --cacti PATH [--docs PATH]

PATH is a Cacti checkout of the branch this manual documents. Each check
compares one documented list or value with the file it was copied from, so a
change on either side fails until the other is updated.
"""
import argparse
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent

def section(text, heading):
    """Return the body of the Markdown section that starts with heading."""
    match = re.search(r'^(#+) ' + re.escape(heading) + r'\s*$', text, re.M)
    if not match:
        raise ValueError('Missing section: ' + heading)
    level = len(match.group(1))
    end = re.compile(r'^#{1,%d} ' % level, re.M).search(text, match.end())
    return text[match.end():end.start() if end else len(text)]


def fence_after(text, marker, language):
    """Return the first fenced block of language that follows marker."""
    start = text.find(marker)
    if start < 0:
        raise ValueError('Missing marker: ' + marker)
    match = re.compile(r'^```' + language + r'\n(.*?)^```', re.M | re.S).search(text, start)
    if not match:
        raise ValueError(f'Missing {language} block after: {marker}')
    return match.group(1)


def memory_tables(schema):
    tables, current = set(), None
    for line in schema.splitlines():
        create = re.match(r'CREATE TABLE `(\w+)`', line)
        if create:
            current = create.group(1)
        elif current and re.search(r'ENGINE=MEMORY', line):
            tables.add(current)
    return tables


def check_galera(docs, cacti):
    text = (docs / 'General-Installing-Instructions.md').read_text()
    block = fence_after(text, 'Galera clustering:', 'sql')
    documented = set(re.findall(r'ALTER TABLE `(\w+)` ENGINE=InnoDB;', block))
    expected = memory_tables((cacti / 'cacti.sql').read_text())
    problems = [f'Galera list is missing MEMORY table {t}' for t in sorted(expected - documented)]
    problems += [f'Galera list converts {t}, which cacti.sql does not create as MEMORY'
                 for t in sorted(documented - expected)]
    return problems


def composer(cacti):
    return json.loads((cacti / 'composer.json').read_text())['require']


def check_php_floor(docs, cacti):
    text = (docs / 'Requirements.md').read_text()
    row = re.search(r'^\| PHP \| PHP (\d+\.\d+) or later.*\(`\^(\d+\.\d+)` in Composer\) \|$', text, re.M)
    if not row:
        return ['Requirements.md has no PHP version row']
    constraint = re.fullmatch(r'\^(\d+\.\d+)', composer(cacti)['php'])
    constant = re.search(r"define\('CACTI_PHP_VERSION_MINIMUM', '(\d+\.\d+)\.\d+'\)",
                         (cacti / 'include/global_constants.php').read_text())
    actual = {constraint.group(1) if constraint else composer(cacti)['php'],
              constant.group(1) if constant else 'undefined'}
    if len(actual) != 1:
        return ['composer.json and CACTI_PHP_VERSION_MINIMUM disagree: ' + ', '.join(sorted(actual))]
    floor = actual.pop()
    return [f'Requirements.md states PHP {v}; the source requires {floor}'
            for v in sorted(set(row.groups())) if v != floor]


def check_extensions(docs, cacti):
    body = section((docs / 'Requirements.md').read_text(), 'PHP extensions')
    listed = {name.lower() for name in re.findall(r'`(\w+)`', body)}
    required = {name[4:] for name in composer(cacti) if name.startswith('ext-')}
    return [f'Requirements.md does not list required extension {name}'
            for name in sorted(required) if name.lower() not in listed]


def literal_kind(value):
    value = value.strip()
    if re.fullmatch(r'-?\d+', value):
        return 'integer'
    if value in ('true', 'false'):
        return 'boolean'
    if re.fullmatch(r"'[^']*'|\"[^\"]*\"", value):
        return 'string'
    return 'expression'


def assignments(text, commented=False):
    prefix = r'#?' if commented else ''
    return {name: literal_kind(value) for name, value in
            re.findall(r'^' + prefix + r'\$(\w+)\s*=\s*(.+?);', text, re.M)}


def check_config_examples(docs, cacti):
    dist = (cacti / 'include/config.php.dist').read_text()
    active, all_names = assignments(dist), assignments(dist, commented=True)
    problems = []
    install = (docs / 'General-Installing-Instructions.md').read_text()
    for name, kind in assignments(fence_after(install, 'Edit the copied file', 'php')).items():
        if name not in active:
            problems.append(f'General-Installing-Instructions.md sets ${name}, which config.php.dist does not define')
        elif kind != active[name]:
            problems.append(f'General-Installing-Instructions.md shows ${name} as {kind}; config.php.dist uses {active[name]}')
    remote = (docs / 'How-To-Setup-Remote-Pollers.md').read_text()
    for name in sorted(set(re.findall(r'\$(rdatabase_\w+)', remote))):
        if name not in all_names:
            problems.append(f'How-To-Setup-Remote-Pollers.md uses ${name}, which config.php.dist does not define')
    return problems


CHECKS = (check_galera, check_php_floor, check_extensions, check_config_examples)


def main(argv=None):
    parser = argparse.ArgumentParser(description='Check manual statements derived from the Cacti source.')
    parser.add_argument('--cacti', type=Path, required=True, help='Cacti source checkout')
    parser.add_argument('--docs', type=Path, default=ROOT, help='documentation checkout')
    args = parser.parse_args(argv)
    problems = [problem for check in CHECKS for problem in check(args.docs, args.cacti)]
    for problem in problems:
        print('error: ' + problem, file=sys.stderr)
    print(f'{len(CHECKS)} source-derived checks, {len(problems)} problems')
    return 1 if problems else 0


if __name__ == '__main__':  # pragma: no cover
    sys.exit(main())
