# File System Layout

Use the target branch's existing structure and naming conventions when adding
files. Some names, including `host` for device-related tables and pages, are
historical compatibility contracts. Do not rename them as incidental cleanup.

## Application entry points

PHP pages in the repository root handle web requests, for example `host.php`,
`graphs.php`, and `data_sources.php`. Authenticated pages load
`include/auth.php`. Administrative command-line tools live under `cli/` and
load `include/cli_check.php`.

The root also contains polling entry points such as `poller.php`, `cmd.php`,
`script_server.php`, and `cactid.php`. These have different responsibilities;
keep scheduling separate from individual data collection scripts.

## Shared code and configuration

- `include/` contains bootstrap, authentication, configuration, global arrays,
  settings, and form definitions. Configure an installation in
  `include/config.php`, using the supplied distribution file as a reference.
- `lib/` contains shared functions and application classes. Existing `api_*`
  files provide management operations; `html_*` files provide rendering and
  form helpers. Keep reusable operations independent of request superglobals.
- `lib/Auth/` and `lib/Console/` contain namespaced classes mapped by Composer
  on the development branch. Check `composer.json` before adding a namespace.
- `include/vendor/` is the Composer installation directory. Declare PHP
  dependencies in `composer.json` and commit the lockfile; do not commit
  installed package trees or edit generated autoload files.

Load dependencies relative to the application base path after bootstrap:

```php
require_once($config['base_path'] . '/lib/api_device.php');
```

## Frontend assets

- `include/themes/` contains themes.
- `include/js/` contains JavaScript assets used by the application.
- `images/` contains application images.
- `build/` contains frontend build instructions and tooling on the development
  branch. Follow its README and the locked npm dependencies when rebuilding
  assets.

## Data collection and extensions

- `resource/` contains XML data-query definitions and other resources.
- `scripts/` contains data collection scripts.
- `plugins/` contains one directory per installed plugin. The directory name
  must match the plugin's expected identifier, and a plugin supplies an `INFO`
  file describing it.
- `locales/po/` contains `cacti.pot` and language source catalogs;
  `locales/LC_MESSAGES/` contains compiled catalogs. Follow the
  [translation workflow](Contributing-Translations.md).

## Runtime files

`rra/`, `log/`, and `cache/` are conventional locations for RRD files, logs,
and cached output. Actual paths depend on installation settings. Give the
poller and web server only the access they need; do not make application code
writable to solve a runtime-directory permission problem.

## Tests and documentation

The development branch keeps PHP tests under `tests/`, with unit tests grouped
by domain under `tests/Unit/`. Follow the target branch's contributor
instructions for test placement, bootstrap, and commands.

Application documentation is under `docs/`; this manual is maintained in the
separate [documentation repository](https://github.com/Cacti/documentation).
Link new manual pages from its `README.md` and use existing image paths where
appropriate.

---

Copyright (c) 2004-2026 The Cacti Group
