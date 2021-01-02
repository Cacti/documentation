# Installing on CentOS 7

## LAMP (Linux, Apache, MySQL/MariaDB, PHP) Required packages

### Web Server (Apache)

1. Enable Epel repo to enable PHP 7.2 package download

   ```console
   yum install <http://rpms.remirepo.net/enterprise/remi-release-7.rpm> -y
   yum install yum-utils -y
   yum-config-manager --enable remi-php72
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

This example configuration assumes you have your own certificates already.  You
should make sure you change the paths to match your setup.

Replace `YourOwnCertFile.crt` and `YourOwnCertFile.key` with the names of the
files holding your certificate (`.crt`) and private key (`.key`).

```console
#
# Cacti: An RRD based graphing tool
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
        # permit the specification of the RRDTool paths during install
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

1. Install MariaDB server

   ```console
   yum install -y MariaDB-server MariaDB-client
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

   The following `[mysqld]` section is a base configuration.  The installer
   will provide recommendations based on the actual system which will be more
   tailored to your environment.

   ```shell
   [mysqld]
   character-set-server=utf8mb4
   collation-server=utf8mb4_unicode_ci
   innodb_file_format = Barracuda
   max_allowed_packet = 16777777
   join_buffer_size = 32M
   innodb_file_per_table = ON
   innodb_large_prefix = 1
   innodb_buffer_pool_size = 250M
   innodb_additional_mem_pool_size = 90M
   innodb_flush_log_at_trx_commit = 2
   log-error                      = /var/log/mysql/mysql-error.log
   log-queries-not-using-indexes  = 1
   slow-query-log                 = 1
   slow-query-log-file            = /var/log/mysql/mysql-slow.log
   ```

2. Restart MySQL/MariaDB service to pick up the changes

   ```console
   systemctl restart mysql
   ```

3. Populate timezone table with available timezones

   ```console
   mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
   ```

#### Setup Cacti database

1. Login to MySQL/MariaDB as root to create Cacti database

   ```console
   # mysql -u root -p
   MariaDB [(none)]> create database if not exists cacti;
   Query OK, 1 row affected (0.00 sec)
   ```

2. Import Cacti database from SQL file

   ```sql
   MariaDB [(none)]> use cacti;
   Database changed
   MariaDB [(cacti)]> source /var/www/html/cacti/cacti.sql
   ```

3. Grant Cacti username access to Cacti database. Replace `your_cacti_username`
   and `your_cacti_password` with your own details.

   ```sql
   MariaDB [(none)]> CREATE USER 'your_cacti_username'@'localhost' IDENTIFIED BY 'your_cacti_password';
   Query OK, 0 rows affected (0.00 sec)
   MariaDB [(none)]> GRANT ALL PRIVILEGES ON cacti.* TO 'your_cacti_username'@'localhost';
   Query OK, 0 rows affected (0.00 sec)
   ```

4. Grant cacti username to MySQL timezone table

   ```sql
   MariaDB [(none)]> GRANT SELECT ON mysql.time_zone_name TO 'your_cacti_username'@'localhost';
   Query OK, 0 rows affected (0.00 sec)
   MariaDB [(none)]> FLUSH PRIVILEGES;
   Query OK, 0 rows affected (0.00 sec)
   ```

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

#### RRDTool

RRDTool is required to store the data retrieved from devices in `.rra` files to
produce the graphs which are shown within Cacti

```console
yum install -y RRDTool
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
   wget https://www.cacti.net/downloads/cacti-1.y.z.tar.gz
   tar -zxvf cacti-1.y.z.tar.gz
   mv -v cacti-1.y.z /var/www/html/cacti
   ```

2. Edit the config.php file

   ```console
   mv -v /var/www/html/cacti/include/config.php-dist /var/www/html/cacti/include/config.php
   ```

3. Update `database_` fields with your own details. This section only applies
 to the Main Cacti Server

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

4. Create your cron task file

   Create and edit `/etc/cron.d/cacti` file.
   Make sure to setup the correct path to poller.php

   ```console
   */5 * * * * apache php /var/www/html/cacti/poller.php &>/dev/null
   ```

#### Spine

1. Install the necessary packages to compile and install spine

   ```console
   yum install -y autoconf automake libtool dos2unix help2man \
   openssl-devel mariadb-devel net-snmp-devel
   ```

2. Download spine source code from [Cacti Web
   Site](https://www.cacti.net/spine_download.php)

   Go to /tmp to download the source code and extract it

   ```console
   cd /tmp
   wget https://www.cacti.net/downloads/spine/cacti-spine-1.y.z.tar.gz
   tar -zxvf cacti-spine-1.y.z.tar.gz
   cd cacti-spine-1.y.z
   ```

3. Run the configure script and compile spine.

   ```console
   # ./configure
   # make &  make install
   config/install-sh -c -d '/usr/local/spine/bin'
   /bin/sh ./libtool   --mode=install /usr/bin/install -c spine '/usr/local/spine/bin'
   libtool: install: /usr/bin/install -c spine /usr/local/spine/bin/spine
   config/install-sh -c -d '/usr/local/spine/etc'
   /usr/bin/install -c -m 644 spine.conf.dist '/usr/local/spine/etc'
   config/install-sh -c -d '/usr/local/spine/share/man/man1'
   /usr/bin/install -c -m 644 spine.1 '/usr/local/spine/share/man/man1'
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

If you are having issues to access the web page, disable SELinux temporarily to
prove that the issues come from the SELinux policy. It is NOT recommended to
disable SELinux permanently.

[CentOS](https:////wiki.centos.org/es/HowTos/SELinux) has a lot of
documentation on how to make your SELinux policy right.

1. Check SELinux status

   ```console
   getenforce
   ```

2. Disable SELinux temporarily

   ```console
   setenforce 0
   ```

3. Enable SELinux back

   ```console
   setenforce 1
   ```

**Note:** If you installed Cacti out of `/var/www/html` make sure you fix up
all SELinux context and permissions.

---
Copyright (c) 2004-2021 The Cacti Group
