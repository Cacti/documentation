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

## DBMS Functions

Do not use functions in SQL queries that are provided only by a single DBMS.
These functions are generally not uniformly support or even available in all
DBMS's. Common examples of such functions are `MD5()`, `CONCAT()`, and `NOW()`.

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
$hostname = db_qstr('myhost.com');
db_execute(UPDATE host SET hostname = '$myhost' WHERE id = $id");

```

## Format of SQL statements

- For short statements, SQL calls may be made on a single row.

- If the SQL statement starts to grow and be unreadable without scrolling, it
  should be wrapped onto a continuation line for ease of use and readability.
  The following keywords should also be placed at the start of a new line:

  - joins statements (excluding JOIN itself which should not be used)
    (eg, INNER JOIN, LEFT JOIN, RIGHT JOIN, OUTER JOIN, CROSS JOIN)

    **Note:** *Any implicit join or JOIN without one of the modifiers should be
    converted to an explicit join with a modifier.  When converting the implicit
    join statement, remember to remove the WHERE joining clause.

  - AND / OR

  - FROM

  - WHERE

  - ORDER

  - GROUP BY

  - HAVING

  - LIMIT

  - prepared statement arrays

- Indentation should consist of one extra tab when any of the following occur:

  - continuation lines

  - Subqueries

- There should always be 'AS' when defining an alias for any table, field or
  query to clearly define the definition of said alias.

- There should always be a space following a comma and before/after an operator.

### Example of single line SQL

###### Before formatting

```php
$templates = db_fetch_assoc('SELECT DISTINCT gt.id, gt.name FROM graph_templates AS gt INNER JOIN graph_templates_graph AS gtg ON gt.id = gtg.graph_template_id INNER JOIN graph_templates_item AS gti ON gtg.graph_template_id=gti.graph_template_id INNER JOIN data_template_rrd AS dtr ON gti.task_item_id=dtr.id INNER JOIN data_template_data AS dtd ON dtd.data_template_id=dtr.data_template_id AND dtd.local_data_id = 0 WHERE gtg.local_graph_id=0 AND dtr.local_data_id = 0 AND dtd.local_data_id = 0 AND dtd.data_input_id in (2,11,12) ORDER BY gt.name;'
```

###### Corrected formatting with prepared usage

```php
$templates = db_fetch_assoc_prepared('SELECT DISTINCT gt.id, gt.name
	FROM graph_templates AS gt
	INNER JOIN graph_templates_graph AS gtg
	ON gt.id = gtg.graph_template_id
	INNER JOIN graph_templates_item AS gti
	ON gtg.graph_template_id=gti.graph_template_id
	INNER JOIN data_template_rrd AS dtr
	ON gti.task_item_id=dtr.id
	INNER JOIN data_template_data AS dtd
	ON dtd.data_template_id=dtr.data_template_id
	AND dtd.local_data_id = 0
	WHERE gtg.local_graph_id=0
	AND dtr.local_data_id = 0
	AND dtd.local_data_id = 0
	AND dtd.data_input_id in (?,?,?)
	ORDER BY gt.name',
	array(2,11,12));
```

### Example of implicit join

###### Before formatting

```php
$user_realms = db_fetch_assoc('SELECT ua.id, uar.realm_id
	FROM user_auth ua, user_auth_realms uar
	WHERE ua.id = uar.user_id');
```

###### Corrected formatting

```php
$user_realms = db_fetch_assoc('SELECT ua.id, uar.realm_id
	FROM user_auth ua
	INNER JOIN user_auth_realms uar
	ON ua.id = uar.user_id');
```

---
<copy>Copyright (c) 2004-2021 The Cacti Group</copy>
