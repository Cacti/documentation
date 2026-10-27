# General Installing Instructions

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

Install the packages required by the selected operating system and verify that
the configured web server, PHP handler, and database start at boot.

## Containers

Use an unprivileged container with its normal security profile where possible.
Diagnose the specific ICMP, socket, or filesystem permission that fails and
adjust only the required capability or policy. Do not remove AppArmor
confinement or make the entire container privileged as a general prerequisite.

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

Use the database versions and configuration described in
[Requirements](Requirements.md). The development branch recommends MySQL 8.4+
or MariaDB 10.11+. Check the installed server with the Cacti installer.

- mysql

- mysql-server

- libmysqlclient

or

- mariadb

- mariadb-server

- libmariadbclient

### PHP Modules

Use PHP 8.3 or later in the PHP 8 series and the extensions listed in
[Requirements](Requirements.md). Verify the CLI with `php -v` and `php -m` and
check web PHP separately in the installer. Source deployments also need
Composer and all extensions required by the selected revision's lock file.
Run `composer install --no-dev` as the deployment owner, then
`composer check-platform-reqs --no-dev`. Use the lock file rather than updating
dependencies during installation.

### Systems using PHP-FPM

After changing PHP configuration, test and restart the actual FPM service.
Service names can be versioned, for example on Debian and Ubuntu. Check the
installed unit rather than assuming that `php-fpm` is the service name. Confirm
its socket path and permissions match the web-server handler.

## FreeBSD

Use a patched release listed in [supported operating systems][supported-os].
Choose binary packages or the Ports Collection using the
[FreeBSD Handbook][freebsd-ports]. Run package and service administration
commands as root. Use the dedicated poller account for collection.

### Choose the Cacti version and PHP flavor

The FreeBSD `net-mgmt/cacti` port currently packages Cacti 1.2.31, not the
unreleased Cacti 1.3 development branch covered by this manual. For a packaged
release, follow its installed instructions and the [1.2.x manual][manual-12].
For development source, meet [Requirements](Requirements.md) and follow the
source-install steps below using FreeBSD paths and service configuration.
Do not overlay a source checkout onto files owned by `pkg`.

Cacti packages have PHP flavors. Discover the names available in your
configured repository before selecting one:

```sh
pkg update
pkg search -S name -x '^cacti(-php[0-9]+)?$'
```

For example, if the repository offers `cacti-php84` and the installation uses
PHP 8.4, review and install that flavor:

```sh
pkg install -n cacti-php84
pkg install cacti-php84
pkg info -D cacti-php84
pkg info -l cacti-php84
```

Replace the example name with the selected flavor. Read the transaction before
accepting it, particularly changes to PHP extensions and database clients.
Dependencies do not configure a web server or create a database server. Set up
a compatible local MariaDB/MySQL service, or an existing remote database,
and configure Apache or nginx with the matching PHP handler separately.
Use FreeBSD `service` and `sysrc` for installed rc.d services; Linux
`systemctl` examples do not apply.

### Build from ports when custom options are required

Use a maintained ports tree and read `/usr/ports/UPDATING`. Clone a tree only
if `/usr/ports` does not already contain one:

```sh
pkg install git
# New tree only:
git clone --depth 1 https://git.FreeBSD.org/ports.git /usr/ports
# Existing Git tree instead:
git -C /usr/ports pull --ff-only
```

Build the chosen flavor, for example:

```sh
cd /usr/ports/net-mgmt/cacti
make FLAVOR=php84 config
make FLAVOR=php84 install clean
```

The supported flavors and dependencies come from that ports revision. Follow
the handbook's dependency-management guidance before mixing custom ports with
binary packages. Rebuilding a port does not turn the packaged release into
Cacti development source.

### Check installed paths and services

The [Cacti port][freebsd-cacti] uses these default locations. Custom ports
options and existing Cacti settings can change them; inspect the installed
files and application configuration before copying commands.

| Item | Default location or account |
| --- | --- |
| Application and bundled schema | `/usr/local/share/cacti` |
| Database configuration | `/usr/local/share/cacti/include/config.php` |
| PHP configuration | `/usr/local/etc/php.ini` |
| RRD data | `/var/db/cacti/rra` |
| Log directory | `/var/log/cacti` |
| PHP CLI | `/usr/local/bin/php` |
| Packaged poller account | `cacti` |
| Web-server account | Commonly `www`; verify the service configuration |

The port supplies `include/config.php.sample`; preserve an existing
`include/config.php` and use the sample when creating a new one. Set the
intended timezone in both CLI and web PHP. Initialize a new database from the
bundled `cacti.sql`, grant the application account access to its database and
`mysql.time_zone_name`, and verify database timezone data is loaded. Never
import `cacti.sql` over an existing installation.

Check package-specific patches as well as upstream instructions. For example,
the current port sets `$php_snmp_support = false` for new configurations;
verify the installed setting and Net-SNMP paths when troubleshooting polling.

Configure write access only for the runtime directories needed by the actual
poller and web processes. Keep application code and database credentials
protected. Preserve Cacti's web-server restrictions on configuration, CLI,
resource, and data directories.

Create one Cacti schedule. For a five-minute launcher, an example entry in the
`cacti` user's crontab is:

```cron
*/5 * * * * /usr/local/bin/php -q /usr/local/share/cacti/poller.php
```

Match this cadence to **Cron/Daemon Interval** in Cacti. A system crontab needs
the account field as well. Check for an existing cron entry or daemon first;
do not run both. Use [Data Source Debugging](Data-Debug.md) and the Cacti log
to verify collection after completing the web installer.

### Optional Spine poller

The [Spine port][freebsd-spine] is `net-mgmt/cacti-spine`; its package is
`spine`. Install it only when its version matches the Cacti release you use:

```sh
pkg install -n spine
pkg install spine
```

Its default binary is `/usr/local/bin/spine`, with
`/usr/local/etc/spine.conf.sample` as the configuration example. Supply the
correct database connection in `spine.conf` and select the binary in Cacti.
Verify the poller account can run it. Grant ICMP privileges only when the
selected polling method requires them; do not apply a blanket setuid command.

For an existing installation, follow
[Upgrading Under FreeBSD](Upgrading-Cacti-Under-FreeBSD.md).

[freebsd-ports]: <https://docs.freebsd.org/en/books/handbook/ports/>
[freebsd-cacti]:
  <https://github.com/freebsd/freebsd-ports/tree/main/net-mgmt/cacti>
[freebsd-spine]:
  <https://github.com/freebsd/freebsd-ports/tree/main/net-mgmt/cacti-spine>
[manual-12]: <https://github.com/Cacti/documentation/tree/1.2.x>

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
MariaDB [cacti]> ALTER TABLE `automation_ips` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `automation_processes` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `data_source_stats_hourly_cache` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `data_source_stats_hourly_last` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `poller_output` ENGINE=InnoDB;
MariaDB [cacti]> ALTER TABLE `poller_output_boost_processes` ENGINE=InnoDB;
```

Before restoring database load balancing, verify the table-engine changes,
replication state and successful polling on the configured topology. A fixed
number of polling cycles is not proof that the cluster is ready.

## Install and Configure Cacti

These are fresh source-install examples for Cacti development (1.3).
Package-managed installations should use the maintainer's procedure instead.
For an existing installation, follow [Upgrading Cacti](Upgrading-Cacti.md). The
examples use `/var/www/html/cacti`; adjust that path and the service accounts
for your OS. Use administrator privileges for software installation and
permission changes.

### Extract the source and create the database

Obtain the intended source revision in a new installation directory. Do not run
these commands over an existing deployment:

```sh
git clone --branch develop --depth 1 https://github.com/Cacti/cacti.git cacti
mv cacti /var/www/html/cacti
cd /var/www/html/cacti
composer install --no-dev
composer check-platform-reqs --no-dev
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
local connection before entering credentials. A freshly imported development
schema uses application username `admin` and initial password `admin`. Open the
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
