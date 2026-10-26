# Installing on Enterprise Linux with Apache

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

This source-install example covers the unreleased Cacti 1.3 development branch
on RHEL, Rocky Linux, or AlmaLinux. Read [Requirements](Requirements.md)
first. Run administrative commands as root and adapt paths and accounts to
your deployment. For an existing installation, use
[Upgrading Cacti](Upgrading-Cacti.md). For package-managed Cacti, follow the
package maintainer's procedure instead of overlaying source files.

## Choose repositories and PHP

For a new, fully updated RHEL 9 installation with the stream available,
[PHP 8.3][php-stream] is an example meeting the development minimum:

```console
dnf module list php
dnf module install php:8.3
```

This is a fresh-install example, not a stream-switching procedure for an
existing server. Check the streams supplied by your distribution. EL 9 and EL
10 do not share identical repositories or module availability. If the required
PHP version is unavailable, choose a maintained distribution or repository that
provides it before continuing.

## Install the web and database packages

This example uses MariaDB. MySQL installations should use the package and
service names for their selected MySQL repository. Review the database version
against Cacti's requirements before installation.

```console
dnf install -y httpd php-fpm php-cli php-mysqlnd php-gd php-gmp \
  php-intl php-ldap php-mbstring php-xml php-process php-snmp \
  mariadb-server rrdtool net-snmp-utils cronie
php -v
php -m
```

Additional packages can be required by the chosen source revision. Check
[Requirements](Requirements.md), including Composer dependencies where
applicable. Do not mix extensions from different PHP versions or repositories.

Configure `date.timezone` in the PHP configuration used by both CLI and FPM.
Check `php --ini` for CLI and the installer for web PHP. Review the FPM pool at
`/etc/php-fpm.d/www.conf`; its account needs access to Cacti's runtime paths.
Keep code owned by the deployment administrator.

Start the database:

```console
systemctl enable --now mariadb
```

Follow the installed database vendor's initialization and account-security
procedure. Do not set a root password on the shell command line. Configure only
variables accepted by that database version; use Cacti's installer
recommendations rather than a fixed tuning block. Keep InnoDB doublewrite
protection enabled.

## Configure Apache

Use the distribution's Apache/PHP-FPM integration. Check that PHP requests are
executed by FPM rather than served as text. This example exposes only
`/cacti/`; replace the hostname and certificate paths before use. Save it in
`/etc/httpd/conf.d/cacti.conf`:

```apache
<VirtualHost *:443>
    ServerName cacti.example.com
    SSLEngine On
    SSLCertificateFile /etc/pki/tls/certs/cacti.crt
    SSLCertificateKeyFile /etc/pki/tls/private/cacti.key
    Alias /cacti /var/www/html/cacti

    <Directory /var/www/html/cacti>
        Options -Indexes
        AllowOverride All
        Require all granted
        DirectoryIndex index.php
    </Directory>
</VirtualHost>
```

Install `mod_ssl` if not already present. `AllowOverride All` lets Cacti's
shipped `.htaccess` restrictions protect private paths; if your policy disables
overrides, reproduce those restrictions in the server configuration. Do not
grant general access to private directories as a troubleshooting step.

```console
dnf install -y mod_ssl
httpd -t
systemctl enable --now php-fpm httpd
```

Use your certificate-management procedure and review any packaged default TLS
virtual host for conflicts. Restrict access to administrators during setup.

## Install and configure Cacti

Use [General Installing Instructions][general] to obtain the intended source,
create a new database and dedicated application account, load timezone data,
import `cacti.sql`, and configure `include/config.php`. The examples there use
`/var/www/html/cacti`; use that same path here.

Complete the dependency and filesystem-permission checks before opening the
installer. The database account and operating-system service accounts are
separate identities. Grant runtime write access to the actual FPM and poller
accounts, not automatically to the nginx master process or the database user.
Keep executable code and credentials protected during normal operation.

Open `https://cacti.example.com/cacti/` and complete the installer. Configure
one scheduler after installation: either a Cacti-specific cron entry or the
supplied `cactid` systemd service, using the procedure in the general guide. Do
not run both for the same collector. The five-minute cron example is:

```cron
*/5 * * * * apache /usr/bin/php /PATH/TO/cacti/poller.php >/dev/null 2>&1
```

Replace `/PATH/TO/cacti` and `apache` with the installed path and chosen poller
account. Enable `crond` if using cron. Verify a manual poll under that account,
then check scheduled runs, logs, collector status, and fresh graph samples.

## SELinux and containers

Keep SELinux enforcing. For a custom installation path, use persistent file
contexts and allow writes only on Cacti's runtime paths. Review audit denials
and authorize the specific network and executable access needed by FPM,
RRDtool, SNMP tools, and the collector. Do not use `setenforce 0` as the
installation procedure. See the [RHEL SELinux guide][selinux].

For LXC or Proxmox, retain an unprivileged container and its confinement where
possible. Diagnose the specific ICMP/socket permission or mapped-file access
failure. Adjust only the required capability or policy; do not make the entire
container privileged or set an unconfined AppArmor profile merely to run Cacti.

## Optional Spine and proxies

Follow [Spine](Spine.md) for the optional compiled collector. Select a
compatible source or package and the development headers for your OS.
Repository names differ: do not apply Rocky/AlmaLinux `crb` commands to RHEL
without checking its repository configuration. Configure the Spine database
connection with the same application credentials and restrict access to its
configuration file.

When using a reverse proxy, see the [proxy configuration in the general
guide][proxy]. A header allowlist alone does not authenticate a proxy; prevent
clients from bypassing the trusted proxy and require it to replace forwarded
client-IP headers.

[general]: General-Installing-Instructions.md#install-and-configure-cacti
[proxy]: General-Installing-Instructions.md
[selinux]:<https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/using_selinux/index>

[php-stream]:<https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/9.6_release_notes/new-features>

[supported-os]: Requirements.md#supported-operating-systems

---

Copyright (c) 2004-2026 The Cacti Group
