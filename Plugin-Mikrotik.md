# MikroTik

The MikroTik plugin adds support for MikroTik RouterOS devices to Cacti. It
discovers Cacti devices that are MikroTik routers or switches, collects data
from them with SNMP and the RouterOS API, and shows the results as tables and
graphs: devices, users, queues, interfaces, DHCP leases, DNS cache entries,
address lists, wireless access points and registrations, and health sensors.
It is for administrators who run MikroTik equipment and want more than plain
interface traffic graphs. It does not replace MikroTik's own management
interface.

This page follows the plugin's `develop` branch, which is unreleased and can
change. That branch declares plugin version 3.4 and Cacti compatibility 1.2.29
in its `INFO` file. Check the release you install for differences.

## Requirements

- Plugin version 3.4 and Cacti 1.2.29 or later, as declared in `INFO`.
- The plugin does not require other plugins.
- MikroTik devices configured in Cacti with SNMP enabled. The plugin reads the
  MikroTik MIB, which ships with the plugin as `mikrotik-6.mib` and
  `mikrotik-7.mib`.
- For RouterOS API polling, a read-only RouterOS user on each device. The plugin
  includes its own RouterOS API client and opens the connection with PHP stream
  sockets. API polling can be turned off with a setting.
- The Cacti poller. The plugin starts its own collector at the end of every
  polling cycle, using the PHP binary configured in Cacti (`path_php_binary`).
- The `INFO` file declares no support for remote data collectors
  (`remote_collect:0`).

## Installation

Follow [Plugin Management](Plugins.md) to install and enable the plugin. The
directory must be named `mikrotik`. Plugin-specific steps:

1. Import the device template package from the plugin's `templates` directory.
   The directory holds `MikroTik_Device.xml.gz` and
   `MikroTik_Switch_SWOS.xml.gz`. Import with
   **Console > Import/Export > Import Templates** or from the command line:

   ```console
   php cli/import_package.php --filename=plugins/mikrotik/templates/MikroTik_Device.xml.gz
   ```

2. Open **Console > Configuration > Settings** and select the **MikroTik** tab.
   The poller is enabled by default. Review the collection frequencies.
3. Edit each MikroTik device in Cacti and fill in the **MikroTik Credentials**
   section described below.

If you use a different device template for your MikroTik devices, consider
changing them to the MikroTik device template from the package.

### Device Credentials

Each device's edit page has a **MikroTik Credentials** section:

| Field | Purpose |
| --- | --- |
| **Read Only User** | A read-only RouterOS user name. |
| **Password** | The user's password. Leave it blank to keep the stored password. |
| **SSL** | Connects to the API over SSL (api-ssl, port 8729). It can be turned on only when the device's api-ssl service is reachable. Enable the service under **IP > Services** on the device first. |

The plugin removes a device's stored credentials when the device is deleted in
Cacti.

### Upgrade and Uninstall

When the version in `INFO` differs from the stored version, the plugin adds
missing database columns and tables the next time **Plugin Management** or the
**MikroTik** tab is opened. Uninstalling the plugin drops all of its
`plugin_mikrotik_` tables, including the stored credentials.

## Permissions

| Realm | Pages |
| --- | --- |
| **MikroTik Viewer** | `mikrotik.php`, the MikroTik tab and all its pages |
| **MikroTik Admin** | `mikrotik_users.php`, the MikroTik Users management page |

The plugin also adds the Viewer realm to Cacti's **Normal User** role and the
Admin realm to the **General Administration** role when the role helper exists.

## Settings

Settings are in **Console > Configuration > Settings**, on the **MikroTik** tab.
A frequency drop-down offers **Disabled**, 1, 5, 10, or 20 minutes, 1, 2, 4, or
12 hours, or 1 day.

### MikroTik General Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **MikroTik Poller Enabled** | on | Turns MikroTik polling on. When off, the poller does not run. |
| **MikroTik API Polling Enabled** | on | Polls settings through the RouterOS API. Turn it off when you have no access to the API. |
| **Allow Unverified API TLS Certificates** | off | Skips certificate and hostname verification for API connections. The setting's description advises leaving it off and installing trusted device certificates. |
| **Automatically Discover Cacti Devices** | on | Scans the Cacti device table for devices that support the MikroTik MIB. |
| **Automatically Purge Devices** | on | Removes MikroTik data for devices that were removed from Cacti. |
| **Maximum Concurrent Collectors** | 10 | Maximum collector processes run at one time (1 to 5, 10, 20, 30, 40, or 50). |

### Auto Discovery Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **Auto Discovery Frequency** | 5 Minutes | How often to look for new Cacti devices. |

### DHCP/DNS/List Settings

Each retention setting offers **Indefinite**, 1, 2, or 3 days, 1, 2, or 4
weeks, 2 or 6 months, or 1 year.

| Setting | Default | Purpose |
| --- | --- | --- |
| **DHCP Retention** | 4 Weeks | How long to keep DHCP IP registration history. |
| **DNS Retention** | 4 Weeks | How long to keep DNS cache history. |
| **Address List Retention** | 4 Weeks | How long to keep address list history. |

### Device Graph Automation

| Setting | Default | Purpose |
| --- | --- | --- |
| **Automatically Add New Graphs** | Never | How often to check for new objects to graph. Choices: Never, 10, 20, or 30 Minutes, 1 or 12 Hours, 1 or 2 Days. |
| **Exclude Users RegEx** | `(^T-$)` | User names that match this expression are not graphed automatically. |
| **Exclude Users Time to Live** | 1 Hour | How long an excluded user's data is kept after the user disconnects (30 Minutes, 1, 2, or 4 Hours, or 1 Day). |

### Collection Frequencies

All collection frequencies default to 5 Minutes and offer the frequency list.
For the queue, tree, and wireless items, the setting's description says that
**Disabled** removes the feature.

| Section | Settings |
| --- | --- |
| **MikroTik Device Collection Frequencies** | **Storage Frequency**, **Processor Frequency**, **Interfaces Frequency**, **DNS/DHCP/List Frequency** |
| **MikroTik Queue/Tree Collection Frequencies** | **Simple Queue/PPPoe Frequency**, **Queue Trees Frequency** |
| **MikroTik Wireless Collection Frequencies** | **Wireless HotSpot Users Frequency**, **Wireless Access Point Frequency**, **Wireless Registrations Frequency**, **Wireless Stations Frequency** |

## Using MikroTik

The **MikroTik** tab appears in Cacti's top tabs for users who have the
**MikroTik Viewer** realm. It opens on the **Devices** page. The other pages
appear in the tab bar only when the plugin has collected data for them.

| Page | What it shows |
| --- | --- |
| **Devices** | One row per device with status, firmware and license versions, uptime, users, CPU, memory, and disk use. |
| **Users** | Hotspot and PPPoe users with address, connect time, current and average rates, and last seen time. |
| **Queues** | Simple queues. |
| **Queue Trees** | Queue trees. |
| **Interfaces** | Interfaces, each with a link to its graphs. |
| **DHCP** | DHCP IP registrations. |
| **DNS Cache** | DNS cache entries, with an export. |
| **Address Lists** | Address list entries, with an export. |
| **Wireless Aps** | Wireless access points. |
| **Wireless Registrations** | Wireless client registrations. |
| **Health** | Health sensor data such as temperature and voltage. |
| **Graphs** | Graphs of the MikroTik devices. |

The following screenshot shows the **Devices** page with one synthetic device.

![Devices page listing one synthetic MikroTik device][mt-devices]

The next screenshot shows the **Users** page with synthetic PPPoe users. Its
filter offers Search, Device, Type (Hotspot or PPPoe), Devices, and Active
Users.

![Users page listing three synthetic PPPoe users][mt-users]

### MikroTik Users Management

**Console > Management > MikroTik Users** lists the collected users with a
filter for Type, Status (Active or Inactive), and search text. It needs the
**MikroTik Admin** realm and offers a **Delete** action for selected users.

## How It Collects Data

The plugin registers the `poller_bottom` hook. At the end of each Cacti polling
cycle it starts `poller_mikrotik.php -M`, the master process, in the
background. The master:

1. Exits when the poller is disabled, or when another collector is still
   running.
2. Runs auto discovery when it is due.
3. Starts one collector process per device, up to **Maximum Concurrent
   Collectors**, and waits for them.
4. Purges devices removed from Cacti when **Automatically Purge Devices** is on.
5. Updates summary statistics and detects the device type.
6. Starts `poller_graphs.php`, which creates graphs when **Automatically Add New
   Graphs** is due.

Each collector runs the items that are due according to the frequency settings.
It reads the MikroTik MIB with SNMP and, when **MikroTik API Polling Enabled**
is on and the device has credentials, reads further data through the RouterOS
API. DHCP, DNS cache, and address list rows older than their retention setting
are deleted by the collector. Users that match **Exclude Users RegEx** are kept
for **Exclude Users Time to Live** after they disconnect.

The plugin keeps its data in tables whose names start with `plugin_mikrotik_`.
Graphing uses script server scripts in the plugin's `scripts` directory and the
matching definitions in `resource/script_server`.

## Command-Line Tools

Run the scripts from any directory as the user Cacti runs as. Each accepts
`--version` and `--help`.

```console
php plugins/mikrotik/poller_mikrotik.php [-M] [-f] [-fd] [-d]
php plugins/mikrotik/poller_mikrotik.php --host-id=N [--seed=N] [-f] [-d]
```

The first form is the master process that Cacti starts after each poll. The
second form collects one device. `-f` or `--force` forces collection, and `-d`
or `--debug` prints more output.

```console
php plugins/mikrotik/poller_graphs.php [-f] [-d]
```

Creates graphs as described under How It Collects Data. `-f` forces the run and
`-d` prints debug output.

## Troubleshooting

- **No data is collected:** check that **MikroTik Poller Enabled** is on and
  that the plugin is enabled. A disabled poller prints `The MikroTik Collection
  is Down!  Exiting`.
- **No API data:** check that **MikroTik API Polling Enabled** is on and that
  the device's **MikroTik Credentials** are filled in. Without credentials the
  plugin does not open an API connection.
- **SSL cannot be selected:** the plugin could not open a TLS connection to the
  device's api-ssl port (8729). Enable and verify the api-ssl service under
  **IP > Services** on the device.
- **A page is missing from the tab bar:** the tab appears only after the plugin
  has stored data for it.
- **Message `Another MikroTik Collector is still running!  Exiting`:** a master
  process is still active. A new one exits.

## More Information

- [MikroTik plugin repository](https://github.com/Cacti/plugin_mikrotik)
- [MikroTik README][mt-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[mt-devices]: images/plugin-mikrotik-devices.png
[mt-users]: images/plugin-mikrotik-users.png
[mt-readme]: https://github.com/Cacti/plugin_mikrotik/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
