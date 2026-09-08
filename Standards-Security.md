# Security

## General Validation

Never trust input regardless of where it is coming from! The responsibility
falls on the library functions to ensure that potentially dangerous input does
not introduce a security hole. Some sort of sanitization, validation, or quoting
must be provided for **all** arguments in a function. This ensures that bad
data does not make its way into an SQL string, a filename, an executable, or
even another function.

## Request Validation

For Plugin Developers, Cacti includes settings to allow you to know when
you are using unvalidated data.  They include:

* get_filter_request_var('somevariable') - This function call, by default,
  will validate that the variable `$_REQUEST['somevariable']` returned
  is actually an integer, if not, Cacti will block the page
  function from continuing.

* get_filter_request_var('somevariable', $filter, $options) - The second
  argument is a PHP filter constant such as `FILTER_VALIDATE_INT` or
  `FILTER_VALIDATE_REGEXP`, and the third is the matching options array.
  This form covers the rest of the verification and sanitization cases.

* set_request_var('somevariable', 'somevalue') - This function will set
  the Cacti request variable superglobal with a value.

Generally speaking, you should never use `$_GET`, `$_POST` or `$_REQUEST`
directly in your Cacti code.  Use the validators.  When you do, you can
turn on the Cacti setting `Log Input Validation Issues` when you are
developing, and your Cacti log will include warnings when an invalid
variable has been encountered.

## OS Command Injection

Never pass unsanitized input to shell execution functions (`exec()`,
`shell_exec()`, `system()`, `passthru()`, `popen()`, `proc_open()`). Device
fields, OID strings, community names, and any other user-influenced values
must be treated as untrusted.

Escape every argument with Cacti's `cacti_escapeshellarg()` rather than the
PHP `escapeshellarg()` directly.  The Cacti wrapper strips carriage returns
and line feeds, and it quotes correctly on both Unix and Windows, where
`escapeshellarg()` blanks out percent signs that RRDtool format strings need.
Where a whole command string has to be escaped, use `cacti_escapeshellcmd()`.
Neither function is a substitute for validating the value first: resolve
binaries from a fixed path and check arguments against an expected pattern
before the command is built.

## Prepared Statements

The second method of hardening your Cacti application is through the use
of prepared SQL statements.  A prepared statement sends the query and the
values separately, so a value can never be parsed as SQL.  This removes the
injection risk that string interpolation creates.

Examples of a non-prepared call and its prepared equivalent:

```php
$somevalue = db_fetch_cell("SELECT COUNT(*)
  FROM host
  WHERE id = $somevariable");
```

In the case above, it would be very easy to exploit Cacti.  The example
below is the correct way to protect against attacks.

```php
$somevalue = db_fetch_cell_prepared('SELECT COUNT(*)
  FROM host
  WHERE id = ?',
  array($somevariable));
```

## Output Escaping

Cacti provides an escaping function to reduce the likelihood of XSS
vulnerabilities in Cacti leading to exploitation of other websites.
Cacti itself has a restrictive XSS mitigation policy in effect
by default, but proper output escaping still matters.

The following examples show how, and how not, to escape output:

```php
print "<tr><td>" . $some_variable . "</td></tr>";
```

The print statement above can lead to Stored XSS in your code whenever the
value comes from the database.  Use the following instead:

```php
print "<tr><td>" . html_escape($some_variable) . "</td></tr>";
```

## JavaScript Validation

Relying on JavaScript-based validation is nice for instant feedback to the
user, but should not replace validation checking in the PHP code.

If you follow the simple rules above, your Plugin will be much safer
for others to use and will more easily pass internal security and
pen tests.

## See Also

For OS-level hardening controls covering file permissions, web server access
restrictions, PHP-FPM pool settings, SELinux, and AppArmor, see
[Hardening a Cacti Installation](Hardening-Cacti-Installation.md).

---
Copyright (c) 2004-2026 The Cacti Group
