# PHP Specific Constructs

Use the PHP range declared in the target branch's `composer.json`, together
with its CI configuration. The development branch requires PHP 8.3 or later
within the declared Composer range; maintenance branches can differ.
Do not introduce syntax or APIs unsupported by the branch being changed.

## Traversing arrays

Use `foreach` to traverse arrays. `each()` was removed in PHP 8.0.

```php
foreach ($devices as $device) {
	// Process the device.
}
```

Define the expected type at the function boundary. If an existing API can
return `false` or `null`, handle that result before iterating or calling
`count()`. Use `is_countable()` when a value can be an array or `Countable`.

## Return values

Preserve the function's documented return contract. Compare strictly when
`false` signals failure and a successful value could be `0` or an empty array.
Do not change a public API's error handling as part of an unrelated fix.

```php
$result = file_get_contents($path);

if ($result === false) {
	// Handle the read failure.
}
```

## String operations and regular expressions

Use string functions for literal operations and `preg_*` functions when the
operation requires a regular expression. The old `ereg*` and `split()` APIs
are unavailable on supported development runtimes.

Prefer single quotes for literal strings. Use double quotes when interpolation
or escape sequences make the code clearer. Do not claim a performance benefit
without measuring the relevant code path.

## Including PHP files

Web entry points that require an authenticated user load `include/auth.php`.
User-facing CLI entry points load `include/cli_check.php`. These bootstrap
files establish the application environment; a CLI entry point must not load
the web authentication bootstrap.

After bootstrap, resolve library paths relative to `$config['base_path']`:

```php
require_once($config['base_path'] . '/lib/api_device.php');
```

Use `require_once` for required libraries that might already be loaded. Follow
the existing entry point's `--help` and `--version` conventions for CLI tools.
Keep request validation and authorization at the appropriate boundaries; see
[Security](Standards-Security.md).

---

Copyright (c) 2004-2026 The Cacti Group
