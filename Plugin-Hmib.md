# Host MIB

The Host MIB plugin collects SNMP data from Cacti devices that implement the
Host Resources MIB (HOST-RESOURCES-MIB) and stores it in the Cacti database.
It records CPU load, running processes and their CPU and memory use, memory and
swap use, storage volumes, hardware devices, and installed software, and it
presents the result as dashboards, summaries, and per-device pages. It is
meant for administrators of server and workstation fleets who want to see what
is running on their hosts without polling every device on demand.

This page follows the plugin's `develop` branch, which is unreleased and can
change. That branch declares plugin version 3.5 and Cacti compatibility 1.2.25
in its `INFO` file. Check the release you install for differences.

## Requirements

- Plugin version 3.5 and Cacti 1.2.25 or later, as declared in `INFO`.
- The plugin does not require other plugins.
- The Cacti poller. The plugin starts its own collector at the end of
  every polling cycle, so Cacti polling must be running. It starts it with the
  PHP binary from Cacti's **Path** settings (`path_php_binary`).
- SNMP enabled on each device in Cacti, with an SNMP agent that answers for the
  Host Resources MIB. The plugin uses each device's own SNMP settings.
- The `INFO` file declares no support for remote data collectors
  (`remote_collect:0`).

For graphing, the plugin also uses the `SNMP - Get Processor Information` and
`SNMP - Get Mounted Partitions` data queries and the `Host MIB - Logged in
Users` and `Host MIB - Processes` graph templates. These ship with Cacti's
Net-SNMP device package, not with this plugin.

## Installation

Follow [Plugin Management](Plugins.md) to install and enable the plugin. The
directory must be named `hmib`. Plugin-specific steps:

1. Install the plugin. Installation creates its database tables and
   registers its realms. The Cacti `admin` user receives both realms; grant them
   to other users from **Console > Management > Users** on the user's
   **Permissions** tab.
2. Open **Console > Configuration > Settings** and select the **Host MIB** tab.
   Check **Host MIB Poller Enabled**. The poller is off by default, and until it
   is checked the plugin's poller scripts exit with `The Host Mib Collection is
   Down!`.
3. Import the two packages in the plugin's `templates` directory with
   **Console > Import/Export > Import Templates**, or from the command line:

   ```console
   php cli/import_package.php --filename=plugins/hmib/templates/Host_Mib_Summary_Device.xml.gz
   php cli/import_package.php --filename=plugins/hmib/templates/Host_Mib_Device_Level_Application_Stats.xml.gz
   ```

Import `Host_Mib_Summary_Device.xml.gz` first. It supplies the
`Host Mib Summary Device` device template, the data queries
`Host MIB - Summary Application Stats` and `Host MIB - Host Type Graphs`, and
the roll-up graph templates. The second package supplies the
`Host Mib - Device Level Application Stats` data query, which tracks
application CPU and memory per device. Add that data query to the device
template of your Host MIB devices, or to individual devices, and create its
graphs by hand or with an automation rule.

Until the data queries and graph templates the Summary tab links to all exist,
the tab shows `NOTE: Import the Host MIB Device Package to view Graphs.`

When the plugin version in `INFO` differs from the stored version, the plugin
updates its stored data the next time **Plugin Management** or the **Host MIB**
tab is opened. Uninstalling the plugin drops its tables; it leaves the saved
settings and the templates and scripts that the packages imported.

## Permissions

| Realm | Pages |
| --- | --- |
| **Host MIB Viewer** | `hmib.php`, the Host MIB tab and all its pages |
| **Host MIB Admin** | `hmib_types.php`, the OS Types management page |

The plugin also adds the Viewer realm to Cacti's **Normal User** role and the
Admin realm to the **General Administration** role when the role helper exists.

## Settings

Settings are in **Console > Configuration > Settings**, on the **Host MIB**
tab. A frequency drop-down offers **Disabled**, 1, 5, 10, or 20 minutes, 1, 2,
4, or 12 hours, or 1 day.

### Host MIB General Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **Host MIB Poller Enabled** | off | Turns Host MIB polling on. When off, the poller does not run. |
| **Automatically Discover Cacti Devices** | on | Scans the Cacti device table for devices that support the Host Resources MIB and adds them. |
| **Automatically Purge Devices** | on | Removes Host MIB data for devices that were removed from Cacti. |
| **Process History Retention** | Never Purge | How long the **Use History** tab keeps a process after it was last seen running. Choices: Never Purge, 30, 90, or 180 days, 1 or 2 years. |
| **Default Row Count** | 10 | Rows shown by default on the OS type views. |
| **Default Top Host Types** | 10 | Number of host types shown by default (5, 8, 10, or 15). |
| **Default Top Processes** | 10 | Number of processes shown by default (5, 10, 20, or 30). |
| **Maximum Concurrent Collectors** | 10 | Maximum collector processes run at one time (1 to 5, 10, 20, 30, 40, or 50). |

### Host Auto Discovery Frequency

| Setting | Default | Purpose |
| --- | --- | --- |
| **Auto Discovery Frequency** | 5 Minutes | How often to look for new Cacti devices. |

### Host Graph Automation

| Setting | Default | Purpose |
| --- | --- | --- |
| **Automatically Add New Graphs** | Never | How often to check for new objects to graph. Choices: Never, 1 Hour, 12 Hours, 1 Day, 2 Days. |

The plugin multiplies the stored value (1, 12, 24, or 48) by 86400 seconds when
it compares it with the time of the last run, so the number acts as a number of
days whatever the label says.

### Host MIB Table Collection Frequencies

| Setting | Default | Purpose |
| --- | --- | --- |
| **Running Programs Frequency** | 5 Minutes | How often to scan running software. |
| **Running Programs CPU/Memory Frequency** | 5 Minutes | How often to scan running software for performance data. |
| **Installed Software Frequency** | 1 Day | How often to scan for installed software. |
| **Storage Frequency** | 1 Hour | How often to scan for storage data. |
| **Device Frequency** | 1 Hour | How often to scan for device data. |
| **Processor Frequency** | 5 Minutes | How often to scan for processor data. |

## Using Host MIB

The **Host MIB** tab appears in Cacti's top tabs for users who have the
**Host MIB Viewer** realm. It opens on the Fleet Dashboard. The tab bar has
these pages.

| Page | What it shows |
| --- | --- |
| **Fleet Dashboard** | Cards for all devices or for one OS type: Fleet Overview, Resource Utilization, Device Status, Storage Utilization, Uptime Distribution, OS Type Distribution, Top Processes by CPU, and Top Processes by Memory. |
| **Summary** | Statistics by OS type and by process name. |
| **Devices** | One row per device with status, uptime, users, CPU, processes, memory, and swap, plus action icons that open the device's other pages. |
| **Dashboard** | Cards for one device. The tab appears after you open it from a device row. |
| **Storage** | Storage volumes. |
| **Hardware** | Hardware devices. |
| **Processes** | Running processes. |
| **Use History** | For each device and process name, when the process was last seen and how long it has been seen running. |
| **Inventory** | Installed software. |
| **Graphs** | Graphs of the Host MIB devices. |

The following screenshot shows the Fleet Dashboard. The example uses synthetic
data from three test devices.

![Fleet Dashboard with two cards for three synthetic devices][hmib-fleet]

On the Fleet Dashboard, the **Scope** drop-down limits the cards to one OS
type, **Add a card** adds a card you removed, and **Refresh** sets an automatic
refresh of **No Refresh**, **30 Seconds**, **1 Minute**, or **5 Minutes**. Each
card has tools to refresh or remove it.

The next screenshot shows the **Devices** tab with synthetic devices. Its filter
offers OS Type, Template, Process, Search, Status, and Devices.

![Devices tab listing three synthetic Host MIB devices][hmib-devices]

The icons in the **Actions** column carry the titles **View Dashboard**,
**View Storage**, **View Hardware**, **View Processes**, **View Software
Inventory**, and **View Graphs**.

### Operating System Types

Each device receives an OS type by comparing what it reports with the types
listed in **Console > Management > OS Types**. This page needs the **Host MIB
Admin** realm. A type has a **Name**, a **Version**, a **System Description
Match**, and a **Vendor snmp Object ID**. The page offers **Delete** and
**Duplicate** actions, and **Rescan**, **Import**, and **Export** buttons.

A type matches a device when the device's sysDescr contains the type's System
Description Match and its sysObjectID starts with the Vendor snmp Object ID.
The install adds a set of default types, such as AIX, Linux, and Windows
variants.

To classify devices:

1. Open **Console > Management > OS Types**.
2. Click **Rescan**. The plugin tests the stored types against devices that
   have no type, then adds a placeholder type named `New Type` with version
   `Unknown` for the sysDescr and sysObjectID of devices that still have none.
3. Edit each placeholder: give it a real name and version and a System
   Description Match that identifies the operating system.
4. After the next collection, or after running the command in
   [Command-Line Tools](#command-line-tools), the devices carry their type and
   the Summary views group by it.

Rescan does not change a device that already has a type.

**Export** downloads `cacti_host_type_xport.csv` with the columns `id`, `name`,
`version`, `sysDescrMatch`, and `sysObjectID`. **Import** reads a file in the
same format. The header line must contain `id`, `sysDescrMatch`, and
`sysObjectID`; `name` and `version` are optional. A row that already exists is
skipped unless **Allow Existing Rows to be Updated?** is checked.

### Automatic Graphs

When **Automatically Add New Graphs** is set to something other than **Never**,
the plugin runs its graph script after each collection once the interval has
passed. The script creates a device named `Summary Device` from the
`Host Mib Summary Device` template if none exists and creates the graphs of
that template's data queries and graph templates. For each Host MIB device that
is up and enabled, it adds the `Host MIB - Logged in Users` and
`Host MIB - Processes` graph templates, graphs for the
`SNMP - Get Processor Information` data query, and graphs for the filesystems
of the `SNMP - Get Mounted Partitions` data query that report a size greater
than zero. Objects whose template or query is missing are skipped.

## How It Collects Data

The plugin registers the `poller_bottom` hook. At the end of each Cacti polling
cycle it starts `poller_hmib.php -M`, the master process, in the background.
The master:

1. Exits when the poller is disabled, or when another master still holds the
   collector lock.
2. Runs auto discovery when it is due. Discovery looks at Cacti devices that
   are enabled and have SNMP enabled and adds those that answer for the Host
   Resources system group.
3. Starts one child process per device, up to **Maximum Concurrent Collectors**,
   and waits for them. Discovery, launching, and waiting stop 10 minutes after
   the master started.
4. Purges devices removed from Cacti when **Automatically Purge Devices** is on,
   and deletes Use History rows older than **Process History Retention**.
5. Updates the per-device summary statistics, assigns OS types to all devices,
   and starts the graph script.

Each child runs only the collectors that are due, according to the frequency
settings. The collectors walk the Host Resources MIB and the MIB-II system
group:

| Collector | OID |
| --- | --- |
| System | `.1.3.6.1.2.1.25.1` (hrSystem), memory size from `.1.3.6.1.2.1.25.2.2.0` |
| Running programs | `.1.3.6.1.2.1.25.4.2.1` (hrSWRunTable) |
| Running programs CPU and memory | `.1.3.6.1.2.1.25.5.1.1` (hrSWRunPerfTable) |
| Installed software | `.1.3.6.1.2.1.25.6.3.1` (hrSWInstalledTable) |
| Storage | `.1.3.6.1.2.1.25.2.3` (hrStorageTable) |
| Devices | `.1.3.6.1.2.1.25.3.2.1` (hrDeviceTable) |
| Processors | `.1.3.6.1.2.1.25.3.3.1` (hrProcessorTable) |

The plugin keeps its data in tables whose names start with `plugin_hmib_`. It
also registers the hooks `hmib_get_cpu`, `hmib_get_cpu_indexes`, and
`hmib_get_disk`, which return stored processor load and disk values to Cacti's
script server.

The only retention setting is **Process History Retention**. With
**Never Purge**, the Use History table keeps its rows indefinitely.

## Command-Line Tools

Run the scripts from any directory as the user Cacti runs as. Each accepts
`--version` and `--help`.

```console
php plugins/hmib/poller_hmib.php [-M] [-f] [-fd] [-d]
php plugins/hmib/poller_hmib.php --host-id=N [--seed=N] [-f] [-d]
```

The first form is the master process that Cacti starts after each poll. The
second form collects one device. `-f` or `--force` runs every collector
regardless of its frequency, and `-d` or `--debug` prints more output.

```console
php plugins/hmib/poller_graphs.php [--force] [--debug]
```

Creates the summary device and graphs described under Automatic Graphs.
`--force` runs the script even when it is not due.

```console
php plugins/hmib/associate_os_type.php [--debug]
```

Assigns OS types to all devices. It takes no other parameters.

## Troubleshooting

- **No data is collected:** check that **Host MIB Poller Enabled** is
  checked. A disabled poller prints `The Host Mib Collection is Down!` and
  exits.
- **Message `Another Host Mib Collector is still running!  Exiting`:** a master
  process holds the lock. A new master exits until the running one finishes.
- **Log message `Stopped waiting on N Host MIB collectors after 600 seconds`:**
  the master waits at most 10 minutes for child processes before it stops
  waiting.
- **Log message `Device[N] experienced N SNMP Errors`:** raise Cacti's logging
  level to HIGH to see the SNMP errors for that device. Log lines from the
  plugin use the `HMIB` tag.
- **A device shows no data:** the plugin skips a device whose agent does not
  return the Host Resources MIB, with the log line `returned no Host Resources
  MIB, skipping collection`.
- **Devices have no OS type:** run **Rescan** on the OS Types page, then edit
  the placeholder types.
- **Graph links missing on the Summary tab:** import the two packages, and make
  sure Cacti's Net-SNMP device package is installed.
- **Graphs are not created automatically:** set **Automatically Add New Graphs**
  to a value other than **Never**, and remember that the interval is counted in
  days.

## More Information

- [Host MIB plugin repository](https://github.com/Cacti/plugin_hmib)
- [Host MIB README][hmib-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[hmib-fleet]: images/plugin-hmib-fleet.png
[hmib-devices]: images/plugin-hmib-devices.png
[hmib-readme]: https://github.com/Cacti/plugin_hmib/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
