# General Installing Instructions

Make sure the following packages are installed according to your operating
systems requirements. Verify, that httpd/apache and MySQL/MariaDB are started
at system startup.

## Required Packages for Most Operating Systems

Depending on your operating system and PHP version, certain packages are
required for Cacti.  The largest variable in these requirements come with
regard to PHP and MySQL/MariaDB.

Installation requirements include the packages below.  The installation of these
packages will vary by operating system.

### Base OS

- apache, IIS, or nginx

- net-snmp, net-snmp-utils

- rrdtool

- help2man (for spine)

- dos2unix (for spine)

- development packages (gcc, automake, autoconf, libtool,
  either mysql-devel or mariadb-devel, net-snmp-devel, help2man)

  (for spine)

### Database

MySQL versions to 5.7 are supported.  MariaDB to 10.2 is also supported.

- mysql

- mysql-server

- libmysqlclient

or

- mariadb

- mariadb-server

- libmariadbclient

### PHP Modules

The installation of these modules vary by OS.  Use the `php -m` command to
verify that they are installed.

- posix

- session

- sockets

- PDO

- pdo_mysql

- xml

- ldap

- mbstring

- pcre

- json

- openssl

- gd

- zlib

### PHP Optional Modules

The following modules are optional, but preferred to be installed.

- snmp

- gmp (for plugin support)

- com or dotnet (windows only)

## FreeBSD

When installing on FreeBSD you can use two ways. For both ways, cacti has a lot
of dependent packages, you don't need to install anything else. Everything is
prepared. Both ways have few pros and cons:

- Compiled packages - fast, but invariant dependencies (like older MySQL server,
  PHP version, ...)

  ```sh
  pkg install cacti
  pkg install spine
  ```

- FreeBSD ports - compilation could last long time, but without invariant
  dependencies (See [Howto use
  ports](https://www.freebsd.org/doc/handbook/ports-using.html))

  ```sh
  portsnap fetch extract
  portsnap fetch update
  cd /usr/ports/databases/mariadb102-server (or mysql57-server)
  make install
  cd /usr/ports/net-mgmt/cacti
  make install
  cd /usr/ports/net-mgmt/spine
  make install
  ```

Apache and other software is possible install with package or Ports too.

Everything in FreeBSD is installed to /usr/local/ directory! In this
documentation you can see paths like /etc/php.ini, /usr/bin/spine, ...

Please use correct paths - /usr/local/etc, /usr/local/bin/spine, ...

For Spine set suid bit (without this isn't possible make ICMP ping):

```sh
chmod +s /usr/local/bin/spine
```

## Configure PHP

Verify that the modules are installed and configured correctly. There are
several ways to do so - consult [PHP configuration
instructions](http://www.php.net/manual/en/configuration.php) for a complete
description.

It is imperative that you set the `date.timezone` in your `/etc/php.ini`, or
`/etc/phpX/apache/php.ini` and `/etc/phpX/cli/php.ini` files.  Failure to do so
will result in errors after the install is complete.

Most other PHP configuration is done automatically by the base OS, so there is
no need to discuss that here.

## Configure the Webserver (Apache)

Most Linux/UNIX OS' automatically configure the Web Server to allow PHP content.
So there should be no need to provide additional configuration.  However, the
following section is included below for reference in the case that you are
running a UNIX version that does not properly configure the Webserver properly.
The documentation below is written specifically for RHEL and variants.  So, the
instructions may vary.

Find the file `/etc/httpd/conf/httpd.conf` or its equivalent and make the
following changes to it:

```ini
# Load config files from the config directory "/etc/httpd/conf.d".
Include conf.d/*.conf
```

Now, locate the PHP configuration file at `/etc/httpd/conf.d/php.conf`

```ini
# PHP is an HTML-embedded scripting language which attempts to make it
# easy for developers to write dynamically generated webpages.
LoadModule php_module modules/libphp.so
#
# Cause the PHP interpreter to handle files with a .php extension.
AddHandler php-script .php
AddType text/html .php
#
# Add index.php to the list of files that will be served as directory
# indexes.
DirectoryIndex index.php
```

## Configure MySQL/MariaDB

Set a password for the root user, and record this password.  If you loose
control of this password, you may have to re-install your database server in the
case of any system disaster or recovering from a crash.

```sh
shell> mysqladmin --user=root password somepassword
shell> mysqladmin --user=root --password reload
```

You must also load timezone information into the database.  This is required for
various plugin use.  Later, you will be required to grant access to the
`time_zone_name` table during the final installation steps.

```sh
shell> mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
```

Since Cacti 1.x is supporting internationalization (i18n), it is important that
the default character set for MySQL/MariaDB be i18n compatible.  The Cacti
installer will make specific recommendations on MySQL/MariaDB settings.  Follow
those as applicable for your OS.

Galera clustering: There are several tables which are set to use the MEMORY
storage engine which do not get replicated among nodes which can cause problems.
If you configure Cacti to only connect to one node of your cluster and are not
load balancing this does not apply to you.

If you are running multiple nodes in a load-balanced environment where you
connect to a VIP you should remove all but one node from rotation during Cacti
installation or update. After the installation/update login to your MySQL server
and execute the following commands to update those tables to use the InnoDB
engine:

```sql
MariaDB [(none)]> use cacti;
MariaDB [cacti]>> ALTER TABLE `automation_ips` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `automation_processes` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `data_source_stats_hourly_cache` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `data_source_stats_hourly_last` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `poller_output` ENGINE=InnoDB;
MariaDB [cacti]>> ALTER TABLE `poller_output_boost_processes` ENGINE=InnoDB;
```

These changes should replicate to the other nodes in your cluster. Allow Cacti
to run at least two or three full polling cycles before placing the other nodes
back into rotation.

## Install and Configure Cacti

1. Extract the distribution tarball.

   ```sh
   shell> tar xzvf cacti-version.tar.gz
   ```

2. Create the MySQL database:

   ```sh
   shell> mysqladmin --user=root create cacti
   ```

3. Import the default cacti database:

   ```sh
   shell> mysql cacti < cacti.sql
   ```

4. Optional: Create a MySQL username and password for Cacti.

   ```sql
   shell> mysql --user=root mysql
   MySQL> GRANT ALL ON cacti.* TO cactiuser@localhost IDENTIFIED BY 'somepassword';
   MySQL> GRANT SELECT ON mysql.time_zone_name TO cactiuser@localhost IDENTIFIED BY 'somepassword';
   MySQL> flush privileges;
   ```

Note that if your `root` (or equivalent) user does not have `SUPER` permissions,
it may still be possible to `GRANT SELECT` privileges to the Cacti user via an
`INSERT INTO mysql.tables_priv`.

```sql
INSERT INTO mysql.tables_priv (Host, Db, User, Table_name, Grantor, Table_priv)
VALUES ('localhost', 'mysql', 'cactiuser', 'time_zone_name', 'root@localhost', 'Select');
```

5. Edit `include/config.php` and specify the database type, name, host, user
   and password for your Cacti configuration.

   ```php
   $database_type = "mysql";
   $database_default = "cacti";
   $database_hostname = "localhost";
   $database_username = "cactiuser";
   $database_password = "cacti";
   ```

6. Set the appropriate permissions on Cacti's directories for graph/log
   generation. You should execute these commands from inside Cacti's directory
   to change the permissions.

   ```sh
   shell> chown -R cactiuser rra/ log/ cache/
   ```

   (Enter a valid username for *cactiuser*, this user will also be used in the
   next step for data gathering.)

7. Create your cron task file or systemd units file

   Starting with Cacti 1.2.16, you have the option to use either the
   legacy Crontab entry, or an optional cactid units file and server
   to run your Cacti pollers.

   For Crontab use, follow the instructions below:

   Create and edit `/etc/cron.d/cacti` file.
   Make sure to setup the correct path to poller.php

   ```console
   */5 * * * * apache php <path_cacti>/poller.php &>/dev/null
   ```

   For systemd unit's file install, you will need to modify the
   included units file to following your install location
   and desired user and group's to run the Cacti poller as.
   To complete the task, follow the procedure below:

   ```console
   vim <path_cacti>/service/cactid.service (edit the path)
   touch /etc/sysconfig/cactid
   cp -p <path_cacti>/service/cactid.service /etc/systemd/system
   systemctl enable cactid
   systemctl start cactid
   systemctl status cactid
   ```

   The systemd units file makes managing a highly available Cacti
   setup a bit more convenient.

8. During install, you will need to provide write access to the following files
   and directories:

   ```sh
   shell> chown -R resource scripts include/config.php
   ```

   Once the installation is complete, you may change the permissions to more
   restrictive settings.

9. Point your web browser to:

   `http://<your-server>/cacti/`

   Log in the with a username/password of *admin*. You will be required to
   change this password immediately. Make sure to fill in all of the path
   variables carefully and correctly on the following screen.

## (Optional) Install and Configure Spine

Spine is a very fast data collection engine, written in C. It is an optional
replacement for cmd.php. If you decide to use it, you will have to install it
explicitly. It does not come with cacti itself.

The easiest way is to install Spine using rpm or ports. You will find packages
for Spine at the main cacti site or from your distribution.

To compile Spine, download it to any location of your liking. Then, issue from
the downloaded directory following commands

```sh
shell>./bootstrap
```

If the `boostrap` script is successful, you then will follow the instructions it
provides to compile and install.

Assuming, you've managed to install spine correctly, you will have to configure
it. The configuration file may be placed in the same directory as spine itself
or at /etc/spine.conf.

```ini
DB_Host  127.0.0.1 or hostname (not localhost)
DB_Database cacti
DB_User     cactiuser
DB_Password cacti
DB_Port     3306
```

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
