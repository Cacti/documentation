# APC UPS

The APC UPS plugin monitors uninterruptible power supplies from Cacti. It reads
UPS status from an `apcupsd` daemon, from a Network UPS Tools (NUT) `upsd`
server, or from a UPS that has an SNMP agent, stores the readings in the Cacti
database, and shows them on a fleet dashboard and on a dashboard for each UPS.
It is for administrators who need to track data center or office UPS units that
do not offer SNMP themselves but are reachable through `apcupsd` or NUT.

This page follows the plugin's `develop` branch, which is unreleased and can
change. That branch declares plugin version 1.4.0 and Cacti compatibility
1.2.29 in its `INFO` file. Check the release you install for differences.

## Requirements

- Plugin version 1.4.0 and Cacti 1.2.29 or later, as declared in `INFO`.
- The plugin does not require other plugins.
- For a UPS of type **APC UPSD Based**, the `apcupsd` daemon on the UPS host
  with its network information server enabled (`NETSERVER on`, TCP port 3551
  unless `NISPORT` says otherwise). The Cacti poller must be able to open a TCP
  connection to it.
- For a UPS of type **NUT Based**, a NUT `upsd` server that the poller can
  reach, by default on TCP port 3493. The `openssl` PHP extension is needed
  for the **Use TLS (STARTTLS)** option.
- For a UPS of type **SNMP Based**, a Cacti device with working SNMP settings.
- `apcupsd`, `apcaccess`, and the NUT client tools do not have to be installed
  on the Cacti poller. The plugin speaks both network protocols itself.
- The Cacti poller. The plugin starts its collector at the end of every polling
  cycle, using the PHP binary configured in Cacti (`path_php_binary`).
- The `INFO` file declares support for remote data collectors
  (`remote_collect:1`). Each UPS has a **Poller ID**, and the plugin replicates
  its UPS tables to remote pollers.

## Installation

Follow [Plugin Management](Plugins.md) to install and enable the plugin. The
directory must be named `apcupsd`. Plugin-specific steps:

1. Import the device package from the plugin's `templates` directory,
   `UPS_APC_UPSD_Device_12x.xml.gz`, with **Console > Import/Export > Import
   Templates**. It supplies the device template that the plugin uses to create
   a Cacti device for each UPS. Until it is imported, the poller writes the log
   line `UPSD Device Package Not Imported.  Device automation will not happen
   until it is imported!` and does not create devices.
2. Enable the network information server on each `apcupsd` host. In
   `apcupsd.conf`, `NISIP` is the address the daemon listens on, not a list of
   allowed clients. The default `0.0.0.0` listens on every interface. Allow the
   poller in through the host firewall on the server port. The README notes that
   the network information server has no authentication and is read-only, so
   expose it only to networks you trust.
3. For NUT, `upsd` listens on localhost by default. To let the poller reach it,
   add a `LISTEN` line to `upsd.conf` (for example `LISTEN 0.0.0.0 3493`),
   restart `upsd`, and allow the poller through the firewall.

The dashboards read each reading's minimum, average, and maximum from the RRD
files of the UPS's Cacti device, so the device needs its graphs. If a device
has none, for example because the package was imported afterward, select the UPS
on the **UPSes** page and choose **Run Graph Automation** from the action
drop-down. This action is offered only to users who have the permission
equivalent to Cacti's **Apply Automation Rules** device action.

When the version in `INFO` differs from the stored version, the plugin
reconciles its tables the next time **Plugin Management** or the **UPSes** page
is opened.

## Permissions

| Realm | Pages |
| --- | --- |
| **Manage UPS's** | `upses.php`: the UPS list, UPS editor, UPS dashboards, and fleet dashboard |

The plugin adds this realm to Cacti's **System Administration** role when the
role helper exists.

## Settings

The plugin adds no tab to **Console > Configuration > Settings**. All
configuration is per UPS, on the UPS editor page. Open **Console > Management >
UPSes**, then add a UPS or edit an existing one.

| Field | Default | Purpose |
| --- | --- | --- |
| **UPS Name** | New UPS | The name of the UPS. For `apcupsd` and NUT UPSes, a Cacti device with this name is created automatically. For SNMP UPSes, create the Cacti device first. |
| **UPS Description** | | A longer description. |
| **UPS Type** | | **APC UPSD Based**, **SNMP Based**, or **NUT Based**. |
| **Poller ID** | 1 | The poller that monitors this UPS. |
| **Site Name** | | The site the UPS belongs to. |
| **Location** | | Free-form physical location, such as a room or rack. |
| **Cacti Device** | Autocreate on First Poll | For SNMP UPSes, the Cacti device that supplies the SNMP credentials. Otherwise select None and the plugin creates the device. |
| **Enabled** | on | Starts polling the UPS immediately. |

The **APC UPSD Information** section applies to `apcupsd` and NUT UPSes:

| Field | Default | Purpose |
| --- | --- | --- |
| **Hostname** | | The host running `apcupsd` or the NUT server (`upsd`). |
| **TCP Port** | | The TCP port. `apcupsd` defaults to 3551 and NUT to 3493. |
| **Timeout (seconds)** | 5 | How long the poller waits for the server, from 1 to 120 seconds. SNMP UPSes use the SNMP timeout instead. |

The **NUT Options** section applies to NUT UPSes:

| Field | Default | Purpose |
| --- | --- | --- |
| **NUT UPS Name** | | The UPS name on the NUT server, as listed by `upsc -l`. One server can serve several UPSes; add one UPS per name. |
| **NUT Username** | | Optional `upsd.users` account. Leave blank for anonymous read-only access. |
| **NUT Password** | | The password for the NUT user. |
| **Use TLS (STARTTLS)** | off | Encrypts the connection before credentials are sent. The server certificate and host name are verified. |
| **CA / Certificate File** | | Optional full path on the poller to a PEM file with the CA certificate, or the self-signed server certificate, to verify the server against. The host name must match the certificate. |
| **Allow Self-Signed Certificate** | off | Accepts any certificate without checking it. The setting's description advises preferring the certificate file. |

The **SNMP Options** section applies to SNMP UPSes and takes the hostname of the
SNMP agent.

## Using APC UPS

**Console > Management > UPSes** opens the UPS list, with the tabs **UPSes** and
**Fleet Dashboard**. The list shows, per UPS, the name, status, collector, UPS
status, model, line voltage, load percent, estimated power, time left,
`Hostname:Port`, enabled state, and last update time. Select UPSes and use the
action drop-down:

| Action | Effect |
| --- | --- |
| **Delete** | Deletes the selected UPSes. |
| **Enable** | Starts polling the selected UPSes. |
| **Disable** | Stops polling the selected UPSes. |
| **Duplicate** | Copies the selected UPSes under a new name. |
| **Reset Detection** | Clears the stored list of SNMP readings that the poller skipped for the UPS. |
| **Run Graph Automation** | Runs graph automation for the linked Cacti device. |

The **Fleet Dashboard** shows these cards: Fleet Overview, Status Distribution,
Fleet Readings, Fleet Power, Fleet Gauges, and UPSes. A **Timespan** drop-down
sets the period for the readings, **Add a card** adds a card you removed, and
**Refresh** sets an automatic refresh interval.

The following screenshot shows the Fleet Dashboard. The example uses synthetic
data from three test UPSes.

![Fleet Dashboard for three synthetic UPSes][apc-fleet]

Selecting a UPS opens its **UPS Dashboard** with the cards UPS Information, one
gauge card per available reading, Estimated Power, Input and Load, Battery and
Runtime, and Events and Transfers.

### Adding a UPS

1. Open **Console > Management > UPSes** and add a UPS.
2. Enter a **UPS Name** and choose the **UPS Type**.
3. Enter the **Hostname** and **TCP Port**. For NUT, also enter the **NUT UPS
   Name** and, if needed, the credentials and TLS options.
4. Leave **Enabled** checked and save.
5. After the next polling cycle, the plugin creates the Cacti device for an
   `apcupsd` or NUT UPS if the device package is imported.

For a UPS with SNMP, select the **Cacti Device** that holds its SNMP
credentials instead.

## How It Collects Data

The plugin registers the `poller_bottom` hook. At the end of each Cacti polling
cycle it starts `poller_apcupsd.php` in the background. The poller handles the
enabled UPSes of each type that belong to its own poller ID, in this order:
`apcupsd`, SNMP, NUT. It stores the readings in the plugin's tables
`apcupsd_ups` and `apcupsd_ups_stats` and writes a summary line tagged
`APCUPSD STATS` to the Cacti log.

- **APC UPSD Based:** the poller asks the daemon for its status over the
  `apcupsd` network protocol.
- **NUT Based:** the poller talks to `upsd` with a PHP implementation of the NUT
  protocol. NUT power flags are translated to the `apcupsd` vocabulary (`OL`
  becomes `ONLINE`, `OB` becomes `ONBATT`, `LB` becomes `LOWBATT`, `RB` becomes
  `REPLACEBATT`, `OVER` becomes `OVERLOAD`), so the dashboards treat both types
  the same way.
- **SNMP Based:** the poller reads the UPS through the linked Cacti device's
  SNMP settings.

The estimated watts shown on the dashboards are computed from the nominal power
rating and the load. The README states that measured real power from NUT
(`ups.realpower`) is not stored yet.

## Command-Line Tools

The poller script is normally started by Cacti. It can be run by hand from any
directory as the user Cacti runs as:

```console
php plugins/apcupsd/poller_apcupsd.php [--force] [--debug]
```

`--debug` prints more output. `--version` prints the version.

## Troubleshooting

- **No Cacti device is created:** import the device package. Without it the
  poller logs `UPSD Device Package Not Imported`.
- **Log message `apcupsd query for UPS ... failed`:** the poller could not read
  status from the `apcupsd` server. Check the hostname, port, and firewall, and
  that `NETSERVER` is on. A `NUT query for UPS ... failed` message means the
  same for a NUT server.
- **Cannot connect from a remote poller:** `NISIP` set to `127.0.0.1` makes
  `apcupsd` accept only local connections.
- **Dashboards show no min, average, or max values:** the UPS's Cacti device has
  no graphs. Run **Run Graph Automation** from the UPS list.
- **UPS not polled:** check that **Enabled** is on and that the UPS's **Poller
  ID** matches the poller that runs the collector.

## More Information

- [APC UPS plugin repository](https://github.com/Cacti/plugin_apcupsd)
- [APC UPS README][apc-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[apc-fleet]: images/plugin-apcupsd-fleet.png
[apc-readme]: https://github.com/Cacti/plugin_apcupsd/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
