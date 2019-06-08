# Requirements

Cacti requires that the following software is installed on your system.

- Web Server that supports PHP e.g. Apache, Nginx, or IIS

- Build environment when using spine (gcc, automake, autoconf, libtool,
  help2man)

- RRDTool 1.3 or greater, 1.5+ recommended

- PHP 5.4 or greater, 5.5+ recommended
  - Required modules:
    - ctype, date, filter, gettext, gd, gmp
    - hash, json, ldap, mbstring, openssl, pcre
    - PDO, pdo_mysql, session, simplexml, sockets, spl
    - standard, xml, zlib
    - com_dotnet (windows only)
    - posix (linux only)

  - Optional modules:
    - snmp (falls back to NetSNMP)

- MySQL 5.x or MariaDB 5.5 or greater
  - Timezone support must be enabled

  - The following are my.cnf recommendations:

    - **version >= 5.6**

      MySQL 5.6+ and MariaDB 10.0+ are great releases, and are very good
      versions to choose. Make sure you run the very latest release though
      which fixes a long standing low level networking issue that was causing
      spine many issues with reliability.

    - **innodb = ON**

      It is recommended that you enable InnoDB in any MySQL/MariaDB version
      greater than 5.1.

    - **collation_server = utf8_general_ci**

      When using Cacti with languages other than English, it is important to
      use the utf8_general_ci collation type as some characters take more than
      a single byte.  If you are first just now installing Cacti, stop, make
      the changes and start over again.  If your Cacti has been running and is
      in production, see the internet for instructions on converting your
      databases and tables if you plan on supporting other languages.

    - **character_set_client = utf8**

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

    - **max_heap_table_size >= 5**

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

    - **table_cache >= 200**

      Keeping the table cache larger means less file open/close operations
      when using innodb_file_per_table.

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

    - **innodb_buffer_pool_size >= 25**

      InnoDB will hold as much tables and indexes in system memory as is
      possible.  Therefore, you should make the innodb_buffer_pool large
      enough to hold as much of the tables and index in memory.  Checking the
      size of the /var/lib/mysql/cacti directory will help in determining this
      value.  We are recommending 25% of your systems total memory, but your
      requirements will vary depending on your systems size.

    - **innodb_doublewrite = OFF**

      With modern SSD type storage, this operation actually degrades the disk
      more rapidly and adds a 50% overhead on all write operations.

    - **innodb_additional_mem_pool_size >= 80M**

      This is where metadata is stored. If you had a lot of tables, it would
      be useful to increase this.

    - **innodb_lock_wait_timeout >= 50**

      Rogue queries should not for the database to go offline to others.  Kill
      these queries before they kill your system.

    - **innodb_flush_log_at_trx_commit = 2**

      Setting this value to 2 means that you will flush all transactions every
      second rather than at commit.  This allows MySQL/MariaDB to perform
      writing less often.

    - **innodb_file_io_threads >= 16**

      With modern SSD type storage, having multiple io threads is advantageous
      for applications with high IO characteristics.

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

    Note:
    - Some of these recommendations may not be applicable depending on the
      version of MySQL/MariaDB you are running.
    - Some of these recommendations should be scaled where appropriate
    - Newer MySQL/MariaDB databases are using [strict modes](https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html)
      and it can causes unexpected problems with import older Cacti mysqldumps, 
      like **Can't create table `cacti`.`poller_output_boost` (errno: 140 "Wrong create options")**. 
      
      You have more posibilities:
      - disable appropriate strict mode - not recomended
      - change mysqldump file - remove **ROW_FORMAT=FIXED** from table definition
      - before mysqldump run query **ALTER TABLE `poller_output_boost` ROW_FORMAT=DYNAMIC;**   


---
Copyright (c) 2004-2019 The Cacti Group
