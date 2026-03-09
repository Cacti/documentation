# Installing Under Windows

> **Note**: As of Cacti 1.2.31, PHP 8.1 is required and PHP Composer is required.
> Composer will be used to ensure all libraries are installed and up to date.

BSOD2600, one of the long-term users of Cacti, provides an installer for Windows.
We recommend using that installer. You can obtain it under the Windows section of
the Cacti forums. If you prefer to install Cacti manually, follow the instructions
below.

1. (Optional) Apache - This software is optional if running Windows Internet
   Information Server.

2. Cacti - Install from the zip distribution into the web root of your choice.
   Many choose to install into a `Cacti` subfolder.

3. Spine - Install from the zip distribution into the `c:\cacti` directory.
   Ensure `spine.conf.dist` is located in that directory as well.

4. RRDtool - Install from the Cacti website into the `c:\cacti` directory.

5. PHP 8.x - Install into the `c:\php` folder. If you choose to install into
   `c:\Program Files\php`, you will have to use 8.3 filenames to reference its
   binaries in Cacti.

6. MySQL 8.x or MariaDB 10.5+ - Install into the default locations.
   For MySQL this is typically:

   `c:\Program Files\MySQL\MySQL Server X.XX`

   For MariaDB it is typically:

   `c:\Program Files\MariaDB`

   After the database is confirmed running, apply the following settings to the
   `my.ini` file:

   ```ini
   [mysqld]
   character-set-server = utf8mb4
   collation-server = utf8mb4_unicode_ci
   max_heap_table_size = 770M  # Adjust for your OS memory size
   max_allowed_packet = 500M   # Adjust for your OS memory size
   tmp_table_size = 512M       # Adjust for your OS memory size
   join_buffer_size = 256M     # Adjust for your OS memory size
   sort_buffer_size = 32M      # Per-session buffer; keep small to avoid OOM under load

   # sql_mode: NO_AUTO_CREATE_USER was removed in MySQL 8.0; omit it on MySQL 8+
   sql_mode = NO_ENGINE_SUBSTITUTION

   innodb_flush_log_at_trx_commit = 2
   innodb_flush_log_at_timeout = 3
   innodb_file_per_table = ON

   innodb_buffer_pool_size = 4500M # Adjust for your OS memory size

   # innodb_file_format and innodb_large_prefix removed in MySQL 8.0 /
   # MariaDB 10.3+; omit those settings on newer releases.

   # for SSDs on a multi-core server
   innodb_doublewrite = OFF
   innodb_read_io_threads = 32
   innodb_write_io_threads = 16
   innodb_io_capacity = 10000
   innodb_io_capacity_max = 20000
   innodb_flush_method = O_DIRECT
   ```

   Restart MariaDB/MySQL after applying these settings. Once you start the
   installer, Cacti will recommend better values for your hardware.

   Write down your MariaDB/MySQL root password and keep a backup copy in a safe
   place.

7. (Optional) Cygwin - Download and execute `setup-x86_64.exe` from the Cygwin
   website. Keep the `setup-x86_64.exe` file for later use. You will need Cygwin
   and its development packages for building RRDtool and Spine.

8. (Optional) Net-SNMP - Install to the `c:\usr` directory. If you choose to
   use `c:\Program Files\net-snmp`, you will have to use 8.3 filenames to
   reference its binaries in Cacti. The default installation location for
   Net-SNMP on Windows is `c:\usr`, which closely aligns with Linux and Unix
   install paths.

## Common OS Changes

The following changes are required regardless of your selected web server.

1. Add the following directory to the existing Windows System `PATH` environment
   variable: `c:\php`. The Windows PATH can be accessed via:
   Control Panel → System → Advanced → Environment Variables → System Variables.

2. Add a new Windows System environment variable `PHPRC` set to `c:\php`.

3. Add a new Windows System environment variable `MIBDIRS` set to
   `c:\php\extrasmibs`.

4. Rename `c:\php\php.ini.dist` to `php.ini`, and make the following changes.
   The Cacti installer will guide you through enabling additional modules.

   ```ini
   extension_dir = c:\php\ext
   extension=php_pdo_mysql.dll
   extension=php_snmp.dll
   extension=php_sockets.dll
   cgi.force_redirect = 0
   date.timezone = America/Detroit
   memory_limit = 800M
   max_execution_time = 300
   ```

   > **Note**: `php_mysql.dll` (the old `mysql_*` extension) was removed in
   > PHP 7.0. Use `php_pdo_mysql.dll` instead.

5. In earlier PHP installation guides, moving certain DLLs to
   `c:\winnt\system32` was recommended. If you followed those guides, remove
   those files. Review the PHP installation documentation for instructions.

6. To allow template importing, uncomment the following line:

   ```ini
   file_uploads = On
   ```

7. Give the user running the scheduled task modify rights to the `.index` file
   in the location pointed to by the `MIBDIRS` environment variable.

## Web Server Configuration

1. Ensure you have stopped any IIS web servers before proceeding with Apache
   installation, or configure Apache on an alternate port.

2. If using Apache 2.x with PHP 8, add the following lines. Adjust values for
   your version of PHP and Apache.

   ```ini
   LoadModule php_module "C:\php\php8apache2_4.dll"
   AddHandler application/x-httpd-php .php
   AddType application/x-httpd-php .php
   DirectoryIndex index.html index.htm index.php
   PHPIniDir "C:\php"
   ```

## IIS Specific Steps

PHP 8.0 removed ISAPI support. For IIS with PHP 8, use the FastCGI handler
instead of ISAPI.

1. Install the **IIS FastCGI module** if it is not already present (available
   via Windows Server roles or Web Platform Installer).

2. Open IIS Manager. At the server level, open **FastCGI Settings** and add a
   new application:
   - **Full Path**: `C:\php\php-cgi.exe`
   - Set **InstanceMaxRequests** to `10000`

3. In the site or server **Handler Mappings**, add a new module mapping:
   - **Request path**: `*.php`
   - **Module**: `FastCgiModule`
   - **Executable**: `C:\php\php-cgi.exe`

4. Under the **Default Document** feature, add `index.php` to the list.

5. Give the IIS application pool identity (or `IUSR`) read and execute
   permissions on `%windir%\system32\cmd.exe`, and read/write/execute on the
   Cacti directories:

   ```batchfile
   icacls "C:\windows\system32\cmd.exe" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\resource\snmp_queries" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\resource\script_server" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\scripts" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\rra" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\log" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\cache" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\include\config.php" /grant "IUSR:(RX,W)"
   copy /b NUL "C:\inetpub\wwwroot\cacti\include\vendor\csrf\csrf-secret.php"
   icacls "C:\inetpub\wwwroot\cacti\include\vendor\csrf\csrf-secret.php" /grant "IUSR:(RX,W)"
   ```

6. Completely stop and start the IIS service:

   ```batchfile
   net stop iisadmin
   net start w3svc
   ```

## Cygwin Installation Steps for Spine and RRDtool

1. Installing a single instance of Cygwin and using it for all applications
   is recommended. Multiple Cygwin installations can have conflicting DLL
   versions.

2. Run the `setup-x86_64.exe` you downloaded previously.

3. At the **Select Packages** step, install the following packages (version
   numbers may have changed):

   - Base (include all items)
     - Libs
       - libcairo2
       - libcrypt0
       - libfontconfig-common
       - libfontconfig1
       - libfreetype6
       - libgcrypt20
       - libgd3
       - libglib2.0_0
       - libmariadb3
       - libssl1.0
       - libpango1.0_0
       - libpng16
       - libreadline7
       - zlib-devel
       - zlib0
     - Devel
       - autoconf
       - automake
       - binutils
       - clang
       - cygwin-devel
       - gcc-core
       - gcc-g++
       - libmariadb-devel
       - help2man
       - libargp
       - libltdl7
       - libtool
       - net-snmp-devel
       - patch
       - texinfo
       - w32api-headers
       - w32api-runtime
       - windows-default-manifest
     - Web
       - wget

4. Add `c:\cygwin\bin` to your Windows System PATH environment variable.

5. Move `setup-x86_64.exe` to `c:\cygwin` for future use. Update this binary
   periodically, as it is updated from time to time.

## RRDtool Download and Installation

1. Obtain Windows-compatible builds of RRDtool from https://rrdtool.org and
   install to `C:\rrdtool`.

2. Create the MariaDB/MySQL database:

   ```sh
   shell> mysqladmin --user=root --password create cacti
   ```

3. Import the default Cacti database:

   ```sh
   shell> mysql --user=root --password cacti < c:\apache2\htdocs\cacti\cacti.sql
   ```

4. Create a MySQL username and password for Cacti:

   ```sh
   shell> mysql --user=root --password mysql
   ```

   ```sql
   MySQL> CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'cactiuser';
   MySQL> GRANT ALL ON cacti.* TO 'cactiuser'@'localhost';
   MySQL> GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';
   MySQL> ALTER DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   MySQL> FLUSH PRIVILEGES;
   ```

## Net-SNMP Installation

1. If you plan to use SNMP v2c and are using early versions of PHP, download
   and install the Net-SNMP libraries. Net-SNMP provides an installer.

   If you use long directory names, note that Cacti requires 8.3 notation:

   | Format | Path |
   | --- | --- |
   | Original | `c:\Program Files\Net-SNMP\bin` |
   | 8.3 notation | `c:\progra~1\net-snmp\bin` |

## Cacti Spine Installation

1. Extract the Spine zip file to `c:\spine` and edit `spine.conf.dist` with
   your database details:

   ```ini
   DB_Host      127.0.0.1
   DB_Database  cacti
   DB_User      cactiuser
   DB_Password  cactiuser
   DB_Port      3306
   ```

   > **Note**: Use `127.0.0.1` rather than `localhost` for the DB host on Windows.

2. Spine is distributed as a binary. We strongly recommend installing Cygwin
   and removing all DLL files and `sh.exe` from `c:\spine`, keeping only
   `spine.exe` and `spine.conf`.

## Finishing Your Setup

1. Edit `cacti_web_root/cacti/include/config.php` and specify the database
   connection details:

   ```php
   $database_default  = "cacti";
   $database_hostname = "localhost";
   $database_username = "cactiuser";
   $database_password = "cactiuser";
   $database_port     = "3306";
   ```

2. Browse to `http://your-server/cacti/` and log in with `admin`/`admin`.
   You will be prompted to change the password immediately.

3. Go to **Settings → Paths** and verify/update all paths to point to the
   correct locations. If using Spine, all paths must use forward slashes.

   - PHP Binary Path: `c:/php/php.exe`
   - RRDtool Binary Path: `c:/rrdtool/rrdtool.exe`
   - SNMP Binary Paths: `c:/usr/bin/snmpget.exe`, `c:/usr/bin/snmpwalk.exe`, etc.
   - Cacti Logfile Path: `c:/mycacti/website/cacti/log/cacti.log`
   - Spine Path: `c:/spine/spine.exe`

4. If you enabled automation, once the Cacti poller starts it will discover
   compatible devices using your SNMP settings and default automation rules.
   A Localhost device is created automatically at install time.

5. Log into the account you will use for the scheduled task and verify a
   polling cycle works:

   ```sh
   php c:/cacti_web_root/cacti/poller.php
   ```

   Expected output includes lines like:

   ```
   OK u:0.00 s:0.06 r:1.32
   10/28/2005 04:57:12 PM - SYSTEM STATS: Time:4.7272 Method:cmd.php ...
   ```

   After the first run, `cacti.log` will appear in `/cacti/log/` and RRD files
   in `/cacti/rra/`.

6. Schedule a recurring task to run `poller.php` every 5 minutes:

   > **Note**: The following instructions apply to most Windows versions.

   1. Open **Task Scheduler** (Control Panel → Scheduled Tasks).
   2. Click **Add Scheduled Task** and then **Next**.
   3. Browse to `c:\php` and select `php.exe`. Choose **Daily** and click **Next**.
   4. Click **Next** without changing the time or date settings.
   5. Ensure the task account has the correct permissions on:
      - `cacti_web_root/cacti/rra`
      - `cacti_web_root/log`
      - `c:\php`
      - `c:\phpsapi`
   6. Click **Next** and **Finish** to close the wizard.
   7. Right-click the task and select **Properties**.
   8. On the **Schedule** tab, confirm **Daily** is selected and click **Advanced**.
   9. Check **Repeat**, set to **5 minutes**, and set duration to **24 hours**.
   10. Click **OK**.
   11. In the **Run** field, enter:

       `c:\php\php.exe c:\mycacti\website\cacti\poller.php`

       Set **Start in** to `c:\mycacti\website\cacti`.

---
Copyright (c) 2004-2026 The Cacti Group
