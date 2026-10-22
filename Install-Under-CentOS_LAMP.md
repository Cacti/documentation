# Installing on CentOS/RHEL/ROCKY

This page retains examples from the CentOS 7/8 era. CentOS Linux 7 reached
end of life on June 30, 2024, and CentOS Linux 8 on December 31, 2021; see the
[CentOS lifecycle notice](https://www.centos.org/cl-vs-cs/). These examples are
not a tested compatibility matrix for current RHEL or Rocky Linux releases.
Use a maintained operating system and a PHP version meeting
[Requirements](Requirements.md), with repositories appropriate to that system.
Run administrative commands as root and adapt paths and service accounts to
the actual installation. Do not use the legacy PHP streams below as a new
server recommendation.

## LAMP (Linux, Apache, MySQL/MariaDB, PHP) Required packages

### Web Server (Apache)

1. Enable Epel repo to enable PHP 7.2 package download ( 7.x and Below)

   ```console
   yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
   yum install yum-utils -y
   yum-config-manager --enable remi-php72
   ```

   For Centos/RHEL/ROCKY 8+

   ```console
   dnf module reset php
   dnf module enable php:8.0
   ```

### A special note for systems using PHP-FPM

Prior to starting the setup process of Cacti you should restart the PHP-FPM
Daemon to rebuild the Cache or you may receive a HTTP 500 Error

   ```console
   systemctl restart php-fpm
   ```

2.Install Apache

   ```console
   yum install -y httpd mod_ssl
   ```

3.Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl start httpd
   systemctl enable httpd
   ```

### Example configuration file for Apache 2.4 and SSL

This example configuration assumes you have your own certificates already.  You
should make sure you change the paths to match your setup.

Replace `YourOwnCertFile.crt` and `YourOwnCertFile.key` with the names of the
files holding your certificate (`.crt`) and private key (`.key`).

```console
#
# Cacti: An RRDtool based graphing web application
#

# For security reasons, the Cacti web interface is accessible only to
# localhost in the default configuration. If you want to allow other clients
# to access your Cacti installation, change the httpd ACLs below.
# For example:
# On httpd 2.4, change "Require host localhost" to "Require all granted".
# On httpd 2.2, change "Allow from localhost" to "Allow from all".

<VirtualHost *:443>
    LogLevel warn

    ServerName cacti.yourdomain.com
    ServerAdmin  admin@yourdomain.com

    DocumentRoot "/var/www/html/cacti"
    Alias /cacti    /var/www/html/cacti
    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/YourOwnCertFile.crt
    SSLCertificateKeyFile /etc/ssl/private/YourOwnCertKey.key

    <Directory /var/www/html/cacti/>
        <IfModule mod_authz_core.c>
                # httpd 2.4
                Require all granted
        </IfModule>
        <IfModule !mod_authz_core.c>
                # httpd 2.2
                Order deny,allow
                Deny from all
                Allow from all
        </IfModule>
    </Directory>

    <Directory /var/www/html/cacti/install>
        # mod_security overrides.
        # Uncomment these if you use mod_security.
        # allow POST of application/x-www-form-urlencoded during install
        #SecRuleRemoveById 960010
        # permit the specification of the RRDtool paths during install
        #SecRuleRemoveById 900011
    </Directory>

    # These sections marked "Require all denied" (or "Deny from all")
    # should not be modified.
    # These are in place in order to harden Cacti.
    <Directory /var/www/html/cacti/log>
        <IfModule mod_authz_core.c>
                Require all denied
        </IfModule>
        <IfModule !mod_authz_core.c>
                Order deny,allow
                Deny from all
        </IfModule>
    </Directory>
    <Directory /var/www/html/cacti/rra>
        <IfModule mod_authz_core.c>
                Require all denied
        </IfModule>
        <IfModule !mod_authz_core.c>
                Order deny,allow
                Deny from all
        </IfModule>
    </Directory>
</VirtualHost>
```

### Database Server

The choice between MySQL server and MariaDB is normally down to the OS
maintainers if you use one of the predefined LAMP setup installations.  If you
are deciding between these yourself, you should research this via your
favorite search engine.

Whilst MySQL is the original open source SQL database server created in 1995
which is now owned by Oracle, MariaDB is designed as a drop-in replacement by
some of the original MySQL developers / owners.  This will likely continue to
be a drop-in alternative until there is a major divergence that can not be
bridged.

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

1. Edit your `server.cnf` file

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

### Common packages

#### PHP

PHP and various packages are all required by Cacti for successful operation

1. Install PHP and required packages.

   ```console
   yum install -y php php-common php-bcmath php-cli \
   php-mysqlnd php-gd php-gmp php-intl \
   php-json php-ldap php-mbstring \
   php-pdo php-pear php-snmp php-process \
   php-xml php-zip
   ```

2. Set a timezone to your PHP.INI configuration

   Edit php.ini typically located at `/etc/php.ini`

   ```console
   date.timezone = Pacific/Auckland
   ```

#### RRDtool

RRDtool is required to store the data retrieved from devices in `.rra` files to
produce the graphs which are shown within Cacti

```console
yum install -y rrdtool
```

#### SNMP

SNMP is used to query most devices for information.

```console
yum install -y net-snmp net-snmp-utils
```

### Cacti

The following steps will show you how to manually download, install and
configure the basics for Cacti.

1. Download Cacti source code from [Cacti Web
   Site](https://www.cacti.net/download_cacti.php)

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/cacti-1.2.31.tar.gz
   tar -zxvf cacti-1.2.31.tar.gz
   mv -v cacti-1.2.31 /var/www/html/cacti
   ```

   Import the schema into the new `cacti` database created above. Do not run
   this fresh-install import against an existing Cacti database.

   ```console
   mysql -u root -p cacti < /var/www/html/cacti/cacti.sql
   ```

2. Edit the config.php file

   ```console
   cp /var/www/html/cacti/include/config.php.dist /var/www/html/cacti/include/config.php
   ```

3. Update `database_` fields with your own details. This section only applies
 to the Main Cacti Server

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

   Keep code owned by the administrator. Allow the web/poller account to read
   the configuration and write only the runtime directories:

   ```console
   chown root:apache /var/www/html/cacti/include/config.php
   chmod 640 /var/www/html/cacti/include/config.php
   chown -R apache:apache /var/www/html/cacti/rra /var/www/html/cacti/log /var/www/html/cacti/cache
   chmod -R u+rwX,go-rwx /var/www/html/cacti/rra /var/www/html/cacti/log /var/www/html/cacti/cache
   ```

   The installer can additionally request temporary write access to its
   `resource` query directories, `scripts`, and the CSRF-secret location.
   Grant only the requested access during installation/package import and
   remove it afterwards. Keep SELinux permissions in mind as well.
   Restrict installer access to the administrator and use HTTPS or a protected
   local connection before entering credentials. Complete the web installer
   before starting scheduled polling.

4. Create your cron task file or systemd units file

   Choose either cron or the daemon, not both. Cacti 1.2.16 and later include
   an optional `cactid.service` for running the polling daemon. Match the
   schedule to the configured **Cron/Daemon Interval** in Settings > Poller;
   this can differ from the shorter data-source polling interval.

   For Crontab use, follow the instructions below:

   Create `/etc/cron.d/cacti` as root with mode `644`.
   Make sure to setup the correct path to poller.php

   ```console
   */5 * * * * apache /usr/bin/php /var/www/html/cacti/poller.php >/dev/null 2>&1
   ```

   For systemd unit's file install, you will need to modify the
   included units file to following your install location
   and desired user and group's to run the Cacti poller as.
   To complete the task, follow the procedure below:

   In that service, use `User=apache`, `Group=apache` and
   `ExecStart=/usr/bin/php /var/www/html/cacti/cactid.php`. The
   supplied service defaults to the Apache account and `/var/www/html/cacti`;
   Nginx installations must change both. The daemon manages local polling;
   it does not by itself provide high availability.

   ```console
   cp /var/www/html/cacti/service/cactid.service /etc/systemd/system/cactid.service
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

   On the legacy Rocky Linux 8 repository layout, build dependencies may
   require PowerTools. Repository names differ on other distributions; do not
   apply this command to every RHEL-compatible release.

   ```console
   yum config-manager --set-enabled powertools
   ```

   Then install the build dependencies for your selected repository set:

   ```console
   yum install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

2. Download spine source code from [Cacti Web
   Site](https://www.cacti.net/spine_download.php)

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
ls -Zd /var/www/html/cacti /var/www/html/cacti/rra
ausearch -m AVC -ts recent
```

Apply the file labels and narrowly scoped policy settings required by your
web server, writable directories and database connection. Consult the
[Red Hat SELinux documentation][selinux-guide]; disabling SELinux is not a
required installation step.

### Considerations when using Proxies in front of Cacti (Cacti 1.2.23+)

A header allowlist does not authenticate the proxy. Enable forwarded client-IP
headers only when requests pass through a trusted proxy that replaces those
headers and untrusted clients cannot bypass it to access Cacti directly.
Otherwise, leave forwarded-header processing disabled. Select only the headers
that the trusted proxy actually supplies.
These can be set by editing the following section of config.php

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

**Note:** If you installed Cacti out of `/var/www/html` make sure you fix up
all SELinux context and permissions.

[innodb-variables]:<https://mariadb.com/docs/server/server-usage/storage-engines/innodb/innodb-system-variables>
[selinux-guide]:<https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/index>

---
Copyright (c) 2004-2026 The Cacti Group
