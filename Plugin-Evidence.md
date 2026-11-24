# Evidence

The Evidence plugin reads inventory information from Cacti Devices over
SNMP: Entity MIB data such as serial numbers, part numbers, hardware,
firmware and software revisions, the MAC and IP addresses of the Device, and
vendor-specific values for some vendors. It can collect this data on a
schedule, keep a history of changes, and send an e-mail when a Device's data
changes. Administrators use it to find a Device by serial number, check which
Devices run a given firmware version, and notice hardware replacements.

## Requirements

- This page documents Evidence release `v0.2`. The `INFO` file in that
  release still reports version 0.1.

- The release's `INFO` file declares compatibility with Cacti 1.0.0 or later
  (`compat`).

- No other plugin is required. E-mail notification is sent to the
  notification list selected for the Device by the Thold plugin, so it only
  works when Thold is installed and a list is assigned.

- Devices must have SNMP enabled. Data is collected with Cacti's own SNMP
  functions.

## Installation

Install the plugin as described in [Plugin Management](Plugins.md). Keep the
directory name `evidence` in lowercase and make the files readable by the
web server.

The plugin identifies vendors through the IANA enterprise numbers in
`data/enterprise-numbers.sql`. Loading them takes some time, so they are not
loaded during installation. The first background run imports the file
automatically when the `plugin_evidence_organization` table is empty. You can
also load it yourself with the MySQL client, as `data/README.md` in the
plugin describes.

When upgrading, the release README says to copy the new files over the old
ones, disable and uninstall the old version, import the enterprise numbers,
then install and enable the new version. Uninstalling drops the plugin's
tables and the collected history.

## Permissions

The plugin registers one realm. It controls the **Evidence** tab and the
**Evidence** link on the Device edit page. Within the plugin, a user only sees
Devices that Cacti allows that user to see.

###### Table 1. Evidence realm

| Realm                   | Pages                              |
| ----------------------- | ---------------------------------- |
| Plugin evidence - view  | `evidence.php`, `evidence_tab.php` |

## Settings

The settings are on **Console > Configuration > Settings > Evidence**.

###### Table 2. Evidence settings

| Label                                     | Default   | Purpose                                                                                                   |
| ----------------------------------------- | --------- | --------------------------------------------------------------------------------------------------------- |
| How often gather data                     | Every day | How often data is collected in the background: **Disabled**, **Every 6 hours**, **Every day** or **Every week**. When disabled, you can only view live data for a single Device. |
| When evidence will be started             | `01:30am` | The base time for collection. With **Every day**, collection starts at about this time each day.         |
| How many changes store in database        | 10 records | How many changed records to keep per Device: **Without history**, 2, 10 or 30.                          |
| Send email on evidence information change | Unchecked | Send an e-mail when collected data differs from the stored data.                                         |
| Excluded notification Host IDs            | Empty     | Comma-separated Device IDs that never trigger an e-mail.                                                  |
| Excluded notification device templates    | Empty     | Comma-separated Device Template IDs that never trigger an e-mail.                                         |

## Using Evidence

### Viewing one Device

Open a Device under **Console > Management > Devices**. When you have the
Evidence realm, an **Evidence** link appears at the top of the Device edit
page. Clicking it queries the Device over SNMP and shows its current data.
Disabled Devices and Devices that are not up show no live data. When history
is stored, a **Show older records** link opens the stored records on the
**Evidence** tab.

### The Evidence tab

Click the **Evidence** tab. With no filter applied, the page shows how many
Devices, Entity MIB records, vendors, unique MAC and IP addresses and vendor
records are stored, and the date of the oldest record.

To display stored data:

1. Select a **Device**, or a **Template** to show every Device that uses that
   Device Template.

2. Optionally pick a **Scan date**. Only the data that changed at that scan
   is shown; data that did not change then is not displayed.

3. Click **Go**.

The **Show or hide** checkboxes narrow the results to Entity MIB data, MAC
addresses, IP addresses, vendor-specific data or vendor optional data.
**Expand all dates** shows every stored scan instead of only the latest.

To search all stored data, type 3 to 20 characters into **Search** and click
**Go**. You can search for a serial number, firmware version, IP address,
MAC address or other value. Letters, digits and the characters `_ - . : +`
are accepted.

### Vendor-specific data

Besides the Entity MIB, MAC addresses (`ifPhysAddress`) and IP addresses,
the release ships vendor-specific SNMP queries for Aruba and HPE, Cisco,
Fortinet, MikroTik, QNAP and Synology Devices. They are stored in the
`plugin_evidence_specific_query` table and selected by the vendor's
enterprise number. Some queries are marked optional; their results appear as
vendor optional data and are not used to detect changes.

## Background Processing

On every polling cycle the `poller_bottom` hook checks whether a collection
is due. A run starts when **How often gather data** is not **Disabled**, the
selected interval has passed since the last run, and the current time is
within five minutes of **When evidence will be started**. The hook then
starts `poller_evidence.php --id=all` in the background.

The collector:

- imports the enterprise numbers first if fewer than 10 are loaded;

- exits without collecting when
  **How many changes store in database** is **Without history**;

- polls every Device that is enabled, is up or recovering, and has SNMP
  enabled;

- compares the new data with the most recent stored records and stores a new
  set only when something changed;

- sends the e-mail notification for changed Devices that are not excluded,
  or only logs the change when notification is disabled;

- deletes records beyond the configured history count for each Device.

At the end it writes an `EVIDENCE STATS:` line with the run time and record
counts to the Cacti log. Deleting a Device in Cacti also deletes its Evidence
records.

The plugin's tables are `plugin_evidence_entity`, `plugin_evidence_mac`,
`plugin_evidence_ip` and `plugin_evidence_vendor_specific`, which hold the
history, plus `plugin_evidence_organization` and
`plugin_evidence_specific_query`. History size is bounded by the history
count per Device.

## Command-Line Tools

`poller_evidence.php` is the collector. Run it by hand to collect one Device
or all Devices, for example while testing:

```console
php plugins/evidence/poller_evidence.php --id=all --debug
php plugins/evidence/poller_evidence.php --id=12
```

- `--id=N` collects the Device with ID N, or all Devices with `--id=all`.
  This option is required.

- `--force` is listed in the help as forcing execution for testing. In this
  release the collector runs the same way with or without it.

- `--debug` prints progress for each Device.

- `--version` and `--help` print the version or usage.

## Troubleshooting

- `No data. Allow periodic scan and store history in settings` on the
  **Evidence** tab means **How often gather data** is **Disabled** or
  **How many changes store in database** is **Without history**.

- `Search string must be 3-20 characters` means the search text is too
  short or too long.

- If the enterprise numbers cannot be imported, the collector stops. With
  `--debug` it prints `Import enterprise numbers failed. Cannot continue.`
  Import `data/enterprise-numbers.sql` with the MySQL client.

- Some Devices report hardware changes often. Add their Device IDs or Device
  Template IDs to the exclusion settings to stop the e-mails while keeping the
  history.

- The collector runs only near the configured start time. If the Cacti
  poller does not run within five minutes of that time, the scheduled
  collection is skipped until the next interval.

## More Information

- [Evidence plugin repository](https://github.com/Cacti/plugin_evidence)

- README for release v0.2:
  [README.md](https://github.com/Cacti/plugin_evidence/blob/v0.2/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
