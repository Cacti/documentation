# MacTrack

MacTrack scans switches and routers to associate MAC addresses, IP addresses,
VLANs, and switch ports. It keeps address history, can use arpwatch data, and
can notify administrators when a watched device reappears on the network.

## Requirements and current documentation

The current development plugin declares Cacti 1.2.29 or later in `INFO` and
requires PHP 8.2 for its supported runtime and toolchain. Use the requirements
for the release you install, including any higher requirements of Cacti itself.

Install the plugin as `plugins/mactrack` and enable it through
[Plugin Management](Plugins.md). For current commands and migration behavior,
see the [MacTrack README](https://github.com/Cacti/plugin_mactrack) and the
[release notes](https://github.com/Cacti/plugin_mactrack/releases).

## Mactrack setup

1. Check **Console > Configuration > Settings > Mactrack**.
2. Create a MacTrack site. MacTrack sites are separate from Cacti's core sites.
3. Add devices or import existing Cacti devices into MacTrack.
4. Define or enable matching Device Types and their scanning functions.
5. Optionally import the IEEE OUI database to identify MAC address vendors.

Older interfaces label MacTrack as **Device Tracking**. Menu wording in older
screenshots and releases can differ from the current plugin.

## Create site

Open **Console > Mactrack > Sites** and create a site before assigning devices
to it. Add devices under **Console > Mactrack > Devices**, or use the import
action for an existing Cacti device. A Cacti device does not become a MacTrack
device merely because both products have a site with the same name.

## Device types

Open **Console > Mactrack > Device Types**. A device needs a matching Device
Type and suitable scanning functions before MacTrack can collect its data.

| Field | Purpose |
| --- | --- |
| Description | Give the Device Type a recognizable name. |
| Vendor | Identify the device vendor. |
| Device Type | Select the hardware role so appropriate scanners are available. |
| System Description Match | Match the device's SNMP system description; `*` is the wildcard. A platform name is usually more useful than a firmware build string. |
| Vendor SNMP Object ID Match | Match its system object ID, such as `.1.3.6.1.4.1.9.1.696`. |
| MAC Address Scanning Function | Choose a scanner appropriate to the switch's layer-two forwarding data. |
| IP Address Scanning Function | Choose a scanner for the device's ARP or supported address-association data. |
| 802.1x Scanning Function | Select a supported scanner when collecting authentication data. |
| Serial Number Base OID | Optionally provide the OID for serial-number collection. |
| Serial Number Collection Method | Use a walk for multiple values or a get for a single value. |
| Low User Port Number | Set the first user port, or leave zero for automatic selection. |
| High User Port Number | Set the last user port, or leave zero for automatic selection. |

Device Types can be exported to CSV and imported through the same page. Keep a
copy of customized definitions before changing scanners or upgrading.

## Import OUI Database from IEEE

The OUI database associates MAC address prefixes with their registered vendors.
Use **Mactrack Tools > Tracking Utilities > Refresh IEEE Vendor MAC/OUI
Database**
when the server has Internet access.

For an offline import, download the IEEE database on a connected machine and
copy it to the Cacti server. From the plugin directory, run:

```console
php mactrack_import_ouidb.php -f=/tmp/oui.txt
```

Replace `/tmp/oui.txt` with the downloaded file. Run the command as the poller
user and check its imported-entry totals and any errors.

## History and partitioning

The current development plugin supports partitioned MAC and IP history,
resumable partition rebuilds, and per-device, per-site, and global rules for
ignoring ports while scanning. Use the instructions for your installed release
before applying these features.

Existing history is not rebuilt merely by changing the partition-size setting.
Back up the database and follow the README's partitioning procedure before
running a rebuild; it needs maintenance time and extra disk space. Run it as the
poller user. Do not remove a `*_rebuild` table after an interruption: follow the
documented resume procedure instead.

## Troubleshooting

Run commands from `<path_cacti>/plugins/mactrack` as the poller user.
Replace the sample site and device IDs with IDs from your installation.

For a site's poller in debug mode:

```console
php -q poller_mactrack.php -d -sid=1
php -q poller_mactrack.php --help
```

For one device's scanner:

```console
php -q mactrack_scanner.php -d -id=23
php -q mactrack_scanner.php --help
```

If a scanning function is missing from a Device Type's list, use
**Tracking Utilities > Refresh Scanning Functions** and check the Cacti log.
Confirm that the device's SNMP settings work and that its Device Type matches
before changing scanner code.

For a stalled history rebuild, inspect **View Partition Status** and the Cacti
log, then resume with the same rebuild command described in the README.

---

Copyright (c) 2004-2026 The Cacti Group
