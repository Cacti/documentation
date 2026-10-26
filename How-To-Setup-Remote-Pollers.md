# Remote Poller Setup

Remote Pollers add complexity to your cacti setup while also massively extended
the scalability of it.  Remote Pollers allow system admins to distribute
the load of polling between different servers as well as provide another source
of polling close to a device.

For example you may have a device in Toronto but if your pollers are in New York
the network latency may causes issues with your metrics having a remote poller
in Toronto in this case will help with that issue.

## Setup Instructions

The process of remote poller installation is similar to cacti installation.
In the wizard, select **New Remote Poller**. Use the same version of Cacti
as the primary installation.

With this setup the following layout is assumed

- Main server IP is 192.168.1.5

- Remote poller 1 server IP is 192.168.1.10

- Remote poller 2 servers Ip is 192.168.1.20

## Database Configuration

Each server needs its own local Cacti database, initialized as described in
[Installing Cacti](General-Installing-Instructions.md). The examples below
assume that each database is named `cacti`. Remote pollers connect to the
primary database, and
the primary connects to each remote database for synchronization. These are
two separate connection directions with separate credentials.

Run the following SQL as a database administrator on the specified server.
Replace every example password with a unique secret before running it. The
host portion of each account must match the source address seen by that
database server, which may differ from the addresses below when using NAT.
Use separate `CREATE USER` and `GRANT` statements; do not rely on `GRANT` to
create an account. If an account already exists, review its authentication
and grants instead of recreating it.

On the primary database server (`192.168.1.5`), create accounts for connections
from the two remote pollers:

```sql
CREATE USER 'cacti_remote1'@'192.168.1.10' IDENTIFIED BY 'replace-with-remote1-secret';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_remote1'@'192.168.1.10';
CREATE USER 'cacti_remote2'@'192.168.1.20' IDENTIFIED BY 'replace-with-remote2-secret';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_remote2'@'192.168.1.20';
```

On remote poller 1's database server (`192.168.1.10`), create an account for
connections from the primary:

```sql
CREATE USER 'cacti_sync'@'192.168.1.5' IDENTIFIED BY 'replace-with-sync1-secret';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_sync'@'192.168.1.5';
```

On remote poller 2's database server (`192.168.1.20`):

```sql
CREATE USER 'cacti_sync'@'192.168.1.5' IDENTIFIED BY 'replace-with-sync2-secret';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_sync'@'192.168.1.5';
```

These network accounts do not replace the local database account configured
in each server's `$database_*` settings. Keep the local account's grants and
credentials consistent with the local installation instructions.

Database listeners and firewalls must permit these connections only between
the required servers. Use database TLS or a protected network connection;
do not expose the database port publicly. Configure matching TLS options in
Cacti and Spine when using database TLS.

## Spine configuration

If a remote poller uses Spine, configure its `spine.conf` with both database
connections. `DB_*` points to that poller's local database and must match its
`$database_*` settings. `RDB_*` points to the primary database and must match
its `$rdatabase_*` settings. Use a Spine release compatible with Cacti 1.2.
Protect this file because it contains database credentials.

For remote poller 1, uncomment and set the following primary-connection
entries. Replace the password with the same secret used in its primary
server account. Remote poller 2 uses `cacti_remote2` and its own secret.

```console
RDB_Host 192.168.1.5
RDB_Database cacti
RDB_User cacti_remote1
RDB_Pass replace-with-remote1-secret
RDB_Port 3306
#RDB_UseSSL 0
#RDB_SSL_Key
#RDB_SSL_Cert
#RDB_SSL_CA
```

## Spine poller and max connections

Since in a multi poller setup Spine is highly recommended you will need
to follow the following calculation when that calculation would be:

```console
connections = spine-processes x ( 1 + threads-per-process  + PHP servers )
```

## Remote poller config.php setup

On each remote poller, copy `include/config.php.dist` to `include/config.php`
if the configuration file does not already exist. Do not overwrite an
existing configuration. Keep `$database_*` pointing to that poller's local
database with its local database credentials.

Uncomment the `$rdatabase_*` settings and point them to the primary database.
For remote poller 1, use the account created on the primary for
`192.168.1.10`:

```php
$rdatabase_type = 'mysql';
$rdatabase_default = 'cacti';
$rdatabase_hostname = '192.168.1.5';
$rdatabase_username = 'cacti_remote1';
$rdatabase_password = 'replace-with-remote1-secret';
$rdatabase_port = '3306';
$rdatabase_retries = 5;
$rdatabase_ssl = false;
$rdatabase_ssl_key = '';
$rdatabase_ssl_cert = '';
$rdatabase_ssl_ca = '';
```

For remote poller 2, use `cacti_remote2` and its corresponding password. The
TLS options shown are disabled; enable and configure them when using database
TLS. Leave `$rdatabase_*` commented out on the primary server.

Restrict access to the installer and use HTTPS or a protected local connection
before entering credentials. Select **New Remote Poller** in the web installer
and use **Test Connection** to check the primary database connection. Cacti
1.2.31 requires `include/config.php` to be writable by the web server during
remote installation so it can save the assigned `$poller_id`. Afterwards,
remove web-server write access while retaining read access. Do not assign
poller IDs from the example numbering above: the primary uses ID `1`, and the
installer obtains the remote poller's ID from the primary database.

After installation, edit each remote Data Collector on the primary server.
Under **Remote Database Connection**, set its reachable database hostname,
database name, port and synchronization credentials. For remote poller 1,
use hostname `192.168.1.10`, database `cacti`, user `cacti_sync` and the
`replace-with-sync1-secret` value you replaced earlier. For remote poller 2,
use `192.168.1.20` and its own synchronization password. Do not use `localhost`
here: the primary must connect to the remote database. Use **Test Connection**
to verify this reverse connection as well.

## Scheduled polling

Complete installation and both connection checks before starting scheduled
polling on a remote poller. Configure one scheduler per server, either cron
or `cactid.service`, using that server's installation path and poller account.
Do not run both. Match the **Cron/Daemon Interval** in Settings > Poller;
this is separate from the data-source polling interval, which can be shorter.
See the scheduler examples in the
[Ubuntu/Debian guide](Installing-Under-Ubuntu-Debian.md#schedule-polling)
or the relevant platform installation guide.

## References

- [Cacti 1.2.31 configuration example][cacti-config]
- [Cacti 1.2.31 remote installation checks][cacti-installer]
- [Spine 1.2.31 database configuration example][spine-config]
- [MySQL CREATE USER][mysql-create-user]
- [MariaDB CREATE USER][mariadb-create-user]

[cacti-config]:<https://github.com/Cacti/cacti/blob/release/1.2.31/include/config.php.dist>
[cacti-installer]:<https://github.com/Cacti/cacti/blob/release/1.2.31/lib/installer.php#L2173-L2207>
[spine-config]:<https://github.com/Cacti/spine/blob/release/1.2.31/spine.conf.dist>
[mysql-create-user]:<https://dev.mysql.com/doc/refman/8.0/en/create-user.html>
[mariadb-create-user]:<https://mariadb.com/docs/server/reference/sql-statements/account-management-sql-statements/create-user>

---

Copyright (c) 2004-2026 The Cacti Group
