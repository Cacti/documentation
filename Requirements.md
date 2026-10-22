# Requirements

This page describes the software and configuration used by Cacti 1.2.31.
The historical compatibility values below come from the
[released requirements][release-readme] and installer checks. They do not
establish whether a dependency is still maintained by its vendor, or certify
every later version. Check the installed components with the Cacti installer
before using them in a new deployment or upgrade.

- Web Server that supports PHP e.g. Apache, Nginx, or IIS

- Build environment when using spine (gcc, automake, autoconf, libtool,
  help2man)

- RRDtool 1.3 or greater, 1.5+ recommended by the 1.2.31 release

- Net-SNMP 5.5 or greater, including the command-line tools used by Cacti

- PHP 5.4 or greater, with a CLI binary for the poller

  - Required modules:

    - ctype, date, filter, gettext, gd, gmp
    - hash, json, ldap, mbstring, openssl, pcre
    - PDO, pdo_mysql, session, simplexml, sockets, spl
    - standard, xml, zlib
    - com_dotnet (windows only)
    - posix (linux only)

  - Optional modules:

    - snmp (falls back to NetSNMP)

- MySQL or MariaDB, with timezone support enabled

## Database compatibility and checks

The 1.2.31 release README lists MySQL 5.1 or greater as its historical
baseline. The installer's tuning guidance recommends MySQL 5.6+ and MariaDB
10.0+; its database-version recommendation is a warning, not a complete
compatibility matrix. These values do not establish an upper supported
version or prove that every database release has been tested.

Review the installer's database checks and the database information under
`Console > Utilities > System Utilities > General`. The
[released recommendation code][database-checks] reads the installed server's
variables, identifies MySQL or MariaDB, and adjusts guidance for version and
memory. It displays recommendations for variables that the server exposes.
Check the database vendor's documentation before applying a setting.

## Database configuration

Use the following points when reviewing the checks. There is no single
`my.cnf` block appropriate for every database version and machine size.

- **Character sets and collation:** The release checks expect `utf8mb4` for
  `character_set_server` and `character_set_client`, and
  `utf8mb4_unicode_ci` for `collation_server`. Use those names consistently;
  `utf8_general_ci` is a different collation. Changing server defaults does
  not by itself convert existing tables. Plan and back up an existing
  database before changing its character sets or collations.

- **Storage engines:** Review InnoDB and `innodb_file_per_table` in the
  installer. Performance Booster tables can use different storage engines;
  inspect the actual tables before sizing memory-table limits. Do not assume
  that memory tables are required on every installation.

- **Connections:** The release checks use 100 as a starting recommendation
  for `max_connections`. Estimate Spine's connections with the formula below,
  then allow for web requests, maintenance and other database clients.

  ```text
  total_connections = total_processes * (total_threads + script_servers + 1)
  ```

- **Buffer pool:** The release check starts with 25% of system memory for
  `innodb_buffer_pool_size`. Review the database size and memory required by
  PHP, pollers, RRDtool and other services before applying it.

- **Per-connection memory:** `join_buffer_size` and `sort_buffer_size` can
  multiply memory use across database connections. The release computes
  recommendations using connection counts and memory; fixed large buffers
  are not a safe substitute for that calculation.

- **Temporary and memory tables:** Size `tmp_table_size` and
  `max_heap_table_size` for the installed database and workload. Review Boost
  buffer usage under System Utilities when using memory tables. A bare
  number such as `5` does not express a percentage of system memory in
  `my.cnf`.

- **Remote collection:** The release recommends `max_allowed_packet` of at
  least 16777216 bytes (16 MiB) for synchronization with remote collectors.

- **Version-specific options:** Cache, I/O, buffer-pool-instance and legacy
  InnoDB options vary by database version. Apply only options supported by
  the installed server; do not copy settings from an older server unchanged.

## Durability and operating-system policy

Do not disable `innodb_doublewrite` simply because the server uses SSDs.
The 1.2.31 checks normally expect it to be enabled and contain separate
MariaDB guidance concerning atomic writes. Confirm the database and storage
requirements before changing crash-protection settings. See the database
vendor's [doublewrite documentation][doublewrite]. Changes to
`innodb_flush_log_at_trx_commit` also affect durability; choose them with an
explicit recovery policy rather than treating them as universal tuning.

Configure SELinux and web-server security rules to allow the operations
needed by the web server and poller accounts. Check policy and application
logs when permissions block polling, scripts or socket access. Disabling an
entire security mechanism is not an installation prerequisite.

[release-readme]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/README.md#requirements>
[database-checks]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/lib/utility.php#L1181>
[doublewrite]:<https://dev.mysql.com/doc/refman/8.0/en/innodb-doublewrite-buffer.html>

---

Copyright (c) 2004-2026 The Cacti Group
