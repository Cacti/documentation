
# Installing Cacti 1.x  in Ubuntu/Debian LAMP stack
<br>

## Installing the required packages needed for the LAMP stack
<br>
<br>
apt-get update
apt-get install -y apache2 rrdtool mariadb-server snmp snmpd php7.0 php-mysql php7.0-snmp php7.0-xml php7.0-mbstring php7.0-json php7.0-gd php7.0-gmp php7.0-zip php7.0-ldap php7.0-mc
<br>
<br>
### Downloading the Cacti software 
Once the OS packages are installed we need to download the Cacti files you can do this by using the git command
<br>
<br>

git clone https://github.com/Cacti/cacti.git
<br>
Cloning into 'cacti'...
<br>
remote: Enumerating objects: 81, done.
<br>
remote: Counting objects: 100% (81/81), done.
<br>
remote: Compressing objects: 100% (55/55), done.
<br>
remote: Total 59936 (delta 40), reused 51 (delta 26), pack-reused 59855
<br>
Receiving objects: 100% (59936/59936), 76.33 MiB | 1.81 MiB/s, done.
<br>
Resolving deltas: 100% (43598/43598), done.
<br>
<br>
 <br>
After downloading the cacti files move the files into the /var/www/html directory 
<br>
mv cacti /var/www/html
<br>
#### Database Creation 
<br>
Next we will create a database for the cacti installation to use 
<br>
<br>
mysql -u root -p
<br>
CREATE DATABASE cacti DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
<br>
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'localhost' IDENTIFIED BY 'cacti'; ;
<br>
GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;
<br>
ALTER DATABASE cacti CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
<br>
FLUSH PRIVILEGES;

<br>
 <br>

we will now need to pre-populate the database used by cacti 
<br>

mysql -u root cacti < /var/www/html/cacti/cacti.sql
<br>

Now we are ready to start configuring cacti we have  need to edit the config.php file locating in /var/www/html/cacti/include
<br>
cd /var/www/html/cacti/include
<br>
cp config.php.dist config.php
<br>

make changes as needed to the below entries 

$database_type     = 'mysql';
<br>
$database_default  = 'cacti';
<br>
$database_hostname = 'localhost';
<br>
$database_username = 'cactiuser';
<br>
$database_password = 'cactiuser';
<br>
$database_port     = '3306';
<br>
$database_retries  = 5;
<br>
$database_ssl      = false;
<br>
$database_ssl_key  = '';
<br>

The system is now ready to go just surf to <youip>/cacti to start the cacti initalization 
 <br>
 <br>
 
 #### Auto installation script by BMFMANCINI 
 This script will do the above steps in a interactive style via a bash script 
 <br>
 <br>
 https://github.com/bmfmancini/cacti-install-wizard
 
 <br>
 
 
 You can also see a video tutorial of this installation below
 <br>
  [![IMAGE ALT TEXT](http://img.youtube.com/vi/be8Pz5O4d8Y/0.jpg)](http://www.youtube.com/watch?v=be8Pz5O4d8YE "Video Title")
 
 <br>
 
 
 
 
 Copyright (c) 2004-2019 The Cacti Group
  
