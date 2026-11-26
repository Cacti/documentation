# FlowView

FlowView collects network flow data (NetFlow v5, v9, and IPFIX) inside Cacti
and reports on it. A collector service receives the flow packets on UDP
listeners and stores them in partitioned database tables. Administrators then
define saved filters, view the results as a table or as charts, and send
scheduled reports by e-mail. It is for network and operations teams that want
to see which hosts, ports, protocols, interfaces, and autonomous systems use
their bandwidth.

This page follows the plugin's `develop` branch, which is unreleased and can
change. The branch declares version 5.1 and Cacti compatibility 1.2.29 in its
`INFO` file. It is not presented here as a released version.

## Requirements

- Cacti 1.2.29 or later, as declared in `INFO` (version 5.1).
- No other plugins are required. The **Notification List** option on schedules
  needs the Thold plugin.
- A database account for the FlowView tables. FlowView can use the Cacti
  database or a separate database (see Installation). The plugin README states
  MariaDB 10.5 or later, or MySQL 8.0 or later. Raw flow tables use the Aria
  engine when the server supports it; MySQL has no Aria engine, so the plugin
  falls back to MyISAM there.
- PHP: the `sockets` extension (the collector creates UDP sockets), `curl`, and
  the `pcntl` and `posix` functions for process control. The code checks for
  `pcntl` and `posix` before using them.
- The `ss` command, which Cacti uses to check whether a listener port is open.
- Optional: the `whois` binary (the **Whois Binary Path** setting) to find
  autonomous system numbers, and `wget` for the daily Internet Route Registry
  download.
- A service on the Cacti server that runs the collector (init script or systemd
  unit, see Installation).

The plugin no longer needs `flow-tools` or Open Flash Charts. Collection and
reporting are done in PHP with the charting that Cacti already provides.

## Installation

Follow [Plugin Management](Plugins.md) for the generic steps. In addition:

1. Copy the plugin to `plugins/flowview` in the Cacti directory.
2. Copy `config.php.dist` to `config.php` and set the database connection. With
   `$flowview_use_cacti_db = true` (the default in the file), FlowView uses the
   Cacti database. Set it to `false` and fill in the `$flowviewdb_*` values to
   use a separate database. If a `config_local.php` file exists, FlowView uses
   it instead of `config.php`. Without a configuration file, installation
   stops with an error message.
3. Install and enable the plugin.
4. Set partitioning and retention under **Console > Configuration > Settings**
   on the **Flowview** tab before flows arrive.
5. Add at least one listener under **Console > FlowView > Listeners**.
6. Install the collector service from the `service` directory and start it.

The `service` directory contains:

- `flow-capture`, an init.d script for Linux.
- `flow-capture.service`, a systemd unit for Linux.
- `flow-capture-freebsd` and `cacti-flow-capture`, for FreeBSD.

Edit the file for your system so that the Cacti base path and the account match
the account that runs the web server, then enable and start the service. The
service does not start unless at least one listener exists, and it must be
restarted whenever a listener is added or removed. After a plugin upgrade,
restart it so that it runs the new collector code. The plugin's own tables are
upgraded in the background by `flowview_upgrade.php` on the next console page
load.

The collector is `flow_collector.php`. It detects NetFlow v5, v9, and IPFIX
streams automatically, so several versions can arrive on the same port. For a
busy listener, add more listeners to spread the load. If you replicate the
database with Galera, note that Aria tables are not replicated by default; see
the plugin README. The README also describes optional MaxScale based sharding.

Uninstalling the plugin drops all tables whose names start with
`plugin_flowview` or `parallel_database`, which deletes the collected flow data.

## Permissions

| Realm | Pages |
| --- | --- |
| **NetFlow User** | `flowview.php` |
| **NetFlow Admin** | `flowview_devices.php`, `flowview_schedules.php`, `flowview_filters.php`, `flowview_databases.php` |

Grant realms in the user or group permissions. When the Cacti version supports
roles, the plugin adds `flowview.php` to the **Normal User** role and the admin
pages (except the databases page) to the **System Administration** role.

## Settings

Most settings are on the **Flowview** tab of **Console > Configuration >
Settings**. Two related settings are on other tabs.

### Name Resolution

| Setting | Default | Purpose |
| --- | --- | --- |
| **Hostname Resolution** | Use Local Server | **Use Local Server**, **Use DNS Servers under Mail/Reporting/DNS**, or **Don't Resolve DNS**. |
| **Download the Internet Registry Daily** | unset | Once a day, download Internet Route Registry data. The description warns that this creates a database of over 3 GBytes. |
| **Local Domain Name** | mydomain.net | Suffix appended to local IPv4 addresses that do not resolve. |
| **Local IP Range** | 192.168.1.0/24 | Your local network, in CIDR or non-CIDR form, mapped to the local domain. |
| **Use Arin to find Domains and AS Numbers** | on | Look up unresolved addresses through ARIN. |
| **Whois Provider Host** | whois.radb.net | Host for whois calls. If set, the `whois` binary must be available. |
| **Whois Binary Path** | /usr/bin/whois | Path of the `whois` binary, used to supplement ARIN for AS information. |

### Graph Drilldown Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **Default Search Filter for Graph Drilldowns** | none | The FlowView filter that the NetFlow icon on graph pages opens. |

### Data Retention and Report Generation

| Setting | Default | Purpose |
| --- | --- | --- |
| **Format File to Use** | default.format | HTML wrapper and CSS for report e-mail. A format file that contains more than CSS must contain a `<REPORT>` tag. |
| **Data Retention Policy** | 1 Month (30 days) | How long partitioned flow tables are kept. Choices run from 1 week to 1 year. |
| **Database Partitioning Scheme** | Hourly | **Daily** or **Hourly** raw tables. Use more tables per day for higher flow rates. |
| **Storage Engine for Raw Tables** | Aria, or MyISAM without Aria | The live raw table always uses InnoDB. |

### Parallel Queries

| Setting | Default | Purpose |
| --- | --- | --- |
| **Parallel Query Backend** | Legacy PHP Runner | **Legacy PHP Runner** forks `flowview_runner.php` per query and shard. **FlowView Query Service** uses a separate Go service shipped in the plugin's `service/flowview-query` directory. |
| **Query Service URL** | empty | Base URL of the query service. Empty discovers the port from the port file. |
| **Query Service Port File** | /var/run/flowview/flowview-query.port | File where the service writes its address. |
| **Query Service Token** | empty | Optional shared secret that Cacti sends as a bearer header. |
| **Max Concurrent Threads** | 4 Threads | Threads for FlowView queries, at most one per partition. **Disabled** turns parallel queries off. |
| **Maximum Run Time** | 5 Minutes | The parallel query exits when it exceeds this time. |
| **Cached Data Time to Live** | 6 Hours | How long cached query results are held. |

### MaxScale Sharding

| Setting | Default | Purpose |
| --- | --- | --- |
| **Leverage MaxScale to Distribute Query Shards** | unset | Distribute parallel queries to several MariaDB back ends through MaxScale. |
| **MaxScale Read-Write Split Port** | 3307 | Port of the `readwrite` service and router. |

### Settings on other tabs

| Tab | Setting | Default | Purpose |
| --- | --- | --- | --- |
| **Poller** | **Report Concurrent Processes (FlowView Only)** | 1 Process | Maximum scheduled report processes that run at once. |
| **Mail/Reporting/DNS** | **Internet Proxy Address**, **Internet Proxy User**, **Internet Proxy Password** | empty | Proxy for Cacti services and plugins that need internet access (`IP:PORT`). |

When a change affects settings the collector reads (partitioning, DNS method,
DNS servers, from e-mail, the ARIN, domain, and IP range options), the plugin
sends SIGHUP to the running collector so that it reloads them.

## Using FlowView

The **FlowView** tab in the Cacti header opens the Flow Viewer. The
administration pages are under the **FlowView** heading in the console menu
(placed after **Import/Export**): **Listeners**, **Filters**, **Schedules**, and
**Databases**.

### Listeners

**Console > FlowView > Listeners** is titled **FlowView Listeners**. The
following example uses synthetic data.

![FlowView Listeners with three synthetic listeners][listeners]

Columns include **Name**, **Method**, **Bind address**, **Allowed From**,
**Port**, **Protocol**, **Status**, **Observed Listen**, **Backlog**,
**Streams**, **Stream Versions**, and **Last Updated**. Select listeners and
choose **Delete**, **Enable**, or **Disable**.

A listener has these fields:

| Field | Default | Purpose |
| --- | --- | --- |
| **Listener Name** | none | Display name. |
| **Bind to address** | 0.0.0.0 | Interface address to listen on. |
| **Allowed Host Range** | 0.0.0.0 | Exporting devices that may send. Accepts CIDR, ranges, or comma separated addresses. |
| **Port** | 2055 | UDP port to listen on. |
| **Protocol** | UDP | Only UDP is offered. |
| **Enabled** | unset | When checked, the collector waits for data on this listener. |

The listener edit page also shows the inbound streams with their status,
version, and templates, and the templates the listener detected.

To add a listener:

1. Open **Console > FlowView > Listeners** and click **+**.
2. Enter a **Listener Name**, the **Port** your devices send to, and an
   **Allowed Host Range** if you want to filter senders.
3. Check **Enabled** and save.
4. Restart the collector service.

### Filters

A filter is a saved report definition. **Console > FlowView > Filters** (titled
**FlowView Filters**) lists them. If no listener exists yet, the title reads
**FlowView Filters [ Add Devices before Filters ]**.

![FlowView Filters list with three synthetic filters][filters]

Columns are **Filter Name**, **ID**, **Materialization**, **Listener**,
**Report Type**, **NAT Shards**, **Non-NAT Shards**, **Partitions**, **Sort
Field**, and **Resolution**. Actions are **Delete**, **Disable**, **Enable**,
and **Materialize**. The **Prune** button removes cached results that match no
filter, after confirmation.

The filter editor groups its fields as **General Filters** (**Filter**,
**Listener**, **Flow Template ID**, **Stream Address**, **Presets**),
**Detailed Filter Criteria** (**Report Type**, **Statistical Report** or
**Printed Report**, **Range Rules**, **Resolve IP's**, **Sort Field**,
**Maximum Rows**, **Minimum Bytes**), **Charting Options** (**Graph Type**,
**Graph Height**, **Use NAT Data**, and the **Table**, **Bytes**, **Packets**,
and **Flows** panels), and **Protocol Filters** (protocols, TCP flags, TOS
fields, source and destination IP, ports, interface, and AS, and post-NAT
address and port).

Statistical reports include Summary, root domains, ports, IP addresses, IP
protocol, interfaces, autonomous systems, IP ToS, and prefixes, each by source,
destination, or both where applicable. Printed reports are **Flow Times**,
**Source/Destination IPs and Ports**, **AS Numbers**, **132 Columns**, and
**Show IP Accounting Emulation**.

### Flow Viewer

Open the **FlowView** tab, choose a **Filter**, and click **Go**. The page
buttons are **Go**, **Clear**, **Edit**, **New**, **Save**, **Save As**,
**Rename**, **Delete**, and **Export** (raw data). You can override a filter's
sort field, lines, timespan (including a custom **From** and **To**), graph
type (**Bar**, **Pie**, or **Treemap**), and height, and show or hide the
**Table**, **Bytes**, **Packets**, and **Flows** panels. **Use NAT Data**
switches between pre-NAT and post-NAT values.

To report on a conversation:

1. Open the **FlowView** tab.
2. Select a saved filter, or click **New** to build one.
3. Adjust the timespan and any overrides.
4. Click **Go**.
5. Click **Save** to keep the changes, or **Save As** to store a copy.

### Schedules

**Console > FlowView > Schedules** (**FlowView Schedules**) lists scheduled
reports. Columns are **Report Title**, **Filter Name**, **Interval**,
**Last Sent**, **Next Send**, **Email/List**, **Logged Sends**, and
**Enabled**. Actions are **Send Now**, **Delete**, **Disable**, and **Enable**.

| Field | Default | Purpose |
| --- | --- | --- |
| **Title** | New Schedule | Report title. |
| **Enabled** | on | Whether the report is sent. |
| **Filter Name** | none | The filter to run. |
| **Send Interval** | none | From every hour up to every month. |
| **Scheduled Base Time** | current time | First send time. Later sends are calculated from it and the interval. |
| **Max Allowed Runtime** | 60 | How long the report may run before it exits. |
| **Email Addresses** | none | Comma separated recipients (legacy e-mail settings). |
| **Format File to Use** | the global setting | HTML wrapper for this report. |
| **Notification List** | none | A Thold notification list, if Thold is installed. |

The schedule's log tab shows past sends, with options to view or download a
report.

### Databases

**Console > FlowView > Databases** has tabs for the **DNS Cache**,
**CIDR/Routes**, and the Internet Route Registry tables (for example
**Autonomous Numbers** and **AS Blocks**). On the DNS cache tab you can delete
selected entries or purge the cache, which refills as records arrive.

### Graph buttons

On the graph view pages, a **NetFlow** icon appears next to graphs of devices
that FlowView can match to a listener stream. It opens the filter selected in
**Default Search Filter for Graph Drilldowns**.

## Background Processing

FlowView does its work in two places.

The collector service (`flow_collector.php`, one process per listener) receives
flows, resolves domain names, and writes them to the raw flow tables. Streams
update their status every 5 minutes.

The plugin's `poller_bottom` hook deletes expired DNS cache entries and starts
`flowview_process.php` in the background with the **PHP Binary Path** setting.
Each cycle that script:

- queues scheduled reports that are due (they run through `run_schedule.php`),
- counts new flow records,
- converts partitions that have rotated to the configured storage engine,
- removes expired parallel query results,
- materializes partitions that rotated since the last cycle for every filter,
  with NAT on and off, and
- logs a `FLOWVIEW STATS` line with the run time, listener count, new records,
  and schedule count.

At the first run after midnight it also performs table maintenance: it drops raw
tables older than **Data Retention Policy**, removes cached shards whose tables
are gone, deletes FlowView entries from the report log older than the
retention, and, if **Download the Internet Registry Daily** is on, refreshes the
registry data.

Raw flow tables, the DNS cache, and the parallel query cache are the tables
that grow. Retention is controlled only by **Data Retention Policy**.

### Materialization

Materialization pre-computes a filter's results for each flow partition so
that reports over older data open quickly. The partition still receiving flows
is never cached. Start it from **Filters** with the **Materialize** action, or
from the command line. The **Materialization** column shows **Required**,
**Running**, or **Up to date**. Saving a filter in a way that changes the data
it materializes shows a warning dialog first.

## Command-Line Tools

Run these from the Cacti directory as the poller user, for example
`php plugins/flowview/cli/materialize_queries.php`.

```console
php plugins/flowview/cli/materialize_queries.php [--query-id=ID[,ID...]]
    [--partitions=TABLE[,TABLE...]] [--nat=on|off] [--dry-run] [--status]
    [--force] [--debug]
php plugins/flowview/flow_collector.php --listener-id=ID [--debug]
php plugins/flowview/run_schedule.php --schedule=ID [--force] [--debug]
php plugins/flowview/flowview_bulkarin.php [--proceed] [--ips] [--origins]
php plugins/flowview/flowview_upgrade_nat_columns.php [--dry-run]
php plugins/flowview/flowview_upgrade.php [--forcever=VERSION]
php plugins/flowview/flowview_cleanup.php [--proceed]
php plugins/flowview/flowview_drop_raw_tables.php [--proceed]
```

| Script | Purpose |
| --- | --- |
| `cli/materialize_queries.php` | Materializes each filter into the parallel query cache for every rotated partition, with NAT on and off. `--dry-run` lists the work, `--status` lists running parallel queries, `--force` runs even if a filter is already being materialized. |
| `flow_collector.php` | The collector for one listener. Normally started by the service. |
| `run_schedule.php` | Runs one scheduled report and sends it. `--force` runs even if another run is active. |
| `flowview_bulkarin.php` | Bulk resolves unverified ARIN details and finds the origin AS through whois. Requires `--proceed`. |
| `flowview_upgrade_nat_columns.php` | Adds the post-NAT columns to older raw partition tables. Safe to re-run. |
| `flowview_upgrade.php` | Command-line database upgrade. `--forcever` sets the starting version. |
| `flowview_cleanup.php` | Developer tool: kills lingering parallel queries and purges the cache. Requires `--proceed` and a super user. |
| `flowview_drop_raw_tables.php` | Developer tool: drops the raw tables. Requires `--proceed` and a super user. |
| `cli/import_flows.php` | Imports flow data from older releases. |
| `cli/repair_tables.php` | Resizes columns in the raw tables to current sizes. |
| `cli/fixprivate.php` | Repairs the domain of flows with certain private addresses. |

`flowview_cleanup.php` and `flowview_drop_raw_tables.php` delete data. Do not
run them on a production system.

## Troubleshooting

- **Installation stops asking for a configuration file:** copy
  `config.php.dist` to `config.php` and set the database values first.
- **No flows arrive:** confirm that a listener exists and is enabled, that the
  collector service is running, and that you restarted it after changing
  listeners. The **Status**, **Observed Listen**, and **Streams** columns on
  the listeners page show what the server observes on the port.
- **A second collector will not start:** the collector exits with `Process
  already running`.
- **Unresolved addresses:** if the Cacti server cannot reach ARIN, those
  addresses stay unresolved.
- **Whois lookups fail:** `flowview_bulkarin.php` stops with `Whois binary path
  not provided or no whois provider specified` when the whois settings are
  empty.
- **A filter will not materialize:** a filter that is already being
  materialized is skipped, and the page reports it. Results are written to the
  Cacti log.
- **Prune does nothing:** it stops when the cache keys of a filter cannot be
  worked out; check that each filter has a valid report.
- **Post-NAT data is missing for old partitions:** run
  `flowview_upgrade_nat_columns.php`.
- **Queries on older data are slow:** run `cli/materialize_queries.php`, and
  make sure **Max Concurrent Threads** is 2 or more.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_flowview)
- [Plugin README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[listeners]: images/plugin-flowview-listeners.png
[filters]: images/plugin-flowview-filters.png
[readme]: https://github.com/Cacti/plugin_flowview/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
