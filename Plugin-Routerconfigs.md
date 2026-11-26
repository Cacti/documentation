# Router Configs

Router Configs backs up the configuration of routers and switches, keeps the
earlier versions in an archive, and shows the differences between two backups.
It is for network administrators who want a record of device configuration
changes next to their monitoring. Depending on the device type, a backup
either has the device copy its configuration to a TFTP server or has the
plugin capture the output of a command over SSH.

This page follows the plugin's `develop` branch, which is unreleased and can
change. The branch declares version 2.1 and Cacti compatibility 1.2.29 in its
`INFO` file. Do not treat this page as a description of a released version.

## Requirements

- Version 2.1 and Cacti 1.2.29 or later, as declared in `INFO`. No other plugin
  is required.
- For TFTP device types: a TFTP server that the devices can reach, and a
  backup directory that the TFTP server writes to and that the poller user can
  read.
- For SSH capture device types and for SSH, SCP and SFTP connections: the PHP
  `ssh2` extension. Without it the plugin logs that PHP does not have the ssh2
  module installed. SSH capture device types do not need a TFTP server.
- Optionally an external `scp` binary, set in **SCP Path**.
- Optionally the Thold plugin. The **Thold Notification List** setting appears
  only when Thold's `plugin_notification_lists` table exists.
- The PHP binary path from Cacti's **Paths** settings, which the poller uses
  to start the backup script. If it is empty, `php` is used.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md), installing the
plugin in `plugins/routerconfigs`.

After installation:

1. Grant the **Router Configs** realm to the users who manage backups.
2. Set the transfer options under **Console > Configuration > Settings >
   Router Configs**. At minimum review **TFTP Server IP**, **TFTP Backup
   Directory Path** and **Archive Directory Path**.
3. Create an authentication account, check the device type for your device
   and create the device.

Make sure the account that runs the poller can write to the archive directory,
and that the TFTP server and the poller user can both use the TFTP backup
directory. The plugin's README lists the permissions to verify.

On install and upgrade the plugin adds built-in device types. A device type
with the same name that already exists is never overwritten. The built-in
types are Cisco IOS, Cisco CatOS, Cisco Nexus, HP Comware, Dell Switch, Ruckus
ICX, Ubiquiti EdgeSwitch, Netgear Managed and TP-Link JetStream (TFTP), and
MikroTik RouterOS, Juniper Junos, Arista EOS, HPE Aruba CX, Extreme EXOS,
Huawei VRP and Fortinet FortiOS (SSH capture). Prompts and commands differ
between models and firmware, so check each definition against your devices.

The plugin's README notes that on Cacti releases below 1.2.31 the Cancel
buttons on forms need a click binding for the `cactiReturnTo` class in
Cacti's `include/layout.js`. See the README for the snippet.

## Permissions

The plugin registers one realm in `setup.php`.

| Realm | Pages covered |
| --- | --- |
| Router Configs | `router-devices.php`, `router-accounts.php`, `router-backups.php`, `router-compare.php`, `router-devtypes.php` |

## Settings

Settings are on the **Router Configs** tab of **Console > Configuration >
Settings**, in three sections.

### General Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **Presentation Mode** | Console | Show Router Configs on the Console or as a top tab. |
| **Config Diff Context Lines** | 3 | Unchanged lines shown around each change when comparing backups. The Compare page can override it. |
| **Default timeout** | 1 | Seconds to wait for a response. |
| **Connection timeout** | 10 | Seconds to wait when establishing the initial connection. A hung device is abandoned so the run continues. |
| **Default sleep time** | 125000 | Sleep time in microseconds. |
| **Close without exit** | off | When ticked, no `exit` command is sent when closing a device connection. |
| **Debug Connection Buffer** | off | Log the direct output of the device connection. |
| **Assume all devices elevated** | off | Assume that all devices are elevated. |
| **Download Hour** | 0 | Hour of the day (0 to 23) for the full downloads. |
| **Retry Schedule** | 4 | Time to wait before another attempt when a scheduled download fails. |
| **Retention Period** | 30 | Days to retain old backups. |
| **Keep Inactive Device Backups** | off | Keep aged-out backups of disabled or removed devices when the retention cleanup runs. |

### Transfer Options

| Setting | Default | Purpose |
| --- | --- | --- |
| **Default connection type** | SSH/Telnet | Default connection type for devices that inherit it. The choices are SSH/Telnet, SSH, Telnet, SCP and SFTP. |
| **Separate By Device** | on | Archive configurations in a folder per device. |
| **Dated Subdirectory** | off | Insert a date-based subdirectory into the archive path, before the per-device folder. |
| **SCP Path** | empty | External SCP binary. Empty uses PHP's SCP module. External SCP is disabled while SSH host key verification is on. |
| **Verify SSH Host Keys** | off | Record each device's SSH host key on first connect and refuse to send credentials if it later changes. SSH/Telnet mode does not fall back to Telnet while this is on. |
| **TFTP Server IP** | address of the Cacti host name | Address of the Cacti server, as seen by the devices. |
| **TFTP Backup Directory Path** | `<Cacti base path>/backups/` | Directory the TFTP server writes to. |
| **Archive Directory Path** | `<Cacti base path>/plugins/routerconfigs/backups/` | Directory backups are archived to (moved from the TFTP directory). |

### Email Options

| Setting | Default | Purpose |
| --- | --- | --- |
| **From Address** | empty | Sender address of the nightly backup email. |
| **From Name** | empty | Sender name of the nightly backup email. |
| **Email Address** | empty | Comma delimited list of recipients. |
| **Include Config Diffs** | off | Append a unified diff of each changed device to the email. Binary configurations are skipped. |
| **Include Secrets in Diffs** | off | Send secret values in the emailed diff as they are. When off, secret-like lines are redacted. |
| **Diff Exclude Patterns** | empty | Regular expressions, one per line, for configuration lines to ignore when comparing. |
| **Thold Notification List** | None | Also send the email to the recipients of this Thold notification list. Shown only when Thold is installed. |

## Using Router Configs

The plugin adds **Console > Utilities > Router Configs** when **Presentation
Mode** is **Console**. When it is **Top Tab**, a tab appears for users with the
realm instead. The pages share a row of tabs: **Devices**, **Device Types**,
**Authentication**, **Backups** and **Compare**.

The following screenshot shows the device list with synthetic data: three
example devices with their last backup, device type, connection type, number of
stored configurations, schedule and directory columns.

![Device list with three synthetic devices][img-routerconfigs-devices]

The next screenshot shows the **Backups** tab with four synthetic stored
configurations, each with **View Config** and **Compare** links.

![Backups list with four synthetic backups][img-routerconfigs-backups]

### Set up a device

1. On the **Authentication** tab, add an account with a name, username,
   password and, if needed, an enable password.
2. On the **Device Types** tab, check the device type you need or add one. A
   device type holds the connection type, username and password prompts, the
   **Copy TFTP** command, an optional **Capture Command**, **Show Version**,
   confirmation prompts, timeouts, **Any Key prompt** and **Post-Login
   Prompts**. A **Capture Command** always runs over SSH and needs no TFTP
   server.
3. On the **Devices** tab, add a device. Set **Description**, **IP Address**,
   **Device Type**, **Connection Type**, **Authentication Account** and the
   schedule. The optional **TFTP Server** overrides the global setting.
4. Choose the schedule with **Schedule Type**, **Rerun Every**, and, for
   weekly and monthly schedules, **Days of Week**, **Months of Year**, **Days
   of Month**, **Weeks of Month** and **Days of Week (Monthly)**.

Device bulk actions are **Backup**, **Edit (bulk change settings)**,
**Delete**, **Enable**, **Disable** and **Clear SSH Host Key**. **Backup**
starts a backup of the selected devices immediately. Use **Clear SSH Host
Key** after a legitimate host key change when **Verify SSH Host Keys** is on.

The plugin also adds an **Add to RouterConfigs Backup** action to the Cacti
devices list, which adds the selected devices to Router Configs and skips any
that are already present.

### Compare two backups

1. On the **Backups** tab, select **Compare** for a stored configuration, or
   open the **Compare** tab.
2. Choose the two backups. Set **Diff Mode** to **Inline** or **Side by
   Side**, and the number of **Context Lines**.
3. The **Compare Output** box shows the differences, or "There are no
   Changes".

## Background Processing

Router Configs hooks into `poller_bottom`. During the first poller interval of
every hour it starts `router-download.php` in the background. In the hour set
by **Download Hour** this is a full run. In other hours the script is started
with `--retry`, which only selects enabled devices whose retry attempt time
(set after a failed backup) has come. In a normal run each enabled device is
backed up when its next backup time has come. A device with the Manual
schedule type is backed up only through the **Backup** action. After a
run, the retention cleanup deletes backups older than **Retention Period**
days, except for disabled or removed devices when **Keep Inactive Device
Backups** is on. An invalid retention value logs a warning and defaults to 30
days.

Backups are files in the archive directory, and the database keeps one row per
stored configuration, so storage grows with the number of devices and the
retention period. The plugin writes its messages to the Cacti log with the
`RCONFIG` tag.

## Command-Line Tools

`router-download.php` runs the backups. The poller runs it, and an
administrator can run it manually from the Cacti directory as the poller user.

```console
php -q plugins/routerconfigs/router-download.php [options]
```

The script accepts these options.

| Option | Purpose |
| --- | --- |
| `--device=ID`, `--devices=ID[,ID...]` | Back up only these device IDs (numeric). |
| `-d`, `--debug` | Debug output. |
| `-b`, `--debug-buffer` | Debug output including the connection buffer. |
| `-r`, `--retry` | Back up only enabled devices whose retry attempt is due. |
| `-f`, `--force` | Back up all enabled devices regardless of schedule. |
| `--simulate-schedule` | Run as a simulated scheduled run. |

A non-numeric device ID, an unknown option or a missing value prints an error
and exits with a non-zero status.

## Troubleshooting

- "FATAL: TFTP Backup Path is not set or is not a directory" in the log:
  set **TFTP Backup Directory Path** to an existing directory that the TFTP
  server writes to.
- "ERROR: Backup Path is not set or is not a directory" appears during the
  retention cleanup: check the same path.
- SSH devices fail and the log or debug output says PHP does not have the ssh2
  module: install the PHP `ssh2` extension.
- A backup is refused with "SSH host key ... changed": verify the change with
  the device, then use **Clear SSH Host Key**. With **Verify SSH Host Keys**
  on, the plugin refuses to send credentials when the key differs from the
  stored one.
- Output of some HP devices contains ANSI codes, and the README states that
  these devices currently do not work with Router Configs. Turn on **Debug
  Connection Buffer** to see the device output.
- Every backup shows a difference because of a timestamp line: add the line
  to **Diff Exclude Patterns**.
- Restoring a saved configuration to a device is not supported.

## More Information

- [Router Configs repository](https://github.com/Cacti/plugin_routerconfigs)
- [Router Configs README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-routerconfigs-devices]: images/plugin-routerconfigs-devices.png
[img-routerconfigs-backups]: images/plugin-routerconfigs-backups.png
[readme]: https://github.com/Cacti/plugin_routerconfigs/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
