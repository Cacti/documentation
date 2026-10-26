# Data Collectors

## Data Collector Background

Cacti can support from one to many **Data Collectors**.  There are two types
of **Data Collectors** they are:

- **Main Data Collector** - This is essentially your core Cacti server
  and database.  The **Main Data Collector** is also referred to as
  the **Primary Server**.
- **Remote Data Collector** - These Data Collectors are located in
  distant locations, or where reaching devices is blocked due to
  firewall or security policies.  The **Remote Data Collectors** are
  also referred to as **Remote Pollers**.

Due to the design of the Cacti **Remote Data Collector**, someone at the
remote site, can actually login to that **Data Collector** and interact
with it as if their **Data Collector** was the **Main Data Collector**.
Additionally, if for some reason the **Main Data Collector** becomes
unavailable due to a WAN outage for example, the data for the **Devices**
it manages will be cached locally until such time as the
**Main Data Collector** is reachable again.

When connectivity returns, the remote collector forwards cached results to the
main collector. This provides continuity during some network outages; it is
not automatic failover of the main server, database, or RRD storage. Size local
storage for the expected outage and monitor the delivery backlog.

Remote collection uses Cacti's built-in [Boost](Boost.md) functionality.
Review its configuration before deploying additional collectors.

Main and remote systems exchange data over the configured web and database
connections. Permit only the required hosts and configured ports, use HTTPS,
and secure database connections according to the installation's policy.
Confirm connectivity in both directions where configuration replication and
remote-agent operations require it. Additional dependencies such as DNS,
SNMP, and device availability checks have their own network requirements.

## Data Collector User Interface

The image below shows the current online collector (aka pollers).  On this page,
we can see the current, average, and max data collection times, the
**Data Collector** processes and threads used, the number of **Devices** as well
as what those **Devices** are polling.  The Actions drop-down allows your to
Enable, Disable, and Delete **Remote Data Collectors**.  There is also a
`Full Sync` option there.  The `Full Sync` option will replicate key Cacti
tables to the selected **Remote Data Collectors** for things like
authentication,
global settings, etc.

In the current Cacti design, you should not have to perform a `Full Sync`
very often.  It would mainly be used to push the user database and global
settings to the remotes, after an outage if there were database changes
during that outage.

![Data Collectors](images/data-collectors.png)

The **Main Data Collector** resides on the central Cacti server.  It also
serves as the master **Data Collector** performing key maintenance operations
for the entire system.

In the edit page below, you can see what options are available when editing the
**Main Data Collector**.  It is important that the hostname used is resolvable
by the **Remote Data Collectors**.

![Data Collectors Edit Main](images/data-collectors-edit-main.png)

When editing the **Remote Data Collector** in the images below, you can see that
it shares many of the settings of the **Main Data Collector** with the addition
of a `TimeZone` setting and MySQL/MariaDB credentials and a `Test Connection`
button.  Generally, these setting are only use during the initial setup
of Cacti, and afterwards for diagnostics only.

![Data Collectors Edit Remote](images/data-collectors-edit-remote1.png)

![Data Collectors Edit Remote Connection Test][ref-1]

## Setup Main Data Collector to accept connections Remotes

Use the same Cacti version on the main and remote systems. Follow
[How To Setup Remote Pollers](How-To-Setup-Remote-Pollers.md), and select
**New Remote Poller** when installing the remote system.

Create a database account restricted to the remote collector's address, using
the account name consistently for both grants. Run the following in an
interactive database administration session after replacing the address and
password placeholders:

```sql
CREATE USER 'cacti_remote'@'192.0.2.20' IDENTIFIED BY 'REPLACE_WITH_UNIQUE_PASSWORD';
GRANT ALL PRIVILEGES ON cacti.* TO 'cacti_remote'@'192.0.2.20';
GRANT SELECT ON mysql.time_zone_name TO 'cacti_remote'@'192.0.2.20';
```

Configure the database listener, firewall, TLS, and host restrictions for your
network. Do not expose database access publicly or grant global privileges.
Use separate accounts where collectors require different access policies.

On the remote system, `include/config.php` uses `$database_*` settings for its
local database and `$rdatabase_*` settings for the main database. Populate the
remote settings during installation using that release's `config.php.dist`.
Verify the main hostname, database name, credentials, port, and TLS settings;
do not copy the main database address into the remote's local database fields.
Protect the configuration file because it contains credentials.

![Remote Data Collector Setup](images/data-collectors-remote-setup.png)

After installation, assign a test device to the collector, run a polling cycle,
and verify both local collection and delivery to the main system. Confirm
that graph timestamps advance before moving additional devices.

[ref-1]: images/data-collectors-edit-remote2.png

---

Copyright (c) 2004-2026 The Cacti Group
