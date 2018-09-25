# SQL Standards

Special care must be taken for Cacti to properly support multiple DBMS's.

## Quotes

When writing queries do not use quotes around numeric values. While MySQL is
not strict about types, most DBMS's assume that any value contained within
quotes is a string.

As well, single quotes are used unless a variable is referenced

```php
$graphs = db_fetch_assoc('SELECT * FROM graph WHERE height >= 150');
```

```php
$rows = db_fetch_cell("SELECT count(*) FROM $archive_table");
```

## SQL Functions

Do not use functions in SQL queries that are provided by the DBMS. These
functions are generally not uniformly support or even available in all DBMS's.
Common examples of such functions are `MD5()`, `CONCAT()`, and `NOW()`.

## Database Abstraction

Always use the database libraries provided by Cacti as an extra layer between
the code and ADODB. Details about these functions are located in
`lib/sys/database.php`.
