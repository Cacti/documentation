# Remote Poller setup

Remote Pollers add complexity to your cacti setup while also massivley extended 
the capability of itremote pollers allow sysadmin to distribute the load of polling 
between differnt servers as well as provideanother source of polling close to a device

For example you may have a device in toronto but if your pollers are in Newyork
the network latency may causes issues with your metrics
having a remote poller in Toronto in this case will help with that issue

## Setup instructions

With this setup the following layout is assumed

Main server IP is 192.168.1.5
Remote poller 1 server IP is 192.168.1.10
Remote poller 2 servers Ip is 192.168.1.20

## Database configurations

Each server will have its own local database however the remote pollers
will need to talk back to the main poller so we must allow the remote servers
user account to connect back to the main pollers database via the network

Main server database config

```bash
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.10' IDENTIFIED BY 'cacti';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.20' IDENTIFIED BY 'cacti';
```

Remote poller 1 database configuration

GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.5' IDENTIFIED BY 'cacti';

Remote poller 2 database configuration

GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.5' IDENTIFIED BY 'cacti';

we have also let the main poller talk to the remote pollers to keep in sync

## Spine configuration

When you have setup multiple pollers while using spine you will need to also
configure the spine.conf file to connect to the remote database as well

Be sure to remove the # next to the below entries

```bash
RDB_Host 192.168.1.5
RDB_Database cacti
RDB_User cacti
RDB_Pass cacti
RDB_Port 3306
#RDB_UseSSL 0
#RDB_SSL_Key
#RDB_SSL_Cert
#RDB_SSL_CA
```

Spine poller and max connections
Since in a multi poller setup Spine is highly recommended you will need 
to follow the following calculation when that calculation would be:

```cmd
connections = spine-processes x ( 1 + threads-per-process  + PHP servers )
```

## Remote poller config.php  setup

Now that we have set up the database connections we need to set up the cacti config.php
file on the remote pollers to give them the database info they need to connect to the main poller
we won’t have to edit the main servers config.php file aside from the normal
install procedure to give it access to its local database.
Below is the portion of the config.php that we need to edit to allow the
remote poller to talk to the main server  be sure to remove the #

```bash
$rdatabase_type = 'mysql';
$rdatabase_default = 'cacti';
$rdatabase_hostname = '192.168.1.5;
$rdatabase_username = 'cacti';
$rdatabase_password = 'cacti';
$rdatabase_port = '3306';
$rdatabase_retries = 5;
$rdatabase_ssl = false;
$rdatabase_ssl_key = '';
$rdatabase_ssl_cert = '';
$rdatabase_ssl_ca = '';
```
