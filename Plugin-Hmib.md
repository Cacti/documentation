# Host MIB

The Host MIB plugin (hmib) collects SNMP data from Cacti **Devices** that
support the Host Resources MIB (HOST-RESOURCES-MIB). It records system
details, processor load, storage, hardware, running processes with their CPU
and memory use, and installed software, and presents them in inventory and
summary views grouped by operating system type. It also ships **Graph
Templates** that graph this data from the Cacti database instead of polling
the devices again. Administrators who want an inventory of servers and
workstations, or application use across many hosts, use it.

## Requirements

- This page documents Host MIB 3.5 (release tag `v3.5`).

- Cacti 1.2.25 or later.

- No other plugin is required.

- The monitored devices must run an SNMP agent that serves the Host
  Resources MIB, and must be configured for SNMP in Cacti.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named `hmib`.
Installing the plugin creates its `plugin_hmib_*` tables; uninstalling it
drops them.

The plugin's `templates` directory holds two packages. Import them from
**Console > Import/Export > Import Packages**:

1. `Host_Mib_Summary_Device.xml.gz` installs a **Device Template** with
   **Data Queries** and **Graph Templates** that track totals by operating
   system type and by application name.

2. `Host_Mib_Device_Level_Application_Stats.xml.gz` installs a **Data Query**
   for application memory and CPU use on individual devices. Add this
   **Data Query** to the **Device Template** of your Host MIB devices and
   sync the template, or add it to individual devices. Create its graphs by
   hand or with an automation rule.

Then enable the collector with **Host MIB Poller Enabled** at
**Console > Configuration > Settings > Host MIB**.

## Permissions

###### Table 1. Host MIB realms

| Realm           | Covers                                                                 |
| --------------- | ---------------------------------------------------------------------- |
| Host MIB Viewer | `hmib.php`, the **Hmib** tab with the inventory and summary views.     |
| Host MIB Admin  | `hmib_types.php`, the **OS Types** page.                               |

The plugin adds the viewer page to the **Normal User** role and the
**OS Types** page to the **General Administration** role.

## Settings

The settings are at **Console > Configuration > Settings > Host MIB**.

###### Table 2. Host MIB General Settings

| Label                                    | Default       | Purpose                                                                                     |
| ---------------------------------------- | ------------- | ------------------------------------------------------------------------------------------- |
| **Host MIB Poller Enabled**              | Off           | Enables Host MIB polling. The collector does nothing while this is off.                     |
| **Automatically Discover Cacti Devices** | On            | Scan Cacti **Devices** and add those that support the Host Resources MIB.                   |
| **Automatically Purge Devices**          | On            | Remove Host MIB data for devices that are deleted from Cacti.                               |
| **Default Row Count**                    | 10            | Rows shown by default on the **OS Types** page.                                             |
| **Default Top Host Types**               | 10 Types      | Number of host types on the summary view: 5, 8, 10 or 15.                                   |
| **Default Top Processes**                | 10 Processes  | Number of processes on the summary view: 5, 10, 20 or 30.                                   |
| **Maximum Concurrent Collectors**        | 10 Processes  | Maximum number of device collector processes running at once, from 1 to 50.                |

###### Table 3. Discovery, automation and collection frequencies

| Label                                     | Default    | Purpose                                                              |
| ----------------------------------------- | ---------- | -------------------------------------------------------------------- |
| **Auto Discovery Frequency**              | 5 Minutes  | How often to look for new Cacti **Devices**.                         |
| **Automatically Add New Graphs**          | Never      | How often to check for new objects to graph.                         |
| **Running Programs Frequency**            | 5 Minutes  | How often to collect the running process table.                      |
| **Running Programs CPU/Memory Frequency** | 5 Minutes  | How often to collect process CPU and memory use.                     |
| **Installed Software Frequency**          | 1 Day      | How often to collect installed software.                             |
| **Storage Frequency**                     | 1 Hour     | How often to collect storage use.                                    |
| **Device Frequency**                      | 1 Hour     | How often to collect the hardware device table.                      |
| **Processor Frequency**                   | 5 Minutes  | How often to collect processor load.                                 |

The frequency lists range from 1 minute to 1 day and include **Disabled**,
which stops collection of that table.

## Using Host MIB

### Host MIB views

Open the **Hmib** tab. Its pages are selected with the tabs at the top:

- **Summary** shows **Device Type Summary Statistics**, with up, recovering,
  down and disabled device counts, logins, CPUs and average and maximum CPU,
  memory, swap and process figures for each operating system type, and
  **Process Summary Statistics** for the busiest processes.

- **Devices** lists each Host MIB device with status, uptime, users, CPU
  percentage, number of CPUs, processes and memory and swap use. Filter by
  **OS Type**, **Template**, **Process**, **Status** or a search term.

- **Storage** lists each storage area with type, errors, percentage used,
  used and total size and allocation unit.

- **Hardware** lists hardware devices with type, status and errors.

- **Processes** lists running processes with path, parameters, CPU time,
  memory, type and status.

- **Use History** lists each process with when it was last seen and its
  total use time.

- **Inventory** lists installed software packages with type and install
  date.

- **Graphs** previews the graphs created from the Host MIB templates.

The following screenshot shows the **Devices** page with three devices that
are up, and their uptime, CPU, process and memory figures.

![Host MIB Devices page listing three devices with status, uptime, users,
CPU percentage, CPUs, processes, memory and swap
columns](images/plugin-hmib-devices.png)

The icons in the **Actions** column open **View Storage**,
**View Hardware**, **View Processes**, **View Software Inventory** and
**View Graphs** for that device.

### Classifying operating systems

The summary groups devices by host type. A device's type is found by
matching its SNMP `sysDescr` and `sysObjectID` against the types on
**Console > Management > OS Types**. The plugin installs a starting set of
types.

To add types for devices that do not match:

1. Open **Console > Management > OS Types**.

2. Click **Rescan**. Unmatched devices are added as types named
   **New Type** with version **Unknown**.

3. Edit each new type and set **Name** and **Version**. Adjust
   **System Description Match** and **Vendor snmp Object ID** so they match
   every device of that type. Both fields accept SQL `LIKE` expressions with
   `%` as the wildcard; regular expressions are not supported.

4. Save. The type is applied on the next collection cycle.

Use **Export** to save the types to a CSV file and **Import** to load them on
another system. The import file needs a header row with the columns `name`,
`version`, `sysDescrMatch` and `sysObjectID`. The combination of
`sysDescrMatch` and `sysObjectID` is the key, so importing an existing
combination updates it when **Allow Existing Rows to be Updated?** is
checked.

## How It Collects Data

The plugin registers a `poller_bottom` hook that starts `poller_hmib.php -M`
in the background after each Cacti polling cycle. The main process:

1. exits at once if **Host MIB Poller Enabled** is off;

2. runs auto discovery when **Automatically Discover Cacti Devices** is on
   and **Auto Discovery Frequency** has passed, walking the Host Resources
   MIB on every enabled SNMP device that is not down;

3. clears the collected tables for devices that are disabled or down;

4. starts one child process per Host MIB device, up to
   **Maximum Concurrent Collectors** at a time. Each child collects the
   tables whose frequency has passed;

5. purges data for deleted devices when **Automatically Purge Devices** is
   on, updates the per-device summaries and applies the OS types;

6. logs a line beginning `HMIB STATS:` to the Cacti log, then starts
   `poller_graphs.php`, which adds graphs according to
   **Automatically Add New Graphs**.

Collector processes that run longer than 10 minutes are removed from the
process table. The running process history is kept in
`plugin_hmib_hrSWRun_last_seen`.

The script server functions in the **Graph Templates** read processor and
disk data from the plugin's tables, so those graphs do not poll the devices
again.

## Command-Line Tools

Run the scripts from the `plugins/hmib` directory as the Cacti poller user.

```console
php poller_hmib.php -M [-f] [-fd] [-d]
php poller_hmib.php --host-id=N [--seed=N] [-f] [-d]
```

- `-M` runs the main process, which discovers devices and starts collectors.

- `--host-id=N` collects one device; the main process starts these.

- `-f` or `--force` collects every table regardless of its frequency.

- `-d` or `--debug` prints debug output.

- `-v` and `-h` print the version or usage.

```console
php poller_graphs.php [--force] [--debug]
```

Creates graphs for Host MIB devices from the installed templates.

```console
php associate_os_type.php [--debug]
```

Applies the OS types to all Host MIB devices without waiting for a polling
cycle.

## Troubleshooting

- `WARNING: The Host Mib Collection is Down!` means
  **Host MIB Poller Enabled** is off or the plugin is disabled.

- `WARNING: Another Host Mib Collector is still running!` means a previous
  run has not finished. Lower the collection frequencies or raise
  **Maximum Concurrent Collectors**.

- `WARNING: Device[N] experienced N SNMP Errors` reports SNMP errors on one
  device. Increase the Cacti log level to HIGH to see the errors.

- `WARNING: Unable to find Host MIB Summary Host Template` and
  `NOTE: Host MIB Summary Host Template Not Specified` mean the
  `Host_Mib_Summary_Device.xml.gz` package has not been imported.

- Devices that appear with an unknown type on the summary need an OS type;
  see [Classifying operating systems](#classifying-operating-systems).

## More Information

- [Host MIB plugin repository](https://github.com/Cacti/plugin_hmib)

- [README for 3.5](https://github.com/Cacti/plugin_hmib/blob/v3.5/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
