# Requirements

## Hardware Sizing

The table below covers common deployment sizes. These are starting points; actual
requirements depend on polling interval, number of data sources per device, use of
Spine vs cmd.php, and whether remote pollers are used.

| Deployment size | Devices | Data sources | CPU cores | RAM | Disk |
|---|---|---|---|---|---|
| Small | < 500 | < 50,000 | 2 | 4 GB | 50 GB SSD |
| Medium | 500–2,000 | 50,000–500,000 | 4–8 | 16 GB | 200 GB SSD |
| Large | 2,000–10,000 | 500,000–2,000,000 | 8–16 | 32–64 GB | 1 TB NVMe |
| Very large | > 10,000 | > 2,000,000 | 16+ | 64+ GB | 2+ TB NVMe |

**Notes:**

- Use SSD or NVMe for the RRD file directory. RRDtool performs many small random
  writes; spinning disk causes polling backlogs on medium and larger installs.
- The MySQL/MariaDB data directory benefits from SSD as well.
  `innodb_doublewrite` protects against torn page writes during a crash;
  disabling it reduces crash safety on any storage type, including SSD/NVMe.
  Setting `innodb_doublewrite = OFF` is an advanced optimization; only
  consider it when you accept the durability trade-off (e.g. strong
  backup/replication strategy and tolerance for potential data loss on an
  unclean shutdown).
- Spine is CPU-bound. Each spine process spawns threads up to your configured
  maximum; allocate 1–2 spine processes per CPU core for best throughput.
- Very large deployments (> 10,000 devices) require remote pollers deployed close to the devices
  they poll rather than scaling a single main poller vertically.

## Software Requirements

Cacti requires that the following software is installed on your system.

> **Note**: As of Cacti 1.2.31, PHP 8.1 is required. When installing from source or
> the develop branch, PHP Composer is required to install vendor dependencies. Pre-packaged
> releases include the required vendor files, so Composer is not needed for standard installs.

- Web Server that supports PHP e.g. Apache, Nginx, or IIS

- Build environment when using spine (gcc, automake, autoconf, libtool,
  help2man)

- RRDtool 1.5 or greater (1.8+ required for Cacti 1.3.x / develop branch)

- PHP 8.1 or greater
  - Required modules:
    - ctype, date, dom, filter, gettext, gd, gmp, intl
    - hash, json, ldap, mbstring, mysqlnd, openssl, pcre
    - PDO, pdo_mysql, Phar, session, simplexml, sockets, spl
    - sqlite3, standard, xml, zlib
    - com_dotnet (windows only)
    - pcntl, posix (linux only)

  - Optional modules:
    - snmp - The PHP SNMP extension is optional. Cacti selectively bypasses it in
      favor of Net-SNMP binaries for SNMPv3 queries, IPv6 targets, bulkwalk, and
      hex-string output. You do not need to remove php-snmp; Cacti handles the
      fallback automatically based on query type and device configuration.

- Problematic software and configuration
  - SELinux, AppArmor, and ModSecurity can interfere with ICMP ping, socket
    connections, and RRDtool file writes. Configure appropriate policies or
    exceptions rather than disabling these protections entirely. Disabling
    SELinux or AppArmor system-wide is a security regression and is not
    recommended for production systems.

- MySQL 8.0 or MariaDB 10.6.28 or greater
  - Timezone support must be enabled

  - The following are my.cnf recommendations:

    - **version >= 8.0 (MySQL) / 10.6.28 (MariaDB)**

      MySQL 8.0+ and MariaDB 10.6.28+ are the minimum supported versions.
      MariaDB 11.8.8 or greater is recommended for new installs. Run the
      latest maintenance release for your chosen branch; older patch releases
      have known networking issues that cause intermittent Spine failures.

    - **innodb = ON**

      Enable InnoDB in any MySQL/MariaDB version greater than 5.1.

    - **collation_server = utf8mb4_unicode_ci**

      When using Cacti with languages other than English, it is important to
      use the utf8_general_ci collation type as some characters take more than
      a single byte.  If you are first just now installing Cacti, stop, make
      the changes and start over again.  If your Cacti has been running and is
      in production, see the internet for instructions on converting your
      databases and tables if you plan on supporting other languages.

    - **character_set_client = utf8mb4**
    - **character_set_server = utf8mb4**

      When using Cacti with languages other than English, it is important to
      use the utf8 character set as some characters take more than a single
      byte. If you are first just now installing Cacti, stop, make the changes
      and start over again. If your Cacti has been running and is in
      production, see the internet for instructions on converting your
      databases and tables if you plan on supporting other languages.

    - **max_connections >= 100**

      Depending on the number of logins and use of spine data collector,
      MySQL/MariaDB will need many connections.  The calculation for spine is:

      ```php
      total_connections = total_processes * (total_threads + script_servers + 1)
      ```

      then you must leave headroom for user connections, which will change
      depending on the number of concurrent login accounts.

    - **max_heap_table_size >= 5% of system RAM**

      If using the Cacti Performance Booster and choosing a memory storage
      engine, you have to be careful to flush your Performance Booster buffer
      before the system runs out of memory table space.  This is done two
      ways, first reducing the size of your output column to just the right
      size.  This column is in the tables poller_output, and
      poller_output_boost.

      The second thing you can do is allocate more memory to memory tables
      with a recommended value of 10% of system memory, but if you are using
      SSD disk drives, or have a smaller system, you may ignore this
      recommendation or choose a different storage engine.  You may see the
      expected consumption of the Performance Booster tables under Console ->
      System Utilities -> View Boost Status.

      > **Note**: If you are using a recent version of MariaDB or MySQL, using
      > memory tables is no longer a requirement.  You may choose to continue
      > to use memory tables to spare your NVMe or SSD drives excessive use
      > wear.  However, outside of that, it is no longer a requirement.
      > As such, the value of the **max_heap_table_size** is not as important
      > as in previous releases.  If you are using Galera
      > replication with Cacti, all your tables must be in InnoDB format, and
      > the only benefit of MariaDB or MySQL memory tables becomes temporary
      > table space, which may not be dependent on **max_heap_table_size**.

    - **table_open_cache >= 200**

      Keeping the table cache larger means less file open/close operations
      when using innodb_file_per_table. (Note: `table_cache` was renamed to
      `table_open_cache` in MySQL 5.1.3; use `table_open_cache` on all
      current MySQL and MariaDB releases.)

    - **max_allowed_packet >= 16777216**

      With Remote polling capabilities, large amounts of data will be synced
      from the main server to the remote pollers.  Therefore, keep this value
      at or above 16M.

    - **tmp_table_size >= 64M**

      When executing subqueries, having a larger temporary table size, keep
      those temporary tables in memory.

    - **join_buffer_size >= 64M**

      When performing joins, if they are below this size, they will be kept in
      memory and never written to a temporary file.

    - **innodb_file_per_table = ON**

      When using InnoDB storage it is important to keep your table spaces
      separate.  This makes managing the tables simpler for long time users of
      MySQL/MariaDB.  If you are running with this currently off, you can
      migrate to the per file storage by enabling the feature, and then
      running an alter statement on all InnoDB tables.

    - **innodb_data_file_path = ibdata1:12M:autoextend:autoshrink** (MariaDB 11.2.0+)

      Long running installs that accumulated blocking queries can end up with a
      very large ibdata1 file that never shrinks back down.  The autoshrink
      attribute lets MariaDB truncate the system tablespace back toward its
      minimum size.  It is off by default and is enabled by appending
      :autoshrink to innodb_data_file_path, not by a separate variable.

      From MariaDB 11.2.3 the shrink runs during a slow shutdown, so set
      innodb_fast_shutdown = 0 before stopping the server or the file will not
      be truncated.  MySQL has no equivalent.

    - **innodb_buffer_pool_size >= 25% of system RAM**

      InnoDB will hold as much tables and indexes in system memory as is
      possible.  Therefore, you should make the innodb_buffer_pool large
      enough to hold as much of the tables and index in memory.  Checking the
      size of the /var/lib/mysql/cacti directory will help in determining this
      value.  We are recommending 25% of your systems total memory, but your
      requirements will vary depending on your systems size.

    - **innodb_doublewrite = OFF**

      Disables the InnoDB doublewrite buffer. This eliminates a 50% write
      overhead on SSD/NVMe storage, but removes protection against partial page
      writes on an unclean shutdown. Only set this on SSD or NVMe storage with
      battery-backed or capacitor-backed write cache, or when the database is
      on a volume with hardware-level write atomicity guarantees. Do not set on
      spinning disk or consumer SSDs without power-loss protection.

    - ~~**innodb_additional_mem_pool_size**~~ (removed in MySQL 5.7.4 / MariaDB 10.0)

      This setting no longer exists. MySQL/MariaDB manages metadata memory
      internally. Remove it from my.cnf if present; MySQL 8.0+ will error on startup.

    - **innodb_lock_wait_timeout >= 50**

      Rogue queries should not for the database to go offline to others.  Kill
      these queries before they kill your system.

    - **innodb_flush_log_at_trx_commit = 2**

      Setting this value to 2 means that you will flush all transactions every
      second rather than at commit.  This allows MySQL/MariaDB to perform
      writing less often.

    - **innodb_flush_log_at_timeout >= 3**

      If your MySQL/MariaDB version supports it, the you can control how often
      MySQL/MariaDB flushes transactions to disk.  The default is 1 second,
      but in high I/O systems setting to a value greater than 1 can allow disk
      I/O to be more sequential

    - **innodb_read_IO_threads >= 32**

      With modern SSD type storage, having multiple read IO threads is
      advantageous for applications with high IO characteristics.

    - **innodb_write_IO_threads >= 16**

      With modern SSD type storage, having multiple write IO threads is
      advantageous for applications with high IO characteristics.

    - **innodb_buffer_pool_instances >= 16**

      MySQL/MariaDB will divide the innodb_buffer_pool into memory regions to
      improve performance with a maximum value is 64.  When your
      innodb_buffer_pool is less than 1GB, you should use the pool size
      divided by 128MB. Continue to use this equation up to the max of 64.

    > **Note**: Some of these recommendations may not be applicable depending
    > on the version of MySQL/MariaDB you are running, and some should be
    > scaled where appropriate.

    - Newer MySQL/MariaDB software are using [strict
      modes](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html) and it can
      cause unexpected problems when importing dumps of Cacti databases from
      older systems, like **Can't create table `cacti`.`poller_output_boost`
      (errno: 140 "Wrong create options")**.

      You have more possibilities:

      - disable appropriate strict mode - not recommended

      - change mysqldump file - remove **ROW_FORMAT=FIXED** from table
        definition

      - before mysqldump run query:
        **ALTER TABLE `poller_output_boost` ROW_FORMAT=DYNAMIC;**

To implement the above mysql recommendations you can use the below entries and
paste them into my.cnf

```console
 innodb_flush_log_at_timeout = 4
 innodb_read_io_threads = 34
 innodb_write_io_threads = 17
 max_heap_table_size = 70M
 tmp_table_size = 70M
 join_buffer_size = 130M
 innodb_buffer_pool_size = 250M
 innodb_io_capacity = 5000
 innodb_io_capacity_max = 10000
```

---
Copyright (c) 2004-2026 The Cacti Group
