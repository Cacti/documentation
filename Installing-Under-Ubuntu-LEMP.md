# Installing Cacti on Ubuntu Server with nginx

This fresh-install guide covers Cacti 1.2.31 with nginx, PHP-FPM,
and MariaDB. Use the [requirements](Requirements.md) for this Cacti branch.
For an existing installation, follow [Upgrading Cacti](Upgrading-Cacti.md).
Do not overlay source files onto a package-managed Cacti installation.

## Choose a supported Ubuntu release

As of 26 October 2026, the latest LTS is **Ubuntu Server 26.04 LTS** and the
latest interim release is **Ubuntu Server 26.10**. Use fully updated packages.
The interim release has a shorter maintenance window; plan its next upgrade
before security support expires. See the [LTS release notes][ubuntu-lts],
[interim release notes][ubuntu-interim], and [Ubuntu lifecycle][ubuntu-cycle].

| Ubuntu release | PHP selection | PHP-FPM unit and socket |
| --- | --- | --- |
| 26.04 LTS | Distribution PHP 8.5 packages | `php8.5-fpm.service`, `/run/php/php8.5-fpm.sock` |
| 26.10 | Distribution PHP 8.5 packages | `php8.5-fpm.service`, `/run/php/php8.5-fpm.sock` |

The [Ubuntu package index][ubuntu-php] documents the LTS FPM package; the
[interim package index][ubuntu-php-interim] lists the corresponding package
for 26.10. Check the package candidates before installation. Vendor OS support
and package availability do not establish that every Cacti plugin has been
tested with that PHP version. Validate the selected Cacti and plugin set on
an isolated installation before production use.

## Install nginx, PHP-FPM, and MariaDB

Run administrative commands as root. Enable Ubuntu's Universe repository if
it is not already enabled, then install the packages:

```console
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y universe
apt-get update
apt-cache policy php-fpm php-cli mariadb-server nginx
apt-get install -y nginx mariadb-server rrdtool snmp cron git \
  php-fpm php-cli php-mysql php-snmp php-xml php-mbstring php-gd php-gmp \
  php-zip php-ldap php-intl php-curl php-sqlite3
php -v
php --ini
php -m
```

Use packages from a consistent Ubuntu release and repository set. Do not
install `libapache2-mod-php` for this nginx/FPM setup. If Apache is already
bound to the chosen HTTP/HTTPS ports, resolve that conflict before starting
nginx rather than running two servers on the same address and port.

Set `date.timezone` for the CLI and FPM configurations, normally under
`/etc/php/8.5/cli/php.ini` and `/etc/php/8.5/fpm/php.ini`. Verify the FPM pool
at `/etc/php/8.5/fpm/pool.d/www.conf` uses the intended account and socket:

```ini
user = www-data
group = www-data
listen = /run/php/php8.5-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660
```

Edit the existing entries. The nginx worker must be able to connect to that
socket. Check the actual pool if you changed the account, PHP version, or
socket path. Validate FPM configuration and enable the services:

```console
php-fpm8.5 -t
systemctl enable --now mariadb php8.5-fpm nginx cron
```

## Deploy Cacti and create the database

Obtain the release archive for Cacti 1.2.31, or use its fixed source tag:

```console
git clone --branch release/1.2.31 --depth 1 https://github.com/Cacti/cacti.git cacti
```

Deploy the source tree to `/var/www/html/cacti` with administrator ownership.
This release includes its runtime libraries; do not apply development-only
Composer instructions to the released source.

Follow [General Installing Instructions][general] to create the new database
and dedicated application account, load timezone data, import the matching
`cacti.sql`, and copy/configure `include/config.php`. These are fresh-install
steps; do not import the default schema over an existing Cacti database.

Use the `www-data` FPM/poller account for this example's runtime permissions.
Keep code owned by the administrator, configuration readable only by the
required identities, and write access limited to runtime paths. Grant extra
installation/import access only where the installer requests it and remove
that access afterward. Database credentials and OS service accounts are
separate identities.

## Configure nginx and HTTPS

Provision a certificate for your hostname using your certificate-management
procedure. Replace `cacti.example.com` and the certificate/key paths below.
Save this virtual host as `/etc/nginx/sites-available/cacti`:

```nginx
server {
    listen 80;
    server_name cacti.example.com;
    return 301 https://cacti.example.com$request_uri;
}

server {
    listen 443 ssl;
    server_name cacti.example.com;
    root /var/www/html;
    index index.php;
    ssl_certificate /etc/ssl/certs/cacti.crt;
    ssl_certificate_key /etc/ssl/private/cacti.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location = / { return 302 /cacti/; }
    location = /cacti { return 301 /cacti/; }

    # nginx does not process Cacti's Apache .htaccess restrictions.
    location ~ (^|/)\. { deny all; }
    location ~ ^/cacti/(cli|contrib|log|mibs|rra|scripts|service)/ {
        deny all;
    }
    location ~ ^/cacti/cache/(boost|mibcache|realtime|spikekill)/ {
        deny all;
    }
    location ~ ^/cacti/include/(config(_local)?\.php|vendor/.*\.php) {
        deny all;
    }

    location ~ ^/cacti/(.+\.php)$ {
        try_files $uri =404;
        include /etc/nginx/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php8.5-fpm.sock;
    }
    location /cacti/ { try_files $uri $uri/ =404; }
}
```

Enable this site once, without overwriting an existing link or configuration:

```console
ln -s /etc/nginx/sites-available/cacti /etc/nginx/sites-enabled/cacti
nginx -t
systemctl reload nginx
```

Review the packaged default site and other virtual hosts for conflicts. Keep
private-path rules before the PHP handler, leave required static vendor
assets accessible, and store backups outside every web root. Confirm over
HTTP that private files are denied and PHP requests execute rather than
expose source. Restrict installation access to administrators until complete.

## Complete installation and schedule polling

Open `https://cacti.example.com/cacti/`, complete the installer, and check the
CLI and web PHP environments separately. Verify executable paths, timezone
data, filesystem permissions, and optional Spine before enabling collection.

Configure either cron or `cactid`, using the [Ubuntu scheduler guide][polling].
Do not run both for one collector. For the default five-minute scheduler,
create `/etc/cron.d/cacti` with mode `644` and this system-cron entry:

```cron
*/5 * * * * www-data /usr/bin/php /var/www/html/cacti/poller.php >/dev/null 2>&1
```

Run a manual polling cycle as the poller account before scheduling, then
verify scheduled execution, collector status, logs, and recent RRD samples.
Keep AppArmor enforcing and adjust only the specific policy and filesystem
access required by the deployed services. For reverse proxies, use the
[trusted-proxy guidance][proxy] rather than trusting arbitrary client headers.

[ubuntu-lts]:<https://documentation.ubuntu.com/release-notes/26.04/>
[ubuntu-interim]:<https://documentation.ubuntu.com/release-notes/26.10/>
[ubuntu-cycle]:<https://ubuntu.com/about/release-cycle>
[ubuntu-php]:<https://packages.ubuntu.com/resolute/php/php-fpm>
[ubuntu-php-interim]:<https://packages.ubuntu.com/stonking/php/php-fpm>
[general]: General-Installing-Instructions.md#install-and-configure-cacti
[polling]: Installing-Under-Ubuntu-Debian.md#schedule-polling
[proxy]: General-Installing-Instructions.md

---

Copyright (c) 2004-2026 The Cacti Group
