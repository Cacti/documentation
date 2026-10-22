# General Installing Instructions

Make sure the following packages are installed according to your operating
systems requirements. Verify, that httpd/apache and MySQL/MariaDB are started at
system startup.

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

The installation of these modules vary by OS. Use the `php -m` command to verify
that they are installed.

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

### A special note for systems using PHP-FPM

Prior to starting the setup process of Cacti you should restart the PHP-FPM
Daemon to rebuild the Cache or you may receive a HTTP 500 Error

```console
systemctl restart php-fpm
```

## FreeBSD

When installing on FreeBSD you can use two ways. For both ways, cacti has a lot
of dependent packages, you don't need to install anything else. Everything is
prepared. Both ways have few pros and cons:

- Compiled packages - fast, but invariant dependencies (like older MySQL server,
  PHP version, ...)

  ```sh
  pkg install cacti
  pkg install spine
  ```

- FreeBSD ports - compilation could last long time, but without invariant
  dependencies (See
  [Howto use ports](https://www.freebsd.org/doc/handbook/ports-using.html))

  ```sh
  pkg install git
  git clone https://git.FreeBSD.org/ports.git /usr/ports
  git -C /usr/ports pull
  cd /usr/ports/databases/mariadb106-server (or mysql80-server)
  make install
  cd /usr/ports/net-mgmt/cacti
  make install
  cd /usr/ports/net-mgmt/spine
  make install
  ```

Apache and other software is possible install with package or Ports too.

Everything in FreeBSD is installed to /usr/local/ directory! In this
documentation you can see paths like /etc/php.ini, /usr/bin/spine, ...

Please use correct paths - /usr/local/etc, /usr/local/bin/spine, ...

For Spine set suid bit (without this isn't possible make ICMP ping):

```sh
chmod +s /usr/local/bin/spine
```

## Configure PHP

Verify that the modules are installed and configured correctly. There are
several ways to do so - consult
[PHP configuration instructions](http://www.php.net/manual/en/configuration.php)
for a complete description.

It is imperative that you set the `date.timezone` in your `/etc/php.ini`, or
`/etc/phpX/apache/php.ini` and `/etc/phpX/cli/php.ini` files. Failure to do so
will result in errors after the install is complete.

Most other PHP configuration is done automatically by the base OS, so there is
no need to discuss that here.

## Configure the Webserver (Apache)

Most Linux/UNIX OS' automatically configure the Web Server to allow PHP content.
So there should be no need to provide additional configuration. However, the
following section is included below for reference in the case that you are
running a UNIX version that does not properly configure the Webserver properly.
The documentation below is written specifically for RHEL and variants. So, the
instructions may vary.

Find the file `/etc/httpd/conf/httpd.conf` or its equivalent and make the
following changes to it:

```ini
# Load config files from the config directory "/etc/httpd/conf.d".
Include conf.d/*.conf
```

Now, locate the PHP configuration file at `/etc/httpd/conf.d/php.conf`

```ini
# PHP is an HTML-embedded scripting language which attempts to make it
# easy for developers to write dynamically generated webpages.
LoadModule php_module modules/libphp.so
#
# Cause the PHP interpreter to handle files with a .php extension.
AddHandler php-script .php
AddType text/html .php
#
# Add index.php to the list of files that will be served as directory
# indexes.
DirectoryIndex index.php
```

## Configure MySQL/MariaDB

Set a password for the root user, and record this password. If you loose control
of this password, you may have to re-install your database server in the case of
any system disaster or recovering from a crash.

```sh
shell> mysqladmin --user=root password somepassword
shell> mysqladmin --user=root --password reload
```

You must also load timezone information into the database. This is required for
various plugin use. Later, you will be required to grant access to the
`time_zone_name` table during the final installation steps.

```sh
shell> mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
```

Since Cacti 1.x is supporting internationalization (i18n), it is important that
the default character set for MySQL/MariaDB be i18n compatible. The Cacti
installer will make specific recommendations on MySQL/MariaDB settings. Follow
those as applicable for your OS.

Galera clustering: There are several tables which are set to use the MEMORY
storage engine which do not get replicated among nodes which can cause problems.
If you configure Cacti to only connect to one node of your cluster and are not
load balancing this does not apply to you.

If you are running multiple nodes in a load-balanced environment where you
connect to a VIP you should remove all but one node from rotation during Cacti
installation or update. After the installation/update login to your MySQL server
and execute the following commands to update those tables to use the InnoDB
engine:

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
create an empty secret file. See the platform-specific installation guides
for their account and permission examples.

Restrict installer access to the administrator and use HTTPS or a protected
local connection before entering credentials. A freshly imported 1.2.31
schema uses application username `admin` and initial password `admin`. Open
the configured Cacti URL, sign in and choose a unique administrator password
when prompted. These are separate from the database credentials. Complete the
installer's dependency, database, path and permission checks before allowing
general access.

### Schedule collection after installation

Use either cron or `cactid.service`, not both. The following examples assume
an existing local user and group named `cacti` with the required polling
permissions; replace them with the actual service identity for your system.
Do not start polling before completing the web installer.

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
Verify scheduler execution, collector status, logs and recent graph data
under the configured account.

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
it. Use the installed `spine.conf.dist` as the example, and configure the actual
Spine configuration path in Cacti. Use the same database account and secret
as the Cacti configuration, and restrict file access to the poller account
and administrators.

```ini
DB_Host     localhost
DB_Database cacti
DB_User     cactiuser
DB_Pass     REPLACE_WITH_UNIQUE_DATABASE_PASSWORD
DB_Port     3306
```

### Considerations when using Proxys in front of Cacti (Cacti 1.2.23+)

A header allowlist does not authenticate a proxy. Trust forwarded client-IP
headers only when a trusted proxy replaces those headers and untrusted clients
cannot bypass it to reach Cacti directly. Select only headers supplied by that
proxy in `include/config.php`:

```php
/*
 * Allow the use of Proxy IPs when searching for client
 * IP to be used
 *
 * This can be set to one of the following:
 *   - false: to use only REMOTE_ADDR
 *   - true: to use all allowed headers (not advised)
 *   - array of one or more the following:
 *		'X-Forwarded-For',
 *		'X-Client-IP',
 *		'X-Real-IP',
 *		'X-ProxyUser-Ip',
 *		'CF-Connecting-IP',
 *		'True-Client-IP',
 *		'HTTP_X_FORWARDED',
 *		'HTTP_X_FORWARDED_FOR',
 *		'HTTP_X_CLUSTER_CLIENT_IP',
 *		'HTTP_FORWARDED_FOR',
 *		'HTTP_FORWARDED',
 *		'HTTP_CLIENT_IP',
 *
 * NOTE: The following will always be checked:
 *		'REMOTE_ADDR',
 */
$proxy_headers = null;

```

---

Copyright (c) 2004-2026 The Cacti Group
