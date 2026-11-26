# Maintenance Scheduler

The maint plugin, shown in Cacti as **Maintenance Scheduler**, lets an
administrator define maintenance windows and attach Devices to them. While a
window is active, plugins that check maint stop sending notifications for those
Devices. In the 1.3 release, the Thold plugin and the Servcheck plugin check
maint, so administrators who run either of them and plan outages or upgrades
need it.

## Requirements

- This page documents Maintenance Scheduler 1.3 (release tag `v1.3`).

- Cacti 1.2.0 or later.

- No other plugin is required. The **Thold Devices** tab of a schedule appears
  only when the Thold plugin is enabled, and the **Servcheck** tab only when
  the Servcheck plugin is enabled.

- No PHP extensions or external programs beyond those Cacti itself uses.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named `maint`.
Installing the plugin creates two tables, `plugin_maint_schedules` and
`plugin_maint_hosts`. There is no configuration file to copy.

## Permissions

The plugin registers one realm. Grant it to the users or groups that manage
maintenance windows.

###### Table 1. Maint realms

| Realm | Pages |
| --- | --- |
| **Maintenance Schedules** | `maint.php` |

## Settings

The plugin adds no entries to **Console > Configuration > Settings**. All
configuration is held in the individual schedules described below.

## Using Maintenance Scheduler

### Maintenance Schedules

Open **Console > Management > Maintenance Schedules**. The page lists every
schedule with its **Name**, whether it is **Active** now, its **Type**, the
**Start** and **End** times, the **Interval** and whether it is **Enabled**.
For a schedule that repeats every week, the start and end columns show the day
of the week and time.

The following screenshot shows three schedules on a test system: an active one
time window, a disabled one time window and a weekly recurring window.

![Maintenance Schedules list with three schedules showing name, active
state, type, start, end, interval and enabled
columns](images/plugin-maint-schedules.png)

The actions menu below the list offers **Update Time (Now + 1 Hour)**, which
moves the selected schedules to start at the current minute and end one hour
later, and **Delete**. Deleting a schedule also removes its Device
associations.

### Create a schedule

1. Open **Console > Management > Maintenance Schedules** and click the add
   icon.

2. Fill in the fields on the **General** tab, then click **Save**.

3. Open the **Thold Devices** tab, select the Devices to include, choose
   **Associate** from the actions menu and click **Go**.

The **General** tab has the following fields.

###### Table 2. Schedule fields

| Label | Default | Purpose |
| --- | --- | --- |
| **Schedule Name** | New Maintenance Schedule | A name for the schedule. |
| **Enabled** | Checked | Whether the schedule is checked at all. |
| **Schedule Type** | One Time | **One Time** or **Recurring**. |
| **Interval** | Not Defined | For recurring schedules, how often the window repeats: **Every Day** or **Every Week**. |
| **Start Time** | The current time | The start date and time. Most date and time formats are accepted. |
| **End Time** | One hour after the current time | The end date and time. Most date and time formats are accepted. |

A schedule must be saved before Devices or tests can be associated with it.

### Associate Devices and tests

The **Thold Devices** tab lists Devices with filters for **Site**,
**Data Collector**, **Location**, **Template**, **Search** and an
**Associated** check box that limits the list to Devices already in the
schedule. Select Devices and use **Associate** or **Disassociate**. The
**Servcheck** tab works the same way for Servcheck tests.

### Put Devices into maintenance from the Devices page

The plugin adds two actions to **Console > Management > Devices** and two
links at the top of a Device's edit page:

- **Enable maintenance for this device (now+1h)** creates a new schedule that
  starts now and ends one hour later, and associates the selected Devices with
  it. The confirmation page asks for a **Schedule name** (the default name is
  **Quick Maintenance**) and a **Schedule Type**. If you choose **Recurring**,
  choose **Every Day** or **Every Week**.

- **Add device(s) to existing maintenance schedule** associates the selected
  Devices with a schedule chosen from a list.

## Background Processing

The plugin has no poller hook or poller script. Other plugins ask it whether a
Device or test is in maintenance at the moment they would send a notification.
A Device is in maintenance when it belongs to an enabled schedule and the
current time is between the schedule's start and end times.

When a recurring schedule's end time has passed, the next check moves the
start and end forward by whole intervals until the window ends in the future,
and saves the new times. The start hour is kept in local time across daylight
saving time changes. Each move is written to the Cacti log in this format:

```console
INFO: Maintenance schedule "<name>" Next start <YYYY-MM-DD HH:MM> End <YYYY-MM-DD HH:MM>
```

## Troubleshooting

- A Device in an active window still alerts: check that the schedule is
  **Enabled** and that the Device is associated on the **Thold Devices** tab.
  For Servcheck tests, associate the test on the **Servcheck** tab, because
  Device associations do not cover tests.

- The **Thold Devices** or **Servcheck** tab is missing: the corresponding
  plugin is not enabled.

- During maintenance, Thold still records breaches. Its log entries carry the
  text "Only logging, maint device" instead of sending notifications.

## More Information

- [Maint plugin repository](https://github.com/Cacti/plugin_maint)

- [README](https://github.com/Cacti/plugin_maint/blob/v1.3/README.md) for
  Maintenance Scheduler 1.3

---

Copyright (c) 2004-2026 The Cacti Group
