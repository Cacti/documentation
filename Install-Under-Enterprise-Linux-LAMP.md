# Installing on Enterprise Linux (RHEL / Rocky Linux / AlmaLinux)

> **Note**: As of Cacti 1.2.31, PHP 8.1 is required and PHP Composer is required.
> Composer will be used to ensure all libraries are installed and up to date.

## LAMP (Linux, Apache, MySQL/MariaDB, PHP) Required packages

### Web Server (Apache)

1. For EL 8 and EL 9+ (RHEL, Rocky Linux, AlmaLinux)

   ```console
   dnf module reset php
   dnf module enable php:8.1
   ```

### A special note on installing Cacti in LXC containers such as those found on Proxmox

We recommend creating a privileged container. You may need to update your container's config file with

```console
lxc.apparmor.profile: unconfined
```

This will allow ICMP ping and other functions to work.

A tested configuration like the one below should work; tune to your needs and standards.

```console
arch: amd64
cores: 2
hostname: cacti
memory: 2048
net0: name=eth0,bridge=vmbr0,firewall=1,hwaddr=mac-id,ip=dhcp,type=veth
ostype: rocky
rootfs: local-lvm:vm-110-disk-0,size=8G
swap: 2048
lxc.apparmor.profile: unconfined
```

### A special note for systems using PHP-FPM

Before starting the Cacti setup process, restart the PHP-FPM daemon to rebuild
its cache, or you may receive an HTTP 500 error.

```console
systemctl restart php-fpm
```

2. Install Apache

   ```console
   yum install -y httpd
   ```

3. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl start httpd
   systemctl enable httpd
   ```

### Example configuration file for Apache 2.4 and SSL

This example configuration assumes you have your own certificates already. You
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

The choice between MySQL server and MariaDB is normally determined by the OS
maintainers when using a predefined LAMP setup. If you are choosing between
them yourself, research the differences via your preferred search engine.

MySQL is the original open source SQL database server, created in 1995 and now
owned by Oracle. MariaDB is designed as a drop-in replacement by some of the
original MySQL developers. The two are expected to remain compatible until a
major divergence occurs that cannot be bridged.

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

1. Install MariaDB server

   ```console
   dnf install -y mariadb-server mariadb
   ```

2. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl enable mariadb
   systemctl start mariadb
   ```

### MySQL/MariaDB common tasks and recommendations

> **Note**: Secure your MySQL installation before making any further changes.

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

   The following `[mysqld]` section is a base configuration. The installer
   will provide recommendations tailored to your actual system; revise these
   values up or down based on those recommendations.

   **For MariaDB earlier than version 11.1, or MySQL:**

   ```shell
   [mysqld]
   character-set-server=utf8mb4
   collation-server=utf8mb4_unicode_ci
   # innodb_file_format and innodb_large_prefix were removed in MySQL 8.0 /
   # MariaDB 10.3+; omit those settings on newer releases.
   max_allowed_packet = 16777777
   join_buffer_size = 32M
   innodb_file_per_table = ON
   innodb_buffer_pool_size = 250M
   # innodb_additional_mem_pool_size was removed in MySQL 5.7.4 /
   # MariaDB 10.0; omit on newer releases.
   innodb_flush_log_at_trx_commit = 2
   log-error                      = /var/log/mysql/mysql-error.log
   log-queries-not-using-indexes  = 1
   slow-query-log                 = 1
   slow-query-log-file            = /var/log/mysql/mysql-slow.log
   ```

   **For MariaDB 11.0 or higher:**

   ```shell
   [mariadb]
   max_heap_table_size=500M
   character_set_client=utf8mb4
   character_set_server=utf8mb4
   collation_server=utf8mb4_unicode_ci
   innodb_buffer_pool_size=8G
   innodb_doublewrite=OFF
   tmp_table_size=500M
   log-error                      = /var/log/mysql/mysql-error.log
   log-queries-not-using-indexes  = 1
   slow-query-log                 = 1
   slow-query-log-file            = /var/log/mysql/mysql-slow.log
   ```

2. Restart MySQL/MariaDB to apply the changes

   ```console
   systemctl restart mysqld  # or: systemctl restart mariadb
   ```

3. Populate the timezone table

   ```console
   mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
   ```

#### Set up the Cacti database

1. Log in to MySQL/MariaDB as root and create the Cacti database

   ```console
   # mysql -u root -p
   MariaDB [(none)]> create database if not exists cacti;
   Query OK, 1 row affected (0.00 sec)
   ```

2. Import the default Cacti schema

   ```sql
   MariaDB [(none)]> use cacti;
   Database changed
   MariaDB [(cacti)]> source /var/www/html/cacti/cacti.sql
   ```

3. Create the Cacti database user. Replace `your_cacti_username` and
   `your_cacti_password` with your own credentials.

   ```sql
   MariaDB [(none)]> CREATE USER 'your_cacti_username'@'localhost'
   IDENTIFIED BY 'your_cacti_password';
   Query OK, 0 rows affected (0.00 sec)
   MariaDB [(none)]> GRANT ALL PRIVILEGES ON cacti.* TO 'your_cacti_username'@'localhost';
   Query OK, 0 rows affected (0.00 sec)
   ```

4. Grant the Cacti user access to the timezone table

   ```sql
   MariaDB [(none)]> GRANT SELECT ON mysql.time_zone_name TO 'your_cacti_username'@'localhost';
   Query OK, 0 rows affected (0.00 sec)
   MariaDB [(none)]> FLUSH PRIVILEGES;
   Query OK, 0 rows affected (0.00 sec)
   ```

5. Set the database character set and collation

   ```sql
   MariaDB [(none)]> ALTER DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   MariaDB [(none)]> FLUSH PRIVILEGES;
   ```

### Common packages

#### PHP

PHP and the following packages are required for Cacti to operate.

1. Install PHP and required packages

   ```console
   yum install -y php php-common php-bcmath php-cli \
   php-mysqlnd php-gd php-gmp php-intl \
   php-ldap php-mbstring \
   php-pdo php-pear php-snmp php-process \
   php-xml php-zip composer
   ```

2. Set a timezone in your PHP configuration

   Edit `/etc/php.ini` and set:

   ```console
   date.timezone = America/Los_Angeles
   ```

#### RRDtool

RRDtool is required to store the data retrieved from devices in `.rra` files and
produce the graphs shown within Cacti.

```console
yum install -y rrdtool
```

#### SNMP

SNMP is used to query most devices for information.

```console
yum install -y net-snmp net-snmp-utils
```

### Cacti

The following steps show you how to manually download, install, and configure
the basics for Cacti.

1. Download the Cacti source code from the
   [Cacti website](https://www.cacti.net/download_cacti.php)

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/cacti-1.y.z.tar.gz
   tar -zxvf cacti-1.y.z.tar.gz
   mv -v cacti-1.y.z /var/www/html/cacti
   ```

2. Create the config.php file

   ```console
   cp -v /var/www/html/cacti/include/config.php.dist /var/www/html/cacti/include/config.php
   ```

3. Update the `database_` fields with your own details. This section applies
   only to the main Cacti server.

   ```php
   $database_type     = 'mysql';
   $database_default  = 'your_cacti_database';
   $database_hostname = 'localhost';
   $database_username = 'your_cacti_username';
   $database_password = 'your_cacti_password';
   $database_port     = '3306';
   $database_ssl      = false;
   $database_ssl_key  = '';
   $database_ssl_cert = '';
   $database_ssl_ca   = '';
   ```

4. Create your cron task file or systemd units file

   Starting with Cacti 1.2.16, you can use either a legacy crontab entry or the
   optional `cactid` systemd service to run your Cacti pollers.

   For crontab use, create and edit `/etc/cron.d/cacti`, setting the correct
   path to `poller.php`:

   ```console
   */5 * * * * apache php /var/www/html/cacti/poller.php &>/dev/null
   ```

   For systemd, modify the included units file to reflect your install location
   and the desired user and group, then follow the procedure below:

   ```console
   vim /var/www/html/cacti/service/cactid.service
   touch /etc/sysconfig/cactid
   cp -p /var/www/html/cacti/service/cactid.service /etc/systemd/system
   systemctl enable cactid
   systemctl start cactid
   systemctl status cactid
   ```

   The systemd units file makes managing a highly available Cacti setup more
   convenient.

#### Spine

1. Install the packages required to compile Spine

   The required packages depend on your EL version. Choose the block that
   matches your distribution.

   **EL 9+ (RHEL 9, Rocky Linux 9, AlmaLinux 9 and later)**

   The `crb` (CodeReady Builder) repository provides the development headers
   needed to compile Spine.

   ```console
   dnf config-manager --set-enabled crb
   dnf install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

   **EL 8 (RHEL 8, Rocky Linux 8, AlmaLinux 8)**

   On EL 8 the same repository is called `powertools`.

   ```console
   dnf config-manager --set-enabled powertools
   dnf install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

   **EL 7 and earlier**

   ```console
   yum install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

2. Download the Spine source code from the
   [Cacti website](https://www.cacti.net/spine_download.php)

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/spine/cacti-spine-1.y.z.tar.gz
   tar -zxvf cacti-spine-1.y.z.tar.gz
   cd cacti-spine-1.y.z
   ```

3. Compile and install Spine

   ```console
   ./bootstrap
   ./configure
   make
   make install
   chown root:root /usr/local/spine/bin/spine
   chmod u+s /usr/local/spine/bin/spine
   ```

4. Configure Spine

   ```console
   mv -v /usr/local/spine/etc/spine.conf.dist /usr/local/spine/etc/spine.conf
   vi /usr/local/spine/etc/spine.conf
   ```

5. Set up the database connection in `spine.conf`

   ```console
   DB_Host       localhost
   DB_Database   your_cacti_database
   DB_User       your_cacti_username
   DB_Pass       your_cacti_password
   DB_Port       3306
   #DB_UseSSL    0
   #RDB_SSL_Key
   #RDB_SSL_Cert
   #RDB_SSL_CA
   ```

### Security Enhanced Linux (SELinux)

If you have trouble accessing the web interface, disable SELinux temporarily to
determine whether the SELinux policy is the cause. Do not disable SELinux
permanently.

The [Rocky Linux SELinux Guide](https://docs.rockylinux.org/guides/security/learning_selinux/) provides
guidance on managing SELinux policies.

1. Check SELinux status

   ```console
   getenforce
   ```

2. Disable SELinux temporarily

   ```console
   setenforce 0
   ```

3. Re-enable SELinux

   ```console
   setenforce 1
   ```

**Note:** If Cacti is installed outside `/var/www/html`, ensure that all SELinux
file contexts and permissions are set correctly.

### Considerations when using proxies in front of Cacti (Cacti 1.2.23+)

For optimal security, specify only the HTTP headers that your proxy software
actually sets. This prevents unauthorized access via header spoofing. Configure
the setting by editing the following section of `config.php`:

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
