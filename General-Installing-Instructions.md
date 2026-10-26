# General Installing Instructions

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

Install the packages required by the selected operating system and verify that
the configured web server, PHP handler, and database start at boot.

## Required Packages for Most Operating Systems

Depending on your operating system and PHP version, certain packages are
required for Cacti. The largest variable in these requirements come with regard
to PHP and MySQL/MariaDB.

Installation requirements include the packages below. The installation of these
packages will vary by operating system.

### Base OS

- apache, IIS, or nginx

- net-snmp, net-snmp-utils

- rrdtool

- help2man (for spine)

- dos2unix (for spine)

- development packages (gcc, automake, autoconf, libtool, either mysql-devel or
  mariadb-devel, net-snmp-devel, help2man)

  (for spine)

### Database

Use MySQL or MariaDB and check the installed version and configuration with
the Cacti 1.2.31 installer. The release's historical compatibility values and
version-dependent tuning checks are described in
[Requirements](Requirements.md).
MySQL 5.7 and MariaDB 10.2 are not upper-version limits established by those
checks. Passing a configuration check does not certify every database version.

- mysql

- mysql-server

- libmysqlclient

or

- mariadb

- mariadb-server

- libmariadbclient

### PHP Modules

The installation of these modules vary by OS. Use the `php -m` command to
verify that they are installed.

- posix

- session

- sockets

- PDO

- pdo_mysql

- xml

- ldap

- mbstring

- pcre

- json

- openssl

- gd

- zlib

### PHP Optional Modules

The following modules are optional, but preferred to be installed.

- snmp

- gmp (for plugin support)

- com or dotnet (windows only)

### Systems using PHP-FPM

After changing PHP configuration, test and restart the actual FPM service.
Service names can be versioned, for example on Debian and Ubuntu. Check the
installed unit rather than assuming that `php-fpm` is the service name. Confirm
its socket path and permissions match the web-server handler.

## FreeBSD

Use the [FreeBSD Handbook][freebsd-ports] to choose binary packages or ports
and follow the installed package's notes. Inspect the offered Cacti version,
PHP dependencies, database service, web integration, and configuration paths
before installing. Do not assume a package contains a development revision.

For binary packages, review the proposed transaction first:

```sh
pkg install -n cacti
pkg install cacti
```

Install optional Spine separately if required. Do not mix ports and binary
packages without reviewing dependency and build-option compatibility. Package
dependencies alone do not configure the database or web server.

FreeBSD commonly installs third-party software under `/usr/local`. Adapt Linux
examples such as `/etc/php.ini` and `/usr/bin/spine` to the actual installed
paths. Grant ICMP privileges only when required by the selected collector and
package; do not apply a blanket setuid command to an unverified binary. Use
[Upgrading Under FreeBSD](Upgrading-Cacti-Under-FreeBSD.md) for an existing
installation.

[freebsd-ports]:<https://docs.freebsd.org/en/books/handbook/ports/>

## Configure PHP

Verify that the modules are installed and configured correctly. There are
several ways to do so - consult
[PHP configuration instructions][php-config]
for a complete description.

It is imperative that you set the `date.timezone` in your `/etc/php.ini`, or
`/etc/phpX/apache/php.ini` and `/etc/phpX/cli/php.ini` files. Failure to do so
will result in errors after the install is complete.

Most other PHP configuration is done automatically by the base OS, so there is
no need to discuss that here.

## Configure the Webserver (Apache)

Use the distribution's Apache/PHP integration, selecting either its PHP-FPM
handler or a compatible Apache PHP module. Do not configure both handlers for
the same files. The [Enterprise Linux LAMP guide][lamp] and
[Ubuntu/Debian guide](Installing-Under-Ubuntu-Debian.md) provide examples.

Verify Apache's configuration before reloading. Restrict access during setup,
use HTTPS, and ensure that PHP requests execute rather than expose source. Keep
Cacti's shipped `.htaccess` restrictions active, or reproduce them in the
server configuration if overrides are disabled. nginx and IIS need their own
restrictions; they do not interpret Apache `.htaccess` files.

## Configure MySQL/MariaDB

Initialize and secure the database using the procedure for the installed MySQL
or MariaDB package. Use the administrator authentication method configured by
that package; some Unix packages use local socket authentication. Store
credentials securely and do not put passwords directly on shell command lines.

You must also load timezone information into the database. This is required for
various plugin use. Later, you will be required to grant access to the
`time_zone_name` table during the final installation steps.

```sh
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
```

Since Cacti 1.x is supporting internationalization (i18n), it is important that
the default character set for MySQL/MariaDB be i18n compatible. The Cacti
installer will make specific recommendations on MySQL/MariaDB settings. Follow
those as applicable for your OS.

Galera clustering: There are several tables which are set to use the MEMORY
storage engine which do not get replicated among nodes which can cause
problems. If you configure Cacti to only connect to one node of your cluster
and are not load balancing this does not apply to you.

If you are running multiple nodes in a load-balanced environment where you
connect to a VIP you should remove all but one node from rotation during Cacti
installation or update. After the installation/update login to your MySQL
server and execute the following commands to update those tables to use the
InnoDB engine:

```sql
MariaDB [(none)]> use cacti;
MariaDB [cacti]>> ALTER TABLE `automation_ips` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `automation_processes` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `data_source_stats_hourly_cache` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `data_source_stats_hourly_last` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `poller_output` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `poller_output_boost_processes` ENGINE=InnoDB;
```

Before restoring database load balancing, verify the table-engine changes,
replication state and successful polling on the configured topology. A fixed
number of polling cycles is not proof that the cluster is ready.

## Install and Configure Cacti

These are fresh source-install examples for Cacti 1.2.31. Package-managed
installations should use the maintainer's procedure instead. For an existing
installation, follow [Upgrading Cacti](Upgrading-Cacti.md). The examples use
`/var/www/html/cacti`; adjust that path and the service accounts for your OS.
Use administrator privileges for software installation and permission changes.

### Extract the source and create the database

Extract the intended release into the installation directory. Do not run these
commands over an existing deployment:

```sh
tar -xzf cacti-1.2.31.tar.gz
mv cacti-1.2.31 /var/www/html/cacti
```

The installation root should now contain `cacti.sql`, `poller.php` and
`include/config.php.dist`, rather than another nested release directory.

Connect with a database administrator account:

```sh
mysql --user=root --password
```

Create the database and a dedicated application account. Replace the password
placeholder before running this SQL, and use the same secret in the Cacti
configuration. The database account is separate from the operating-system
account that runs the poller.

```sql
CREATE DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cactiuser'@'localhost'
  IDENTIFIED BY 'REPLACE_WITH_UNIQUE_DATABASE_PASSWORD';
GRANT ALL PRIVILEGES ON cacti.* TO 'cactiuser'@'localhost';
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';
EXIT;
```

Use an authorized database administrator to grant access. Do not edit
`mysql.tables_priv` as a substitute for an authorized `GRANT` operation. Ensure
the server's timezone tables are populated using the procedure for the
installed MySQL or MariaDB server; granting access does not populate them.

Import the schema into the new database using the appropriate client:

```sh
mysql --user=root --password --default-character-set=utf8mb4 cacti \
  < /var/www/html/cacti/cacti.sql
```

The `--password` option prompts for the password. Use `mariadb` in place of
`mysql` where appropriate for the installed server.

### Configure access and complete installation

Copy the supplied configuration example:

```sh
cp /var/www/html/cacti/include/config.php.dist \
  /var/www/html/cacti/include/config.php
```

Edit the copied file to match the account created above:

```php
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'cactiuser';
$database_password = 'REPLACE_WITH_UNIQUE_DATABASE_PASSWORD';
$database_port     = '3306';
$url_path          = '/cacti/';
```

Identify the actual web and poller service accounts. Give them the required
read/execute access to application files and external tools, and write access
to the runtime paths they use, including RRD, log and cache paths. They need
not be the same account. Do not assume a database username is also a local OS
account or make the whole application tree writable.

During installation and package imports, grant the performing identity the
additional access required by the installer, including query/script resources
and the location used to initialize the CSRF secret. Remove temporary setup
permissions afterward. Preserve read access to the generated secret; do not
create an empty secret file. See the platform-specific installation guides for
their account and permission examples.

Restrict installer access to the administrator and use HTTPS or a protected
local connection before entering credentials. A freshly imported 1.2.31 schema
uses application username `admin` and initial password `admin`. Open the
configured Cacti URL, sign in and choose a unique administrator password when
prompted. These are separate from the database credentials. Complete the
installer's dependency, database, path and permission checks before allowing
general access.

### Schedule collection after installation

Use either cron or `cactid.service`, not both. The following examples assume an
existing local user and group named `cacti` with the required polling
permissions; replace them with the actual service identity for your system. Do
not start polling before completing the web installer.

For a system cron file such as `/etc/cron.d/cacti`, use an absolute PHP CLI
path and include the OS username:

```console
*/5 * * * * cacti /usr/bin/php /var/www/html/cacti/poller.php >/dev/null 2>&1
```

The five-minute launch interval must match **Cron/Daemon Interval** under the
poller settings. This is separate from individual data-source polling
intervals. The redirection above works with `/bin/sh`; `&>` is Bash-specific.

The supplied systemd unit uses `Type=forking`. Confirm that the selected PHP
CLI provides `pcntl_fork` before using it; otherwise use cron or install the
appropriate PCNTL support. For the example CLI path, this should report
`bool(true)`:

```sh
/usr/bin/php -r 'var_dump(function_exists("pcntl_fork"));'
```

For systemd, copy the supplied unit and edit the installed copy:

```sh
cp /var/www/html/cacti/service/cactid.service \
  /etc/systemd/system/cactid.service
```

Replace the unit's existing `User`, `Group`, `ExecStart` and `EnvironmentFile`
settings with values for the actual deployment, retaining its other settings.
For example:

```ini
User=cacti
Group=cacti
ExecStart=/usr/bin/php /var/www/html/cacti/cactid.php
EnvironmentFile=-/etc/default/cactid
```

The `-` allows the optional environment file to be absent. Disable the
Cacti-specific cron entry before enabling the daemon, then load the edited
unit:

```sh
systemctl daemon-reload
systemctl enable cactid.service
systemctl start cactid.service
systemctl status cactid.service
```

The unit manages the local daemon; it does not establish high availability.
Verify scheduler execution, collector status, logs and recent graph data under
the configured account.

## (Optional) Install and Configure Spine

Spine is a very fast data collection engine, written in C. It is an optional
replacement for cmd.php. If you decide to use it, you will have to install it
explicitly. It does not come with cacti itself.

The easiest way is to install Spine using rpm or ports. You will find packages
for Spine at the main cacti site or from your distribution.

To compile Spine, download it to any location of your liking. Then, issue from
the downloaded directory following commands

```sh
./bootstrap
```

After `bootstrap` succeeds, follow the release's build instructions to
configure, compile and install Spine.

Assuming, you've managed to install spine correctly, you will have to configure
it. Use the installed `spine.conf.dist` as the example, and configure the
actual Spine configuration path in Cacti. Use the same database account and
secret as the Cacti configuration, and restrict file access to the poller
account and administrators.

```ini
DB_Host     localhost
DB_Database cacti
DB_User     cactiuser
DB_Pass     REPLACE_WITH_UNIQUE_DATABASE_PASSWORD
DB_Port     3306
```

### Considerations when using Proxies in front of Cacti (Cacti 1.2.23+)

A header allowlist does not authenticate a proxy. Trust forwarded client-IP
headers only when a trusted proxy replaces those headers and untrusted clients
cannot bypass it to reach Cacti directly. Leave forwarding disabled otherwise.
In `include/config.php`, select only the headers your proxy sets. For a
deployment using `X-Forwarded-For`, the setting is:

```php
$proxy_headers = ['X-Forwarded-For'];
```

[lamp]: Install-Under-Enterprise-Linux-LAMP.md
[supported-os]: Requirements.md#supported-operating-systems

[php-config]:<https://www.php.net/manual/en/configuration.php>

---

Copyright (c) 2004-2026 The Cacti Group
