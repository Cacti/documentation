# Installing on Enterprise Linux (RHEL / Rocky Linux / AlmaLinux)

> **Note**: As of Cacti 1.2.31, PHP 8.1 is required and PHP Composer is required.
> Composer will be used to ensure all libraries are installed and up to date.

## LEMP (Linux, Nginx, MySQL/MariaDB, PHP) Required packages

### Web Server (Nginx)

1. Install Nginx

   ```console
   yum install -y nginx
   ```

2. Enable and start the service to ensure it starts when the system reboots

   ```console
   systemctl start nginx
   systemctl enable nginx
   ```

### Example Nginx configuration with SSL

This example assumes you have your own certificates already. Change the paths to
match your setup. Replace `YourOwnCertFile.crt` and `YourOwnCertFile.key` with
the names of your certificate (`.crt`) and private key (`.key`) files.

Save the following as `/etc/nginx/conf.d/cacti.conf`:

```nginx
# Advanced config for NGINX
#server_tokens off;
add_header X-XSS-Protection "1; mode=block";
add_header X-Content-Type-Options nosniff;

# Redirect all HTTP traffic to HTTPS
server {
   listen 80;
   server_name cacti.yourdomain.com;
   return 301 https://$host$request_uri;
}

# SSL configuration
server {
   listen 443 ssl;
   server_name cacti.yourdomain.com;
   root /usr/share/nginx/html/cacti;
   index index.php index.html index.htm;

   # Compression improves performance
   gzip on;
   gzip_types      text/plain text/html text/xml text/css application/xml application/javascript application/x-javascript application/rss+xml application/xhtml+xml;
   gzip_proxied    no-cache no-store private expired auth;
   gzip_min_length 1000;

   location / {
      try_files $uri $uri/ /index.php?$query_string;
   }

   error_page 404 /404.html;
   error_page 500 502 503 504 /50x.html;
   location = /50x.html {
      root /usr/share/nginx/html/;
   }

   location ~ \.php$ {
      root /usr/share/nginx/html/cacti;
      index index.php;
      try_files $uri $uri/ =404;
      fastcgi_split_path_info ^(.+\.php)(/.+)$;

      # Adjust path for your OS if needed
      fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include /etc/nginx/fastcgi_params;
   }

   location /cacti {
      root /usr/share/nginx/html/;
      index index.php index.html index.htm;
      location ~ ^/cacti/(.+\.php)$ {
         try_files $uri =404;
         root /usr/share/nginx/html;

         # Adjust path for your OS if needed
         fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
         fastcgi_index index.php;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         include /etc/nginx/fastcgi_params;
      }

      location ~* ^/cacti/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
         expires max;
         log_not_found off;
      }
   }

   location /doc/ {
      alias /usr/share/nginx/html/cacti/doc/;
      location ~* ^/docs/(.+\.(html|md|txt))$ {
         root /usr/share/nginx/html/cacti/;
         autoindex on;
         allow 127.0.0.1; # Change this to allow your local networks
         allow ::1;
         deny all;
      }
   }

   location ~ ^/(cacti/)?(rra|log|cache)/ {
      deny all;
   }

   ## Access and error logs.
   access_log /var/log/nginx/cacti_access.log;
   error_log  /var/log/nginx/cacti_error.log info;

   ssl_certificate      /etc/ssl/certs/YourOwnCertFile.crt;
   ssl_certificate_key  /etc/ssl/private/YourOwnCertKey.key;

   # Improve HTTPS performance with session resumption
   ssl_session_cache shared:SSL:10m;
   ssl_session_timeout 5m;

   # Only allow TLS 1.2 and 1.3; TLS 1.0 and 1.1 are prohibited by RFC 8996
   ssl_protocols TLSv1.2 TLSv1.3;

   # Secure cipher suites; excludes known-weak ciphers (3DES, RC4, NULL)
   ssl_ciphers ECDH+AESGCM:ECDH+AES256:ECDH+AES128:!ADH:!AECDH:!MD5:!3DES;
   ssl_prefer_server_ciphers on;

   # Diffie-Hellman parameter for DHE cipher suites
   # Generate with: openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
   ssl_dhparam /etc/ssl/certs/dhparam.pem;

   # Enable HSTS (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
   add_header Strict-Transport-Security "max-age=63072000; includeSubDomains";
}
```

### Database Server

The choice between MySQL and MariaDB is normally determined by the OS
maintainers when using a predefined LAMP setup. If you are choosing between them
yourself, research the differences via your preferred search engine.

MySQL is the original open source SQL database server, created in 1995 and now
owned by Oracle. MariaDB is designed as a drop-in replacement by some of the
original MySQL developers. The two are expected to remain compatible until a
major divergence occurs that cannot be bridged.

#### MySQL

1. Install MySQL server

   ```console
   yum install -y mysql mysql-server
   ```

2. Enable and start the service

   ```console
   systemctl enable mysqld
   systemctl start mysqld
   ```

#### MariaDB

1. Install MariaDB server

   ```console
   dnf install -y mariadb-server mariadb
   ```

2. Enable and start the service

   ```console
   systemctl enable mariadb
   systemctl start mariadb
   ```

### MySQL/MariaDB common tasks and recommendations

> **Note**: Secure your MySQL installation before making any further changes.

```console
/usr/bin/mysql_secure_installation
```

The following recommendations may vary depending on your system. Cacti will
prompt you with more accurate recommendations during installation.

1. Edit your `server.cnf` file

   ```console
   vim /etc/my.cnf.d/server.cnf
   ```

   The following is a base configuration. Adjust values up or down based on the
   recommendations Cacti provides during installation.

   **For MariaDB earlier than version 11.1, or MySQL:**

   ```shell
   [mysqld]
   character_set_client            = utf8mb4
   character-set-server            = utf8mb4
   collation-server                = utf8mb4_unicode_ci
   # innodb_file_format and innodb_large_prefix were removed in MySQL 8.0 /
   # MariaDB 10.3+; omit those settings on newer releases.
   max_allowed_packet              = 16777777
   max_heap_table_size             = 500M
   join_buffer_size                = 32M
   innodb_file_per_table           = ON
   innodb_buffer_pool_size         = 500M
   # innodb_additional_mem_pool_size was removed in MySQL 5.7.4 /
   # MariaDB 10.0; omit on newer releases.
   innodb_flush_log_at_trx_commit  = 2
   log-error                       = /var/log/mysql/mysql-error.log
   log-queries-not-using-indexes   = 1
   slow-query-log                  = 1
   slow-query-log-file             = /var/log/mysql/mysql-slow.log
   ```

   **For MariaDB 11.0 or higher:**

   ```shell
   [mariadb]
   character_set_client            = utf8mb4
   character_set_server            = utf8mb4
   collation_server                = utf8mb4_unicode_ci
   max_heap_table_size             = 500M
   join_buffer_size                = 32M
   innodb_buffer_pool_size         = 8G
   innodb_doublewrite              = OFF
   tmp_table_size                  = 500M
   log-error                       = /var/log/mysql/mysql-error.log
   log-queries-not-using-indexes   = 1
   slow-query-log                  = 1
   slow-query-log-file             = /var/log/mysql/mysql-slow.log
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
   MariaDB [(cacti)]> source /usr/share/nginx/html/cacti/cacti.sql
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

### PHP

PHP and the following packages are required for Cacti to operate.

> **Note**: `php-fpm` is required when using Nginx as the web server.

1. Install PHP and required packages

   ```console
   yum install -y php php-common php-bcmath php-cli \
   php-mysqlnd php-gd php-gmp php-intl \
   php-ldap php-mbstring \
   php-pdo php-pear php-snmp php-process \
   php-xml php-zip php-fpm composer
   ```

2. Set a timezone in your PHP configuration

   Edit `/etc/php.ini` and set:

   ```console
   date.timezone = America/Los_Angeles
   ```

3. Disable insecure `cgi.fix_pathinfo`

   ```console
   cgi.fix_pathinfo=0
   ```

#### Set up php-fpm

1. Enable and start the service

   ```console
   systemctl start php-fpm
   systemctl enable php-fpm
   ```

2. Edit `/etc/php-fpm.d/www.conf`

   Change the listen address from TCP to a Unix socket:

   ```console
   listen = /var/run/php-fpm/php-fpm.sock
   ```

   Set the socket owner and group to `nginx`:

   ```console
   listen.owner = nginx
   listen.group = nginx
   ```

   Set the process user and group to `nginx`:

   ```console
   user = nginx
   group = nginx
   ```

   Restart php-fpm to apply the changes:

   ```console
   systemctl restart php-fpm
   ```

### RRDtool

RRDtool is required to store the data retrieved from devices in `.rra` files and
produce the graphs shown within Cacti.

```console
yum install -y rrdtool
```

### SNMP

SNMP is used to query most devices for information.

```console
yum install -y net-snmp net-snmp-utils
echo "rocommunity public" > /etc/snmp/snmpd.conf
systemctl enable snmpd
systemctl start snmpd
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
   mv -v cacti-1.y.z /usr/share/nginx/html/cacti
   ```

2. Create the config.php file

   ```console
   cp -v /usr/share/nginx/html/cacti/include/config.php.dist /usr/share/nginx/html/cacti/include/config.php
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

4. Set your cookie domain to match your website domain name

   ```php
   $cacti_cookie_domain = 'cacti.yourdomain.com';
   ```

5. Create your cron task file or systemd units file

   Starting with Cacti 1.2.16, you can use either a legacy crontab entry or the
   optional `cactid` systemd service to run your Cacti pollers.

   For crontab use, create and edit `/etc/cron.d/cacti`, setting the correct
   path to `poller.php`:

   ```console
   */5 * * * * nginx php /usr/share/nginx/html/cacti/poller.php &>/dev/null
   ```

   For systemd, modify the included units file to reflect your install location
   and the desired user and group, then follow the procedure below:

   ```console
   vim /usr/share/nginx/html/cacti/service/cactid.service
   touch /etc/sysconfig/cactid
   cp -p /usr/share/nginx/html/cacti/service/cactid.service /etc/systemd/system
   systemctl enable cactid
   systemctl start cactid
   systemctl status cactid
   ```

   The systemd units file makes managing a highly available Cacti setup more
   convenient.

#### Spine

1. Install the packages required to compile Spine

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

**Note:** If Cacti is installed outside `/usr/share/nginx/html`, ensure that all
SELinux file contexts and permissions are set correctly.

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
