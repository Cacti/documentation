# Remote Poller Setup

Remote Pollers add complexity to your Cacti setup while also massively extending
the scalability of it.  Remote Pollers allow system admins to distribute
the load of polling between different servers as well as provide another source
of polling close to a device.

For example, you may have a device in Toronto, but if your pollers are in New
York the network latency may cause issues with your metrics. Having a remote
poller in Toronto in this case will help with that issue.

## Setup Instructions

The process of remote poller installation is similar to Cacti installation.
In the wizard, select the installation type for Remote poller. For the remote
poller you must use the same version of Cacti as the main poller installation.

With this setup the following layout is assumed:

- Main server IP is 192.168.1.5

- Remote poller 1 server IP is 192.168.1.10

- Remote poller 2 server's IP is 192.168.1.20

## Database Configuration

> **Security**: The username `cacti` and password `cacti` shown in the examples
> below are placeholders. Use a strong, randomly generated password in
> production. Never use the literal string `cacti` as a database password on
> any reachable system.

Each server will have its own local database; however, the remote pollers
will need to talk back to the main poller, so we must allow the remote servers'
user account to connect back to the main poller's database via the network.

Main server database config

```sql
CREATE USER 'cacti'@'192.168.1.10' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.10';
CREATE USER 'cacti'@'192.168.1.20' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.20';
FLUSH PRIVILEGES;
```

Remote poller 1 database configuration

```sql
CREATE USER 'cacti'@'192.168.1.5' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.5';
FLUSH PRIVILEGES;
```

Remote poller 2 database configuration

```sql
CREATE USER 'cacti'@'192.168.1.5' IDENTIFIED BY 'strongpassword';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti'@'192.168.1.5';
FLUSH PRIVILEGES;
```

We have also let the main poller talk to the remote pollers to keep them in sync.

## Spine configuration

When you have set up multiple pollers while using Spine you will need to also
configure the spine.conf file to connect to the remote database as well.

Be sure to remove the # next to the below entries

```console
RDB_Host     192.168.1.5
RDB_Database cacti
RDB_User     cacti
RDB_Pass     strongpassword
RDB_Port     3306
```

If the network between pollers and the main server is not fully trusted,
enable SSL for the remote database connection:

```console
RDB_UseSSL 1
RDB_SSL_Key  /etc/cacti/ssl/client.key
RDB_SSL_Cert /etc/cacti/ssl/client.crt
RDB_SSL_CA   /etc/cacti/ssl/ca.crt
```

## Spine poller and max connections

Since Spine is highly recommended in a multi-poller setup, you will need
to follow this calculation for the number of connections:

```console
connections = spine-processes x ( 1 + threads-per-process  + PHP servers )
```

## Remote poller config.php setup

Now that we have set up the database connections, we need to set up the Cacti
config.php file on the remote pollers to give them the database info they need
to connect to the main poller. We won’t have to edit the main server's
config.php file aside from the normal install procedure to give it access to its
local database. Below is the portion of the config.php that we need to edit to
allow the remote poller to talk to the main server. Be sure to remove the hash
sign (#).

```console
$rdatabase_type = 'mysql';
$rdatabase_default = 'cacti';
$rdatabase_hostname = '192.168.1.5';
$rdatabase_username = 'cacti';
$rdatabase_password = 'strongpassword';
$rdatabase_port = '3306';
$rdatabase_retries = 5;
$rdatabase_ssl = false;
$rdatabase_ssl_key = '';
$rdatabase_ssl_cert = '';
$rdatabase_ssl_ca = '';
$rdatabase_ssl_capath = '';
$rdatabase_ssl_verify_server_cert = true;
```

---
Copyright (c) 2004-2026 The Cacti Group
