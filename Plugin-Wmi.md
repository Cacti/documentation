# WMI

The WMI plugin, shown in Cacti as **WMI Information Collector**, runs WMI
queries against Windows devices from the Cacti poller and stores the returned
rows in cache tables. Queries are defined once and associated with **Device
Templates**, so every **Device** that uses the template and has a WMI account
is polled with them. Administrators who need data from Windows hosts that SNMP
does not expose are the audience for this plugin.

The plugin README states that development is in progress, that the plugin is
not fully functional, and that it should not be used on production systems.

## Requirements

- No release of the WMI plugin has been published. This page documents the
  default branch `develop` at commit `4b3fe69`, whose `INFO` file reports
  version 1.1.

- Cacti 1.1.4 or later, as declared in `INFO`. The README for this commit
  states that the plugin was run on Cacti 1.2.x and that the Cacti core
  functions it calls exist in Cacti 1.2.0.

- PHP 8.0 or later, according to the README.

- On a Linux Cacti server, a `wmic` client. Its path is set in **WMI Client
  (wmic) Path** (default `/usr/bin/wmic`).

- On a Windows Cacti server, PowerShell (`powershell.exe`). Remote Windows
  targets must have WinRM configured and reachable.

- No other plugin is required.

## Installation

Install the plugin with the generic procedure in
[Plugin Management](Plugins.md). The plugin directory must be named `wmi`, not
`plugin_wmi`.

Installing the plugin creates seven tables, adds a `wmi_account` column to
Cacti's `host` table, registers the **WMI Management** realm and adds two
**Data Input Methods**, **Get WMI Data** and **Get WMI Data (Indexed)**.

Uninstalling the plugin drops its tables, removes the `wmi_account` column,
and deletes the **Graphs** and **Data Sources** that use the two WMI data
input methods. Disable the plugin instead of uninstalling it if you want to
keep that data.

## Permissions

###### Table 1. WMI realms

| Realm              | Pages                                              |
| ------------------ | -------------------------------------------------- |
| **WMI Management** | `wmi_accounts.php`, `wmi_queries.php`, `wmi_tools.php` |

On Cacti versions that support role augmentation, the plugin also gives the
**Template Editor** role access to `wmi_queries.php` only.

## Settings

The plugin adds a **WMI Settings** section to **Console > Configuration >
Settings > Misc** and one field to **Console > Configuration > Settings >
Paths**.

###### Table 2. WMI settings

| Label | Default | Purpose |
| ----- | ------- | ------- |
| **Enable WMI Data Collection** | Checked | Described as turning WMI queries of Windows devices on or off. At this commit no code reads it. |
| **Concurrent Processes** | 10 | How many device collectors run at once, from 1 to 10 and then in steps of 5 up to 50. |
| **Auto Create WMI Queries** | Checked | Described as creating the template's WMI queries when a device is created or saved. At this commit the hook that reads it does not create queries. |
| **Use WinRM over HTTPS** | Unchecked | Default transport for accounts that use the server default. |
| **WinRM Port Override** | Empty | Default port for accounts that use the server default. Empty uses the Windows default. |
| **WinRM Authentication** | Negotiate | Default authentication for accounts that use the server default: **Negotiate**, **Kerberos** or **Basic (HTTPS only)**. |
| **WMI Client (wmic) Path** (Paths tab) | `/usr/bin/wmic` | Path to the `wmic` binary on a Linux Cacti server. |

The three WinRM settings apply to the PowerShell transport.

## Using WMI

### WMI Queries

Open **Console > Data Collection > WMI Queries**. The page has two tabs,
**Queries** and **Authentication**.

The **Queries** tab lists each query with its **Frequency**, **Namespace**,
**WQL Query** and **Primary Key**, and poll health columns: **Polled
Devices**, **Last Poll**, **Failing Devices**, **Timeouts** and **Most Recent
Error**. The following screenshot shows the **Queries** tab with five example
queries in the `root\cimv2` namespace.

![WMI Queries tab listing five example WQL queries with their frequency,
namespace and primary key](images/plugin-wmi-queries.png)

To create a query:

1. Click the add icon on the **WMI Queries** bar.

2. Enter a **Name** and choose a **Collection Frequency** (default
   5 minutes; choices run from 1 minute to 1 day).

3. Check **Enabled**.

4. Enter the **Namespace**, for example `root\cimv2`, and the WQL text in
   **Query**. Responses are capped at 16 MiB.

5. If the query returns several rows, enter the column that identifies each
   row in **Primary Key**. Separate several columns with commas.

6. Save the query.

With the PowerShell transport on a Windows Cacti server, a query can instead
use the namespace `PDH` and list Windows performance counter paths, one per
line, in **Query**.

### Authentication accounts

The **Authentication** tab holds the Windows accounts used to connect to
devices. Each account has a **Name**, **Username** (include the domain if
needed) and **Password**. For the PowerShell transport, **WinRM Transport**,
**WinRM Port Override** and **WinRM Authentication** can override the server
defaults or use **Use Server Default**.

### Device Templates and Devices

The **Device Template** edit page shows an **Associated WMI Queries** box
with an **Add WMI Query** control and a delete icon for each query.

The **Device** edit page has a **WMI Authentication Account** field in the
**WMI Account Options** section. A device is polled only when an account is
selected. The page also lists the template's WMI queries and whether each
exists for the device.

To start collecting from a device:

1. Create an account on the **Authentication** tab.

2. Create the queries on the **Queries** tab.

3. Add the queries to the device's **Device Template**.

4. On the device, choose the **WMI Authentication Account** and save.

### WMI Query Tool

**Console > Utilities > WMI Query Tool** runs a query against one host
interactively. Enter the **Host**, **Username**, **Password**, **Namespace**
and **Command**, then click **Run**. **Queries** offers a list of common
queries, **Help** shows setup assistance, and **Add** creates a saved WMI
query from the current one. The results appear in **Query Results**.

## How It Collects Data

The plugin registers a `poller_bottom` hook. At the end of each poller cycle
on the main poller, Cacti starts `poller_wmi.php -M` in the background.

The master process selects devices that are not down, not disabled, have a
WMI account, and have an enabled template query whose frequency has elapsed.
It starts one child process per device, up to **Concurrent Processes** at a
time. Each child runs the due queries and stores the rows in
`host_wmi_cache`. Cache rows for down or disabled devices are removed at the
start of each run.

Running collectors are tracked in the `wmi_processes` table. A new master run
exits while any collector is still recorded there; rows older than one hour
are removed before that check.

At the end of a run the summary is saved and written to the Cacti log with
the prefix `WMI STATS:`.

The transport depends on the Cacti server's operating system: `wmic` over
DCOM on Linux, and PowerShell `Get-CimInstance` over WinRM on Windows.

## Command-Line Tools

`poller_wmi.php` is normally started by the poller. It can be run by hand
from the Cacti base directory as the poller user:

```console
php plugins/wmi/poller_wmi.php -M [-f] [-d]
php plugins/wmi/poller_wmi.php --host-id=N [--seed=N] [-f] [-d]
```

- `-M` runs the master process, which polls every device that is due.

- `--host-id=N` runs the collector for one device.

- `--seed=N` is set by the master for its children.

- `-f` and `-d` are accepted and passed on to the children.

- `--version` and `--help` print the version and usage.

## Troubleshooting

- `WARNING: Another WMI Collector is still running!  Exiting` means a
  previous run is still recorded in `wmi_processes`.

- `FATAL: You must specify a Cacti host-id run` means `poller_wmi.php` was run
  without `-M` or `--host-id`.

- A device is not polled unless it has a **WMI Authentication Account**, its
  **Device Template** has an enabled WMI query, and the device is up.

- The **Help** button in the **WMI Query Tool** notes that the account needs
  Distributed COM permissions and that the Windows firewall must allow
  Distributed COM traffic when the `wmic` transport is used.

- Test a query in the **WMI Query Tool** before adding it to a template.

## More Information

- [WMI plugin repository](https://github.com/Cacti/plugin_wmi)

- [develop README](https://github.com/Cacti/plugin_wmi/blob/develop/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
