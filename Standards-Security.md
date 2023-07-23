# Security

## General Validation

Never trust input regardless of where it is coming from! The responsibility
falls on the library functions to ensure that potentially dangerous input does
not introduce a security hole. Some sort of sanitation, validation, or quoting
must be provided for **all** arguments in a function. This ensures that bad
data does not make its way into an SQL string, a filename, an executable, or
even another function.

## Request Validation

For Plugin Developers, Cacti includes settings to allow you to know when
you are using unvalidated data.  They include:

* get_filter_request_var('somevariable') - This function call, by default,
  will validate that the variable `$_REQUEST['somevariable']` returned
  is actually an integer, if not, Cacti will block the the page
  function from continuing.

* get_filter_request_var('somevariable', 'options') - This version of the
  function can do all sorts of verification and sanitization.

* set_request_var('somevariable', 'somevalue') - This function will set
  the Cacti request variable superglobal with a value.

Generally speaking, you should never use either `$_GET`, `$_REQUEST` or
`$_POST` in your Cacti code.  Use the validators.  When you do, you can
turn on the Cacti setting `Log Input Validation Issues` when you are
developing, and you Cacti log will include warnings when an unvalidate
variable has been encountered.

## Prepared Statements

The second method of hardening your Cacti application is through the use
of prepared SQL statements.  When you use prepared SQL statements, the
Database API will validate that all variables have been properly escaped
making it much more difficult to perform SQL injection attacks on Cacti.

Examples of non-prepared function calls and prepared include:

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
vulnerabilities in Cacti leading to exploitation of other Web Sites.
Cacti itself has a very restrictive XSS mitigation policy in affect
by default, but following proper output escaping minimizes problems.

The following example is how to, and not to escape output:

```php
print "<tr><td>" . $some_variable . "</td></tr>";
```

Using the print statement above, for values that come from the database
can lead to Stored XSS vunerabilities in your code.  So, it's better
to use the following:

```php
print "<tr><td>" . html_escape($some_variable) . "</td></tr>";
```

## JavaScript Validation

Relying on JavaScript-based validation is nice for instant feedback to the
user, but should not replace validation checking in the PHP code.

If you follow the simple rules above, your Plugin will be much safer
for others to use and will more easily pass internal security and
pen tests.

---
Copyright (c) 2004-2023 The Cacti Group
