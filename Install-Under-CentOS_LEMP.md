# Installing on CentOS 7

This page retains examples from the CentOS 7/8 era. CentOS Linux 7 reached
end of life on June 30, 2024, and CentOS Linux 8 on December 31, 2021; see the
[CentOS lifecycle notice](https://www.centos.org/cl-vs-cs/). These examples are
not a tested compatibility matrix for current RHEL or Rocky Linux releases.
Use a maintained operating system and a PHP version meeting
[Requirements](Requirements.md), with repositories appropriate to that system.
Run administrative commands as root and adapt paths and service accounts to
the actual installation. Do not use the legacy PHP streams below as a new
server recommendation.

## LEMP (Linux, Nginx, MySQL, PHP) Required packages

### Web Server

1. Install Nginx

   ```console
   yum install -y nginx
   ```

2. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl start nginx
   systemctl enable nginx
   ```

### Example configuration file for Nginx and SSL

This example assumes you have your own certificates already. You should make
sure you change the paths to match your setup.

Replace `YourOwnCertFile.crt` and `YourOwnCertFile.key` with the names of the
files holding your certificate (`.crt`) and private key (`.key`).

```console
/etc/nginx/conf.d/cacti.conf
```

```console
# Serve Cacti at https://cacti.yourdomain.com/cacti/.
server {
   listen 80;
   server_name cacti.yourdomain.com;
   return 301 https://$host$request_uri;
}

server {
   listen 443 ssl;
   server_name cacti.yourdomain.com;
   root /usr/share/nginx/html;
   index index.php index.html;

   ssl_certificate /etc/ssl/certs/YourOwnCertFile.crt;
   ssl_certificate_key /etc/ssl/private/YourOwnCertKey.key;
   ssl_protocols TLSv1.2;

   location = / {
      return 302 /cacti/;
   }
   location = /cacti {
      return 301 /cacti/;
   }

   # Nginx does not process Apache .htaccess files.
   location ~ (^|/)\. {
      deny all;
   }
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
      fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
      fastcgi_index index.php;
   }
   location /cacti/ {
      try_files $uri $uri/ =404;
   }

   access_log /var/log/nginx/cacti_access.log;
   error_log /var/log/nginx/cacti_error.log;
}
```

The socket must match the PHP-FPM pool configured below. Adjust the TLS
configuration for the maintained OS and web-server versions you actually use;
this legacy example is not a current TLS compatibility matrix. Validate the
configuration with `nginx -t` before reloading Nginx. Keep the private-path
rules before the PHP handler; static files such as the CSRF JavaScript and
flag icons under `include/vendor` must remain accessible.

### Database Server

The choice between MySQL server and MariaDB is normally down to the OS
maintainers if you use one of the predefined LAMP setup installations. If you
are deciding between these yourself, you should research this via your favorite
search engine.

Whilst MySQL is the original open source SQL database server created in 1995
which is now owned by Oracle, MariaDB is designed as a drop-in replacement by
some of the original MySQL developers / owners. This will likely continue to be
a drop-in alternative until there is a major divergence that can not be bridged.

#### MySQL

1. Install MySQL server

   ```console
   yum install -y mysql mysql-server
   ```

2. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl enable mysqld
   systemctl start mysqld
   ```

#### MariaDB

1. Install the distribution MariaDB packages (package names differ when using
   the MariaDB vendor repository).

   ```console
   yum install -y mariadb-server mariadb
   ```

2. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl enable mariadb
   systemctl start mariadb
   ```

### MySQL/MariaDB common tasks and recommendations

**IMPORTANT**: Secure your MySQL installation before doing any more changes

```console
/usr/bin/mysql_secure_installation
```

The following MySQL/MariaDB recommendations may vary depending on your system
setup. In any case, Cacti will prompt you with more accurate recommendations
during the installation.

1. Edit your **server.cnf** file

   ```console
   vim /etc/my.cnf.d/server.cnf
   ```

   Keep the database vendor's configuration defaults unless the installer and
   workload justify a change. A minimal character-set example is:

   ```ini
   [mysqld]
   character-set-server=utf8mb4
   collation-server=utf8mb4_unicode_ci
   ```

   Buffer sizes depend on available memory and workload. Do not copy obsolete
   InnoDB options or disable doublewrite protection as a general tuning step;
   consult the [MariaDB InnoDB variable reference][innodb-variables] for the
   installed version.

2. Restart the service actually installed (`mariadb` for the MariaDB example,
   or `mysqld` for the MySQL example):

   ```console
   systemctl restart mariadb
   ```

3. Populate timezone table with available timezones

   ```console
   mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
   ```

#### Setup Cacti database

Connect using the database administrator's authentication method:

```console
mysql -u root -p
```

Create a new database and account. Replace the username and password below,
and use those same values in Cacti's configuration. Do not apply this
fresh-install procedure to an existing Cacti database.

```sql
CREATE DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'your_cacti_username'@'localhost' IDENTIFIED BY 'your_cacti_password';
GRANT ALL PRIVILEGES ON cacti.* TO 'your_cacti_username'@'localhost';
GRANT SELECT ON mysql.time_zone_name TO 'your_cacti_username'@'localhost';
EXIT;
```

The schema import occurs below, after the Cacti archive has been extracted.

### Common PHP packages

#### PHP

PHP and various packages are all required by Cacti for successful operation

1. Install PHP and required packages.

   ```console
   yum install -y php php-common php-bcmath php-cli \
   php-mysqlnd php-gd php-gmp php-intl \
   php-json php-ldap php-mbstring \
   php-pdo php-pear php-snmp php-process \
   php-xml php-zip php-fpm
   ```

---

Note: **php-fpm** is only required if your Web Server is Nginx

1. Set a timezone to your PHP.INI configuration

   Edit php.ini, typically located at `/etc/php.ini`

   ```console
   date.timezone = Pacific/Auckland
   ```

2. Disable insecure `cgi.fix_pathinfo`

   ```console
   cgi.fix_pathinfo=0
   ```

#### Setup php-fpm

1. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl start php-fpm
   systemctl enable php-fpm
   ```

2. Edit `/etc/php-fpm.d/www.conf`

   Replace the existing `listen` setting; do not leave two active settings:

   ```console
   listen = /var/run/php-fpm/php-fpm.sock
   ```

   Find `listen.owner` and `listen.group` and set them to nginx

   ```console
   listen.owner = nginx
   listen.group = nginx
   ```

   Find user and group and set them to `nginx`

   ```console
   user = nginx
   group = nginx
   ```

   Restart php-fpm to pick up the changes

   ```console
   systemctl restart php-fpm
   ```

### RRDtool

RRDtool is required to store the data retrieved from devices in `.rra` files to
produce the graphs which are shown within Cacti

```console
yum install -y rrdtool
```

### SNMP

SNMP is used to query most devices for information.

```console
yum install -y net-snmp net-snmp-utils
```

Install and enable `snmpd` only if this host also needs to expose an SNMP
agent. Configure credentials and an appropriate access view before starting
it; polling remote devices does not require a local SNMP agent.

### Cacti

The following steps will show you how to manually download, install and
configure the basics for Cacti.

1. Download Cacti source code from
   [Cacti Web Site](https://www.cacti.net/download_cacti.php)

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/cacti-1.2.31.tar.gz
   tar -zxvf cacti-1.2.31.tar.gz
   mv -v cacti-1.2.31 /usr/share/nginx/html/cacti
   ```

   Import the schema into the new `cacti` database created above. Do not run
   this fresh-install import against an existing Cacti database.

   ```console
   mysql -u root -p cacti < /usr/share/nginx/html/cacti/cacti.sql
   ```

2. Edit the config.php file

   ```console
   cp /usr/share/nginx/html/cacti/include/config.php.dist /usr/share/nginx/html/cacti/include/config.php
   ```

3. Update database\_ fields with your own details. This section only applies to
   the Main Cacti Server

   ```php
   $database_type     = 'mysql';
   $database_default  = 'cacti';
   $database_hostname = 'localhost';
   $database_username = 'your_cacti_username';
   $database_password = 'your_cacti_password';
   $database_port     = '3306';
   $database_ssl      = false;
   $database_ssl_key  = '';
   $database_ssl_cert = '';
   $database_ssl_ca   = '';
   ```

4. Keep the URL path consistent with the Nginx `/cacti/` location:

   ```php
   $url_path = '/cacti/';
   ```

   Keep code owned by the administrator. Allow the web/poller account to read
   the configuration and write only the runtime directories:

   ```console
   chown root:nginx /usr/share/nginx/html/cacti/include/config.php
   chmod 640 /usr/share/nginx/html/cacti/include/config.php
   chown -R nginx:nginx /usr/share/nginx/html/cacti/rra /usr/share/nginx/html/cacti/log /usr/share/nginx/html/cacti/cache
   chmod -R u+rwX,go-rwx /usr/share/nginx/html/cacti/rra /usr/share/nginx/html/cacti/log /usr/share/nginx/html/cacti/cache
   ```

   The installer can additionally request temporary write access to its
   `resource` query directories, `scripts`, and the CSRF-secret location.
   Grant only the requested access during installation/package import and
   remove it afterwards. Keep SELinux permissions in mind as well.
   Restrict installer access to the administrator and use HTTPS or a protected
   local connection before entering credentials. For a freshly imported
   1.2.31 schema, sign in with application username `admin` and initial
   password `admin`, then choose a unique administrator password when
   prompted. These are separate from the database credentials. Complete the
   web installer before starting scheduled polling or allowing general access.

5. Create your cron task file or systemd units file

   Before using the supplied `Type=forking` systemd unit, confirm that the PHP
   CLI used by the unit provides `pcntl_fork`. For example,
   `/usr/bin/php -r 'var_dump(function_exists("pcntl_fork"));'` should report
   `bool(true)`. Otherwise use cron or install the appropriate PCNTL support.

   Choose either cron or the daemon, not both. Cacti 1.2.16 and later include
   an optional `cactid.service` for running the polling daemon. Match the
   schedule to the configured **Cron/Daemon Interval** in Settings > Poller;
   this can differ from the shorter data-source polling interval.

   For Crontab use, follow the instructions below:

   Create `/etc/cron.d/cacti` as root with mode `644`. Use the installation
   path and PHP CLI binary appropriate to this host.

   ```console
   */5 * * * * nginx /usr/bin/php /usr/share/nginx/html/cacti/poller.php >/dev/null 2>&1
   ```

   For systemd unit's file install, you will need to modify the included units
   file to following your install location and desired user and group's to run
   the Cacti poller as. To complete the task, follow the procedure below:

   In that service, use `User=nginx`, `Group=nginx` and
   `ExecStart=/usr/bin/php /usr/share/nginx/html/cacti/cactid.php`. The
   supplied service defaults to the Apache account and `/var/www/html/cacti`;
   Nginx installations must change both. The daemon manages local polling;
   it does not by itself provide high availability.

   ```console
   cp /usr/share/nginx/html/cacti/service/cactid.service /etc/systemd/system/cactid.service
   vi /etc/systemd/system/cactid.service
   install -d -m 755 /etc/sysconfig
   touch /etc/sysconfig/cactid
   systemctl daemon-reload
   systemctl enable cactid.service
   systemctl start cactid.service
   systemctl status cactid.service
   ```

#### Spine

1. Install the necessary packages to compile and install spine

   ```console
   yum install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

2. Download spine source code from
   [Cacti Web Site](https://www.cacti.net/spine_download.php)

   Go to /tmp to download the source code and extract it

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/spine/cacti-spine-1.2.31.tar.gz
   tar -zxvf cacti-spine-1.2.31.tar.gz
   cd cacti-spine-1.2.31
   ```

3. This example uses the corresponding Spine 1.2.31 release. Prepare its
   build configuration, then configure and compile it.

   ```console
   ./bootstrap
   ./configure
   make
   make install
   ```

4. Edit spine.conf

   Rename spine.conf.dist to spine.conf

   ```console
   mv -v /usr/local/spine/etc/spine.conf.dist /usr/local/spine/etc/spine.conf
   vi /usr/local/spine/etc/spine.conf
   ```

5. Now set up your database connection

   ```console
   DB_Host       localhost
   DB_Database   cacti
   DB_User       your_cacti_username
   DB_Pass       your_cacti_password
   DB_Port       3306
   #DB_UseSSL    0
   #RDB_SSL_Key
   #RDB_SSL_Cert
   #RDB_SSL_CA
   ```

### Security Enhanced Linux (SELinux)

Keep SELinux enforcing. Inspect denials and file contexts rather than
assuming a Unix ownership change is sufficient:

```console
getenforce
ls -Zd /usr/share/nginx/html/cacti /usr/share/nginx/html/cacti/rra
ausearch -m AVC -ts recent
```

Apply the file labels and narrowly scoped policy settings required by your
web server, writable directories and database connection. Consult the
[Red Hat SELinux documentation][selinux-guide]; disabling SELinux is not a
required installation step.

**Note:** If you installed Cacti out of `/usr/share/nginx/html` make sure you
fix up all SELinux context and permissions.

---

Copyright (c) 2004-2026 The Cacti Group
