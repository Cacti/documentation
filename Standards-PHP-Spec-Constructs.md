# PHP Specific Constructs

## Traversing Arrays

Use the ```foreach ($array as $name => $value)``` syntax instead of ```while
(list($name, $value) = each($array))``` syntax when traversing arrays. The
former has been demonstrated to be more efficient and does not increment the
internal pointer of the array. The `foreach` construct will error if the array
is empty or is not an array, so you must check this first.

```php
if ((is_array($array)) && (sizeof($array) > 0)) {
    foreach ($array as $name => $value) {
        // code
    }
}
```

It should be noted that with PHP 7.2 use of `list() = each()` syntax will result
in warnings and/or errors.  It should also be noted that 7.2 also introduced the
need for the variable to implement ICountable which are arrays and objects.  You
should therefore check if `variable !=== false` before using `sizeof()` or
`count()`

## Error Return Values

When an a function needs to return a generic error, it is best to return boolean
`false` in PHP. This makes it very straightforward to check for.

```php
if (file_list() === false) {
    // there was an error
}
```

## Regular Expressions Are Slow

Only use PHP's regular expression parsing functions (`preg_match`,
`preg_replace`, `preg_quote`, etc) when absolutely needed. Often simpler
functions such as `strstr()`, `str_replace()`, `substr()`, and `explode()` can
be used, and are much faster.

```php
$items = explode(':', $string));
```

It's much quicker than:

```php
$items = split(':', $string));
```

## Use `preg` Functions Instead of `ereg`

The POSIX based regular expressions in PHP tend to be slower than their
Perl-based equivalents. Use Perl-based regular expression functions unless there
is an explicit reason to do otherwise.

***NOTE:*** Do not use any deprecated functions: `eregi_replace`, `ereg`, or
`eregi`

## Quotes

Single quotes are used instead of double where possible. Per string, it doesn't
really make a huge difference, but when you have thousands upon thousands of
them, every little bit helps.

```php
include_once('./lib/api_tree.php');
```

However, there isn't any difference between

```php
"This is a $test"
```

and

```php
'This is a ' . $test
```

Don't bother trying to break out variables out of the string if you are just
going to have to concatenate them.

## Including other PHP files

When including other PHP files, you should use the `$config['base_path']` to
ensure that the base path is configured properly.

If the main file is a web-based page, it should include `include/auth.php` to
ensure that the current user is authenticated.

If the main file is a CLI-based program to be run by end users, it should
include `lib/cli_check.php` and support `-h` and `-v` parameters which run
`display_help()` and `display_version()` respectively.

```php
include($config['base_path'] . '/lib/database.php');
```

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
