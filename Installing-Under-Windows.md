# Installing Under Windows

BSOD2600, one of the long term users of Cacti, provides an Installer on Windows.
We recommend you use that installer for Cacti. You can obtain that installer
under the Windows section of the Cacti forums. However, if you wish to install
Cacti yourself, please follow the instructions below.

1. (Optional) Apache - This software is optional if running Windows Internet
   Information Server.

2. Cacti - Install from the zip distribution and install in the web root or your
   choice. Many choose to install into a `Cacti` sub folder.

3. Spine - Install from the zip distribution into the `c:\cacti` directory.
   Make sure your `spine.conf.dist` is located in that directory as well.

4. RRDtool - Install from the Cacti website. Install it into the `c:\cacti`
   directory.

5. PHP X - Install into the `c:\php` folder. If you choose to install into
   `c:\Program Files\php`, you will have to use 8.3 filenames to reference it's
   binaries in Cacti.

6. MySQL 8.x or MariaDB 10.5.x++ - Install into the default locations.
   This is typically for MySQL:

   `c:\Program Files\MySQL\MySQL Server X.XX`.

   For MariaDB it is normally:

   `c:\Program Files\MariaDB`.

   After the Database is confirmed running, follow the steps to setup the
   correct settings to InnoDB in the `my.ini` file which include the following:

   ```
   [mysqld]
   character-set-server = utf8mb4
   collation-server = utf8mb4_unicode_ci
   max_heap_table_size = 770M  # Adjust for your OS memory size
   max_allowed_packet = 500M   # Adjust for your OS memory size
   tmp_table_size = 512M       # Adjust for your OS memory size
   join_buffer_size = 256M     # Adjust for your OS memory size
   sort_buffer_size = 200M     # Adjust for your OS memory size

   # important for compatibility
   sql_mode=NO_ENGINE_SUBSTITUTION,NO_AUTO_CREATE_USER

   innodb_flush_log_at_trx_commit = 2
   innodb_flush_log_at_timeout = 3
   innodb_file_per_table = ON

   innodb_buffer_pool_size = 4500M # Adjust for your OS memory size
   
   # for very large indexes
   innodb_file_format = Barracuda
   innodb_large_prefix = 1

   # for SSD's on a 64 core server
   innodb_doublewrite = OFF
   innodb_read_io_threads = 32
   innodb_write_io_threads = 16
   innodb_io_capacity = 10000
   innodb_io_capacity_max = 20000
   innodb_flush_method = O_DIRECT
   ```
   
   Restart MariaDB/MySQL after applying these settings.  Once you start the install
   Cacti will recommend better values.

   Ensure you write down your MariaDB/MySQL root password for later use.  Keep
   a backup copy of it safe.

8. (Optional) Cygwin - Download and execute `setup-x86_64.exe` from the Cygwin website.
   Keep the `setup-x86_64.exe` file for later use.  You will need Cygwin and its
   development packages for building RRDtool and spine.

9. (Optional) Net-SNMP - Install to the `c:\usr` directory. If you choose to
   use `c:\Program Files\net-snmp` you will have to use 8.3 filenames to
   reference its binaries in Cacti.  The default installation location for Net-SNMP
   on Windows is `c:\usr` where closely aligns with Linux and Unix install paths.

## Common OS Changes

The following changes will be required regardless of your selected Webserver.

1. Add the following directory to the existing Windows System `PATH` environment
   variable: `c:\php`. The Windows path can be accessed via the Control Panel at:
   System -> Advanced -> Environment Variables -> System Variables.

2. Add the following directory to a new Windows System environment variable
   called `PHPRC`: `c:\php`.

3. Add a new Windows System environment variable called `MIBDIRS` set it to
   `c:\php\extrasmibs`

4. Rename the file `c:\php\php.ini.dist` to `php.ini`, and make the following
   changes to it:

   Uncomment the following lines.  You will need more modules.  The Cacti
   install process will guide you through this process.

   ```ini
   extension_dir = c:\php\ext
   extension=php_mysql.dll
   extension=php_snmp.dll
   extension=php_sockets.dll
   cgi.force_redirect = 0
   date.time_zone = America/Detroit
   memory_limit = 800M
   max_execution_time = 300
   ```

6. In earlier installation guides to PHP, they recommended moving certain DLL's
   to the `c:\winnt\system32` directory. If so, you will have to remove those
   files. Please review the PHP installation documentation for instructions on
   removing those files.

7. If you want to allow template importing, uncomment the following line:

   ```ini
   file_uploads = On
   ```

8. Give the user who will be running the scheduled task, modify rights to the
   `.index` file in the location pointed to by the `MIBDIRS` Windows System
   environment variable.

## Web Server Configuration

1. Make sure you have stopped any IIS web servers before you proceed with Apache
   installation, or make sure Apache is configured on an alternate port.

2. If using Apache 2.x and PHP 8, then add the following lines.  The values will
   change depending on your version of PHP and Apache.

   ```ini
   LoadModule php_module "C:\php\php8apache2_4.dll"
   AddHandler application/x-httpd-php .php
   AddType application/x-httpd-php .php
   DirectoryIndex index.html index.htm index.php
   PHPIniDir "C:\php"
   ```

## IIS Specific Steps

1. Start the Internet Information Services (IIS) Manager, right click on the
   Default Web Site (in most cases) and select Properties.

2. Under the Home Directory tab, select Configuration and click Add. Browse to
   the path of `php8isapi.dll`, and type in .php as the
   extension. Note: if using IIS6, Enable All Verbs and Script Engine.

3. Under the ISAPI Filters tab, click Add and browse to the `php8isapi.dll`
   file. Name the filter "php" and click OK.

5. Under the Documents tab, add `index.php` to the list.

6. If using IIS6, goto Web Service Extensions and add a new Web Service
   Extension. Name the extension "php", and click Add and browse to the
   `php8isapi.dll` file, enable Set Extension status to
   Enable, and click OK.

7. Give the IIS user read & execute permissions to the required files
   file `%windir%\system32\cmd.exe`. They will also need read permissions on
   `cacti_web_root/cacti` and it's subfolders.
   A anm example provided by one user included the following assuming the
   Cacti web root is `C:\inetpub\wwwroot\cacti`:

   ```
   icacls "C:\windows\system32\cmd.exe" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\resource\snmp_queries" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\resource\script_server" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\scripts" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\rra" /grant "IUSR:(OI)(CI)(RX,W)"
   icacls "C:\inetpub\wwwroot\cacti\log" /grant "IUSR:(OI)(CI)(RX,W)"
   copy /b NUL "C:\inetpub\wwwroot\cacti\include\vendor\csrf\csrf-secret.php"
   icacls "C:\inetpub\wwwroot\cacti\include\vendor\csrf\csrf-secret.php" /grant "IUSR:(RX,W)"
   ```
   
8. Completely stop and start the IIS service using the following commands:

   ```batchfile
   net stop iisadmin
   net start w3svc
   ```

## Cygwin Installation Steps for spine and RRDtool

1. Installing a single instance of Cygwin, and using it for all applications
   that require it is recommended so you do not have different versions of the
   Cygwin dlls laying around on your system, which can cause conflicts.

2. Run `setup-x86_64.exe` you previously download.

3. Once you reach the portion of setup entitled Select Packages, install the
   following noting that the versions numbers may have changed:

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

5. Move `setup-x86_64.exe` to `c:cygwin` for future use. This binary
   is updated from time to time, so it's recommended that you update it
   periodically.

## RRDtool Download and Installation Instructions

1. You can obtain Windows compatible versions for RRDtool at https://rrdtool.org.
   Install them into C:\rrdtool directory.

2. Create the MariaDB/MySQL database:

   ```sh
   shell> mysqladmin --user=root --password create cacti
   ```

3. Import the default Cacti database:

   ```sh
   shell> mysql --user=root --password cacti < c:\apache2\htdocs\cacti\cacti.sql
   ```

4. Create a MySQL username and password for Cacti.

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

1. If you plan to use any hosts with SNMP v2c support, and are using early
   versions of PHP, you must download and install the Net-SNMP libraries.
   Net-SNMP provides installers to install their product. However, caution must
   be taken if you choose to use long file names as Cacti does not see them as
   long file names. You will have to user 8.3 notation.

   Type | Name
   --- | ---
   Original | `c:\Program Files\Net-SNMP\bin`
   Becomes | `c:\progra~1\net-snmp\bin`.

## Cacti spine Installation

1. Extract the Spine zip file to `c:\spine` and modify the `spine.conf.dist`
   file to include the following statements.

   ```ini
   DB_Host  127.0.0.1 or hostname (not localhost)
   DB_Database cacti
   DB_User     cactiuser
   DB_Password cactiuser
   DB_Port     3306
   ```

   All other pre 0.8.6 settings are obsolete.

2. Spine now comes with a binary distribution. However, we strongly suggest that
   you install Cygwin and then remove all the DLL files and `sh.exe` from the
   `c:\spine` directory.  If you simply downloaded all the Cygwin components and
   compiled spine from source, the only two files you will require in the
   `c:\spine` directory will be `spine.exe` itself and `spine.conf`.

## Finishing your Setup

1. Edit `cacti_web_root/cacti/include/config.php` and specify the MariaDB/MySQL user,
   password, database, and database port for your Cacti configuration.

   ```php
   $database_default = "cacti";
   $database_hostname = "localhost";
   $database_username = "cactiuser";
   $database_password = "cactiuser";
   $database_port = "3306";
   ```

2. Point your web browser to:

   `http://your-server/cacti/`

   Log in using the username and password of admin/admin. You will be required
   to change this password immediately.

3. From Cacti, go to Settings -> Paths and verify/udate your paths to point to
   the correct locations. Recommended examples are posted below. If you plan on
   using Spine, then it is very important that all paths include forward slashes
   instead of backslashes.

   - PHP Binary Path:

     `c:/php/php.exe`

   - RRDtool Binary Path:

     `c:/rrdtool/rrdtool.exe`

   - SNMPGET, SNMPWALK, SNMPBULKWALK, SNMPGETNEXT Paths:

     `c:/usr/bin/snmpget.exe`
     `c:/usr/bin/snmpwalk.exe`
     `c:/usr/bin/snmpbulkwalk.exe`
     `c:/usr/bin/snmpgetnext.exe`

   - Cacti Logfile Path:

     `c:/mycacti/website/cacti/log/cacti.log`

   - Spine Path:

     `c:/spine/spine.exe`

4. If you chose automation, once the Cacti poller starts, it will create
   any compatible devices found on the network using the snmp settings
   and default automation rules.  These are tuned specifically for Linux
   Cisco and Windows devices by default.  A Localhost device will automatically
   be created for you at install time.
   
5. Log into the user account you'll be using for the scheduled task and verify
   starting a Cacti polling cycle works. Do this by running the following from
   the command prompt:

   ```sh
   php c:/cacti_web_root/cacti/poller.php
   ```

   The output should look something like the following:

   ```sh
   C:\>php c:inetpubwwwrootcactipoller.php
   OK u:0.00 s:0.06 r:1.32
   OK u:0.00 s:0.06 r:1.32
   OK u:0.00 s:0.16 r:2.59
   OK u:0.00 s:0.17 r:2.62
   10/28/2005 04:57:12 PM - SYSTEM STATS: Time:4.7272 Method:cmd.php Processes:1 Threads:N/A Hosts:1 HostsPerProcess:2 DataSources:4 RRDsProcessed:2
   ```

   After this has ran once, you should have `cacti.log` in `/cacti/log/` and
   RRDfiles in `/cacti/rra/`.

8. You are going to need to schedule a task while logged on as an Administrator.
   This task is required to you can run `poller.php` every 5 minutes. Make sure
   the Task Scheduler service is started and follow the steps below to begin.

   > **Note:* The following instructions are based on most Windows installs.

   1. Select Start -> Settings -> Control Panel and double click on Scheduled
      Tasks.

   2. Double click on Add Scheduled Task.

   3. Click Next and Browse on the following screen. Find `c:php` and select
      `php.exe`. Choose Daily on and click Next.

   4. Click Next again without changing the time or date settings.

   5. In the steps above, you should have granted access to the Cacti user, but
      if the poller encounters problems, make sure you have the correct permissions
      to the directories below:
      
      `cacti_web_root/cacti/rra`
      `cacti_web_root/log`

      Make sure the user has read, write, and execute access to the following
      directories:

      `c:\php`
      `c:\phpsapi`

   7. Click Next and Finish to close the wizard.

   8. Right click on the task you just created, and select Properties.

   9. Select the Schedule tab.

   10. Make sure Daily is selected and click the Advanced button.

   11. Check the Repeat checkbox, set it for 5 minutes and set the duration for
       24 hours.

   12. Click Ok

   13. In the Run textbox enter the following text making sure to use the
       appropriate paths.

       `c:\php\php.exe c:\mycacti\website\cacti\poller.php`

   The start in box should say `c:\mycacti\website\cacti`.

---
Copyright (c) 2004-2024 The Cacti Group
