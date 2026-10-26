# Installing on Rocky Linux 9 and 10 with nginx

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

This source-install example covers released Cacti 1.2.31
on RHEL, Rocky Linux, or AlmaLinux. Read [Requirements](Requirements.md)
first. Run administrative commands as root and adapt paths and accounts to
your deployment. For an existing installation, use
[Upgrading Cacti](Upgrading-Cacti.md). For package-managed Cacti, follow the
package maintainer's procedure instead of overlaying source files.

## Choose the Rocky Linux release and packages

Use the current security-updated minor release of Rocky Linux 9 or 10. This
is a fresh-install procedure; do not reset or switch module streams on an
existing database or PHP deployment without a separate upgrade plan.

| Rocky Linux branch | PHP and database selection |
| --- | --- |
| 9 | Enable the AppStream `php:8.3` and `mariadb:10.11` streams before installing packages |
| 10 | Install the AppStream PHP and MariaDB packages directly; this branch does not use module streams |

### Rocky Linux 9

Inspect the available streams, then select the versions for this example:

```console
dnf module list php mariadb
dnf module enable -y php:8.3 mariadb:10.11
```

### Rocky Linux 10

Check the packages offered by AppStream; do not run `dnf module` commands:

```console
dnf info php-fpm mariadb-server
```

Rocky's [PHP/FPM guide][rocky-php] explains the difference in packaging, and
its [release notes][rocky-10] list the major-version package changes.
Other Enterprise Linux distributions can differ in subscriptions, repositories,
and package availability; verify those before adapting this Rocky example.

## Install the web and database packages

This example uses MariaDB. MySQL installations should use the package and
service names for their selected MySQL repository. Review the database version
against Cacti's requirements before installation.

```console
dnf install -y nginx php-fpm php-cli php-mysqlnd php-gd php-gmp \
  php-intl php-ldap php-mbstring php-xml php-process php-snmp php-pdo \
  mariadb-server rrdtool net-snmp-utils cronie
php -v
php -m
```

Additional packages can be required by the chosen source revision. Check
[Requirements](Requirements.md), including Composer dependencies where
applicable. Do not mix extensions from different PHP versions or repositories.

Configure `date.timezone` in the PHP configuration used by both CLI and FPM.
Check `php --ini` for CLI and the installer for web PHP. Review the FPM pool
at `/etc/php-fpm.d/www.conf`. For this example, retain the `apache` worker
account and allow nginx to connect through the socket ACL:

```ini
user = apache
group = apache
listen = /run/php-fpm/www.sock
listen.acl_users = apache,nginx
```

Modify the existing entries rather than appending a second pool definition.
The socket ACL grants nginx connection access; Cacti's runtime files must be
writable by the FPM worker and poller accounts. Keep code owned by the
administrator. Validate the pool with `php-fpm -t` before restarting FPM.

Start the database:

```console
systemctl enable --now mariadb
```

Follow the installed database vendor's initialization and account-security
procedure. Do not set a root password on the shell command line. Configure only
variables accepted by that database version; use Cacti's installer
recommendations rather than a fixed tuning block. Keep InnoDB doublewrite
protection enabled.

## Configure nginx

Configure the FPM pool's `listen` path and socket ACLs so nginx can connect.
The example uses `/run/php-fpm/www.sock`; verify that it matches your pool.
Keep the FPM worker account consistent with the permissions you grant later.
Save this example in `/etc/nginx/conf.d/cacti.conf`, replacing the hostname and
certificate paths:

```nginx
server {
    listen 80;
    server_name cacti.example.com;
    return 301 https://cacti.example.com$request_uri;
}

server {
    listen 443 ssl;
    server_name cacti.example.com;
    root /usr/share/nginx/html;
    index index.php;
    ssl_certificate /etc/pki/tls/certs/cacti.crt;
    ssl_certificate_key /etc/pki/tls/private/cacti.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location = / { return 302 /cacti/; }
    location = /cacti { return 301 /cacti/; }

    # nginx does not read Apache .htaccess files.
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
        fastcgi_pass unix:/run/php-fpm/www.sock;
    }
    location /cacti/ { try_files $uri $uri/ =404; }
}
```

Keep private-path restrictions before the PHP handler and validate them over
HTTP. Static assets under `include/vendor` can be required by the interface; do
not deny all vendor assets indiscriminately. Keep backups outside every web
root. Restrict setup to administrators until installation is complete.

```console
nginx -t
systemctl enable --now php-fpm nginx
```

## Install and configure Cacti

Use [General Installing Instructions][general] to obtain the intended source,
create a new database and dedicated application account, load timezone data,
import `cacti.sql`, and configure `include/config.php`. The examples there use
`/var/www/html/cacti`; substitute `/usr/share/nginx/html/cacti` here.

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

[supported-os]: Requirements.md#supported-operating-systems

[rocky-php]:<https://docs.rockylinux.org/guides/web/php/>
[rocky-10]:<https://docs.rockylinux.org/releases/release_notes/10_0/>

---

Copyright (c) 2004-2026 The Cacti Group
