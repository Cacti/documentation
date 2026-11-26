# TopX

TopX ranks the data sources of one data template by their average or peak
value over a chosen period, for example the busiest interfaces by traffic or
the hosts with the highest CPU utilization. It reads the statistics that
Cacti's Data Source Statistics (dsstats) feature already collects, so it adds
no polling of its own. Network and system administrators use it to find the
heaviest or lightest data sources without opening graphs one by one.

This page follows the plugin's development branch (`master`), which is
unreleased and can change. That branch declares version 0.7 and Cacti
compatibility 1.0.0 in its `INFO` file. The supported plugins list asks you to
check repository compatibility before use, so confirm that the branch works
with your Cacti version on a test system first.

## Requirements

- Plugin version 0.7 and Cacti compatibility 1.0.0, as declared in `INFO`.
- No other plugins are required.
- Data Source Statistics must be enabled in Cacti. If it is off, the TopX
  page shows only a link to the **Console > Configuration > Settings > Data**
  tab and nothing else. Let dsstats collect samples before expecting results.
- The page draws its bar chart with a bundled Chart.js script. No PHP
  extensions or external programs are called.

## Installation

Follow [Plugin Management](Plugins.md) for the generic steps. In addition:

1. Copy the plugin into `plugins/topx` under the Cacti root. The directory
   must be named `topx`, not `plugin_topx`.
2. Make the files readable by the web server user.
3. Install and enable the plugin in **Console > Configuration > Plugin
   Management**.

Installation creates two tables, `plugin_topx_source` and
`plugin_topx_average`, and inserts the built-in source definitions into the
first.

Uninstalling the plugin drops both tables, including any source definitions
you added. The plugin has no schema migration hook, so replacing the files
does not change an existing database layout. Back up the database before an
upgrade and do not use uninstall followed by install as an upgrade step when
you need to keep customized source definitions.

## Permissions

| Realm | Pages |
| --- | --- |
| **Plugin topx - view** | `topx.php` |

Users who are not administrators need this realm to open the TopX page and to
see the tab that links to it.

## Settings

TopX has no settings of its own and adds nothing to the Cacti settings pages.
The only configuration it depends on is Data Source Statistics, which is
enabled under **Console > Configuration > Settings > Data**.

The data sources that TopX can rank are rows in the `plugin_topx_source` table
that `setup.php` creates at install time. There is no page for editing them.
Adding another one means editing `setup.php` and `topx.php` as described in
`HOW_TO_ADD_YOUR_DATA.txt` in the plugin directory.

## Using TopX

TopX adds a **TopX** tab to the Cacti top bar and to the graph view tabs for
users who hold the realm above.

The page title is **TopX**. Above the results is a filter row. Changing any
drop-down reloads the page with the new choice; **Go** refreshes and **Clear**
resets the filters.

| Filter | Choices |
| --- | --- |
| Data source | Data templates that match a built-in source definition are listed first, then every other data template with the prefix `unsupported -`. Each entry ends with the number of data sources in parentheses. |
| Age | Last Hour (default), Last Day, Last Week, Last Month, Last year |
| Number of records | Top 5 (default), Top 10, Top 20, Top 50, All |
| Order | Normal (ascending) or Reverse (descending, the default) |
| What | Average (default) or Peak |

The built-in source definitions are:

- ucd/net - Load Average - 1 Minute
- Host MIB - CPU Utilization
- Host MIB - Hard Drive Space
- Interface - Errors_in + Discards_in
- Interface - Errors_out + Discards_out
- Mikrotik - System - Uptime
- APC load
- MultiCPU AVG
- Interface - Traffic_in+Traffic_out

A definition only appears in the list when a data template with the matching
hash exists in your Cacti installation.

The result is a table with the columns **Data source**, **Avg. value** and
**Peak**, followed by a row **Average all DS**. Each data source name links to
the edit page of its graph. Values of built-in definitions are scaled with
their own unit, for example bits become Kbit, Mbit or Gbit and uptime becomes
seconds, minutes, hours or days. Entries marked `unsupported` are shown as
plain numbers with decimal prefixes and no unit.

Below the table a bar chart shows the same values. The chart is drawn only
when 50 or fewer records are shown; with **All** on a large installation, the
page prints a note that no graph is displayed. At the bottom the page prints
the last major and last daily run times of Data Source Statistics, which tell
you how current the numbers are.

To find the busiest interfaces over the last week:

1. Open the **TopX** tab.
2. Select **Interface - Traffic_in+Traffic_out** in **Data source**.
3. Select **Last Week** in **Age** and **Top 10** in **Number of records**.
4. Leave **Order** on **Reverse** and **What** on **Average**, or select
   **Peak** to rank by peak values.

This manual does not include a screenshot for TopX.

## Background Processing

TopX has no poller hooks and no scheduled work. The hooks that would feed the
`plugin_topx_average` table are commented out in `setup.php`, and the page
reads the Cacti tables `data_source_stats_hourly`, `data_source_stats_daily`,
`data_source_stats_weekly`, `data_source_stats_monthly` and
`data_source_stats_yearly` according to the **Age** filter. How often those are
refreshed is controlled by Data Source Statistics in Cacti, not by TopX.

## Troubleshooting

- The page shows only a link and no results: Data Source Statistics is not
  enabled. Enable it under **Console > Configuration > Settings > Data**.
- The list or table is empty or old: dsstats has not yet run for the selected
  age. Compare against the run times printed at the bottom of the page.
- A definition is missing from **Data source**: no data template with the
  definition's hash exists in this Cacti installation.
- No chart appears: more than 50 records are selected.
- A user cannot see the tab or page: grant the **Plugin topx - view** realm.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_topx)
- [README](https://github.com/Cacti/plugin_topx/blob/master/README.md)
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

---

Copyright (c) 2004-2026 The Cacti Group
