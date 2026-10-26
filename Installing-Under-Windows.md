# Installing Under Windows

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

These instructions describe a manual installation of Cacti development (1.3) on
Windows. Use the [requirements](Requirements.md) for your Cacti release and
supported Windows builds of PHP, your database server and RRDtool. Community
Windows installers are also discussed in the [Cacti
forums](https://forums.cacti.net/); check their included versions and
maintenance status before using them.

The examples use `C:\inetpub\wwwroot\cacti` for Cacti, `C:\php` for PHP,
`C:\rrdtool` for RRDtool and `C:\spine` for optional Spine. Substitute your
actual paths throughout. Use a dedicated Windows account for the poller and a
separate web-server identity. Install software and configure services as an
administrator; the poller does not normally need administrator privileges.

## Development packaging prerequisite

The current development dependency manifest requires PHP `^8.3`, including
`ext-pcntl` and `ext-posix` unconditionally. Native Windows PHP cannot supply
those two extensions. A source checkout therefore cannot currently install its
Composer dependencies on native Windows. A bundled artifact must also pass its
generated runtime platform check. Stop if it rejects Windows and use a
compatible release or a Unix installation. Do not bypass platform checks or
edit generated vendor files to force an incompatible installation.

The remaining instructions apply only to an artifact that passes its platform
checks. Read the [PHP PCNTL platform restriction][pcntl] and the selected
revision's [dependency manifest][manifest] before choosing an artifact.

## Install the software

1. Choose IIS or Apache and install only the web server you intend to use on
   the selected address and port.

2. Extract the Cacti ZIP distribution into the chosen web directory.

3. Install PHP and its required runtime libraries using the
   [PHP Windows installation instructions][php-windows]. Match the architecture
   and build type to your web-server integration. Use a Non-Thread-Safe build
   for IIS FastCGI; an Apache module requires a compatible Thread-Safe build.
   A path without spaces, such as `C:\php`, simplifies tool configuration.

4. Install a Windows build of [RRDtool](https://oss.oetiker.ch/rrdtool/) and
   verify its runtime dependencies. If using Spine, install a compatible
   [Spine release](Spine.md) and the dependencies supplied or required by that
   build. The PHP poller can be used without Spine.

5. Install MySQL or MariaDB. Use the server's supported Windows configuration
   and service-management instructions. Start with its documented defaults,
   then review the Cacti installer's checks for your actual server and
   workload.

   Do not copy a tuning block from a different database version or operating
   system. MySQL 8 removed `NO_AUTO_CREATE_USER`, `innodb_file_format` and
   `innodb_large_prefix`; these settings can prevent startup. Do not disable
   InnoDB doublewrite protection or reduce commit durability as an installation
   shortcut. Size global and per-connection buffers for the available memory
   and expected concurrency.

6. Install Net-SNMP command-line tools if your collection configuration needs
   them, for example into `C:\usr`. Cacti uses these tools for SNMPv3
   requests from the web interface and PHP poller; PHP's SNMP extension alone
   does not provide that collection path. Verify the installed executable paths
   instead of assuming a particular short filename or installation directory.

## Configure PHP

Copy `php.ini-production` from the PHP distribution to `C:\php\php.ini`. Set
the timezone for your installation and enable the required extensions. For
current PHP Windows builds, an example configuration is:

```ini
extension_dir = "C:\php\ext"
extension=curl
extension=pdo_mysql
extension=sqlite3
extension=gd
extension=gmp
extension=intl
extension=ldap
extension=mbstring
extension=openssl
extension=sockets
extension=com_dotnet
; Enable if using PHP's SNMP extension:
extension=snmp

date.timezone = America/Detroit
file_uploads = On
```

Use only extensions supplied for the selected PHP build and install their
required DLL dependencies according to PHP's instructions. Some modules are
built in. The Cacti installer checks additional modules, including SimpleXML,
XML and zlib, in both the web and command-line environments. `pdo_mysql` is the
database driver Cacti uses; the removed `php_mysql.dll` is not a substitute.
Set memory and execution limits using the installer recommendations for your
installation rather than copying values sized for another server.

Check the command-line configuration before configuring the web server:

```console
C:\php\php.exe --ini
C:\php\php.exe -m
```

Set `PHPRC` to `C:\php` for the web-server and poller environments if needed to
select this configuration. An absolute path to `php.exe` avoids depending on
`PATH` for scheduled tasks. Ensure required DLLs are discoverable by both
identities; do not copy PHP DLLs into Windows system directories.

If loading external MIBs, set `MIBDIRS` to their actual directory and allow the
collecting account to update the Net-SNMP index/cache there if needed. This is
separate from permission to modify executable files.

After changing PHP configuration, recycle the application pool or restart the
selected web-server service. Confirm the Cacti installer reports the expected
configuration and modules for both web PHP and CLI PHP.

## Configure the web server

### IIS with FastCGI

Follow the [PHP IIS instructions][php-iis] and Microsoft's
[FastCGI configuration reference][iis-fastcgi].

1. Enable the IIS CGI role service, which supplies FastCGI support.

2. Create the Cacti site/application and a dedicated application pool. Match
   the pool architecture to PHP. In Handler Mappings, map `*.php` through
      `FastCgiModule` to `C:\php\php-cgi.exe`, not `php.exe`. Use the
   corresponding
   FastCGI application entry and allow script execution for the application.
   PHP 8 does not provide `php8isapi.dll`; do not configure an ISAPI filter.

3. Add `index.php` to the site's Default Document list. Apply the PHP CGI
   settings required by the PHP IIS guide, including `cgi.force_redirect=0`
   for IIS. Configure authentication/impersonation deliberately so the account
   accessing Cacti files is known.

4. Configure an HTTPS binding and restrict access during installation. Recycle
   the affected application pool after configuration changes.

### Apache

Follow the [PHP Apache instructions][php-apache] for a matching Apache/PHP
build. For Apache 2.4 with a compatible PHP 8 Thread-Safe module, the relevant
configuration is:

```apache
LoadModule php_module "C:/php/php8apache2_4.dll"
<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
DirectoryIndex index.php index.html
PHPIniDir "C:/php"
```

Check Apache's configuration before restarting its service. If using FastCGI
instead of the Apache module, follow that integration's PHP instructions and
use the appropriate PHP build.

## File permissions

Identify the effective web identity and the scheduled-task account before
setting ACLs. For IIS, this may be `IIS AppPool\Cacti` for a pool named
`Cacti`, or another account selected by authentication and FastCGI
impersonation. See Microsoft's [application-pool identity
guidance][iis-identity]. Do not assume the account is always `IUSR`.

Give the web and poller identities read access to Cacti's code and
configuration, and read/execute access to PHP, RRDtool, SNMP and optional Spine
programs and their dependencies. If PHP requires `cmd.exe` to launch a command,
allow only the necessary read/execute access. Do not grant either identity
write access to Windows system executables or to tool installation directories.

The poller needs Modify permission on `rra` and `log` and on the cache
subdirectories it uses. The web identity also needs Modify permission on `log`,
its configured temporary/session directories and the Cacti cache subdirectories
used by features such as real-time graphs. Use the installer's permission
checks to identify the required paths, including `cache/boost`,
`cache/mibcache`, `cache/realtime` and `cache/spikekill`. Grant access only to
the identities and paths that need it, accounting for inherited ACLs.

During installation or signed-package imports, Cacti also needs to write
queries and scripts under `resource/snmp_queries`, `resource/script_server`,
`resource/script_queries` and `scripts`. Grant temporary Modify access to the
identity performing that operation, then remove it when finished. The installer
also needs to initialize a nonempty CSRF secret, by default
`include/vendor/csrf/csrf-secret.php`. Allow creation in its containing
directory during setup, then retain read access to the generated secret and
remove the temporary directory write permission. Do not create an empty
placeholder secret.

Edit `include/config.php` as an administrator. Keep it readable by the web and
poller identities but not writable by them for ordinary operation. If a
specific installation operation needs to update it, grant temporary write
access for that operation and remove it afterward.

## Create the database

The following commands are for **Command Prompt**, not PowerShell. Use the
actual path to `mysql.exe` or the equivalent MariaDB client if it is not on
`PATH`. The `--password` option prompts for the database administrator's
password; do not put that password on the command line.

```console
mysql --user=root --password
```

Create an empty database and a dedicated application account. Replace
`REPLACE_WITH_UNIQUE_DATABASE_PASSWORD` with a unique secret before executing
this SQL. The example account and connection use TCP loopback consistently.

```sql
CREATE DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cacti_user'@'127.0.0.1'
  IDENTIFIED BY 'REPLACE_WITH_UNIQUE_DATABASE_PASSWORD';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_user'@'127.0.0.1';
GRANT SELECT ON mysql.time_zone_name TO 'cacti_user'@'127.0.0.1';
```

Exit the SQL client and import the schema from the same Cacti release you
extracted:

```console
mysql --user=root --password --default-character-set=utf8mb4 cacti < "C:\inetpub\wwwroot\cacti\cacti.sql"
```

Ensure the server's time-zone tables are populated using its documented Windows
procedure. Granting access to an empty `mysql.time_zone_name` table does not
populate it. Resolve the database and time-zone checks reported by the Cacti
installer before completing installation.

## Optional Cygwin and Spine configuration

If your Spine or RRDtool build depends on Cygwin, install the runtime packages
required by that build using the official
[Cygwin installer](https://cygwin.com/).
For a source build, follow the release's build instructions and select its
current compiler/development dependencies. Do not replace or delete DLLs
shipped with a binary distribution without checking that distribution's
requirements. Avoid mixing incompatible Cygwin runtimes.

For Spine, copy `spine.conf.dist` to `spine.conf` and set the connection
details to match Cacti. Replace the password placeholder with the same
application secret used above, not a sample password:

```ini
DB_Host     127.0.0.1
DB_Database cacti
DB_User     cacti_user
DB_Pass     REPLACE_WITH_UNIQUE_DATABASE_PASSWORD
DB_Port     3306
```

Restrict access to `spine.conf` to administrators and the poller account.
Verify Spine from that account before selecting it as the poller in Cacti.

## Finish the Cacti installation

1. Copy `include/config.php.dist` to `include/config.php` and set its database
   connection. Replace the password placeholder with your application secret:

   ```php
   $database_default  = 'cacti';
   $database_hostname = '127.0.0.1';
   $database_username = 'cacti_user';
   $database_password = 'REPLACE_WITH_UNIQUE_DATABASE_PASSWORD';
   $database_port     = '3306';
   $url_path          = '/cacti/';
   ```

   Adjust `$url_path` if Cacti is served at another URL path.

2. Open the Cacti URL through HTTPS. For a freshly imported development schema,
   sign in with application username `admin` and initial password `admin`,
   then choose a unique administrator password when prompted. These are
   separate from the database credentials. Complete the installer and resolve
   its dependency, database, path and permission checks before allowing
   general access.

3. In **Console > Configuration > Settings > Paths**, verify the executable
   paths against your installation. For the example layout:

   | Setting | Example |
   | --- | --- |
   | PHP binary | `C:/php/php.exe` |
   | RRDtool | `C:/rrdtool/rrdtool.exe` |
      | SNMP tools, if used | `C:/usr/bin/snmpget.exe`, `snmpwalk.exe`, `snmpbulkwalk.exe`, `snmpgetnext.exe` |
   | Cacti log | `C:/inetpub/wwwroot/cacti/log/cacti.log` |
   | Spine, if used | `C:/spine/spine.exe` |

   Use the CLI PHP executable here, not the IIS FastCGI executable. Verify the
   separate Spine configuration path if selecting Spine.

4. Create devices and graphs deliberately, or configure discovery and
   automation
   rules for the intended network. Installing Cacti does not establish that
   every discovered device exposes all measurements in its selected template.

## Schedule and verify the poller

Log on as the intended poller account and test the same executable and paths
that the task will use:

```console
C:\php\php.exe -q C:\inetpub\wwwroot\cacti\poller.php
```

Check `log/cacti.log`, data-source polling and graph updates. RRD files are
created for configured data sources; an installation without graphs need not
create them. Resolve permission and configuration errors before scheduling.

Open **Task Scheduler** and choose **Create Task**:

1. Select the dedicated poller account and **Run whether user is logged on or
   not**, with the account rights needed for batch logon. Do not enable
   **Run with highest privileges** unless a documented local requirement needs
   it.

2. Add a daily trigger that repeats every **5 minutes** indefinitely for the
   default five-minute scheduler configuration. If changing Cacti's scheduler
   interval, adjust this trigger to match it; the scheduler interval and data
   source polling intervals are separate settings.

3. Add a **Start a program** action with these separate fields:

   - **Program/script:** `C:\php\php.exe`
   - **Add arguments:** `-q "C:\inetpub\wwwroot\cacti\poller.php"`
   - **Start in:** `C:\inetpub\wwwroot\cacti`

4. Under **Settings**, choose **Do not start a new instance** if the task is
   already running. Review any task execution limit against the configured
   polling cycle; do not terminate a healthy poller prematurely.

Run the task manually, then verify subsequent scheduled runs, Task Scheduler's
result/history, Cacti's poller statistics and graph freshness. Recheck these
under the task account after changing PHP, paths, credentials or ACLs.

## References

- [Cacti development (1.3) PHP dependency checks][cacti-extensions]
- [Cacti development (1.3) installation permission checks][cacti-permissions]
- [PHP Windows installation][php-windows], [IIS][php-iis] and
  [Apache][php-apache]
- [Microsoft FastCGI configuration][iis-fastcgi] and
  [application-pool identities][iis-identity]
- [MySQL 8 removed features][mysql-removed]
- [Microsoft Task Scheduler][task-scheduler]

[pcntl]:<https://www.php.net/manual/en/pcntl.installation.php>
[manifest]:<https://github.com/Cacti/cacti/blob/develop/composer.json>
[php-windows]:<https://www.php.net/manual/en/install.windows.manual.php>
[php-iis]:<https://www.php.net/manual/en/install.windows.iis.php>
[php-apache]:<https://www.php.net/manual/en/install.windows.apache2.php>
[iis-fastcgi]:<https://learn.microsoft.com/en-us/iis/configuration/system.webserver/fastcgi/>
[iis-identity]:<https://learn.microsoft.com/en-us/iis/manage/configuring-security/application-pool-identities>
[mysql-removed]:<https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html>
[task-scheduler]:<https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page>
[cacti-extensions]:<https://github.com/Cacti/cacti/blob/develop/lib/utility.php>
[cacti-permissions]:<https://github.com/Cacti/cacti/blob/develop/lib/installer.php>

[supported-os]: Requirements.md#supported-operating-systems

---

Copyright (c) 2004-2026 The Cacti Group
