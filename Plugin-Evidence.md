# Evidence

The Evidence plugin collects hardware and software inventory from devices over
SNMP and keeps a history of what changed. It records SNMP system information,
Entity MIB data such as serial numbers and hardware, firmware, and software
revisions, MAC and IP addresses, and some vendor-specific data. It is for
administrators who need to answer questions such as which device carries a given
serial number or firmware version, and when a part was replaced.

This page follows the plugin's `main` branch, which is unreleased and can
change. That branch declares plugin version 0.4 and Cacti compatibility 1.2.32
in its `INFO` file. Check the release you install for differences.

## Requirements

- Plugin version 0.4 and Cacti 1.2.32 or later, as declared in `INFO`.
- The plugin does not require other plugins.
- Devices with SNMP enabled in Cacti. The plugin uses Cacti's own SNMP
  functions and each device's SNMP settings, and reads the Entity MIB
  (`.1.3.6.1.2.1.47.1.1.1.1`) among others.
- The Cacti poller. When a collection is due, the plugin starts its own
  collector at the end of a polling cycle, using the PHP binary configured in
  Cacti (`path_php_binary`).
- Files readable by the web server and poller accounts.
- The `INFO` file declares no support for remote data collectors
  (`remote_collect:0`).

## Installation

Follow [Plugin Management](Plugins.md) to install and enable the plugin. The
directory must be named `evidence`. Plugin-specific steps:

1. Install and enable the plugin, and grant the **Plugin evidence - view** realm
   to the users who need it.
2. Open **Console > Configuration > Settings** and select the **Evidence** tab.
   Choose how often to gather data and how much history to keep.
3. Check SNMP access to a supported device and confirm that a polling cycle
   records it.

The first time the collector runs it checks the `plugin_evidence_organization`
table. When the table holds fewer than 10 rows, it imports the vendor reference
data from `data/enterprise-numbers.sql`. The collector first writes a message
to the Cacti log that the table is empty and that the import can take a few
minutes. The import is not part of installation.

### Upgrade and Uninstall

The plugin's configuration check runs its database upgrade, including
repointing its hooks from an old `include/` directory to `includes/`. A normal
upgrade does not require uninstalling the plugin, and the README advises backing
up the Cacti database and the plugin configuration before replacing files.
Uninstalling offers to remove the plugin's data; choosing that drops the
`plugin_evidence_` tables.

## Permissions

| Realm | Pages |
| --- | --- |
| **Plugin evidence - view** | `evidence.php` and `evidence_tab.php`, the Evidence tab and the device view |

A user sees the data of the devices that user is allowed to see in Cacti. The
plugin shows `Permission issue` when a user requests a device outside that set.

## Settings

Settings are in **Console > Configuration > Settings**, on the **Evidence** tab.

| Setting | Default | Purpose |
| --- | --- | --- |
| **How often gather data** | Every day | Choices: Disabled, Every 6 hours, Every day, Every week. When disabled, you can only view data for a specific device. |
| **When evidence will be started** | 01:30am | The base time for gathering. For example, with `12:00am` and once per day, the run begins at about midnight every day. |
| **How many changes store in database** | 10 records | History records kept for each device. Choices: Without history, 2, 10, or 30 records. |
| **Display information on device edit page** | off | Shows the evidence data at the bottom of the device edit page. |
| **Send email on evidence information change** | off | Sends an email when the plugin finds a change. |
| **Excluded notification Host IDs** | empty | Device IDs, separated by commas, that never trigger a notification. For devices that report hardware changes too often. |
| **Excluded notification device templates** | empty | Device template IDs, separated by commas, that never trigger a notification. |

## Using Evidence

The **Evidence** tab appears in Cacti's top tabs for users who have the
**Plugin evidence - view** realm. The device edit page also has an **Evidence**
link, which opens the data for that device.

The Evidence tab has these filters:

| Filter | Purpose |
| --- | --- |
| **Device** | Shows one device. |
| **Template** | Shows all devices that use one device template. |
| **Scan date** | **Only last changed states** or **All history**, or a single scan date. |
| **Search** | Searches any string in all data, such as a serial number, firmware version, IP address, or MAC address. |
| **Show or hide** | Switches for SNMP info, Entity MIB, Mac addresses, IP addresses, Vendor specific data, and Vendor optional data, and for expanding all dates or only the latest date. |

The following screenshot shows the Evidence tab after a search. The example uses
synthetic device names and data.

![Evidence tab with a search result for four synthetic devices][evidence-img]

When a search returns results, an **Export** button appears next to the filter
buttons. It opens the results in a print view in a new window, so allow pop-ups
for the Cacti site. Use the **Print** button in that window to print the results
or save them to PDF.

Without a filter, the tab shows record counts: devices, Entity MIB records and
vendors, unique MAC addresses, unique IP addresses, vendor-specific data, and
the oldest record. If it shows the message `No data. Allow periodic scan and
store history in settings`, enable **How often gather data** and a history
size.

To find a part by serial number:

1. Open the **Evidence** tab.
2. Enter the serial number in **Search**.
3. Choose **All history** under **Scan date** to include older records.
4. Click **Go**.

### Email Notifications

With **Send email on evidence information change** on, the collector sends an
email when it finds a change in a device's evidence data. Devices listed in
**Excluded notification Host IDs**, or using a template listed in **Excluded
notification device templates**, are logged but do not send email.

## Background Processing

The plugin registers the `poller_bottom` hook. At the end of each polling cycle
it checks whether a collection is due. A collection starts when **How often
gather data** is not **Disabled**, the time since the last run is longer than
the chosen interval, and the current time is within five minutes of **When
evidence will be started**. It then runs `poller_evidence.php --id=all` in the
background.

The collector processes devices that are enabled and have a status of up or
recovering. For each device it identifies the vendor from the SNMP enterprise
number, gathers SNMP system information, Entity MIB data, MAC and IP addresses,
and vendor-specific data, compares them with the stored data, and records a new
history entry when something changed. It keeps at most **How many changes store
in database** history records per device. With **Without history**, it exits
without collecting. When a device is
deleted in Cacti, the plugin deletes that device's evidence data. At the end the
collector writes a summary line tagged `EVIDENCE STATS` to the Cacti log.

## Command-Line Tools

Run the collector from the Cacti directory as the user Cacti runs as.

```console
php plugins/evidence/poller_evidence.php [--force] [--debug]
```

```console
  --id=N        - run for a specific Device or 'all' for all devices
  --force       - force execution, e.g. for testing
  --debug       - debug execution, e.g. for testing
```

The script requires `--id`. Use `--id=all` or the numeric ID of one device.

## Troubleshooting

- **No data on the Evidence tab:** enable **How often gather data** and a
  history size other than **Without history**.
- **Nothing is collected at the expected time:** the collection starts only
  within five minutes of **When evidence will be started** and only when the
  interval has passed. Raise Cacti's log level to HIGH to see lines such as
  `Not Time to Run` written with the `EVIDENCE` tag.
- **Collector exits at once:** another Evidence process is still running, or the
  enterprise number import failed. The collector stops when the import fails.
- **`Disabled/down device. No actual data`:** the device is disabled or not up,
  so the plugin has no current data for it.

## More Information

- [Evidence plugin repository](https://github.com/Cacti/plugin_evidence)
- [Evidence README][evidence-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[evidence-img]: images/plugin-evidence-search.png
[evidence-readme]: https://github.com/Cacti/plugin_evidence/blob/main/README.md

---

Copyright (c) 2004-2026 The Cacti Group
