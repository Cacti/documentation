# Monitor

The Monitor plugin shows the status of selected Cacti Devices on one dashboard
page. When a monitored Device goes down, the page can play an alarm sound in the
browser. In the background, the plugin records Device reboots and can send
Email notifications for reboots and for ping latency above per-Device
thresholds. It is meant for operations staff who keep a status screen open, and
for administrators who want reboot and latency notices by Email.

## Requirements

- This page documents Monitor 2.9 (release tag `v2.9`).

- Cacti 1.2.15 or later.

- The Thold plugin, version 1.2.1 or later. Monitor uses Thold's
  **Notification Lists** and the ping threshold notifications need Thold.

- No PHP extensions or external programs beyond those Cacti itself uses.
  The alarm is played by the viewer's browser from the `.wav` and `.mp3` files
  in the plugin's `sounds` directory.

## Installation

Install and enable Thold first, then install and enable Monitor as described in
[Plugin Management](Plugins.md). The plugin directory must be named `monitor`.

After installation, choose which Devices to monitor. Monitor shows only
Devices with **Monitor Device** checked, and the empty dashboard reminds you to
"first select eligible Devices to be Monitored from the Devices page". To have
new Devices monitored automatically, check **Enable on new devices** in the
settings.

## Permissions

###### Table 1. Monitor realms

| Realm | Pages |
| --- | --- |
| **View Monitoring Dashboard** | `monitor.php` |

Users with this realm see the **Monitor** tab at the top of the page.

## Settings

Global settings are on **Console > Configuration > Settings > Monitor**. Each
user can also set personal values for the dashboard display settings in the
**Monitor Settings** section of their own user settings.

###### Table 2. Monitor Settings

| Label | Default | Purpose |
| --- | --- | --- |
| **Enable on new devices** | Unchecked | Turn monitoring on automatically for newly created Devices. |
| **Notification/Reboot Log Retention** | 1 Month | How many days of notification and reboot history to keep. Choices run from 1 Month to 1 Year, or **Indefinitely**. |
| **Alarm Sound** | `attn-noc.wav` | Sound file played when a Device goes down, chosen from the files in the `sounds` directory. |
| **Loop Alarm Sound** | Unchecked | Play the sound in a loop while a Device is down. |
| **Refresh Interval** | 60 seconds | Time before the dashboard refreshes. |
| **Show Icon Legend** | Unchecked | Show an icon legend on the dashboard. |
| **Grouping** | Default | How Devices are grouped: **Default**, **Default with permissions**, **Tree** or **Device Template**. |
| **View** | Default | How Devices are drawn: **Default**, **List**, **Names only**, **Tiles** or **Tiles & Downtime**. |

###### Table 3. Notification Report Format and Ping Threshold Notifications

| Label | Default | Purpose |
| --- | --- | --- |
| **Format File to Use** | `default.format` | The HTML and CSS wrapper for notification Emails, from Cacti's report `formats` directory. |
| **Warning Latency Notification** | Disabled | Send an Email when a Device's ping latency is above its warning threshold and the Device's criticality is at or above the level chosen here. |
| **Alert Latency Notification** | Disabled | The same for the alert threshold. |
| **How Often to Resend Emails** | Every Occurrence | How often to repeat latency Emails while a Device stays above its threshold. |

###### Table 4. Reboot Notifications and Notification Email Addresses

| Label | Default | Purpose |
| --- | --- | --- |
| **Send Reboot Notifications** | Checked | Send an Email when a Device reboots. |
| **Send one Email to all addresses** | Checked | Send one Email to all recipients instead of one per address. |
| **Include Threshold Alert Lists** | Checked | Also notify the Thold alert Notification Lists. |
| **Subject** | Cacti Device Reboot Notification | Subject of the reboot Email. |
| **Email Body** | A heading and the `<DETAILS>` tag | Body of the reboot Email. `<DETAILS>` is the only replacement tag. |
| **From Name** | Empty | Sender name for notifications. |
| **From Address** | Empty | Sender address for notifications. |
| **Notification List** | None | A Thold Notification List whose members receive notifications. |
| **Email Addresses** | Empty | Comma-separated addresses to inform of reboots. |

The personal display settings are **Alarm Sound**, **Loop Alarm Sound**,
**Show Icon Legend**, **Show Uptime**, **Zoom to Errors**, **Zoom Background**
and **Zoom Fontsize** (default 50px).

### Device settings

Monitor adds a **Device Monitoring Settings** section to each Device's edit
page in **Console > Management > Devices**.

###### Table 5. Device Monitoring Settings

| Label | Default | Purpose |
| --- | --- | --- |
| **Monitor Device** | Value of **Enable on new devices** for new Devices | Show this Device on the Monitor tab. |
| **Device Criticality** | Disabled | **Low**, **Medium**, **High** or **Mission Critical**. Used by the dashboard filter and the latency notifications. |
| **Ping Warning Threshold** | Empty | Round-trip latency in milliseconds above which a warning is logged or sent. 0 disables it. |
| **Ping Alert Threshold** | Empty | Round-trip latency in milliseconds above which an alert is logged or sent. 0 disables it. |
| **Re-Baseline Warning** | Do not Change | Set the warning threshold to a percentage above the current average ping time. |
| **Re-Baseline Alert** | Do not Change | Set the alert threshold to a percentage above the current average ping time. |
| **Down Device Message** | Empty | Message displayed when the Device is reported down. |
| **Device icon** | Not set | Icon used for the Device on the dashboard. |

To change these values for many Devices at once, select them on the Devices
page and use the **Change Monitoring Options**, **Enable Monitoring** or
**Disable Monitoring** action.

## Using Monitor

### The Monitor dashboard

Click the **Monitor** tab. The page title in the navigation bar is
**Monitoring**. The filter bar at the top selects which Devices appear and how
they are drawn:

- **Layout** selects a saved dashboard.

- **Status** limits the list, for example to **All Monitored Devices** or to
  Devices that are down, recovering or have triggered thresholds.

- **View** and **Grouping** override the settings of the same name.

- **Criticality** limits the list to Devices of a given criticality or higher.

- **Size** and **Trim** set the icon size and how many characters of each
  Device name are shown.

- **Tree**, **Sites** and **Template** filters appear for the matching
  groupings.

- **Refresh** sets the refresh interval of the page.

The following screenshot shows the dashboard on a test system in the
**Default** view, with nine monitored Devices drawn as icons colored by their
status.

![Monitor dashboard with the filter bar above a row of nine Device icons
in green, red, gray and amber](images/plugin-monitor-dashboard.png)

Hover over a Device icon to see the **Device Status Information** box, with
details such as availability, current and average ping time, time in state and
notes.

### Mute or acknowledge the alarm

The filter bar has a button that mutes the alarm for the Devices that are down
or triggered now. It reads **Mute** when an alarm sound is configured and
**Acknowledge** otherwise. After you click it, it reads **Un-Mute** or
**Reset**. When another Device goes down, the mute is cleared and the alarm
plays again.

### Save a dashboard

1. Set the filters you want.

2. Click **New** and enter a name for the dashboard.

3. Later, choose it from **Layout**. Use **Save** to update it, or **Rename**
   and **Delete** to manage it.

## How It Collects Data

At the end of every polling cycle on the main data collector, Monitor starts
`poller_monitor.php` in the background. That script:

1. Compares Device uptime values with the previous cycle, records reboots in
   `plugin_monitor_reboot_history` and sends reboot notifications if
   **Send Reboot Notifications** is checked.

2. If **Warning Latency Notification** or **Alert Latency Notification** is
   not **Disabled**, finds Devices whose ping time is above their thresholds,
   sends the Emails and records them in `plugin_monitor_notify_history`.

3. Deletes notification and reboot history older than
   **Notification/Reboot Log Retention**.

4. Writes a summary line to the Cacti log in this format:

```console
MONITOR STATS: Time:<seconds> Reboots:<n> DownDevices:<n> Notifications:<n> Purges:<n>
```

The plugin also keeps the last known uptime of each Device in
`plugin_monitor_uptime` and saved dashboards in `plugin_monitor_dashboards`.

## Command-Line Tools

`poller_monitor.php` is started by the poller and can also be run by hand from
the plugin directory to see what it does.

```console
php -q poller_monitor.php --debug
```

###### Table 6. poller_monitor.php options

| Option | Meaning |
| --- | --- |
| `--debug` | Print debug output, for testing. |
| `--version`, `-V`, `-v` | Show the version. |
| `--help`, `-H`, `-h` | Show the usage text. |

## Troubleshooting

- A Device is missing from the dashboard: check **Monitor Device** on the
  Device and the **Status** filter.

- The Cacti log shows `WARNING: No Global Notification List defined.  Please
  set under Settings -> Thresholds`: latency notifications are enabled, but
  Thold's **Global Notification Email** setting is empty.

- No latency Emails are sent: both latency settings are **Disabled** by
  default, and a Device needs a criticality and a ping threshold above zero.

## More Information

- [Monitor plugin repository](https://github.com/Cacti/plugin_monitor)

- [README](https://github.com/Cacti/plugin_monitor/blob/v2.9/README.md) for
  Monitor 2.9

---

Copyright (c) 2004-2026 The Cacti Group
