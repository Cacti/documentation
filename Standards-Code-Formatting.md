# Formatting Guidlines

All style guidelines should be followed exactly as shown in these examples
unless indicated otherwise.

## Indenting

Very simply, always use tabs to indent rather than spaces.
Tab stops should be set to 4 spaces.

Below are the vim rules to accomplish this:

```markdown
set expandtab
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
} else if ($var == 1) {
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
    echo "$key = $value\n";
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

Constants should always be in all capital letters. In most cases, they begin
with some identifier. The name should be verbose enough that it describes
**exactly** what the constant represents. Below is the general structure of the
name.

`[identifer]_[type]_[value]`

`Supported graph rendering file types`

```php
define('GRAPH_IMAGE_TYPE_PNG', 1);
define('GRAPH_IMAGE_TYPE_GIF', 2);
```

`Data input types for data sources`

```php
define('DATA_INPUT_TYPE_NONE', 1);
define('DATA_INPUT_TYPE_DATA_QUERY', 2);
define('DATA_INPUT_TYPE_SCRIPT', 3);
define('DATA_INPUT_TYPE_SNMP', 4);
```

## Common Action Types

* list - an array of one or more items

* get - an array with one item or a single value (such as an integer or string)

* remove - some data is to be removed from the database

* update - some pre-existing data is to be updated

* insert - some new data to be saved

* print - information will be echoed to the screen/browser

* generate - data will be generated and returned

* format - data will be passed in, formatted, and then returned

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

As a general rule of thumb, it is ok to include additional spaces where
necessary to improve code readability.
The key here is that writing readable code always takes priority.

### Whitespace

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

Always use constants in place of numbers to represent static values. Instead of
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

Allocating memory for a variable consumes resources. Only declare a variable if
it is referenced more than once throughout the code. Instead of doing:

```php
$num_devices = device_total_num_get();

if ($num_devices > 0) {
    // code
}
```

Do:

```php
if (device_total_num_get() > 0) {
    // code
}
```

### Global Variables

Certain situations warrant creating a single variable that is to be referenced
by multiple functions. Do not rely on PHP's `global` keyword since it creates
the possibility of name space collisions. Instead, create a wrapper function
that brings the variable into a global scope and returns a new copy to any
function that needs to use it.

```php
$graph_unit_exponent_values = array('-18' => 'a - atto', '-15' => 'f - femto', ...);

function graph_unit_exponent_values_list() {
    global $graph_unit_exponent_values;

    return $graph_unit_exponent_values;
}

function graph_unit_exponent_values_print() {
    foreach (graph_unit_exponent_values_list() as $power => $unit) {
        // code
    }
}
```

## References

Copying around large arrays in PHP can be an expensive operation. Be sure to
return or pass arrays by reference when data corruption is not a huge concern.
Keep in mind that call time pass by reference is deprecated in PHP.

```php
function &big_array_list() {
    // code
}
```

```php
function big_array_process(&$big_array) {
    // code
}
```

## Comments

The key to being a respectable coder is to write clear, concise code and to use
comments everywhere.

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
 * split up into multiple lines */
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
 | Copyright (C) 2004-2018 The Cacti Group                                 |
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
 | http://www.cacti.net/                                                   |
 +-------------------------------------------------------------------------+
*/
```

### Function Comments

All functions must be preceded by a comment describing the purpose, argument
list, and return type of the function. It should be formatted as such:

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
 * @return bool true if successful, false otherwise
 */
```
