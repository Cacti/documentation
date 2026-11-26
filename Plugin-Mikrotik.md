# MikroTik

The MikroTik plugin collects RouterOS data from MikroTik devices that are
already Cacti **Devices**, stores it in its own tables, and shows it on a
**MikroTik** tab: device summaries, users, queues, queue trees, interfaces,
DHCP leases, DNS cache, address lists and wireless information. It can also
create Cacti **Graphs** for these objects automatically. It is meant for
administrators of networks with MikroTik routers who want this data next to
their other Cacti graphs. It does not replace MikroTik's own management
interface.

## Requirements

- This page documents MikroTik 3.1 (release tag `v3.1`).

- Cacti 1.2.24 or later.

- No other plugin is required.

- The devices must be Cacti **Devices** with SNMP enabled. Most data is
  collected over SNMP.

- DHCP, DNS cache, address list and PPPoE user details are read through the
  RouterOS API, which the plugin reaches on TCP port 8728. This needs a
  read-only RouterOS user for each device and **MikroTik API Polling Enabled**.

- The main poller process fetches
  `http://upgrade.mikrotik.com/routeros/LATEST.6` at most once an hour to
  show the latest RouterOS version in the **Devices** header. This needs
  outbound HTTP access from the Cacti server.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named
`mikrotik`.

The plugin ships Cacti packages in its `templates` directory:
`MikroTik_Device.xml.gz` and `MikroTik_Switch_SWOS.xml.gz`. The
**MikroTik Device** package holds the **Device Template**,
**Graph Templates** and **Data Queries** used by the plugin's graphs. The
release README says to import it with Cacti's `import_package.php` script,
run from the Cacti base directory:

```console
php cli/import_package.php \
  --filename=plugins/mikrotik/templates/MikroTik_Device.xml.gz
```

Then:

1. Go to **Console > Configuration > Settings > MikroTik** and check the
   collection settings.

2. Assign the **MikroTik Device** device template to your MikroTik devices, if
   they use a different template, so that graph automation and the API
   credential fields apply to them.

3. For each device that should be polled through the RouterOS API, edit it
   under **Console > Management > Devices** and fill in the
   **MikroTik Credentials** section.

## Permissions

MikroTik registers two realms.

###### Table 1. MikroTik realms

| Realm               | Pages                | Purpose                                                 |
| ------------------- | -------------------- | ------------------------------------------------------- |
| **MikroTik Viewer** | `mikrotik.php`       | View the **MikroTik** tab and its data                  |
| **MikroTik Admin**  | `mikrotik_users.php` | Manage the user list under **MikroTik Users**           |

## Settings

The settings are on the **MikroTik** tab under
**Console > Configuration > Settings**.

###### Table 2. MikroTik General, Auto Discovery and Automation settings

| Label                                      | Default   | Purpose                                                                                   |
| ------------------------------------------ | --------- | ----------------------------------------------------------------------------------------- |
| **MikroTik Poller Enabled**                | On        | Turn MikroTik data collection on or off                                                   |
| **MikroTik API Polling Enabled**           | On        | Collect data through the RouterOS API as well as SNMP                                     |
| **Automatically Discover Cacti Devices**   | On        | Find Cacti devices that support the MikroTik MIB and add them to the plugin               |
| **Automatically Purge Devices**            | On        | Remove plugin data for devices that were removed from Cacti                               |
| **Maximum Concurrent Collectors**          | 10 Processes | Number of device collectors that run at the same time                                  |
| **Auto Discovery Frequency**               | 5 Minutes | How often to look for new Cacti devices                                                   |
| **DHCP Retention**                         | 4 Weeks   | How long to keep DHCP registration history                                                |
| **DNS Retention**                          | 4 Weeks   | How long to keep DNS cache history                                                        |
| **Address List Retention**                 | 4 Weeks   | How long to keep address list history                                                     |
| **Automatically Add New Graphs**           | Never     | How often to check for new objects to graph                                               |
| **Exclude Users RegEx**                    | `(^T-$)`  | User names matching this expression are not graphed automatically                         |
| **Exclude Users Time to Live**             | 1 Hour    | How long data of an excluded user is kept after the user disconnects                      |

Graph automation is off by default. Set **Automatically Add New Graphs** to a
frequency to have the plugin create graphs for new users, queues, interfaces
and other objects.

The remaining sections set how often each type of data is collected:
**MikroTik Device Collection Frequencies** (**Storage Frequency**,
**Processor Frequency**, **Interfaces Frequency**,
**DNS/DHCP/List Frequency**), **MikroTik Queue/Tree Collection Frequencies**
(**Simple Queue/PPPoe Frequency**, **Queue Trees Frequency**) and
**MikroTik Wireless Collection Frequencies**
(**Wireless HotSpot Users Frequency**, **Wireless Access Point Frequency**,
**Wireless Registrations Frequency**, **Wireless Stations Frequency**). Each
defaults to 5 minutes and can be set from 1 minute to 1 day, or to
**Disabled** to turn that collection off.

The **MikroTik Credentials** section on the device edit page has two fields,
**Read Only User** and **Password**. It is shown only for devices that use the
**MikroTik Device** device template. Once credentials are saved, the page
tests the API connection and shows the **Connection Result**.

## Using MikroTik

### The MikroTik Tab

Users with the **MikroTik Viewer** realm see a **MikroTik** tab at the top of
the Cacti window. Its sub-tabs are **Devices** and **Graphs**, plus one tab
for each type of data that has been collected: **Users**, **Queues**,
**Queue Trees**, **Interfaces**, **DHCP**, **DNS Cache**, **Address Lists**,
**Wireless Aps** and **Wireless Registrations**.

The **Devices** sub-tab lists each MikroTik device with its status, firmware
and license version, uptime, number of queue trees and users, CPU load,
processes, memory and disk use. Its header shows the latest RouterOS version.
The icons in the **Actions** column link to the device's users, queue trees,
simple queues, interfaces, wireless access points and graphs.

The following screenshot shows the **Devices** sub-tab with one test device.

![MikroTik Devices tab showing one RouterOS device with status, firmware
version, uptime, CPU, memory and disk usage][img-devices]

The **Users** sub-tab shows HotSpot and PPPoE users with their device, IP
address, MAC address, connect time, current, average and total traffic, and
the time they were last seen. **Active Users** limits the list to connected
users.

The following screenshot shows the **Users** sub-tab with three test PPPoE
users on one device.

![MikroTik Users tab listing three PPPoE users with IP address, MAC address,
connect time and traffic counters][img-users]

The **Graphs** sub-tab shows the Cacti graphs created for MikroTik objects.

### MikroTik Users

**Console > Management > MikroTik Users** lists every HotSpot and PPPoE user
the plugin has seen, filtered by **Type** (**Hotspot** or **PPPoe**) and
**Status** (**Active** or **Inactive**). The only action is **Delete**, which
removes the selected users and their graphs.

To remove a user that no longer exists:

1. Go to **Console > Management > MikroTik Users**.

2. Search for the user, select it and choose **Delete**.

3. Click **Go** and confirm with **Continue**.

## How It Collects Data

MikroTik adds a `poller_bottom` hook that starts `poller_mikrotik.php -M` in
the background after every Cacti polling cycle. The main process:

1. Exits if **MikroTik Poller Enabled** is off or the plugin is disabled.

2. Runs auto discovery when **Auto Discovery Frequency** has passed. Cacti
   devices with SNMP enabled that are not disabled are added when their system
   description contains `RouterOS` (and not `SwOS`) or when they use the
   **MikroTik Device** device template.

3. Starts one collector process per device, up to
   **Maximum Concurrent Collectors** at a time, and waits for them.

4. Purges data of removed devices when **Automatically Purge Devices** is on,
   updates summary statistics, and writes a `MIKROTIK STATS` line to the Cacti
   log.

5. Starts `poller_graphs.php`, which creates new graphs when
   **Automatically Add New Graphs** is due.

Each collector checks the device's collection times and only collects the
data whose frequency has passed. A device that is down in Cacti is skipped.
Data is stored in the `plugin_mikrotik_*` tables. DHCP, DNS cache and address
list history is deleted after its retention period, and objects that are no
longer present on the device are removed from the tables.

## Command-Line Tools

Run both scripts from the plugin directory as the user that runs the Cacti
poller. The poller hook starts them, so running them by hand is only needed
for testing.

`poller_mikrotik.php` is the collector. Its help text shows two forms:

```console
php poller_mikrotik.php [-M] [-f] [-fd] [-d]
php poller_mikrotik.php --host-id=N [--seed=N] [-f] [-d]
```

###### Table 3. poller_mikrotik.php options

| Option                         | Meaning                                                  |
| ------------------------------ | -------------------------------------------------------- |
| `-M`                           | Run as the main process for all devices                  |
| `--host-id=N`                  | Collect from one device (child process)                  |
| `-f`, `--force`                | Collect all data regardless of frequency                 |
| `-fd`, `--force-discovery`     | Force auto discovery                                     |
| `-d`, `--debug`                | Print debug messages                                     |
| `-V`, `-v`, `--version`        | Print the version                                        |
| `-H`, `-h`, `--help`           | Print the help text                                      |

`poller_graphs.php` creates graphs for new objects.

```console
php poller_graphs.php [-f] [-d]
```

`-f` (`--force`) runs graph automation even when it is not due, and `-d`
(`--debug`) prints debug messages. Automation does not run while
**Automatically Add New Graphs** is set to **Never**.

## Troubleshooting

- `WARNING: The MikroTik Collection is Down!  Exiting`: the plugin is disabled
  or **MikroTik Poller Enabled** is off.

- `WARNING: Another MikroTik Collector is still running!  Exiting`: the
  previous run has not finished. Reduce the collection frequencies or raise
  **Maximum Concurrent Collectors**.

- `ERROR: Device[N] for RouterOS API Call Timed Out.  Check for an invalid API
  password!` in the Cacti log: check the **MikroTik Credentials** of that
  device.

- The **MikroTik Credentials** section is missing on the device page: the
  device does not use the **MikroTik Device** device template.

- No graphs are created: **Automatically Add New Graphs** is **Never** by
  default, and the **MikroTik Device** package must be imported.

- Run `php poller_mikrotik.php --host-id=N -f -d` to see what is collected
  from one device.

## More Information

- [MikroTik plugin repository][repo]

- [MikroTik 3.1 README][readme]

[img-devices]: images/plugin-mikrotik-devices.png
[img-users]: images/plugin-mikrotik-users.png
[repo]: https://github.com/Cacti/plugin_mikrotik
[readme]: https://github.com/Cacti/plugin_mikrotik/blob/v3.1/README.md

---

Copyright (c) 2004-2026 The Cacti Group
