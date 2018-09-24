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

## Error Return Values

When an a function needs to return a generic error, it is best to return
boolean `false` in PHP. This makes it very straightforward to check for.

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
Perl-based equivalents. Use Perl-based regular expression functions unless
there is an explicit reason to do otherwise.

---

### NOTE

```markdown
Do not use any deprecated functions:  eregi_replace, ereg, eregi
```

---

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
