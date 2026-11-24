# FlowView

The FlowView plugin receives NetFlow v5, v9 and IPFIX flow records directly
from your routers and switches, stores them in the Cacti database or a
separate database, and lets you query them from inside Cacti. Results can be
shown as a table or as bar, pie or treemap charts, exported to CSV, and sent
as scheduled e-mail reports. Network administrators who want to see which
hosts, ports, protocols and autonomous systems account for traffic on a link
use it alongside Cacti's interface graphs.

## Requirements

- This page documents FlowView 4.9 (release tag `v4.9`).

- Cacti 1.2.28 or later (INFO `compat`).

- No other plugin is required. The **Notification List** option of a
  schedule is only populated when the Thold plugin is installed.

- The release README states that MariaDB 10.5 or later, or MySQL 8.0 or
  later, is required. MySQL has no Aria storage engine, so raw tables use
  MyISAM or InnoDB there.

- PHP with the `sockets` extension, which the flow collector uses to receive
  flow packets, and the `posix` extension, which is used to signal the
  collector service when relevant settings change. The `curl` extension is
  needed to download the Internet Routing Registry databases and to query
  ARIN.

- The `ss` utility, or `netstat` as a fallback, which the **Listeners** page
  uses to show whether each listener port is open.

- The `whois` binary, if you use the **Whois Provider Host** setting.

## Installation

Install the plugin as described in [Plugin Management](Plugins.md). The
plugin directory must be named `flowview`. In addition:

1. Copy `config.php.dist` to `config.php` in the plugin directory. With the
   default `$flowview_use_cacti_db = true;` the flow tables are created in the
   Cacti database. To use a separate database, set it to `false` and fill in
   the `$flowviewdb_*` connection values.

2. Install and enable the plugin from **Console > Configuration > Plugins**.

3. Review the partitioning and retention settings under
   **Console > Configuration > Settings > Flowview** before flow data starts
   to arrive.

4. Configure your network devices to export flows to the Cacti server, then
   add a listener for each port under **Console > FlowView > Listeners**.

5. Install the flow capture service from the plugin's `service` directory.
   The directory contains `flow-capture` for init.d systems,
   `flow-capture.service` for systemd, and `flow-capture-freebsd` with
   `cacti-flow-capture` for FreeBSD. For systemd, copy the unit file to
   `/etc/systemd/system`, edit the path to the `flow-capture` script and the
   `User=` line so the service runs as the web server account, then run:

   ```console
   systemctl daemon-reload
   systemctl enable flow-capture
   systemctl start flow-capture
   systemctl status flow-capture
   ```

The service does not start unless at least one listener exists. Restart it
whenever you add or remove a listener.

## Permissions

The plugin registers two realms. Grant them under
**Console > Configuration > Users** or **User Groups**.

###### Table 1. FlowView realms

| Realm         | Pages                                                                                          |
| ------------- | ---------------------------------------------------------------------------------------------- |
| NetFlow User  | `flowview.php` (the **FlowView** tab)                                                          |
| NetFlow Admin | `flowview_devices.php`, `flowview_schedules.php`, `flowview_filters.php`, `flowview_databases.php` |

## Settings

Most settings are on **Console > Configuration > Settings > Flowview**, in
five collapsible sections. Changing **Database Partitioning Scheme**,
**Hostname Resolution**, **Use Arin to find Domains and AS Numbers**,
**Local Domain Name** or **Local IP Range** signals the running flow capture
service to reload.

###### Table 2. Name Resolution

| Label                                   | Default          | Purpose                                                                                                                        |
| --------------------------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Hostname Resolution                     | Use Local Server | How to resolve hostnames: **Use Local Server**, **Use DNS Servers under Mail/Reporting/DNS**, or **Don't Resolve DNS**.          |
| Local Domain Name                       | `mydomain.net`   | Suffix appended to local IPv4 addresses that do not resolve.                                                                   |
| Local IP Range                          | `192.168.1.0/24` | The local IPv4 range, CIDR or non-CIDR, whose unresolved hosts are mapped to the **Local Domain Name**.                         |
| Use Arin to find Domains and AS Numbers | Checked          | Query ARIN for the owner of addresses that do not resolve through DNS. Requires Internet access.                              |
| Whois Provider Host                     | `whois.radb.net` | Host used for whois lookups. If not empty, the `whois` binary must be in the system path.                                     |
| Whois Binary Path                       | `/usr/bin/whois` | Path to the `whois` binary, used to find AS information that supplements ARIN.                                                 |

###### Table 3. Graph Drilldown, Data Retention and Report Generation

| Label                                     | Default             | Purpose                                                                                                   |
| ----------------------------------------- | ------------------- | --------------------------------------------------------------------------------------------------------- |
| Default Search Filter for Graph Drilldowns | None                | A saved FlowView filter to use for graph drilldowns. If unset, the first saved filter is stored here.    |
| Format File to Use                        | `default.format`    | The HTML and CSS wrapper used for e-mailed reports.                                                       |
| Data Retention Policy                     | 1 Month             | How long the partitioned flow tables are kept, from 1 week to 1 year.                                    |
| Database Partitioning Scheme              | Hourly              | Create one raw table per day (**Daily**) or per hour (**Hourly**).                                       |
| Storage Engine for Raw Tables             | Aria, or MyISAM     | Engine for raw tables other than the live one, which is always InnoDB. Aria is offered when the server supports it. |

###### Table 4. Parallel Queries and MaxScale Sharding

| Label                                         | Default   | Purpose                                                                                              |
| --------------------------------------------- | --------- | ---------------------------------------------------------------------------------------------------- |
| Max Concurrent Threads                        | 4 Threads | Maximum threads dispatched to run a query, at most one per table partition. **Disabled** runs one.   |
| Maximum Run Time                              | 5 Minutes | A parallel query that does not finish in this time exits.                                            |
| Cached Data Time to Live                      | 6 Hours   | How long cached query results are kept before they are purged.                                      |
| Leverage MaxScale to Distribute Query Shards  | Unchecked | Distribute parallel queries to several MariaDB backend servers through MaxScale.                     |
| MaxScale Read-Write Split Port                | `3307`    | Port of the MaxScale read-write split service.                                                       |

The plugin also adds settings to two core tabs. On
**Console > Configuration > Settings > Mail/Reporting/DNS** it adds an
**Internet Proxy Settings** section with **Internet Proxy Address**,
**Internet Proxy User** and **Internet Proxy Password**, used when the plugin
downloads routing registry data. If the core **Poller** tab does not already
have it, the plugin adds **Report Concurrent Processes (FlowView Only)**,
default 1, the maximum number of report processes that run at once, next to
the report timeout setting. A sample MaxScale configuration is in
`maxscale/maxscale.cnf` in the plugin directory.

## Using FlowView

### Listeners

A listener is a UDP port on which the Cacti server accepts flow packets. Go
to **Console > FlowView > Listeners** and click the add icon.

###### Table 5. Listener fields

| Label              | Default | Purpose                                                                                                                                    |
| ------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Listener Name      |         | Name shown in the interface.                                                                                                               |
| Allowed Host Range | `0`     | Addresses allowed to send to this listener. `0` allows any host. Accepts a single address, CIDR or range syntax, or a comma-separated list. |
| Port               | `2055`  | Port the collector listens on.                                                                                                             |
| Protocol           | UDP     | The only protocol offered in this release.                                                                                                 |
| Enabled            |         | When checked, the service starts a collector for this listener.                                                                           |

The list shows each listener's **Status**, **Observed Listen**,
**Backlog**, **Streams** and **Stream Versions**. Opening a listener shows
the **Inbound Streams and Status** table, one row per exporting device, and
the **Listener Detected Templates** received from v9 and IPFIX exporters.
The collector detects v5, v9 and IPFIX automatically, so different versions
can arrive on the same port.

The following screenshot shows the **FlowView Listeners** list with three test
listeners, their allowed source addresses, ports, status and stream counts.

![FlowView Listeners list with three UDP listeners, two down and one
disabled, showing port, protocol, status and stream
columns](images/plugin-flowview-listeners.png)

### Viewing flow data

Click the **FlowView** tab. The filter bar at the top of the page selects
what to show:

- **Filter**, **Listener** and **Stream** choose a saved filter and the data
  source.

- **Report** picks one of the statistical reports, such as **Source IP**,
  **UDP/TCP Destination Port**, **IP Protocol** or **Source AS**, or one of the
  printed reports, such as **Flow Times** or **AS Numbers**.

- **Sort Field**, **Lines**, **Exclude** and **Octets** limit and order the
  rows. **Domains/Hostnames Only** restricts the charts to domain names.

- **Timespan**, **From** and **To** set the time range, with buttons to shift
  it backward and forward.

- **Graph** selects **Bar**, **Pie** or **Treemap**, **Height** sets the chart
  height, and **Show/Hide** toggles the **Table**, **Bytes**, **Packets** and
  **Flows** panels.

The **New**, **Edit**, **Save**, **Save As**, **Rename** and **Delete**
buttons manage saved filters from the same page, and **Export** downloads the
raw result rows as `flowview_data.csv`. A filter that is used by a schedule
cannot be deleted.

### Filters

**Console > FlowView > Filters** lists the saved filters with their listener,
report type, sort field and resolution setting, and can delete, enable or
disable them. The filter editor has four sections:

- **General Filters**: **Filter** name, **Listener**, **Flow Template ID**
  (v9 and IPFIX only), **Stream Address** and **Presets** for a predefined
  timespan.

- **Detailed Filter Criteria**: **Report Type**, **Statistical Report**,
  **Printed Report**, **Range Rules**, **Resolve IP's**, **Sort Field**,
  **Maximum Rows** (default 20) and **Minimum Bytes**.

- **Charting Options**: **Graph Type**, **Graph Height** and the
  **Table Panel**, **Bytes Panel**, **Packets Panel** and **Flows Panel**
  defaults.

- **Protocol Filters**: **Protocols**, **TCP Flags**, **TOS Fields**, and
  source and destination **IP**, **Ports**, **Interface** and **AS** fields.
  Address fields accept comma-separated IPv4 or IPv6 addresses or CIDR ranges.

**Range Rules** controls which flows match the time range:
**Any Part in Range (slow)**, **End Time in Range (fast)**, which is the
default, **Start Time in Range (fast)** or **Entirely in Range (slow)**.

### Scheduled reports

To e-mail a filter's results on a schedule:

1. Go to **Console > FlowView > Schedules** and click the add icon. A filter
   must exist first.

2. Enter a **Title**, leave **Enabled** checked and choose the
   **Filter Name**.

3. Choose a **Send Interval**, from **Every Hour** to **Every Month**, and set
   **Scheduled Base Time**, the first time the report is sent. Later reports
   are calculated from this time plus the interval.

4. Set **Max Allowed Runtime**, default 1 minute.

5. Enter **Email Addresses** and a **Format File to Use**, or select a
   **Notification List** if the Thold plugin is installed.

6. Click **Save**.

### Databases

**Console > FlowView > Databases** has tabs for the **DNS Cache**, where you
can view, filter and purge cached name resolutions, **CIDR/Routes**, and the
Internet Routing Registry objects the plugin downloads, such as
**Autonomous Numbers**, **AS Sets**, **Domains** and **Organizations**.

### Graph drilldown

On the **Graphs** page, the plugin adds a FlowView button to graphs of
Devices whose hostname or description matches the address of a flow stream.
The button opens the flow data for that stream. No button is shown until at
least one filter has been saved; if
**Default Search Filter for Graph Drilldowns** is empty, the first saved
filter is stored in that setting.

## How It Collects Data

The flow capture service starts one `flow_collector.php` process per enabled
listener and restarts collectors that stop. Each collector binds its UDP port
and writes records into raw tables named `plugin_flowview_raw_` followed by
the year and day of the year, plus the hour when **Hourly** partitioning is
selected. The newest raw table is InnoDB; the poller converts older tables to
the **Storage Engine for Raw Tables**.

On every Cacti polling cycle the `poller_bottom` hook removes expired DNS
cache entries and starts `flowview_process.php` in the background. That
script:

- queues enabled schedules that are due as Cacti reports and starts
  `run_schedule.php` to run them;

- counts new flow records and expires cached parallel query results;

- once a day, at the first run after midnight, or when run with `--maint`,
  drops raw tables older than **Data Retention Policy**, removes stale cache
  entries and old FlowView report log entries, and downloads updated
  Internet Routing Registry databases.

The raw tables are what grow. Their size depends on flow volume and the
retention period.

## Command-Line Tools

Run these as the web server user from the Cacti base directory, unless noted.

`flowview_process.php` is started by the poller. Run it by hand to force table
maintenance or see debug output:

```console
php plugins/flowview/flowview_process.php [--maint] [--debug]
```

`flow_collector.php` is the per-listener collector that the service starts.
Run it in the foreground to debug one listener:

```console
php plugins/flowview/flow_collector.php --listener-id=ID [--debug]
```

`run_schedule.php` runs one schedule. `--force` runs it even if another run
is in progress:

```console
php plugins/flowview/run_schedule.php --schedule=ID [--force] [--debug]
```

`flowview_bulkarin.php` resolves unverified ARIN details in bulk and, with
`--origins`, looks up origin AS numbers through whois. It requires `--proceed`
and the **Use Arin to find Domains and AS Numbers** setting. Run it from the
plugin directory:

```console
cd plugins/flowview
php flowview_bulkarin.php --proceed [--ips] [--origins]
```

`import_flows.php` imports flow files saved by earlier FlowView versions
that used flow-tools. Run it from the plugin directory once, after setting
the partitioning scheme and checking free database space:

```console
cd plugins/flowview
php import_flows.php
```

`flowview_cleanup.php` and `flowview_drop_raw_tables.php` take `--proceed`.
Their help describes them as tools for developers who wish to reset their
database: the first stops running parallel queries and the second drops the
raw tables.

## Troubleshooting

- If the flow capture service will not start, check that at least one
  listener exists, and restart the service after adding or removing one.

- The **Status** column on the **Listeners** page is read from the output of
  `ss`, or `netstat` as a fallback. Install `ss` as the release README
  requires.

- `flow_collector.php` exits with `FATAL: Process already running` if a
  collector for that listener is already running, so stop the service before
  running a collector by hand.

- `Unable to query Databases ensure php-curl is installed` in the Cacti log
  means the PHP `curl` extension is missing, so the routing registry
  downloads fail.

- `FATAL Can not connect to the flowview database` means the connection
  values in `config.php` are wrong or the database is unreachable.

- If collector processes use close to 100 percent CPU, the release README
  advises adding listeners to spread the load. It also suggests raising the
  operating system's connection and UDP buffer limits with `sysctl`.

## More Information

- [FlowView plugin repository](https://github.com/Cacti/plugin_flowview)

- README for release 4.9:
  [README.md](https://github.com/Cacti/plugin_flowview/blob/v4.9/README.md)

- Flow capture service instructions:
  [README](https://github.com/Cacti/plugin_flowview/blob/v4.9/service/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
