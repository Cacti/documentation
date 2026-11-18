"""Tests for bin/check_code_claims.py using small source and manual fixtures."""
import contextlib
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import check_code_claims as claims

SCHEMA = """CREATE TABLE `poller_output` (
  `local_data_id` int(10) unsigned NOT NULL
) ENGINE=MEMORY;
CREATE TABLE `processes` (
  `pid` int(10) unsigned NOT NULL
) ENGINE=MEMORY;
CREATE TABLE `host` (
  `id` int(10) unsigned NOT NULL
) ENGINE=InnoDB;
"""

INSTALL = """# Installing

Galera clustering: convert these tables.

```sql
MariaDB [cacti]> ALTER TABLE `poller_output` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `processes` ENGINE=InnoDB;
```

Edit the copied file to match the account created above:

```php
$database_hostname = 'localhost';
$database_port     = 3306;
```
"""

REQUIREMENTS = """# Requirements

| Component | Requirement |
| --- | --- |
| PHP | PHP 8.3 or later in the PHP 8 series (`^8.3` in Composer) |

### PHP extensions

- `gd`, `PDO`, and `posix`.

### Composer and source deployments

Run `composer install`.
"""

REMOTE = """# Remote pollers

```php
$rdatabase_hostname = 'main';
$rdatabase_ssl_capath = '';
```
"""

CONFIG = """<?php
$database_hostname    = 'localhost';
$database_port        = 3306;
$database_ssl         = false;
#$rdatabase_hostname  = 'localhost';
#$rdatabase_ssl_capath = '';
"""


class CodeClaimsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        base = Path(self.temp.name)
        self.docs, self.cacti = base / 'docs', base / 'cacti'
        (self.cacti / 'include').mkdir(parents=True)
        self.docs.mkdir()
        self.write(self.docs / 'General-Installing-Instructions.md', INSTALL)
        self.write(self.docs / 'Requirements.md', REQUIREMENTS)
        self.write(self.docs / 'How-To-Setup-Remote-Pollers.md', REMOTE)
        self.write(self.cacti / 'cacti.sql', SCHEMA)
        self.write(self.cacti / 'include/config.php.dist', CONFIG)
        self.write(self.cacti / 'include/global_constants.php',
                   "<?php\ndefine('CACTI_PHP_VERSION_MINIMUM', '8.3.0');\n")
        self.composer({'php': '^8.3', 'ext-gd': '*', 'ext-PDO': '*', 'ext-posix': '*', 'psr/log': '^3.0'})

    @staticmethod
    def write(path, text):
        path.write_text(text)

    def composer(self, require):
        self.write(self.cacti / 'composer.json', json.dumps({'require': require}))

    def edit(self, name, old, new):
        path = self.docs / name
        text = path.read_text()
        self.assertIn(old, text)
        path.write_text(text.replace(old, new))

    def run_checks(self):
        out, err = io.StringIO(), io.StringIO()
        with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
            status = claims.main(['--cacti', str(self.cacti), '--docs', str(self.docs)])
        return status, err.getvalue()

    def test_matching_manual_passes(self):
        self.assertEqual(self.run_checks(), (0, ''))

    def test_galera_list_must_match_memory_tables(self):
        self.edit('General-Installing-Instructions.md',
                  "MariaDB [cacti]> ALTER TABLE `processes` ENGINE=InnoDB;\n",
                  "MariaDB [cacti]> ALTER TABLE `host` ENGINE=InnoDB;\n")
        status, errors = self.run_checks()
        self.assertEqual(status, 1)
        self.assertIn('missing MEMORY table processes', errors)
        self.assertIn('converts host', errors)

    def test_php_floor_must_match_composer_and_constant(self):
        self.composer({'php': '^8.4', 'ext-gd': '*', 'ext-PDO': '*', 'ext-posix': '*'})
        self.assertIn('disagree: 8.3, 8.4', self.run_checks()[1])
        self.write(self.cacti / 'include/global_constants.php',
                   "<?php\ndefine('CACTI_PHP_VERSION_MINIMUM', '8.4.0');\n")
        self.assertIn('states PHP 8.3; the source requires 8.4', self.run_checks()[1])

    def test_php_row_and_constant_must_exist(self):
        self.edit('Requirements.md', '| PHP | PHP 8.3', '| PHP | 8.3')
        self.assertIn('no PHP version row', self.run_checks()[1])
        self.edit('Requirements.md', '| PHP | 8.3', '| PHP | PHP 8.3')
        self.write(self.cacti / 'include/global_constants.php', '<?php\n')
        self.composer({'php': '>=8.3', 'ext-gd': '*', 'ext-PDO': '*', 'ext-posix': '*'})
        self.assertIn('disagree: >=8.3, undefined', self.run_checks()[1])

    def test_required_extensions_must_be_listed(self):
        self.composer({'php': '^8.3', 'ext-gd': '*', 'ext-PDO': '*', 'ext-posix': '*', 'ext-intl': '*'})
        self.assertIn('required extension intl', self.run_checks()[1])

    def test_config_example_names_and_types_follow_dist(self):
        self.edit('General-Installing-Instructions.md', '$database_port     = 3306;',
                  "$database_port     = '3306';\n$database_typo = 'x';")
        errors = self.run_checks()[1]
        self.assertIn('$database_port as string; config.php.dist uses integer', errors)
        self.assertIn('sets $database_typo', errors)

    def test_remote_poller_variables_must_exist(self):
        self.edit('How-To-Setup-Remote-Pollers.md', '$rdatabase_ssl_capath', '$rdatabase_ssl_path')
        self.assertIn('uses $rdatabase_ssl_path', self.run_checks()[1])

    def test_literal_kinds(self):
        self.assertEqual([claims.literal_kind(v) for v in ('-5', 'true', '"x"', 'CONSTANT')],
                         ['integer', 'boolean', 'string', 'expression'])

    def test_missing_structure_is_reported(self):
        with self.assertRaisesRegex(ValueError, 'Missing section'):
            claims.section('# Title\n', 'PHP extensions')
        with self.assertRaisesRegex(ValueError, 'Missing marker'):
            claims.fence_after('text', 'Galera clustering:', 'sql')
        with self.assertRaisesRegex(ValueError, 'Missing sql block'):
            claims.fence_after('Galera clustering: none', 'Galera clustering:', 'sql')

    def test_last_section_runs_to_end_of_file(self):
        self.assertEqual(claims.section('## A\nbody\n', 'A'), '\nbody\n')


if __name__ == '__main__':
    unittest.main()
