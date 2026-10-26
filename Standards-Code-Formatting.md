# Formatting Guidelines

## Overview

Follow the target branch's `.php-cs-fixer.php` and contributor instructions.
The development branch exposes `composer php-cs-fixer` for a dry run and
`composer php-cs-fixit` to apply formatting. Inspect formatter changes and
avoid unrelated formatting in a focused fix.

Cacti uses conventions based on
[PSR-12](https://www.php-fig.org/psr/psr-12/) with project-specific exceptions.
The checked-in formatter configuration takes precedence over these examples.

The main conventions are:

- Initial white space must be tabs not spaces followed by the use of spaces to
   align elements after initial tab.

- In a block of variable assignments or array elements (moved to multi-line) it
   is acceptable, but not required, to use spaces to align the `=` or `=>` for
   purpose of readability.

- Bracketing/braces should start on the same line of the statement.  For
   example:
   - `if (expression) {`,
   - `} else {`,
   - and `} elseif (expression) {`

- Use lower case constants for things like `false`, `true`, and `null`.

- Use `print` over `echo`.

- Function declarations should include opening braces on the same line as
   the function.  For example:
   - `function name($params ...) {`

- White-space inside of evaluations is discouraged.  For example:
   - `if (expression) {` and not `if ( expression ) {`.

- Prefer single quotes for literal strings. Use double quotes for interpolation
   or escape sequences. Use short array syntax on the development branch;
   preserve compatibility with the target branch.

All style guidelines should be followed exactly as shown in these examples,
unless indicated otherwise.

## Indenting

Very simply, always use tabs to indent rather than spaces.
Tab stops should be set to 4 spaces.

Below are the vim rules to accomplish this:

```console
set noexpandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
```

## Control Structures

Use the following style guidelines for control structures.

### if elseif else Construct

```php
if ($var == 0) {
    $i++;
} elseif ($var == 1) {
    $i--;
} else {
    $i = 0;
}
```

### switch Construct

```php
switch ($var) {
    case 0:
        $var = 1;

        break;
    case 1:
        $var = 2;

        break;
    default:
        $var = 3;

        break;
}
```

### while Loop

```php
while ($i < 10) {
    $i++;
}
```

### for Loop

```php
for ($i = 0; $i < 10; $i++) {
    $var *= 6;
}
```

### foreach Loop

```php
foreach ($array as $key => $value) {
    print "$key = $value\n";
}
```

## Naming

### General Function Naming

All function names should begin with an identifier (see below) and end with
an action.
The identifier should generally be derived from the name of the file which
the function resides.

`Returns all users`

```php
function user_list() {
    // code
}
```

`Returns a specific user`

```php
function user_get($user_id) {
    // code
}
```

`Returns the total number of graphs`

```php
function graph_total_get() {
    // code
}
```

`Returns a specific graph title`

```php
function graph_title_get() {
    // code
}
```

### Constant Naming

Constants should always be all capital letters. In most cases, they begin
with some identifier. The name should be verbose enough that it describes
**exactly** what the constant represents. Below is the general structure of the
name.

`[identifier]_[type]_[value]`

`Examples of application constants`

```php
define('DATA_INPUT_TYPE_SCRIPT', 1);
define('DATA_INPUT_TYPE_SNMP', 2);
```

`Data input types for data sources`

```php
define('DATA_INPUT_TYPE_SNMP_QUERY', 3);
define('DATA_INPUT_TYPE_SCRIPT_QUERY', 4);
```

## Common Action Types

- list - an array of one or more items

- get - an array with one item or a single value (such as an integer or string)

- remove - some data is to be removed from the database

- update - some pre-existing data is to be updated

- insert - some new data to be saved

- print - information will be echoed to the screen/browser

- generate - data will be generated and returned

- format - data will be passed in, formatted, and then returned

## Formatting

### Argument Spacing

Always include a single space after each argument in a list except for the last
one.

```php
function log_insert($facility, $severity, $message) {
    // code
}
```

```php
log_insert(LOG_FACILITY_LOCAL0, LOG_LEVEL_WARNING, 'test message');
```

As a general rule of thumb, it is OK to include additional spaces where
necessary to improve code readability.
The key here is that writing readable code always takes priority.

### White space

Always place a single blank line after a control structure unless the following
line is an ending brace `}`.  There should be no blank lines at the end of the
file, and no spaces at the end of line.

```php
if ($var == 0) {
    $i = 0;
}

if ($i == 0) {
    $i *= 2;
}
```

```php
if ($var ==0) {
    if ($i == 2) {
        $i++;
    }
}
```

## Storage Constructs

### Constants

Always use constants instead of numbers to represent static values. Instead of
doing:

```php
if ($poller_verbosity == 2) {
    // code
}
```

Do:

```php
if ($poller_verbosity == POLLER_VERBOSITY_LOW) {
    // code
}
```

### Variables

Use a local variable when it clarifies intent, avoids repeated work, or makes
error handling explicit. Do not sacrifice readability to avoid an assignment.

### Global Variables

Use explicit arguments and return values for new shared code where practical.
Preserve existing global-state contracts when fixing legacy functions. Do not
introduce additional global state as an incidental part of a focused change.

## References

Pass arrays by value unless the function is intended to modify the caller's
array. PHP uses copy-on-write; adding references is not a general performance
optimization. Document intentional mutation and measure performance-sensitive
changes against the actual call path.

## Database Calls

Ensure that you indent your Database calls by a single tab per indentation level
and that you break up database calls by the various provisos.  A few well
defined
database queries can be seen in the examples below

```php
$devices = db_fetch_assoc_prepared('SELECT *
  FROM host
  WHERE id = ?',
  [$device_id]);

$vdefs = db_fetch_assoc("SELECT rs.*,
  SUM(CASE WHEN local_graph_id = 0 THEN 1 ELSE 0 END) AS templates,
  SUM(CASE WHEN local_graph_id > 0 THEN 1 ELSE 0 END) AS graphs
  FROM (
    SELECT vd.*, gti.local_graph_id
    FROM vdef AS vd
    LEFT JOIN graph_templates_item AS gti
    ON gti.vdef_id = vd.id
    GROUP BY vd.id, gti.graph_template_id, gti.local_graph_id
  ) AS rs
  $sql_where
  GROUP BY rs.id
  $sql_having
  $sql_order
  $sql_limit");
```

1) Use prepared statements for values, as in the first example.

2) Build dynamic identifiers and SQL fragments from explicit allowlists.
Do not concatenate untrusted values into SQL.

3) Always use the term `AS` to define an alias.

4) Ensure that your JOINs are either INNER, LEFT, or RIGHT.

5) Ensure that the ON clause uses table aliases, and that each
  `AND` or `OR` expression is logically organized for easy reading
  and interpretation.

6) In your SQL WHERE and SELECT, where functions are involved

    1. Ensure that there are spaces between parameter
    2. Ensure operators and variables are separated by spaces

## Comments

Explain intent, constraints, and non-obvious behavior. Keep comments consistent
with the code and avoid comments that merely restate an assignment or test.

### Whole Line Comments

All single and multi-line comments should follow the C-style syntax.

```php
/* this determines if $i is equal to 0 */
if ($i == 0) {
    // code
}
```

```php
/* this is an extra long comment that deserves to be
 * split up into multiple lines
 */
if ($i == 0) {
    // code
}
```

### End of Line Comments

Shorter comments that follow a line of code should use the familiar `//` style.

```php
$var = 0; // assign 0 to $var
```

### File Header Comments

All code related files must contain the following notice at the beginning of
the file.

```php
/*
 +-------------------------------------------------------------------------+
 | Copyright (C) 2004-2026 The Cacti Group                                 |
 |                                                                         |
 | This program is free software; you can redistribute it and/or           |
 | modify it under the terms of the GNU General Public License             |
 | as published by the Free Software Foundation; either version 2          |
 | of the License, or (at your option) any later version.                  |
 |                                                                         |
 | This program is distributed in the hope that it will be useful,         |
 | but WITHOUT ANY WARRANTY; without even the implied warranty of          |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |
 | GNU General Public License for more details.                            |
 +-------------------------------------------------------------------------+
 | Cacti: The Complete RRDtool-based Graphing Solution                     |
 +-------------------------------------------------------------------------+
 | This code is designed, written, and maintained by the Cacti Group. See  |
 | about.php and/or the AUTHORS file for specific developer information.   |
 +-------------------------------------------------------------------------+
 | https://www.cacti.net/                                                   |
 +-------------------------------------------------------------------------+
*/
```

### Function Comments

All functions must be preceded by a comment describing the purpose, argument
list, and return type of the function. It should be formatted per
PHP DocBlock specifications as follow:

```php
/**
 * Makes a connection to the database server
 *
 * Given a set of login credentials, an attempt is made to establish a persistent database connection.
 * If the attempt fails, script execution will halt with an error.
 *
 * @param string $host the hostname of the database server, 'localhost' if the database server is running
 *   on this machine
 * @param string $user the username to connect to the database server as
 * @param string $pass the password to connect to the database server with
 * @param string $db_name the name of the database to connect to
 * @param string $db_type the type of database server to connect to, only 'mysql' is currently supported
 * @param int $retries the number a time the server should attempt to connect before failing
 *
 * @return bool true if successful, false otherwise
 */
```

Place a space between the `@param` and `@return`.

---
Copyright (c) 2004-2026 The Cacti Group
