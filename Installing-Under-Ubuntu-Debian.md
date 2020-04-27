# Installing Cacti 1.x  in Ubuntu/Debian LAMP stack

## Installing the required packages needed for the LAMP stack

```console
apt-get update
apt-get install -y apache2 rrdtool mariadb-server snmp snmpd php7.0 php-mysql php7.0-snmp php7.0-xml php7.0-mbstring php7.0-json php7.0-gd php7.0-gmp php7.0-zip php7.0-ldap php7.0-mc
```

### Downloading the Cacti software

Once the OS packages are installed, you will need to download the Cacti files
you can do this by using the git command

```console
git clone https://github.com/Cacti/cacti.git
Cloning into 'cacti'...
remote: Enumerating objects: 81, done.
remote: Counting objects: 100% (81/81), done.
remote: Compressing objects: 100% (55/55), done.
remote: Total 59936 (delta 40), reused 51 (delta 26), pack-reused 59855&
Receiving objects: 100% (59936/59936), 76.33 MiB | 1.81 MiB/s, done.
Resolving deltas: 100% (43598/43598), done.
```

After cloning the Cacti repository, move the files into the /var/www/html
directory

```console
mv cacti /var/www/html
```

#### Database Creation

Next we will create a database for the cacti installation to use

```console
mysql -u root -p
CREATE DATABASE cacti DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'localhost' IDENTIFIED BY 'cacti';
GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;
ALTER DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
FLUSH PRIVILEGES;
```

You will now need to pre-populate the database used by cacti

```console
mysql -u root cacti < /var/www/html/cacti/cacti.sql
```

Next, you will need to create the config.php file in /var/www/html/cacti/include

```console
cd /var/www/html/cacti/include
cp config.php.dist config.php
```

Now, edit the config.php file and make sure to change the database settings as
needed to match the below entries (though it is highly recommended to use a
customised username/password combination for security)

```console
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

The system is now ready to finialise the steps by browsing to
[http://serverip/cacti](http://serverip/cacti) to start the cacti initalization
wizard.

### Video Tutorial on how to install cacti step by step

[![Video Tutorial ](https://www.youtube.com/watch?v=bCiL51G0sSg/0.jpg)](https://www.youtube.com/watch?v=bCiL51G0sSg "Video Tutorial")

---
Copyright (c) 2004-2020 The Cacti Group
