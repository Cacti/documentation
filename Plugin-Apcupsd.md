# UPS Monitor (apcupsd)

The apcupsd plugin tracks the status of uninterruptible power supplies (UPS)
and stores it in the Cacti database, where it can be used for graphs,
reports and alerts. It reads a UPS in one of two ways: from a host running
the `apcupsd` daemon, using the `apcaccess` command, or directly from the
UPS over SNMP. The `apcupsd` daemon supports APC and other UPS models
connected by USB, serial or network links. Administrators who need to watch
data center or office UPS units from Cacti use it.

## Requirements

- This page documents the apcupsd plugin 1.2 (release tag `v1.2`).

- Cacti 1.2.24 or later.

- No other plugin is required.

- For UPS units read through `apcupsd`, the `apcaccess` program on the Cacti
  server, in `/usr/sbin`, `/usr/bin` or `/usr/local/bin`, and an `apcupsd`
  daemon that the Cacti server can reach on its network port.

- SNMP collection uses APC object identifiers, so it covers APC UPS models.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named
`apcupsd`. Installing the plugin creates the `apcupsd_ups` and
`apcupsd_ups_stats` tables; uninstalling it drops them.

After installing the plugin, import the device package
`templates/UPS_APC_UPSD_Device.xml.gz` from the plugin directory at
**Console > Import/Export > Import Packages**. It provides the
**Device Template** that the plugin uses when it creates Cacti **Devices**
for UPS units. Until it is imported the plugin collects data but does not
create devices.

## Permissions

###### Table 1. apcupsd realm

| Realm        | Covers                                                  |
| ------------ | ------------------------------------------------------- |
| Manage UPS's | `upses.php`, the **UPSes** list and the UPS edit form. |

The plugin adds the **UPSes** page to the **System Administration** role.

## Settings

The plugin adds no settings to
**Console > Configuration > Settings**. Each UPS is configured on its own
edit form, described below.

###### Table 2. UPS edit form

| Label               | Default                  | Purpose                                                                                                                                                         |
| ------------------- | ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **UPS Name**        | New UPS                  | Name of the UPS. For an `apcupsd` UPS, a Cacti **Device** with this name is created automatically.                                                              |
| **UPS Description** | Empty                    | A longer description of the UPS.                                                                                                                                |
| **UPS Type**        | APC UPSD Based           | **APC UPSD Based** reads the UPS through `apcaccess`; **SNMP Based** reads it over SNMP.                                                                         |
| **Poller ID**       | 1                        | The Cacti **Data Collector** that monitors the UPS.                                                                                                             |
| **Site Name**       | None                     | The Cacti **Site** the UPS belongs to.                                                                                                                          |
| **Cacti Device**    | Autocreate on First Poll | For an SNMP UPS, the Cacti **Device** whose SNMP credentials are used. Leave it at **Autocreate on First Poll** to let the plugin create the **Device**.        |
| **Enabled**         | On                       | Start polling the UPS immediately.                                                                                                                              |
| **Hostname**        | Empty                    | For **APC UPSD Based**, the host running `apcupsd`; for **SNMP Based**, the host of the SNMP agent.                                                             |
| **TCP Port**        | 3551                     | For **APC UPSD Based**, the TCP port of the `apcupsd` network server.                                                                                           |

For **SNMP Based** units the form also shows the standard Cacti
**SNMP Options**.

## Using apcupsd

### Viewing UPS status

Open **Console > Management > UPSes**. The list shows, for each UPS, the
**Status** of the collector connection, the **Collector** type,
**UPS Status**, **UPS Model**, **Line Voltage**, **Load Percent**,
**Time Left** in minutes of battery charge, **Hostname:Port**, whether it is
**Enabled**, and when it was **Last Updated**. Use **Search** to filter the
list.

### Adding a UPS read through apcupsd

1. Make sure the `apcupsd` daemon on the UPS host accepts network
   connections from the Cacti server.

2. Open **Console > Management > UPSes** and click the add icon.

3. Enter **UPS Name**, set **UPS Type** to **APC UPSD Based**, and enter
   **Hostname** and **TCP Port**.

4. Choose the **Poller ID** and, optionally, the **Site Name**, and save.

On the next polling cycle the plugin reads the UPS and, if the device
package is imported, creates a Cacti **Device** for it.

### Adding an SNMP UPS

1. Open **Console > Management > UPSes** and click the add icon.

2. Enter **UPS Name** and set **UPS Type** to **SNMP Based**.

3. Select an existing **Cacti Device** to reuse its SNMP settings, or leave
   **Autocreate on First Poll** and enter the **Hostname** and
   **SNMP Options**.

4. Save.

### List actions

Select one or more UPS units in the list and choose an action:

- **Delete** removes the UPS from the plugin.

- **Duplicate** copies the UPS. The name template `<ups> (1)` is replaced
  with the original name.

- **Reset Detection** clears the list of SNMP values the plugin stopped
  requesting because the UPS returned no data for them, so they are tried
  again.

## How It Collects Data

The plugin registers a `poller_bottom` hook that starts
`poller_apcupsd.php` in the background after each Cacti polling cycle. Each
data collector reads the enabled UPS units assigned to it:

- For an **APC UPSD Based** UPS it runs `apcaccess -u -h host:port` and
  stores each value in `apcupsd_ups_stats`, one row per UPS. When
  `apcaccess` returns an error, the UPS status is set to down and the
  command output is saved as the error message. A **STATUS** of `ONLINE`
  marks the linked Cacti **Device** up; any other status marks it down.

- For an **SNMP Based** UPS it checks the agent's uptime and then queries
  each supported value. Values that return no data are skipped on later
  polls until the UPS goes down and comes back, or until
  **Reset Detection** is used.

- If the UPS has no linked Cacti **Device** and the device package is
  imported, a **Device** is created from the package's **Device Template**.

At the end of the run the script logs a line beginning `APCUPSD STATS:` to
the Cacti log with the run time and the number of `apcupsd` and SNMP units.
With remote data collectors, the plugin replicates its tables to them.

## Command-Line Tools

The collector can be run by hand from the Cacti `plugins/apcupsd` directory
to test a configuration.

```console
php poller_apcupsd.php [--force] [--debug]
```

- `--debug` or `-d` prints each value read from each UPS.

- `--force` or `-f` is accepted but does not change what is collected in
  this release.

## Troubleshooting

- `WARNING: UPSD Device Package Not Imported.  Device automation will not
  happen until it is imported!` in the Cacti log means the device package
  has not been imported; see [Installation](#installation).

- If an `apcupsd` UPS stays down, check that `apcaccess` is installed in one
  of the searched directories and that
  `apcaccess -u -h host:port` works from the Cacti server. The error from
  `apcaccess` is stored with the UPS.

- `WARNING: SNMP Value from UPS Returns invalid ENUM values` means the UPS
  returned an unexpected value for a status field. The field is skipped
  until **Reset Detection** is used.

## More Information

- [apcupsd plugin repository](https://github.com/Cacti/plugin_apcupsd)

- [README for 1.2](https://github.com/Cacti/plugin_apcupsd/blob/v1.2/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
