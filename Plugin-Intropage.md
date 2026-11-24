# Intropage

Intropage adds user dashboards to Cacti. Each dashboard is a set of panels
that summarize the state of the Cacti installation, such as poller status,
devices with the worst ping or availability, threshold events, log analysis
and favorite Cacti **Graphs**. Each user can keep several dashboards, share
them with other users, and show them either on the **Console** page or on a
separate tab. Administrators who want one page that shows what needs
attention, and users who want their own set of graphs on login, use it.

## Requirements

- This page documents Intropage 4.0.4 (release tag `v4.0.4`).

- Cacti 1.2.17 or later.

- No other plugin is required. Some panels appear only when the plugin they
  report on is installed: **Thold** for the threshold panels and the
  **24 Hour Extremes** panel, **Syslog**, **MacTrack**, **Maint**,
  **Servcheck** and **Webseer** for their own panels.

- The **NTP/DNS Status** panel uses the PHP `sockets` extension to query the
  NTP server.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named
`intropage`. Installing the plugin creates its database tables; uninstalling
it drops them, which removes all dashboards and panel settings.

After the plugin is enabled:

1. Review the settings at
   **Console > Configuration > Settings > Intropage**.

2. Grant users the **Intropage Viewer** realm, and choose which panels each
   user or group may use, as described in [Permissions](#permissions).

3. Open a dashboard and add panels. Panels do not start rendering until at
   least one user has access to them.

## Permissions

Intropage registers two realms.

###### Table 1. Intropage realms

| Realm                    | Covers                                                                                                    |
| ------------------------ | --------------------------------------------------------------------------------------------------------- |
| Intropage Viewer         | `intropage.php`, the dashboard page and tab. Also required to see the dashboard on the **Console** page. |
| Intropage Administration | Administrative actions; it adds **Reload Panel Definitions** to the dashboard **Actions** menu.          |

Access to individual panels is set per user and per user group. Edit a user
at **Console > Configuration > Users** or a group at
**Console > Configuration > User Groups** and open the **Intropage** tab. The
tab lists every registered panel under **System Level Panels** (panels about
overall system use, meant for administrators) and **User Level Panels**
(panels whose content is limited to what the user can view), with a check box
for each panel and for **Favorite Graphs**. A panel that a user is not
allowed to use is grayed out in that user's **Panels** menu.

## Settings

The settings are at **Console > Configuration > Settings > Intropage**, in
two sections. Several dashboard options, such as automatic refresh, the
important period and the number of panel lines, can also be changed per user
from the dashboard **Actions** menu.

###### Table 2. Display Settings

| Label                                                                 | Default                 | Purpose                                                                                                     |
| --------------------------------------------------------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Important things will be at the top**                               | Off                     | Display panels with errors and warnings first.                                                              |
| **Display more panels on a line**                                     | Off                     | Fit more panels on each line, for wide screens.                                                             |
| **Automatically Uninstall Panels**                                    | Off                     | When the plugin a panel requires is removed, remove the panel too.                                          |
| **Automatic Page Refresh**                                            | Every Minute            | How often the dashboard refreshes: by the poller, never, every minute, every 5 minutes or every hour.       |
| **Important period**                                                  | 1 hour                  | How far back events are highlighted; older events are displayed without highlighting.                      |
| **Number of panel lines**                                             | 5 lines                 | Lines shown in each panel: 5, 10 or 15.                                                                     |
| **Trend Timespan**                                                    | Timespan Last 4 Hours   | Default timespan for trend charts, from 1 hour to 1 day.                                                    |
| **Poller Timeout**                                                    | 30 Minutes              | How long the Intropage background poller may run before Cacti stops it.                                     |
| **Analyze Log - number of lines**                                     | 500                     | Log lines analyzed; the panel uses this number and the detail view twice this number.                      |
| **How often analyze DB**                                              | Every Week              | How often the poller runs the database check.                                                               |
| **Analyze DB - Level of db check**                                    | Changed                 | Check level: Quick, Fast, Changed, Medium or Extended. Medium and Extended can slow page loads.            |
| **NTP Time Check - IP or DNS name of NTP server**                     | `pool.ntp.org`          | NTP server used to compare the Cacti server's clock.                                                        |
| **How often check NTP**                                               | Every Hour              | Interval of the NTP check, run by the poller.                                                               |
| **DNS Check - Any DNS name**                                          | `dns.google`            | Name resolved to test DNS.                                                                                  |
| **How often check DNS**                                               | Every Hour              | Interval of the DNS check, run by the poller.                                                               |
| **Admin Information Panel about Maintenance Tasks, Down Devices, ..** | Empty                   | Text for an administrator message panel displayed at the top of dashboards when not empty.                 |
| **Upcoming Maint Schedule warning days**                              | 1 Day Before            | How long before a **Maint** schedule starts a warning is displayed.                                         |
| **Network stats in**                                                  | Bits                    | Unit for network statistics: Bytes or Bits.                                                                 |

The **Alarm Settings** section sets which status color, **Red Status**,
**Yellow Status** or **Green Status**, a panel shows when a condition is
found.

###### Table 3. Alarm Settings

| Label                                                       | Default                  |
| ----------------------------------------------------------- | ------------------------ |
| **Alarm DB check Aborted Clients**                          | Yellow Status            |
| **Alarm Host with the same Description**                    | No valid default is set  |
| **Alarm Orphaned Data Source**                              | Yellow Status            |
| **Alarm non-empty Poller Output**                           | Red Status               |
| **Alarm Bad indexes Data Source**                           | Red Status               |
| **Alarm Threshold logonly action**                          | Red Status               |
| **Alarm when device bulk_walk_size is not optimized**       | Red Status               |
| **Alarm Devices with the same IP/port**                     | Yellow Status            |
| **Alarm Device in more than one Tree**                      | Yellow Status            |
| **Alarm Device without a Tree**                             | Yellow Status            |
| **Alarm Device with Default public/private SNMP Community** | Yellow Status            |
| **Alarm Device without Monitoring**                         | Yellow Status            |
| **Alarm Device without Graph**                              | Yellow Status            |
| **Alarm Red/Yellow Polling Time**                           | 10s / 20s Yellow / Red   |
| **Alarm Red/Yellow Failed/All Ratio**                       | 0.2 / 0.4 Yellow / Red   |
| **Alarm Red/Yellow Ping**                                   | 10ms / 20ms Yellow / Red |
| **Alarm Red/Yellow Worst Availability**                     | 99 / 95% Yellow / Red    |

## Using Intropage

### Opening the dashboard

Intropage has no menu entry. A user with console access sees the dashboards
below the standard **Console** page. To use the whole page for Intropage,
enable **Hide Cacti Dashboard** at
**Console > Configuration > Settings > General**. A user can instead choose
**Display Intropage in Tab as Default Page** from the **Actions** menu; the
dashboard then opens from its own **Intropage** tab and becomes the login
page. A user without console access always uses the tab, and can choose
**Set Intropage as Default Login Page** from the **Actions** menu.

The following screenshot shows a dashboard with availability, ping, poller,
device status, device template, Cacti object analysis and host alert panels.
The color of each panel header shows its alarm state.

![Intropage dashboard with eight panels, including bottom availability,
bottom ping, poller information, devices by status, device templates and
host alerts](images/plugin-intropage-dashboard.png)

The toolbar above the panels holds one tab for each of the user's
dashboards, the **Panels** menu to add panels, a trend timespan list and the
**Actions** menu.

### Adding panels

1. Open the dashboard you want to change.

2. Select a panel from the **Panels** menu. Grayed out panels are not
   permitted for your account.

The panels are grouped into **Alerts**, **The busiest**,
**Graphical Panels**, **Syslog Panels**, **Analysis Panels**,
**Poller Panels**, **MacTrack Panels**, **Miscellaneous Panels**,
**System Panels**, **Top/Bottom 5 Panels** and **Threshold Panels**. Each
panel header has icons for **Show Details**, **Reload Panel** where the panel
allows it, and **Disable panel**, which removes the panel from the
dashboard. Panels can be moved by drag and drop; the toolbar icon
**Disable panel move/enable copy text from panel** turns this off so text
can be copied from a panel.

### Adding a Cacti Graph to a dashboard

1. Open **Graphs** and find the graph.

2. Click the eye icon, **Add to Dashboard**, next to the graph. Click it again
   to remove the graph.

Graphs viewed with a custom timespan cannot be added. The user needs the
**Favorite Graphs** permission.

### Managing dashboards

A user can create up to nine dashboards. From the **Actions** menu:

- **Add New Dashboard** and **Remove current dashboard** create and delete
  dashboards. The gear icon in the toolbar names a dashboard.

- **Share this dashboard** makes the current dashboard available to other
  users as a template, and **Cancel sharing** withdraws it. An empty
  dashboard cannot be shared.

- **Use shared dashboard** copies a shared dashboard. The copy uses the
  permissions of the user who adds it.

- The refresh, important period, number of lines, sorting
  (**Sort by Severity** or **Sort by User Preference**) and panels per line
  options override the global settings for the current user.

- **Reload Panel Definitions**, for users with
  **Intropage Administration**, reloads the panel library.

### Adding panel libraries

Panels are defined in PHP files in the plugin's `panellib` directory. Each
file has a registration function named `register_` followed by the file's
base name, which returns the panel definitions: name, description, level
(system or user), update interval, priority, default alarm color, required
plugin and the functions that collect data and draw the detail view. The
`panellib/README.md` file in the plugin describes the format.

## How It Collects Data

The plugin registers a `poller_bottom` hook that starts
`poller_intropage.php` in the background after each Cacti polling cycle. The
script:

- registers itself as a Cacti process, so only one instance runs at a time,
  limited by **Poller Timeout**;

- runs the update function of each panel whose refresh interval has passed,
  and the trend functions of panels that keep trends;

- deletes trend rows older than two days from the `plugin_intropage_trends`
  table;

- logs a line beginning `INTROPAGE STATS:` to the Cacti log with the run
  time and the number of checks, panels and trends.

The NTP, DNS and database checks run only at the intervals set in
**How often check NTP**, **How often check DNS** and
**How often analyze DB**.

## Command-Line Tools

The background poller can be run by hand from the plugin directory to test
panel collection.

```console
php poller_intropage.php [--force] [--debug]
```

- `--force` forces execution, for testing.

- `--debug` prints each step and the duration of each panel function.

- `--version` and `--help` print the version or usage.

## Troubleshooting

- A panel shows **No Data Present** until the background poller has
  collected its data. Wait for the next polling cycle or use
  **Reload Panel** if the panel allows forced updates.

- If a user sees **One or more panels was removed due to insufficient
  permissions**, grant the panels on the user's **Intropage** tab.

- `WARNING: Unable to find update function` in the Cacti log means a panel
  definition points to a function that is not loaded, for example after its
  panel library or required plugin was removed. Use
  **Reload Panel Definitions**, or enable
  **Automatically Uninstall Panels**.

- If the background poller is still running when the next cycle starts, the
  new run exits. Run `poller_intropage.php --debug` to find slow panels, and
  lower **Analyze DB - Level of db check** if the database check is slow.

## More Information

- [Intropage plugin repository](https://github.com/Cacti/plugin_intropage)

- [README for 4.0.4][readme]

[readme]: https://github.com/Cacti/plugin_intropage/blob/v4.0.4/README.md

---

Copyright (c) 2004-2026 The Cacti Group
