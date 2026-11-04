# Installing Cacti Development on Ubuntu or Debian with Apache

For nginx with PHP-FPM on Ubuntu Server 26.04 LTS or 26.10, use the
[Ubuntu LEMP guide](Installing-Under-Ubuntu-LEMP.md).

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

This is a source-install example for Cacti development (1.3), not a tested
distribution
matrix. Use a maintained distribution and check its PHP version against
[Requirements](Requirements.md) before
installing packages. Run the administrative commands below as root. The
example uses `/var/www/html/cacti` and the default Debian/Ubuntu web account,
`www-data`; adjust both if your web-server setup differs.

## Install the required packages

The unversioned PHP package names select the distribution's configured PHP
version. Confirm that it is PHP 8.3 or later in the PHP 8 series before
continuing. Use a distribution or configured repository that supplies the
required version; do not mix extensions from different PHP versions.

```console
apt-get update
apt-get install -y apache2 libapache2-mod-php mariadb-server rrdtool snmp git cron \
  composer php-cli php-curl php-sqlite3 php-mysql php-snmp php-xml php-mbstring php-gd php-gmp php-zip php-ldap php-intl
systemctl enable --now apache2 mariadb cron
```

If using PHP-FPM instead of the Apache PHP module, configure Apache's FPM
integration and use the installed FPM pool's account. FPM service names are
versioned on Debian/Ubuntu; inspect them with `systemctl list-unit-files
'php*-fpm.service'` and restart the actual unit after configuration changes. Do
not assume a service named `php-fpm` exists.

## Download the Cacti source

This example checks out the unreleased `develop` branch. Record the commit you
deploy; do not treat a moving development branch as a stable release.

```console
git clone --branch develop --depth 1 https://github.com/Cacti/cacti.git cacti
mv cacti /var/www/html/cacti
cd /var/www/html/cacti
composer install --no-dev
composer check-platform-reqs --no-dev
```

Do not overwrite an existing installation with these fresh-install commands.

## Create the database

Choose a unique database password and replace the example placeholder in both
the SQL and `include/config.php`. Connect using your database administrator's
authentication method; the example below prompts for a password.

```console
mysql -u root -p
```

```sql
CREATE DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'replace-with-a-unique-password';
GRANT ALL PRIVILEGES ON cacti.* TO 'cactiuser'@'localhost';
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';
EXIT;
```

Load the system timezone data and the schema into this new database. A MariaDB
installation may provide `mariadb-tzinfo-to-sql` as the timezone utility's
name.

```console
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
mysql -u root -p cacti < /var/www/html/cacti/cacti.sql
```

## Configure Cacti and filesystem permissions

Copy the distributed configuration example; do not rename or delete it.

```console
cp /var/www/html/cacti/include/config.php.dist /var/www/html/cacti/include/config.php
```

Edit the database fields to match the account and database created above:

```php
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'cactiuser';
$database_password = 'replace-with-a-unique-password';
$database_port     = '3306';
```

Keep application code owned by the administrator. The web and poller accounts
must be able to read the configuration and write the runtime directories:

```console
chown root:www-data /var/www/html/cacti/include/config.php
chmod 640 /var/www/html/cacti/include/config.php
chown -R www-data:www-data /var/www/html/cacti/rra /var/www/html/cacti/log /var/www/html/cacti/cache
chmod -R u+rwX,go-rwx /var/www/html/cacti/rra /var/www/html/cacti/log /var/www/html/cacti/cache
```

During installation or package import, the installer also checks write access
to `resource/snmp_queries`, `resource/script_server`, `resource/script_queries`
and `scripts`, and the location used to create the CSRF secret. Grant only the
additional access requested by the installer and remove that temporary access
afterwards. Do not make the entire application tree world-writable.

Restrict installer access to the administrator. Configure HTTPS or use a
protected local connection before entering credentials, then browse to
`/cacti/`. For a freshly imported development schema, sign in with application
username `admin` and initial password `admin`, then choose a unique
administrator password when prompted. These are separate from the database
credentials. Complete the web installer before starting scheduled polling or
allowing general access.

## Schedule polling

Choose either cron or `cactid.service`, not both. Complete the web installer
before starting the selected scheduler. The example cron interval is five
minutes; match the **Cron/Daemon Interval** in Settings > Poller. This is
separate from the data-source polling interval, which can be shorter.

### Cron

Create `/etc/cron.d/cacti` as root, with mode `644`, and include this line:

```console
*/5 * * * * www-data /usr/bin/php /var/www/html/cacti/poller.php >/dev/null 2>&1
```

This is a system cron file, so the username field is required. Use an absolute
PHP CLI path and POSIX shell redirection; Debian cron uses `/bin/sh` by
default. See [Debian crontab format][crontab-format].

### systemd

The supplied unit uses `Type=forking`, so the selected PHP CLI must provide
`pcntl_fork`. Check `/usr/bin/php -r
'var_dump(function_exists("pcntl_fork"));'` for `bool(true)` before using this
example. If fork support is unavailable, use cron or install the appropriate
PCNTL support for that PHP CLI.

Copy the supplied service and edit the installed copy:

```console
cp /var/www/html/cacti/service/cactid.service /etc/systemd/system/cactid.service
```

Replace its existing `User`, `Group`, `EnvironmentFile` and `ExecStart` entries
with the following, retaining the other service settings:

```ini
User=www-data
Group=www-data
EnvironmentFile=-/etc/default/cactid
ExecStart=/usr/bin/php /var/www/html/cacti/cactid.php
```

The leading `-` makes the optional environment file unnecessary if you do not
use one. After completing the installer, load and start the service:

```console
systemctl daemon-reload
systemctl enable cactid.service
systemctl start cactid.service
systemctl status cactid.service
```

The service manages the local polling daemon; it does not by itself provide
high availability. Verify the poller log and newly created graphs after
starting the selected scheduler.

### Considerations when using Proxies in front of Cacti (Cacti 1.2.23+)

A header allowlist does not authenticate a proxy. Trust forwarded client-IP
headers only when a trusted proxy replaces those headers and untrusted clients
cannot bypass it to reach Cacti directly. Leave forwarding disabled otherwise.
In `include/config.php`, select only the headers your proxy sets. For a
deployment using `X-Forwarded-For`, the setting is:

```php
$proxy_headers = ['X-Forwarded-For'];
```

[crontab-format]:<https://manpages.debian.org/bookworm/cron/crontab.5.en.html>
[supported-os]: Requirements.md#supported-operating-systems

---

Copyright (c) 2004-2026 The Cacti Group
