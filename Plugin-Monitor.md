# Monitor

Monitor shows the status of your Cacti devices on one page, so that you can see
at a glance which ones are up, down, recovering, or have breached thresholds.
It can play an alarm sound in the browser when a device goes down, and it can
send email when a device exceeds a ping latency threshold or reboots. It is for
operators who watch a Cacti installation from a status board, for example in a
network operations center.

This page follows the plugin's `develop` branch, which is unreleased and can
change. That branch declares version 3.0 and Cacti compatibility 1.2.29 in its
`INFO` file.

## Requirements

- Cacti 1.2.29 or later, as declared in `INFO`.
- The Thold plugin 1.2.1 or later. `INFO` declares it with
  `requires = thold:1.2.1`, so install and enable [Thold](Plugin-Thold.md)
  before you enable Monitor. The ping latency notifications also need Thold, as
  the setting descriptions state.
- Working mail settings in Cacti, to send notifications.
- A valid Cacti **PHP Binary Path** setting, because the poller starts the
  plugin's script with it. If the setting is empty, the plugin runs `php`.
- The plugin uses no extra PHP extension or external program.

## Installation

Follow [Plugin Management](Plugins.md) to install and enable the plugin. Place
the code in `<path_cacti>/plugins/monitor`; the directory must be named
`monitor`.

Installing creates the plugin's own tables in the Cacti database. After
installation, grant the **View Monitoring Dashboard** realm to the users who
should see the **Monitor** tab, and review the notification settings (see
[Settings](#settings)).

Sound files are read from the plugin's `sounds` directory. Files with the
`.wav` and `.mp3` extensions are offered in the **Alarm Sound** drop-downs.

## Permissions

| Realm | Pages covered |
| --- | --- |
| View Monitoring Dashboard | `monitor.php` (the Monitor tab) |

Users see only the devices Cacti permits them to see. When Cacti provides
`auth_augment_roles`, the plugin adds `monitor.php` to the **Normal User**
role.

## Settings

Monitor has three places for configuration.

### Console settings

The administrator settings are on the **Monitor** tab of **Console >
Configuration > Settings**. The tab has these sections.

#### Monitor Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| Enable on new devices | off | Enable monitoring automatically for new devices. |
| Notification/Reboot Log Retention | 1 Month (31 days) | How long notification and reboot logs are kept. |
| Alarm Sound | attn-noc.wav | Sound played when a device goes down. |
| Loop Alarm Sound | off | Play the sound on a loop. |
| Refresh Interval | 60 | Seconds before the page refreshes. |
| Show Icon Legend | off | Show an icon legend on the Monitor display. |
| Grouping | Default | How devices are grouped: Default, Default with permissions, Tree, or Device Template. |
| View | Default | How devices are rendered: Default, List, Names only, Tiles, or Tiles & Downtime. |

#### Notification Report Format

| Setting | Default | Purpose |
| --- | --- | --- |
| Format File to Use | default.format | HTML wrapper and CSS file for notification email. |

#### Ping Threshold Notifications

| Setting | Default | Purpose |
| --- | --- | --- |
| Warning Latency Notification | Disabled | Notify when a device's ping latency exceeds its warning threshold and its criticality is above this level. |
| Alert Latency Notification | Disabled | The same for the alert threshold. |
| How Often to Resend Emails | Every Occurrence | Interval between repeat notifications for devices that stay above their thresholds. |

The criticality levels are Disabled, Low, Medium, High, and Mission Critical.

#### Reboot Notifications

| Setting | Default | Purpose |
| --- | --- | --- |
| Send Reboot Notifications | on | Send device reboot notifications. |
| Send one Email to all addresses | on | Send a single email to all addresses. |
| Include Threshold Alert Lists | on | Also notify Thold alert lists. |
| Subject | Cacti Device Reboot Notification | Subject of the reboot email. |
| Email Body | HTML message with a `<DETAILS>` tag | Body of the reboot email. `<DETAILS>` is the only replacement tag. |

#### Notification Email Addresses

| Setting | Default | Purpose |
| --- | --- | --- |
| From Name | empty | Sender name. |
| From Address | empty | Sender address. |
| Notification List | None | A Thold notification list to inform. |
| Email Addresses | empty | Comma-delimited addresses to inform of a reboot. |

### Device settings

Each device has a **Device Monitoring Settings** section on **Console >
Management > Devices**, where you edit the device:

| Field | Default | Purpose |
| --- | --- | --- |
| Monitor Device | follows **Enable on new devices** | Show this device on the Monitor tab. |
| Device Criticality | Disabled | Criticality of the device. |
| Ping Warning Threshold | empty | Latency in milliseconds above which a warning is raised. 0 disables. |
| Ping Alert Threshold | empty | Latency in milliseconds above which an alert is raised. 0 disables. |
| Re-Baseline Warning | 0 | Percentage above the average ping time to use as the warning threshold. |
| Re-Baseline Alert | 0 | Percentage above the average ping time to use as the alert threshold. |
| Down Device Message | empty | Message shown while the device is down. |
| Device icon | 0 | Icon used for the device. |

The device list action menu also offers **Change Monitoring Options**,
**Enable Monitoring**, and **Disable Monitoring** for selected devices.

### User settings

Each user can set personal options on the **Monitor Settings** tab of the Graph
Settings page: **Alarm Sound** (default attn-noc.wav), **Loop Alarm Sound**,
**Show Icon Legend**, **Show Uptime**, **Zoom to Errors**, **Zoom Background**,
and **Zoom Fontsize** (default 50px).

## Using Monitor

Select the **Monitor** tab in the Cacti header. The page is titled
**Monitoring**. The filter bar at the top has these controls:

- **Layout**: a saved dashboard layout.
- **Show**: All Monitored Devices, All Devices, Devices not Monitored, or
  Devices without Thresholds. **Devices without Service Checks** appears when
  the Service Check plugin is enabled and you may use it.
- **View**, **Grouping**: how devices are drawn and grouped. Grouping offers
  Default, Tree, Site, and Device Template.
- **Search**, **Events**, **Criticality**, **Size**, **Trim**, **Refresh**:
  narrow and size the display and set the refresh time.
- **Refresh**, **Clear**, **Save**, **New**: apply, reset, or save the filter,
  or save it as a new dashboard. **Rename** and **Delete** appear for a saved
  dashboard you own.
- A mute button, labeled **Mute** or **Un-Mute** when an alarm sound file is
  selected and exists, and **Acknowledge** or **Reset** when it is not.
- **Devices**: opens the Devices management page, if you may use it.

The screenshot shows the board with nine synthetic devices. Each card takes the
color of its state. The example uses synthetic data.

![Monitor board with nine synthetic devices][board-image]

Event classes that cards can show are Down, Recovering, Triggered, their muted
or acknowledged forms (M/A), Warn Ping, Alert Ping, and Failed Svc. In the List
view, the columns include Description, Location, Site, Criticality, Events,
Thresholds, Availability, Averages, Length in Status, and Last Fail.

To start monitoring a device:

1. Open **Console > Management > Devices** and edit the device.
2. In **Device Monitoring Settings**, check **Monitor Device**.
3. Set **Device Criticality**, and optionally the ping thresholds.
4. Save. The device appears on the **Monitor** tab.

To get ping latency email:

1. Set **Ping Warning Threshold** or **Ping Alert Threshold** on the devices.
2. Set **Warning Latency Notification** or **Alert Latency Notification** to a
   criticality level on the **Monitor** settings tab.
3. Subscribe email addresses to the device, as the setting descriptions
   state, and define a global notification list under the Thold settings.

## How It Collects Data

Monitor does not poll devices itself. It reads the device status that Cacti's
poller already records. Monitor registers a `poller_bottom` hook. On the main
poller, it starts `poller_monitor.php` in the background at the end of each
polling cycle.

The script checks device uptime for reboots, sends reboot notifications, sends
ping threshold notifications when a warning or alert criticality is set, and
purges old records. Notification and reboot history is deleted after
**Notification/Reboot Log Retention**. The script writes a line starting with
`MONITOR STATS` to the Cacti log with the elapsed time, reboots, down devices,
notifications, and purges. The plugin keeps notification history, reboot
history and uptime in its own tables, which grow with the number of events.

## Command-Line Tools

`poller_monitor.php` is normally started by the poller. Run it from the plugin
directory to test:

```console
usage: poller_monitor.php [--debug]

  --debug       - debug execution, e.g. for testing
```

## Troubleshooting

- The plugin cannot be enabled: Thold 1.2.1 or later must be installed and
  enabled first.
- No **Monitor** tab: the user needs the **View Monitoring Dashboard** realm.
- A device is missing from the board: check **Monitor Device** on the device and
  the **Show** filter. Users see only devices they have permission to see.
- No latency email: set a criticality for **Warning Latency Notification** or
  **Alert Latency Notification**, set thresholds on the device, and define a
  global notification list. Without one, the log shows `WARNING: No Global
  Notification List defined. Please set under Settings -> Thresholds`.
- Email delivery problems: the Cacti log shows `WARNING: Monitor had problems
  sending to ...` with the error, or `NOTICE: Email Notification Sent to ...`
  on success. Messages carry the component `MONITOR`.
- No sound: select an **Alarm Sound** that exists in the plugin's `sounds`
  directory. Without one, the button reads **Acknowledge** instead of **Mute**.

## More Information

- [Monitor plugin repository](https://github.com/Cacti/plugin_monitor)
- [Monitor README][monitor-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[board-image]: images/plugin-monitor-dashboard.png
[monitor-readme]: https://github.com/Cacti/plugin_monitor/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
