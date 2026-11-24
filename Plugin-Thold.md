# Thresholds

The thold plugin, shown in Cacti as **Thresholds**, checks the values Cacti
collects for its Graphs against limits you define and notifies people when a
value is out of range. Notifications go out by Email, to syslog, as SNMP Traps
or Informs, or by running a command. Thold also sends notifications when a
Cacti Device goes down or recovers. Administrators who use Cacti for fault
alerting need it, and other plugins such as Monitor depend on it.

## Requirements

- This page documents Thresholds 1.8.2 (release tag `v1.8.2`).

- Cacti 1.2.25 or later.

- No other plugin is required. The Maint plugin is used when it is enabled:
  Devices in an active maintenance schedule do not send threshold or Device
  notifications.

- Email notifications use Cacti's mail settings in
  **Console > Configuration > Settings > Mail/Reporting/DNS**.

- SNMP notifications use Cacti's SNMP Agent and the `CACTI-THOLD-MIB` file
  shipped with the plugin.

- The optional Threshold Daemon uses the PHP `pcntl` functions to run in the
  background. Without them it can only run in the foreground.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named `thold`.

After enabling it:

1. Check that Cacti can send Email by using the test button in
   **Console > Configuration > Settings > Mail/Reporting/DNS**.

2. Review the settings on **Console > Configuration > Settings >
   Alerting/Thold**.

3. Grant the Thold realms to the users who need them.

To use the optional Threshold Daemon, install its systemd unit as described in
[Background Processing](#background-processing).

## Permissions

###### Table 1. Thold realms

| Realm | Pages |
| --- | --- |
| **Configure Thresholds** | `thold.php` |
| **Configure Threshold Templates** | `thold_templates.php` |
| **Manage Notification** | `notify_lists.php`, `notify_queue.php` |
| **View Thresholds** | `thold_graph.php`, `graph_thold.php`, `thold_view_failures.php`, `thold_view_normal.php`, `thold_view_recover.php`, `thold_view_recent.php`, `thold_view_host.php` |

Users with **View Thresholds** see the **Thold** tab at the top of the page.

## Settings

The settings are on **Console > Configuration > Settings > Alerting/Thold**.
The tab has many settings in the sections below. This section lists the ones
an administrator usually decides on. The rest are described next to each
setting in the interface. Several settings are presets: they set the default
for new Thresholds and Threshold Templates, and the Threshold's own setting
decides what happens.

###### Table 2. General and Notification Preferences

| Label | Default | Purpose |
| --- | --- | --- |
| **Disable All Thresholds** | Unchecked | Turn off alerting on all Thresholds, for example during network maintenance. |
| **Auto Create Thresholds** | Unchecked | Create the Thresholds for a Device's Device Template when automation runs or when a Device is created or saved. |
| **Consider Unknown Data as Zero** | Unchecked | Treat a value of `U` as zero when checking Thresholds. |
| **Default Management Status** | Any | The default status filter on the Thresholds page. |
| **Disable Legacy Notifications** | Unchecked | Turn off Email addresses entered directly on a Threshold instead of through a Notification List. |
| **Enable Command Execution** | Unchecked | Allow Thresholds to run commands on breach and restoral. |
| **Enable Per Thold Notification** | Unchecked | Allow custom Email bodies per Threshold. |
| **Enable Notification Queue** | Unchecked | Send notifications from a separate background process instead of during the threshold check. |

###### Table 3. Threshold Daemon and Logging

| Label | Default | Purpose |
| --- | --- | --- |
| **Enable Threshold Daemon** | Unchecked | Check Thresholds in the Threshold Daemon instead of in the poller. |
| **Daemon Down Notification Frequency** | Every 2 Hours | How often to Email the Cacti administrator when the daemon is down. |
| **Daemon Threads** | The number of concurrent poller processes set in Cacti | Number of daemon threads. |
| **Log Threshold Breaches** | Unchecked | Write all Threshold failures to the Cacti log. |
| **Log Threshold Changes** | Unchecked | Write all Threshold changes to the Cacti log. |
| **Debug Log** | Unchecked | Write Thold debug messages. |
| **Alert Log Retention** | 1 Month | How long to keep the Threshold log. Choices run from 1 Month to 1 Year, or **Indefinitely**. |

###### Table 4. Presets for new Thresholds

| Label | Default | Purpose |
| --- | --- | --- |
| **Syslog Enabled** | Unchecked | Send new Thresholds' events to the local syslog. |
| **Weekend exemptions** | Unchecked | Do not run Thold on weekends. |
| **Default Trigger Count** | 1 | Consecutive breaches needed before an alert. |
| **Re-Alerting** | 12 | Repeat the alert after this many poller cycles. |
| **Baseline Time Range Default** | From 1 Day Ago | Reference period for Baseline Thresholds. |
| **Baseline Trigger Count** | 2 | Consecutive Baseline breaches needed before an alert. |
| **Baseline Deviation Percentage** | 20 | Default allowed deviation for Baseline Thresholds. |

###### Table 5. SNMP and Email options

| Label | Default | Purpose |
| --- | --- | --- |
| **SNMP Notifications** | Unchecked | Send Threshold alerts, warnings and restorations to SNMP notification receivers. |
| **Send Alerts as Text** | Unchecked | Send plain text Emails without the Graph. By default, Emails are HTML with the Graph embedded. |
| **From Email Address** | Cacti's **From Email Address** | Sender address of Threshold Emails. |
| **From Name** | Cacti's **From Name** | Sender name of Threshold Emails. |

###### Table 6. Device Notification Options

| Label | Default | Purpose |
| --- | --- | --- |
| **Enable Notifications** | Checked | Send notifications when Devices go down or recover. |
| **Single Email Notification** | Checked | With Notification Lists and the Notification Queue, send one Email for all Devices that change in one cycle. |
| **Global Notification Email** | Empty | Address that receives Device notifications when a Device uses the **Global List**. |
| **Down Subject**, **Down Message** | Provided | Subject and body of Device down Emails. Replacement tags such as `<HOSTNAME>` and `<DESCRIPTION>` are listed in the interface. |
| **Recovering Subject**, **Recovering Message** | Provided | Subject and body of Device recovery Emails. |
| **Status Change Command** | Empty | Command to run when a Device changes state. It must not include arguments. |

The **Alert/Warning Message Defaults** section holds the default bodies of
Threshold alert, warning and restoral Emails.

### Device settings

Thold adds a **Device Up/Down Notification Settings** section to each Device's
edit page.

###### Table 7. Device Up/Down Notification Settings

| Label | Default | Purpose |
| --- | --- | --- |
| **Threshold Up/Down Email Notification** | Global List | Who is told about Device up and down events: **Disabled**, **Global List**, **List Below** or **Global and List Below**. |
| **Notification List** | None | The Notification List used by **List Below**. |
| **Host Failure Count** | Use Cacti Setting | Polling intervals a Device must be down before Thold reports it down. |

## Using Thresholds

Thold adds these pages:

- **Console > Management > Thresholds** to create and manage Thresholds.

- **Console > Templates > Threshold** to manage Threshold Templates.

- **Console > Management > Notification Lists** to manage who receives
  notifications.

- **Console > Management > Notification Queue** to see queued notifications
  when **Enable Notification Queue** is checked.

- The **Thold** tab, with the **Thresholds**, **Log** and **Device Status**
  views.

### Threshold Management

**Console > Management > Thresholds** lists Thresholds with filters for
**Site**, Device, **Template**, **Data Template** and **Status**. The columns
include the current value, the high and low limits, the trigger and repeat
settings, whether the Threshold is triggered and how long it has been in its
state.

The following screenshot shows the Threshold Management page on a test system
with six High / Low Thresholds, two of them in alert, and the color legend
below the list.

![Threshold Management page listing six thresholds with their status,
type, current value, limits and trigger
state](images/plugin-thold-thresholds.png)

The actions menu offers **Acknowledge**, **Suspend Notifications**,
**Resume Notifications**, **Delete**, **Enable**, **Disable**,
**Reapply Suggested Names** and **Propagate Template**.

### Threshold types and data manipulation

Each Threshold has a **Threshold Type**:

- **High / Low**: the value must stay between the high and low limits. A
  breach longer than the **Breach Duration** raises a warning or an alert.

- **Time Based**: the value must not cross the limits more than
  **Breach Count** times within the **Breach Window**.

- **Baseline Deviation**: the value is compared with the value at a reference
  time in the past, and an alert is raised when it moves up or down by more
  than **Deviation UP** or **Deviation DOWN**.

Warnings and alerts have separate limits. The **Re-Alert Cycle** sets how often
a notification is repeated while the Threshold stays breached.

The **Data Type** sets how the value is computed before the check:
**Exact Value**, **CDEF**, **Percentage** (of another Data Source),
**RPN Expression** or **Upper + Lower bytes**.

### Create Thresholds from a Threshold Template

1. Open **Console > Templates > Threshold** and add a Threshold Template for
   the Data Template and Data Source you want to check.

2. Set the limits and notification settings, and save.

3. Open **Console > Management > Graphs**, select the Graphs, choose
   **Create Threshold from Template** from the actions menu and select the
   template. The same action is available on the Data Sources page.

To create Thresholds automatically, associate Threshold Templates with a Device
Template in the **Associated Threshold Templates** box of the Device Template.
Thresholds are then created by the **Apply Thresholds** action on the Devices
page, by the **Auto-create Thresholds** link on a Device's **Create Graphs**
page, or automatically when **Auto Create Thresholds** is checked.

### Notification Lists

A Notification List is a named set of addresses in **To Email Addresses** and
**BCC Email Addresses**, with an optional **Email Style/Format File**. Lists
are chosen as the **Warning Notification List** and **Alert Notification List**
of Thresholds and templates, and for Device up and down notifications. The
**Devices**, **Thresholds** and **Templates** tabs of a list associate it with
many objects at once.

### The Thold tab

The **Thold** tab shows users the Thresholds they are allowed to see.
**Thresholds** lists their current state, **Log** shows the Threshold log, and
**Device Status** shows Device availability. From the Thresholds view a user can
acknowledge a Threshold that requires acknowledgment.

## Background Processing

At the end of every polling cycle, Thold starts `poller_thold.php` in the
background. Thold also receives each cycle's collected values from the poller.
When the Threshold Daemon is not enabled, `poller_thold.php`:

1. Checks all Thresholds and sends notifications.

2. Checks Device status and sends Device up and down notifications.

3. Deletes Threshold log entries older than **Alert Log Retention** from
   `plugin_thold_log`.

4. Removes Thresholds, log entries and failure records of deleted Devices and
   Graphs.

5. Writes a `THOLD STATS` line to the Cacti log.

When **Enable Notification Queue** is checked, `poller_thold.php` also starts
`thold_notify.php` to send the queued notifications.

### Threshold Daemon

With the Threshold Daemon, threshold checks run in a separate long-running
process with several worker threads. The poller then only checks Device status,
cleans up the log, and Emails the administrator if the daemon has not reported
in for three polling intervals. It writes a `THOLD POLLER STATS` line to the
Cacti log.

The plugin ships a systemd unit in `service/systemd/thold_daemon.service`. To
install it:

1. Replace `<CACTIDIR>` in the file with your Cacti directory. If you use
   MySQL, change `mariadb.service` to `mysql.service`. Check that the `User`
   line names your web server user.

2. Copy the file and start the service.

   ```console
   cp thold_daemon.service /etc/systemd/system
   systemctl daemon-reload
   systemctl enable --now thold_daemon
   ```

3. Check that it runs with `systemctl status thold_daemon`.

Starting the daemon turns on **Enable Threshold Daemon**.

## Command-Line Tools

Run these scripts from the plugin directory as the user that runs the Cacti
poller.

### cli_thresholds.php

Creates Thresholds from Threshold Templates.

```console
php cli_thresholds.php --auto-create=N
php cli_thresholds.php [--host-ids='N1 N2 ...'] [--graph-template=N] \
  [--thold-template=N] [--graph-ids='N1 N2 ...']
```

###### Table 8. cli_thresholds.php options

| Option | Meaning |
| --- | --- |
| `--auto-create=N` | Create all Thresholds for Device ID N from the Threshold Templates of its Device Template. |
| `--host-ids='N1 N2 ...'` | Devices to create Thresholds for. |
| `--graph-template=N` | Graph Template to create Thresholds for. |
| `--thold-template=N` | Threshold Template to use. |
| `--graph-ids='N1 N2 ...'` | Graphs to create Thresholds for. |

In the second form, at least one of the options must be given.

### cli_import.php

Imports a Threshold Template exported from the Thold plugin.

```console
php cli_import.php --filename=N
```

### poller_thold.php

Runs one threshold processing pass. It is normally started by the poller.

```console
php poller_thold.php [--debug] [--force]
```

`--debug` prints verbose output and `--force` forces all checks to run now.

### thold_daemon.php

Starts the Threshold Daemon. `--foreground` (or `-f`) keeps it in the
foreground and `--debug` prints debug output.

```console
php thold_daemon.php [--foreground | -f] [--debug]
```

## Troubleshooting

- Thresholds do not trigger after enabling the daemon: check that the
  `thold_daemon` service is running. If **Enable Threshold Daemon** is checked
  but the daemon is stopped, no thresholds are checked. Thold Emails the
  Cacti administrator with the subject "Thold Daemon Not Started" or
  "Thold Daemon Down" at the **Daemon Down Notification Frequency**.

- The daemon prints `The Thold Daemon is still running`: another copy is
  already running.

- No Emails arrive: test Cacti's mail settings first, then check that the
  Threshold has a Notification List or Email addresses, and that
  **Disable All Thresholds** is unchecked.

- The Cacti log shows `THOLD was unable to generate SNMP notifications`:
  **SNMP Notifications** is checked but Cacti's SNMP Agent is not available.

- A Device in a maintenance schedule only logs: Thold log entries for Devices
  in maintenance carry the text "Only logging, maint device".

## More Information

- [Thold plugin repository](https://github.com/Cacti/plugin_thold)

- [README](https://github.com/Cacti/plugin_thold/blob/v1.8.2/README.md) for
  Thresholds 1.8.2

---

Copyright (c) 2004-2026 The Cacti Group
