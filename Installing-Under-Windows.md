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

5. PHP X - Install into the `c:php` folder. If you choose to install into
   `c:\Program Files\php`, you will have to use 8.3 filenames to reference it's
   binaries in Cacti.

6. MySQL 5.x - Install into the default location. This is typically:

   `c:\Program Files\MySQL\MySQL Server X.XX`.

7. (Optional) Cygwin - Download and execute `setup.exe` from the Cygwin website.
   Keep the `setup.exe` file for later use.  You will need Cygwin and its
   development packages for building RRDtool and spine.

8. (Optional) Net-SNMP - Install to the `c:net-snmp` directory. If you choose to
   use `c:\Program Files\net-snmp` you will have to use 8.3 filenames to
   reference its binaries in Cacti.

## Common OS Changes

The following changes will be required regardless of your selected Webserver.

1. Add the following directory to the existing Windows System `PATH` environment
   variable: `c:php`. The Windows path can be accessed via the Control Panel at:
   System -> Advanced -> Environment Variables -> System Variables.

2. Add the following directory to a new Windows System environment variable
   called `PHPRC`: `c:\php`.

3. Add a new Windows System environment variable called `MIBDIRS` set it to
   `c:\php\extrasmibs`

4. Rename the file `c:\php\php.ini.dist` to `php.ini`, and make the following
   changes to it:

   Uncomment the following lines.

   ```ini
   extension_dir = c:phpext
   extension=php_mysql.dll
   extension=php_snmp.dll
   extension=php_sockets.dll
   cgi.force_redirect = 0
   ```

5. In earlier installation guides to PHP, they recommended moving certain DLL's
   to the `c:\winnt\system32` directory. If so, you will have to remove those
   files. Please review the PHP installation documentation for instructions on
   removing those files.

6. If you want to allow template importing, uncomment the following line:

   ```ini
   file_uploads = On
   ```

7. Give the user who will be running the scheduled task, modify rights to the
   `.index` file in the location pointed to by the `MIBDIRS` Windows System
   environment variable.

## Web Server Configuration

1. Make sure you have stopped any IIS web servers before you proceed with Apache
   installation, or make sure Apache is configured on an alternate port.

2. If using Apache 2.x and PHP 5, then add the following lines.

   ```ini
   LoadModule php5_module c:\php\php5\apache2.dll
   AddType application/x-httpd-php .php
   DirectoryIndex index.html index.htm index.php
   ```

## IIS Specific Steps

1. Start the Internet Information Services (IIS) Manager, right click on the
   Default Web Site (in most cases) and select Properties.

2. Under the Home Directory tab, select Configuration and click Add. Browse to
   the path of `php4isapi.dll` or `php5isapi.dll`, and type in .php as the
   extension. Note: if using IIS6, Enable All Verbs and Script Engine.

3. Under the ISAPI Filters tab, click Add and browse to the `php4isapi.dll` or
   `php5isapi.dll` file. Name the filter "php" and click OK.

4. Under the Documents tab, add `index.php` to the list.

5. If using IIS6, goto Web Service Extensions and add a new Web Service
   Extension. Name the extension "php", and click Add and browse to the
   `php4isapi.dll` or `php5isapi.dll` file, enable Set Extension status to
   Enable, and click OK.

6. Give the `IUSR_XXXX` and `IIS_WPG` users read & execute permissions to the
   file `%windir%\system32\cmd.exe`. They will also need read permissions on
   `cacti_web_root/cacti` and it's subfolders.

7. If using IIS6, give the `IIS_WPG` user modify permissions to the folders
   `cacti_web_root/cacti/log` and `cacti_web_root/cacti/rrd`.

8. Completely stop and start the IIS service using the following commands:

   ```batchfile
   net stop iisadmin
   net start w3svc
   ```

## Cygwin Installation Steps for spine and RRDtool

1. Installing a single instance of Cygwin, and using it for all applications
   that require it is recommended so you do not have different versions of the
   Cygwin dlls laying around on your system, which can cause conflicts.

2. Run `setup.exe` or `setup-x64.exe` you previously download.

3. Once you reach the portion of setup entitled Select Packages, install the
   following:

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
         - libmariadb-devel
         - libmysqlclient18
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

5. Move `setup.exe` or `setup-x64.exe` to `c:cygwin` for future use. This binary
   is updated from time to time, so it's recommended that you update it
   periodically.

## RRDtool Download and Installation Instructions

1. TBD

## MySQL Download and Installation Instructions

1. Extract the MySQL zip file to a temp directory and run `setup.exe`.

2. Install MySQL to the default directory, or for the purposes of this manual to
   the `c:\MySQL` directory.

3. If running an older version of MySQL, start it by running
   `c:\MySQL\bin\win\mysqladmin.exe`. In more recent versions, this is not
   required.

4. Set a password for the root user

   ```sh
   shell> cd c:\mysql\bin
   shell> mysqladmin --user=root password somepassword
   shell> mysqladmin --user=root --password reload
   ```

5. Create the MySQL database:

   ```sh
   shell> mysqladmin --user=root --password create cacti
   ```

6. Import the default Cacti database:

   ```sh
   shell> mysql --user=root --password cacti < c:\apache2\htdocs\cacti\cacti.sql
   ```

7. Create a MySQL username and password for Cacti.

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

1. Extract the Spine zip file to `c:\cacti` and modify the `spine.conf.dist`
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
   `c:\cacti` directory.

## Finishing your Setup

1. Edit `cacti_web_root/cacti/include/config.php` and specify the MySQL user,
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

     `c:/cacti/rrdtool.exe`

   - SNMPGET, SNMPWALK, SNMPBULKWALK, SNMPGETNEXT Paths:

     `c:/progra~1/net-snmp/bin/snmpget.exe`
     `c:/progra~1/net-snmp/bin/snmpwalk.exe`
     `c:/progra~1/net-snmp/bin/snmpbulkwalk.exe`
     `c:/progra~1/net-snmp/bin/snmpgetnext.exe`

   - Cacti Logfile Path:

     `c:/mycacti/website/cacti/log/cacti.log`

   - Spine Path:

     `c:/cacti/spine.exe`

4. Click on Devices. Delete the Localhost devices as it intended for Linux
   environments In the upper right corner, click Add. Fill in the following
   information and then click Add.

   - Description: My Windows localhost
   - Hostname: localhost
   - Device Template: Windows Device

5. You should now be looking at the localhost device screen. Right under it's
   name, there should be some SNMP information listed, if not you should double
   check the SNMP settings on the server and firewall settings. In the upper
   right-hand corner, click on Create Graphs for this Host. On the following
   screen, select a disk partition and network interface. At the bottom of the
   page, click on Create.

6. Log into the user account you'll be using for the scheduled task and verify
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

7. You are going to need to schedule a task while logged on as an Administrator.
   This task is required to you can run `poller.php` every 5 minutes. Make sure
   the Task Scheduler service is started and follow the steps below to begin.

   > **Note:* The following instructions are based on Windows XP and Windows
   > Server 2003. You should be able to follow these instructions close enough
   > for Windows 2000 as well.

   1. Select Start -> Settings -> Control Panel and double click on Scheduled
      Tasks.

   2. Double click on Add Scheduled Task.

   3. Click Next and Browse on the following screen. Find `c:php` and select
      `php.exe`. Choose Daily on and click Next.

   4. Click Next again without changing the time or date settings.

   5. When entering a username and password make sure the user has read and
      write access to the following directories:

      `cacti_web_root/cacti/rra`
      `cacti_web_root/log`

      Make sure the user has read, write, and execute access to the following
      directories:

      `c:\php`
      `c:\phpsapi`

   6. Click Next and Finish to close the wizard.

   7. Right click on the task you just created, and select Properties.

   8. Select the Schedule tab.

   9. Make sure Daily is selected and click the Advanced button.

   10. Check the Repeat checkbox, set it for 5 minutes and set the duration for
       24 hours.

   11. Click Ok

   12. In the Run textbox enter the following text making sure to use the
       appropriate paths.

       `c:\php\php.exe c:\mycacti\website\cacti\poller.php`

   The start in box should say `c:\mycacti\website\cacti`.

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
