# Router Configs

The Router Configs plugin backs up the configuration of routers and switches on
a schedule, keeps the backups for a set period, and lets you view any backup
and compare two of them. It logs in to each device over SSH or Telnet and
tells the device to copy its configuration to a TFTP server on the Cacti
server, or downloads the configuration file directly over SCP or SFTP. It is
meant for network administrators who want a dated history of device
configurations next to their Cacti monitoring. The release README states that
it is designed primarily for Cisco devices but may work with other device
types.

## Requirements

- This page documents Router Configs 2.0 (release tag `v2.0`).

- Cacti 1.2.29 or later.

- No other plugin is required. When the Thold plugin's notification lists
  exist, the backup email can also go to a Thold notification list.

- A TFTP server on the Cacti server for device types that copy their
  configuration with a TFTP command. The web server user and the TFTP server
  both need access to the TFTP directory.

- PHP's `ssh2` extension for the SSH, SCP and SFTP connection types.

- For the **SCP** connection type an external `scp` program can be used
  instead of the `ssh2` extension's SCP support (see **SCP Path**).

The release README notes that if you run a Cacti version below 1.2.31, you
must add a small function to `include/layout.js` for the **Cancel** buttons on
the plugin's forms to work; the README gives the code.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named
`routerconfigs`.

When the plugin is installed it creates its tables and adds these device
types: **Cisco IOS**, **Cisco CatOS**, **Cisco Nexus**, **HP Comware** and
**Dell Switch**.

Before the first backup:

1. Set up the TFTP server so that it writes to a directory the web server user
   can read, if you use TFTP device types. The release README shows an
   example with `tftp-server` under `xinetd`, using
   `server_args = -c -s /home/configs/backups`.

2. Set **TFTP Server IP**, **TFTP Backup Directory Path** and
   **Archive Directory Path** under
   **Console > Configuration > Settings > Router Configs**.

3. Create a device type if none of the built-in ones fit, create an
   authentication account, and add the devices.

## Permissions

Router Configs registers one realm.

###### Table 1. Router Configs realm

| Realm              | Pages                                                                                              |
| ------------------ | -------------------------------------------------------------------------------------------------- |
| **Router Configs** | `router-devices.php`, `router-accounts.php`, `router-backups.php`, `router-compare.php`, `router-devtypes.php` |

The same realm controls the top tab, the console menu entry and the
**Add to RouterConfigs Backup** action on the Cacti **Devices** page.

## Settings

Router Configs adds a **Router Configs** tab under
**Console > Configuration > Settings**.

###### Table 2. General Settings

| Label                              | Default        | Purpose                                                                                          |
| ---------------------------------- | -------------- | ------------------------------------------------------------------------------------------------ |
| **Presentation Mode**              | Console        | Show Router Configs in the console menu or as a top tab                                          |
| **Config Diff Context Lines**      | 3 lines        | Unchanged lines shown around each change when comparing backups; can be changed per comparison   |
| **Default timeout**                | 1              | Seconds to wait for a response from a device                                                     |
| **Connection timeout**             | 10             | Seconds to wait for the initial connection; an unreachable device is skipped after this time     |
| **Default sleep time**             | 125000         | Microseconds to sleep while waiting for output                                                   |
| **Close without exit**             | Off            | Do not send `exit` when closing the connection                                                   |
| **Debug Connection Buffer**        | Off            | Log the raw input and output of each device connection                                           |
| **Assume all devices elevated**    | Off            | Treat every device as already in privileged mode                                                 |
| **Download Hour**                  | 00:00 (12am)   | Hour of the day for the full scheduled backup run                                                |
| **Retry Schedule**                 | 4 hours        | Wait time before retrying a failed scheduled backup; **Never** turns retries off                 |
| **Retention Period**               | 1 Month        | How long old backups are kept, from 1 month to 5 years                                           |
| **Keep Inactive Device Backups**   | Off            | Keep aged-out backups of disabled or removed devices                                             |

###### Table 3. Transfer Options

| Label                              | Default                                    | Purpose                                                                                 |
| ---------------------------------- | ------------------------------------------ | --------------------------------------------------------------------------------------- |
| **Default connection type**        | SSH/Telnet                                 | Connection type for devices and device types set to **Inherit**                         |
| **Separate By Device**             | On                                         | Store archived configurations in a folder per device                                    |
| **Dated Subdirectory**             | Off (no dated subdirectory)                | Add a date folder (`YYYY-MM-DD`, `YYYY/MM/DD` or `DD-MM-YYYY`) to the archive path       |
| **SCP Path**                       | Empty                                      | Path of an external `scp` program; empty uses PHP's SCP support                          |
| **Verify SSH Host Keys**           | Off                                        | Record each device's SSH host key on first connection and refuse to log in if it changes |
| **TFTP Server IP**                 | Address of the Cacti server's host name    | Address the devices send their configuration to; must point to the Cacti server          |
| **TFTP Backup Directory Path**     | `<cacti>/backups/`                         | Directory the local TFTP server writes to                                               |
| **Archive Directory Path**         | `<cacti>/plugins/routerconfigs/backups/`   | Directory the backups are moved to                                                      |

The **SCP Path** setting is not used while **Verify SSH Host Keys** is on.
With host key verification on, the **SSH/Telnet** connection type does not
fall back to Telnet.

###### Table 4. Email Options

| Label                         | Default | Purpose                                                                                                   |
| ----------------------------- | ------- | --------------------------------------------------------------------------------------------------------- |
| **From Address**              | Empty   | Sender address of the backup email                                                                        |
| **From Name**                 | Empty   | Sender name of the backup email                                                                           |
| **Email Address**             | Empty   | Comma-separated recipients of the backup email                                                            |
| **Include Config Diffs**      | Off     | Append a unified diff for each device whose configuration changed                                         |
| **Include Secrets in Diffs**  | Off     | Send secret values in the diff as they are; when off, lines that look like secrets are hidden             |
| **Diff Exclude Patterns**     | Empty   | Regular expressions, one per line, for lines to ignore when comparing                                     |
| **Thold Notification List**   | None    | Also send the email to a Thold notification list; shown only when Thold's notification lists exist        |

The diff always ignores some lines that change on every backup, such as the
Cisco IOS `! Last configuration change` and `ntp clock-period` lines.

## Using Router Configs

With the default **Presentation Mode**, open the plugin from
**Console > Utilities > Router Configs**. With **Top Tab**, a Router Configs
tab appears at the top of the Cacti window instead. The plugin's pages are tabs:
**Devices**, **Device Types**, **Authentication**, **Backups** and
**Compare**.

### Devices

The **Devices** tab lists the devices to back up with their device type,
connection type, IP address, TFTP server, number of backups, and the times of
the last and next backup and attempt. The actions menu offers **Backup**,
**Edit (bulk change settings)**, **Delete**, **Enable**, **Disable** and
**Clear SSH Host Key**. The bug icon in the **Actions** column opens the
**Router Debug Info** for the last connection.

The following screenshot shows the **Devices** tab with three test devices,
their last and next backup times, and links to their stored configurations.

![Router Configs Devices tab listing three devices with device type, connect
type, IP address, TFTP server and backup times][img-devices]

A device has these fields: **Enable Device**, **Description**, **IP Address**,
**TFTP Server** (blank uses the global setting), **Directory**, the schedule
fields, **Device Type** (**Auto-Detect** uses built-in Cisco-style defaults),
**Connection Type**, **Authentication Account**, **Default timeout**,
**Default sleep time** and **Assume elevated**. When host key verification is
used, the **Stored SSH Host Key** field shows the recorded fingerprint.

The schedule is set with **Schedule Type**: **Manual**, **Daily**, **Weekly**,
**Monthly** or **Monthly on Day**. **Rerun Every** sets the interval in days or
weeks; **Days of Week**, **Months of Year**, **Days of Month**,
**Weeks of Month** and **Days of Week (Monthly)** narrow weekly and monthly
schedules. A **Manual** device is only backed up through the **Backup**
action.

To add a device:

1. Create an account on the **Authentication** tab with a **Name**,
   **Username**, **Password** and, if the device needs one,
   **Enable Password**.

2. On the **Devices** tab, click the add icon.

3. Enter the **Description**, **IP Address** and **Directory**, choose the
   **Device Type**, **Connection Type** and **Authentication Account**, and set
   the schedule.

4. Save, select the device, choose **Backup** and click **Go** to test it.

Existing Cacti devices can be added in bulk: on **Console > Management >
Devices**, select them and choose **Add to RouterConfigs Backup**. Devices
already in Router Configs are skipped.

### Device Types

A device type describes how to log in and how to start the backup. Its fields
are **Name**, **Connection Type**, **Username Prompt**, **Password Prompt**,
**Configuration file** (the file to fetch with SCP or SFTP), **Copy TFTP** (the
command that sends the configuration to the TFTP server), **Show Version**,
**Confirmation Prompt**, **Confirm**, **Force Confirm**,
**Check End in Config**, **Assume elevated**, **Default timeout**,
**Default sleep time**, **Any Key prompt** and **Post-Login Prompts**.

**Post-Login Prompts** takes one `prompt|response` pair per line. The prompt is
a case-insensitive regular expression, and `<CR>` sends only a carriage
return, for example `Press any key|<CR>`.

Timeout, sleep, connection type and elevation are taken from the device first,
then its device type, then the global settings.

### Backups and Compare

The **Backups** tab lists stored backups with their directory, backup time,
time of the last change, the user who made the change, and the file name.
**View Config** shows the backup and **Compare** opens it on the **Compare**
tab.

The following screenshot shows the **Backups** tab with four backups of two
test devices.

![Router Configs Backups tab listing backups with hostname, directory, backup
time, last change, changed by and filename][img-backups]

The **Compare** tab compares two backups of the same device. **Diff Mode**
selects **Inline** or **Side by Side** output and **Context Lines** sets the
number of unchanged lines shown around each change.

## How It Collects Data

Router Configs adds a `poller_bottom` hook. In the first polling cycle of each
hour it starts `router-download.php` in the background. In the hour set by
**Download Hour** it runs a full backup of all enabled devices that are due;
in every other hour it runs in retry mode and only retries failed backups
whose retry time has come. A scheduled run exits if another run started less
than two hours earlier, unless it is forced.

For each device the plugin logs in with the selected connection type. TFTP
device types send the **Copy TFTP** command, and the plugin reads the file
from **TFTP Backup Directory Path**; SCP and SFTP download the
**Configuration file**. The configuration is then moved to
**Archive Directory Path**, into a per-device folder and dated folder if those
settings are on.

After a run the plugin sends the backup email, if recipients are set, and then
deletes backups older than **Retention Period** from the archive and from the
`plugin_routerconfigs_backups` table. That table and the archive directory
grow with each backup until retention removes old entries.

## Command-Line Tools

`router-download.php` runs a backup from the command line. Run it as the user
that runs the Cacti poller. The script has no help output; these options are
accepted by its option parser.

```console
php plugins/routerconfigs/router-download.php [options]
```

###### Table 5. router-download.php options

| Option                                  | Meaning                                                          |
| --------------------------------------- | ---------------------------------------------------------------- |
| `-h <ids>`, `--device=<ids>`, `--devices=<ids>` | Back up only these device IDs (comma-separated)         |
| `-d`, `--debug`                         | Print debug output                                               |
| `-b`, `--debug-buffer`                  | Print debug output and the raw connection buffer                 |
| `-r`, `--retry`                         | Retry mode: only retry failed backups                            |
| `-f`, `--force`                         | Back up all enabled devices whether or not they are due          |
| `--simulate-schedule`                   | Simulated scheduled run; the email subject is marked Simulated   |

Note that `-h` selects devices; it does not print help.

## Troubleshooting

- `FATAL: TFTP Backup Path is not set or is not a directory` or
  `FATAL: TFTP Server is not set` in the Cacti log: set
  **TFTP Backup Directory Path** and **TFTP Server IP**.

- `WARN: Backup already running since ...`: a previous run started less than
  two hours ago and has not finished.

- To see what a device sends and receives, turn on
  **Debug Connection Buffer**, or run
  `router-download.php --debug-buffer --devices=<id>`, and open the device's
  **Router Debug Info**.

- The release README states that some HP devices send ANSI codes instead of
  plain text and do not work with the plugin. The debug buffer shows whether a
  device is affected.

- After a legitimate SSH host key change on a device, use
  **Clear SSH Host Key** so the new key is recorded.

- SSH, SCP and SFTP need PHP's `ssh2` extension; without it the debug log
  reports that PHP does not have the ssh2 module.

## More Information

- [Router Configs plugin repository][repo]

- [Router Configs 2.0 README][readme]

[img-devices]: images/plugin-routerconfigs-devices.png
[img-backups]: images/plugin-routerconfigs-backups.png
[repo]: https://github.com/Cacti/plugin_routerconfigs
[readme]: https://github.com/Cacti/plugin_routerconfigs/blob/v2.0/README.md

---

Copyright (c) 2004-2026 The Cacti Group
