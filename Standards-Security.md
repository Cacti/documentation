# Security

## Report vulnerabilities privately

Follow the [Cacti security policy][ref-1]
for suspected vulnerabilities. Keep exploit details and credentials out of
public issues and pull requests until disclosure is coordinated.

## Authentication and authorization

Authenticated web entry points load `include/auth.php`. Check the user's realm
and object permissions before returning protected data or changing state.
Hiding a button or filtering a browser view does not enforce authorization.
Shared management functions must not assume that a caller owns an object just
because its ID is valid.

Protect cookie-authenticated changes with Cacti's CSRF mechanism. Use POST for
mutations and include the expected `__csrf_magic` token in forms and AJAX
requests. Do not implement state changes through GET requests.

## Request validation

Treat request data, device responses, plugin output, and database content as
untrusted. Validate each value for its intended use. Cacti provides request
helpers in `lib/html_utility.php`:

- `get_filter_request_var()` (also `gfrv()`) validates an integer by default
  and supports PHP filter constants and options for other types.
- `get_request_var()` (`grv()`) retrieves request data; retrieval alone does
  not establish that the value is valid for a particular use.
- `set_request_var()` (`srv()`) stores a request value; it is not a validator.

A value already validated in the request cache need not be validated again in
every getter. Preserve the validation contract and check lengths, ranges,
allowed choices, and permissions where required. The **Log Input Validation
Issues** setting helps identify missing validation during development.

## SQL statements

Use Cacti's prepared database helpers for values:

```php
$hostname = db_fetch_cell_prepared('SELECT hostname
	FROM host
	WHERE id = ?',
	[$device_id]);
```

Placeholders bind values, not identifiers or SQL fragments. Build dynamic
column names, sort directions, and table names from an explicit allowlist.
See [SQL Standards](Standards-SQL.md).

## OS commands and paths

Prefer an existing API or process helper over constructing shell commands.
When a shell command is required, validate values and escape each argument
using the target branch's Cacti helpers. On the development branch, use
`cacti_escapeshellarg_cmd()` for arguments reaching Windows `cmd.exe`, and
`cacti_escapeshellarg()` for the supported non-cmd path.
A whole-command escape is not a substitute for argument escaping.

Use configured binary paths and restrict user-selected paths to the intended
location. Check ownership and permissions before reading, replacing, or
deleting files. Do not solve permission errors by making application code or
credential files writable by everyone.

## Output escaping

Escape values for the context where they are rendered. HTML text, HTML
attributes, JavaScript, URLs, and shell arguments require different handling.
On the development branch, use `html_escape()` for HTML text and
`html_escape_attr()` for attribute values. Check helper availability before
backporting to another branch.

```php
print '<td>' . html_escape($description) . '</td>';
```

When building browser content, use `textContent` for plain text and DOM methods
for elements. Do not concatenate untrusted values into HTML, inline event
handlers, or executable JavaScript. Validate dynamic URLs for the intended
protocol and destination before escaping them for an attribute.

For intentionally supported HTML, use the application's reviewed sanitization
path. Sanitize after Markdown or other markup conversion and do not append
untrusted markup afterward. A content security policy supplements these
controls;
it does not replace validation, authorization, or output escaping.

## Browser and server checks

Browser validation gives prompt feedback, but enforce validation and
permissions on the server. Test realistic denied-access cases as well as valid
requests when changing a security boundary.

## See also

[Hardening a Cacti Installation](Hardening-Cacti-Installation.md) covers
installation permissions and operating-system controls.

[ref-1]: https://github.com/Cacti/cacti/security/policy

---

Copyright (c) 2004-2026 The Cacti Group
