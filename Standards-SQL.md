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

## SQL Injection

Cacti provides support for prepared statements.  You should use these prepared
statement functions as much as possible to avoid the risk of SQL Injection
attacks from the Cacti website.  Examples include:

```php
// Example prepared statements
$hostname = db_fetch_cell_prepared('SELECT hostname FROM host WHERE id = ?', array($id));
$host     = db_fetch_row_prepared('SELECT * FROM host WHERE id = ?', array($id));
$graphs   = db_fetch_assoc('SELECT * FROM graph_local WHERE host_id = ?', array($id));

db_execute_prepared('UPDATE host SET description = ? WHERE id = ?', array('Local Machines', $id));

// Escape strings if using legacy functions
$hostname = db_escape('myhost.com');
db_execute(UPDATE host SET hostname = '$myhost' WHERE id = $id");

```

---
Copyright (c) 2018 Cacti Group
