# Intropage

Intropage adds dashboards made of panels to Cacti. A panel shows one piece of
information, for example the state of devices, poller statistics, an analysis
of the Cacti log, the worst ping times, recent threshold events, or a graph that
a user has added. The dashboards appear below the console page or on a separate
tab. Administrators who want an overview of the health of the monitoring system
and users who want a personal start page both use it.

This page follows the plugin's `develop` branch, which is unreleased and can
change. In its `INFO` file that branch declares version 4.1.0 and compatibility
with Cacti 1.2.29. Check the release you install for differences.

## Requirements

- Cacti 1.2.29 or later, as declared in the `INFO` file. The `INFO` file lists
  no required plugins.
- A working Cacti poller. The panel data comes from `poller_intropage.php`,
  which Cacti starts at the end of every polling cycle with the PHP binary from
  the **Paths** setting `path_php_binary` (`php` when it is empty).
- The Busiest panels read Cacti's data source statistics tables
  (`data_source_stats_hourly`), so they show data only when Cacti collects
  those statistics.
- Some checks call external facilities: the NTP check opens a UDP socket to the
  configured NTP server, the DNS check resolves the configured name, and the
  Analyze Cacti Objects panel runs `nproc` (or `sysctl` or PowerShell on other
  systems) to count CPU cores.

### Other plugins

Intropage works without any other plugin. These panels are offered only when
the plugin they need is installed and enabled:

| Plugin | Panels |
| --- | --- |
| thold | Last Threshold Events, Threshold, 24 Hour Extremes |
| syslog | Syslog Details, Syslog Top Devices, Syslog Message levels |
| mactrack | MacTrack Plugin, MacTrack Sites |
| maint | Maint Plugin Details |
| webseer | Webseer Details |
| servcheck | Servcheck plugin Details |

## Installation

Follow the generic steps in [Plugin Management](Plugins.md). The plugin
directory must be named `intropage`. Plugin-specific points:

- Installing creates the plugin tables and registers the hooks and realms. The
  plugin is not active until you enable it.
- After installation, grant access to panels. Open **Console > Configuration >
  Users**, edit a user and select the **Intropage** tab. The same tab exists
  for user groups under **Console > Configuration > User Groups**. Each panel is
  a checkbox, grouped into **System Level Panels** and **User Level Panels**.
  A user can use a panel when the user or one of the user's groups has it.
- Users who have not been given any panel see an empty dashboard.
- Uninstalling the plugin drops its tables.
- On upgrade the plugin compares the `INFO` version with the stored version and
  updates its tables. It also removes files that its `manifest.json` lists as
  obsolete and logs any unlisted top-level entry in the Cacti log without
  removing it.

## Permissions

The plugin registers three realms in `setup.php`. Grant them under **Plugin
Permissions** on the **Permissions** tab of a user or group.

| Realm | Page | Allows |
| --- | --- | --- |
| Intropage Viewer | `intropage.php` | Opening the dashboard. Part of the Normal User role. |
| Intropage Administration | `intropage_admin.php` | Reload Panel Definitions, and access to system level panels. Part of the System Administration role. |
| Intropage Panel Library | `intropage_panels.php` | The Panel Library page. |

Panel permissions are separate from realms and are set on the **Intropage** tab
of the user or group, as described above. A user created or copied later gets
the default panel permissions defined by the plugin's hooks.

## Settings

Settings are under **Console > Configuration > Settings > Intropage**. Users
can override some display choices for themselves from the **Actions** list on
the dashboard.

### Display Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| Important things will be at the top | off | Show important (error, warning) information first. |
| Display more panels on a line | off | For wide screens. |
| Automatically Uninstall Panels | off | Remove the panels of a plugin that is no longer installed. |
| Automatic Page Refresh | Every Minute | How often the page reloads: Automatically by poller, Never, Every Minute, Every 5 Minutes, Every Hour. |
| Important period | 1 hour | How far back rows are colored as important: Disabled, 15 minutes, 1 hour, 4 hours, 1 day. Older events are displayed but not highlighted. |
| Number of panel lines | 5 lines | Lines per panel: 5, 10 or 15. |
| Trend Timespan | Timespan Last 4 Hours | Default timespan of trend charts, from 1 hour to 2 days. |
| Poller Timeout | 30 Minutes | How long the background script may run before Cacti stops it, from 1 minute to 1 hour. |
| Analyze Log - number of lines | 500 | Log lines analyzed. The panel uses this number of lines and the detail window uses twice as many. |
| Analyze DB - Level of db check | Changed | Quick, Fast, Changed, Medium or Extended. Medium and Extended can slow the page load. |
| NTP Time Check - IP or DNS name of NTP server | pool.ntp.org | Server for the NTP check. |
| DNS Check - Any DNS name | dns.google | Name resolved by the DNS check. |
| Admin Information Panel about Maintenance Tasks, Down Devices, .. | empty | Text shown in a panel at the top when it is not empty. |
| Upcoming Maint Schedule warning days | 1 Day Before | Never warn, When maintenance starts, or 1, 3 or 7 days before a maintenance schedule. |
| Network stats in | Bits | Bytes or Bits. |

The settings page also lists **How often analyze DB**, **How often check NTP**
and **How often check DNS**. The update frequency of the corresponding panels
is set per panel with the cog icon on the dashboard.

### Alarm Settings

Each of these chooses the status color (Red Status, Yellow Status or Green
Status) of a panel when the condition occurs.

| Setting | Default |
| --- | --- |
| Alarm DB check Aborted Clients | Yellow |
| Alarm Host with the same Description | Yellow |
| Alarm Orphaned Data Source | Yellow |
| Alarm non-empty Poller Output | Red |
| Alarm Bad indexes Data Source | Red |
| Alarm Threshold logonly action | Red |
| Alarm when device bulk_walk_size is not optimized | Red |
| Alarm Devices with the same IP/port | Yellow |
| Alarm Device in more than one Tree | Yellow |
| Alarm Device without a Tree | Yellow |
| Alarm Device with Default public/private SNMP Community | Yellow |
| Alarm Device without Monitoring | Yellow |
| Alarm Device without Graph | Yellow |

Four more settings choose thresholds as a yellow and red pair: **Alarm
Red/Yellow Polling Time** (default 10s / 20s), **Alarm Red/Yellow Failed/All
Ratio** (default 0.2 / 0.4), **Alarm Red/Yellow Ping** (default 10ms / 20ms)
and **Alarm Red/Yellow Worst Availability** (default 99 / 95%).

## Using Intropage

A user can have up to nine dashboards. Dashboards are selected with the tabs
above the panels. Where the dashboard appears depends on the user's login
option:

- Below the console page, when the user has console access. This is the default
  placement and the page then shows a note about the Cacti setting **Hide Cacti
  Dashboard**.
- On its own **Intropage** tab at the top of the Cacti window, when the user
  has no console access or has chosen **Display Intropage in Tab as Default
  Page**. The user then lands on the dashboard after login.

The next screenshot shows a dashboard with synthetic data: bottom availability,
bottom ping, poller information, devices by status, device templates, the Cacti
object analysis and host alerts panels, with the toolbar at the top right.

![Intropage dashboard with seven synthetic panels][intropage-image]

The toolbar above the panels has these controls:

- **Panels** adds a panel. Panels the user is not allowed to use are disabled
  in the list.
- The cog icon opens the page where dashboards are named and where the update
  frequency of panels is changed.
- The **Timespan** list sets the timespan of trend charts.
- **Actions** holds dashboard-level choices: Add New Dashboard, Remove current
  dashboard, Number of lines, Refresh Now and the automatic refresh options,
  the Important period, Sort by Severity or Sort by User Preference, More or
  Less panels on a line, and the login placement options. Users with the
  Intropage Administration realm also see **Reload Panel Definitions**.
- Panels can be dragged, resized, opened in a larger detail window, reloaded
  when the panel allows it, and disabled. A drag toggle turns dragging off so
  that text in a panel can be copied.

### Add a favorite graph

1. Open any graph in the Cacti graph view.
2. Click the eye icon next to the graph. The icon is shown to users who have
   the **Favorite Graphs** panel.
3. Open the dashboard. The graph is now a panel.

### Share a dashboard

1. On the dashboard to share, choose **Share this dashboard** in the
   **Actions** list. A dashboard without panels cannot be shared. **Cancel
   sharing** stops sharing it.
2. Another user chooses **Use shared dashboard** in the **Actions** list. This
   creates a new dashboard for that user from the shared one. Panels the user
   has no permission for are removed when the dashboard is opened.

### Panel Library

Users with the Intropage Panel Library realm see **Console > Intropage > Panel
Library**. The page lists every panel with its **Panel Name**, **Source**,
**Status**, **Category**, **Level**, **Requires**, **Update Function** and
**Refresh**. It can be filtered by search text and **Source**, and its
**Actions** menu enables or disables the selected panels.

### Panels

| Group | Panels | Level |
| --- | --- | --- |
| Alerts | Host alerts | User |
| Analysis | Analyze Logins, Analyze Logs, Database Checks, Analyze DS stats | System |
| Analysis | Analyze Cacti Objects | User |
| The busiest | Busiest CPU, Busiest ucd/net - Load, Busiest Hard Drive Space, Busiest uptime, Busiest Interface in/out traffic, Busiest Interface error, Busiest Interface utilization | User |
| Graphical | Data Sources, Device Templates, Devices by Status | User |
| Miscellaneous | NTP/DNS Status, Webseer Details, Servcheck plugin Details | System |
| Miscellaneous | Maint Plugin Details | User |
| Poller | Poller Information, Poller Statistics, Poller Output Items | System |
| System | Information, Administrative Alerts, Boost Statistics, Boost History, CPU Utilization | System |
| System | 24 Hour Extremes | User |
| Top/Bottom 5 | Bottom Ping, Bottom Availability, Bottom Polling Time, Bottom Polling Ratio | User |
| Syslog | Syslog Details, Syslog Top Devices, Syslog Message levels | System |
| Threshold | Last Threshold Events, Threshold | User |
| MacTrack | MacTrack Plugin, MacTrack Sites | User |

System level panels show the same content to every user. User level panels are
limited to what the user is allowed to see in Cacti.

### Adding your own panels

Panels are defined in the files of the plugin's `panellib` directory. Every
`.php` file there is loaded. Each file has a function named `register_` plus the
file name without `.php`, which returns the array of panels. The keys of a
panel (`name`, `description`, `class`, `level`, `refresh`, `update_func` and
others) are described in `panellib/README.md` in the plugin. After adding or
changing a file, an administrator runs **Reload Panel Definitions** from the
**Actions** list, then grants the panel to users.

Other plugins can publish panels from their own directory by calling
`intropage_register_panel()`. Guard the call with
`function_exists('intropage_register_panel')` so the plugin works when Intropage
is absent. The older `intropage_add_panel()` and `intropage_remove_panel()`
functions only write a warning to the Cacti log.

## How It Collects Data

The `poller_bottom` hook starts `poller_intropage.php` in the background after
every polling cycle. For every panel row that is due, it runs the panel's
update function and stores the result in the plugin tables. Details:

- Only one copy runs at a time. A second start exits quietly while the first is
  registered as running. **Poller Timeout** limits the run time.
- Each panel has its own update frequency, and trend panels have their own trend
  frequency. Defaults are part of the panel definition. A user can change the
  frequency for personal panels, and an administrator for system panels, with
  the cog icon.
- On every run the script moves the plugin to the first position in Cacti's
  plugin order so that it sees the results of other plugins.
- It keeps the panel registration catalog in sync with the `panellib` files and
  removes registrations of plugins that no longer exist.
- Trend values in `plugin_intropage_trends` older than two days are deleted at
  the end of each run.
- When it finishes, it writes a line starting with `INTROPAGE STATS:` to the
  Cacti log and stores the same figures (time, checks, panels, trends) in the
  `stats_intropage` setting.

Dashboard data lives in the tables `plugin_intropage_panel_definition`,
`plugin_intropage_panel_data`, `plugin_intropage_panel_dashboard`,
`plugin_intropage_dashboard`, `plugin_intropage_user_auth`,
`plugin_intropage_user_group_auth`, `plugin_intropage_panel_registration` and
`plugin_intropage_trends`. Removing a user or user group removes that user's or
group's Intropage rows.

## Command-Line Tools

The poller script can be run by hand from the plugin directory as the Cacti
poller user:

```console
php poller_intropage.php [--force] [--debug]
php poller_intropage.php --version
php poller_intropage.php --help
```

- `--debug` prints each step as it runs.
- `--force` is listed as "force execution" in the help text.
- `--version` and `--help` print the version banner and usage.

## Troubleshooting

- An empty dashboard after installation means the user has not been granted any
  panels. Edit the user or group and use its **Intropage** tab.
- The message "One or more panels was removed due to insufficient permissions"
  appears when a shared dashboard contains panels the user may not use.
- A panel that says "No Data Found" has no stored result yet. Wait for the next
  poller cycle or use the reload icon when the panel offers it.
- A plugin panel that does not render usually needs its plugin enabled. The
  **Requires** column of the Panel Library shows the plugin.
- Warnings that start with `WARNING: intropage` in the Cacti log, for example
  about files that could not be removed or entries not listed in
  `manifest.json`, are written during an upgrade. Check the file permissions of
  the plugin directory.
- If the poller script appears not to run, check the `INTROPAGE STATS:` lines in
  the Cacti log and that `path_php_binary` is correct.

## More Information

- [Intropage repository](https://github.com/Cacti/plugin_intropage)
- [Intropage README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[intropage-image]: images/plugin-intropage-dashboard.png
[readme]: https://github.com/Cacti/plugin_intropage/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
