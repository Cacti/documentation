# Installing Cacti 1.x on Ubuntu/Debian — LAMP Stack

> **Note**: As of Cacti 1.2.31, PHP 8.1 is required and PHP Composer is required.
> Composer will be used to ensure all libraries are installed and up to date.
> PHP 8.1 reached end-of-life on 31 December 2025. Check the
> [PHP supported versions page](https://www.php.net/supported-versions.php)
> and substitute the current supported release (e.g. `php8.3`) where appropriate.

## Installing the required packages

```console
apt-get update
apt-get install -y apache2 rrdtool mariadb-server snmp snmpd \
  php8.3 php8.3-mysql php8.3-snmp php8.3-xml php8.3-mbstring \
  php8.3-json php8.3-gd php8.3-gmp php8.3-zip php8.3-ldap \
  php8.3-intl php8.3-curl composer
```

### A special note for systems using PHP-FPM

Before starting the Cacti setup process, restart the PHP-FPM daemon to rebuild
its cache, or you may receive an HTTP 500 error.

```console
systemctl restart php-fpm
```

### A special note on installing Cacti in LXC containers (e.g. Proxmox)

We recommend creating a privileged container. You may need to update your
container's config file with:

```console
lxc.apparmor.profile: unconfined
```

This allows ICMP ping and other functions to work.

A tested configuration is shown below; tune to your needs and standards.

```console
arch: amd64
cores: 2
hostname: cacti
memory: 2048
net0: name=eth0,bridge=vmbr0,firewall=1,hwaddr=mac-id,ip=dhcp,type=veth
ostype: ubuntu
rootfs: local-lvm:vm-110-disk-0,size=8G
swap: 2048
lxc.apparmor.profile: unconfined
```

### Downloading the Cacti software

Once the OS packages are installed, clone the Cacti repository:

```console
git clone -b 1.2.x https://github.com/Cacti/cacti.git
```

Move the files into the web root:

```console
mv cacti /var/www/html
```

### Database creation

Create the Cacti database and user:

```console
mysql -u root -p
```

```sql
CREATE DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'cactiuser'@'localhost' IDENTIFIED BY 'cactiuser';
GRANT ALL ON cacti.* TO 'cactiuser'@'localhost';
GRANT SELECT ON mysql.time_zone_name TO 'cactiuser'@'localhost';
FLUSH PRIVILEGES;
```

> **Security note**: Replace `cactiuser`/`cactiuser` with a strong,
> unique username and password before using this in production.

Import the default Cacti schema:

```console
mysql -u root cacti < /var/www/html/cacti/cacti.sql
```

### Creating the config file

```console
cd /var/www/html/cacti/include
cp config.php.dist config.php
```

Edit `config.php` to match your database settings:

```php
$database_type     = 'mysql';
$database_default  = 'cacti';
$database_hostname = 'localhost';
$database_username = 'cactiuser';
$database_password = 'cactiuser';
$database_port     = '3306';
$database_retries  = 5;
$database_ssl      = false;
$database_ssl_key  = '';
```

### Create your cron task or systemd units file

Starting with Cacti 1.2.16, you can use either a legacy crontab entry or the
optional `cactid` systemd service to run your Cacti pollers.

For crontab use, create and edit `/etc/cron.d/cacti`:

```console
*/5 * * * * www-data php /var/www/html/cacti/poller.php &>/dev/null
```

For systemd, modify the included units file to reflect your install location
and the desired user and group, then:

```console
vim /var/www/html/cacti/service/cactid.service
touch /etc/sysconfig/cactid
cp -p /var/www/html/cacti/service/cactid.service /etc/systemd/system
systemctl enable cactid
systemctl start cactid
systemctl status cactid
```

The system is now ready. Browse to
[http://serverip/cacti](http://serverip/cacti) to start the Cacti
initialization wizard.

### AppArmor Configuration

Ubuntu and Debian enable AppArmor by default, but they do not ship a
confinement profile for Apache, so on a stock system Apache runs unconfined
and no AppArmor changes are needed for Cacti. This section applies only if you
have deliberately installed and loaded an Apache profile (for example from the
`apparmor-profiles-extra` package).

First confirm whether an Apache profile is actually loaded:

```console
aa-status | grep apache2
ls /etc/apparmor.d/usr.sbin.apache2 2>/dev/null
```

If neither prints anything, Apache is unconfined and you can skip this section.
If a profile is present and denials appear in `/var/log/syslog` or `dmesg`:

```console
grep -i "apparmor.*DENIED" /var/log/syslog | grep -E "apache|php"
```

add a local override so Apache can reach the Cacti directories
(adjust the path if Cacti is not installed under `/var/www/html/cacti`):

```console
cat > /etc/apparmor.d/local/usr.sbin.apache2 << 'EOF'
# Cacti: allow Apache to read web root and write to RRD/log/cache dirs
/var/www/html/cacti/** r,
/var/www/html/cacti/rra/** rw,
/var/www/html/cacti/log/** rw,
/var/www/html/cacti/cache/** rw,
EOF

apparmor_parser -r /etc/apparmor.d/usr.sbin.apache2
systemctl restart apache2
```

Verify AppArmor is enforcing (not complaining) and no new denials appear:

```console
aa-status | grep apache2
grep -i "apparmor.*DENIED" /var/log/syslog | grep apache | tail -5
```

### Considerations when using proxies in front of Cacti (Cacti 1.2.23+)

For optimal security, specify only the HTTP headers that your proxy software
actually sets. Configure this by editing the following section of `config.php`:

```ini
 * Allow the use of Proxy IPs when searching for client
 * IP to be used
 *
 * This can be set to one of the following:
 *   - false: to use only REMOTE_ADDR
 *   - true: to use all allowed headers (not advised)
 *   - array of one or more the following:
 *'X-Forwarded-For',
 *'X-Client-IP',
 *'X-Real-IP',
 *'X-ProxyUser-Ip',
 *'CF-Connecting-IP',
 *'True-Client-IP',
 *'HTTP_X_FORWARDED',
 *'HTTP_X_FORWARDED_FOR',
 *'HTTP_X_CLUSTER_CLIENT_IP',
 *'HTTP_FORWARDED_FOR',
 *'HTTP_FORWARDED',
 *'HTTP_CLIENT_IP',
 *
 * NOTE: The following will always be checked:
 *'REMOTE_ADDR',
 */
$proxy_headers = null;
```

---
Copyright (c) 2004-2026 The Cacti Group
