# ReportIt

ReportIt builds tabular reports from the RRD files that Cacti already collects.
An administrator defines a report template with variables and metrics (the
calculations), users create reports from a template, pick the data sources to
analyze and a reporting period, and ReportIt calculates minimum, maximum,
average, percentile and similar results for each data source. Reports can run
on a schedule and be sent by email. It is for administrators and report owners
who need periodic summaries, such as monthly utilization figures, rather than
graphs.

This page follows the plugin's `develop` branch, which is unreleased and can
change. The branch declares version 3.0 and Cacti compatibility 1.3.0 in its
`INFO` file. Do not treat this page as a description of a released version.

## Requirements

- Version 3.0 and Cacti 1.3.0 or later, as declared in `INFO`.
- PHP 8.3 or later, as required by `composer.json`.
- No other Cacti plugin is listed in `INFO` as required. Notification lists
  in the email settings appear only when the `plugin_notification_lists` table
  exists.
- RRDtool, through Cacti's own RRD interface. The calculation reads the RRD
  files of the selected data sources. When Cacti's Boost is active, the
  calculation runs an on-demand update before it fetches data.
- The PHP `yaml` extension is optional. The YAML attachment format is offered
  only when it is loaded.
- The PHP binary path that Cacti stores in its **Paths** settings, which the
  poller uses to start the report process.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md). Install the plugin
in `plugins/reportit` (the directory name must be `reportit`, not
`plugin_reportit`).

After installation:

1. Grant the ReportIt realms to users or groups under **Console > Utilities >
   User Management**. See Permissions below.
2. Review the settings under **Console > Configuration > Settings > Reports**.

The installer creates its own tables with the `plugin_reportit_` prefix.
Uninstalling the plugin drops them, including all reports, templates and
recipients, so back up the database first.

The plugin's README notes that, on the current Cacti 1.3 development line,
the Cancel buttons on ReportIt forms need a click binding for the
`cactiReturnTo` class in Cacti's `include/layout.js`. If your Cacti release
lacks that binding, see the README for the snippet.

## Permissions

The plugin registers three realms in `setup.php`.

| Realm | Pages covered |
| --- | --- |
| ReportIt - Report Viewing | `view.php` |
| ReportIt - Create Reports | `reportit.php`, `view.php` |
| ReportIt - Manage Reports | `templates.php` |

When Cacti supports role augmentation, the plugin also adds `view.php` to the
**Normal User** role, `reportit.php` to **General Administration**, and
`templates.php`, `measurands.php` and `variables.php` to **System
Administration**.

A report owner can change only their own reports. A user with the
**ReportIt - Manage Reports** realm acts as report administrator and can see
every report and use the **Take Ownership** action.

## Settings

Settings are on the **Reports** tab of **Console > Configuration > Settings**.
The same per-user options also appear for each user on the **Report General
Settings** tab of the user's graph settings.

### General

| Setting | Default | Purpose |
| --- | --- | --- |
| **Maximum Execution Time (in seconds)** | 300 | Maximum execution time of one calculation. |
| **Maximum Record Count Change** | 100 | With **Auto Generated Data Items**, the RRD list of a report is not changed if the record count would change by more than this number. |
| **Time Zones** | off | Use time zones for data item configuration and report calculation. The description says that the server time must then be set to GMT/UTC. |
| **Show Local Time Zone** | on | Show the server time zone in the headlines. |
| **Allow Scheduling by Operators** | off | Lets report owners change scheduling. When off, only administrators can change it. |
| **SI-Prefixes** | on | Use correct SI prefixes for binary multiples (IEEE 1541, IEC 60027-2). |

### Auto E-Mailing

| Setting | Default | Purpose |
| --- | --- | --- |
| **Enable** | off | Lets scheduled reports be emailed to a list of recipients. The **Email** tab of a report appears only when this is on. |

### Per-user report options

| Setting | Default | Purpose |
| --- | --- | --- |
| **Separate Report View Filter** | on | Use an individual filter for each report. |
| **Rows Per Page** | 25 | Number of rows on a single page. |
| **CSV Column Separator** | first entry (comma) | Column separator for CSV exports. Choices are comma, semicolon, Tab and Blank. |
| **CSV Decimal Separator** | first entry (comma) | Symbol that separates the integer and fractional parts. Choices are comma and period. |

## Using ReportIt

The plugin adds these places to the Cacti interface.

| Location | Page |
| --- | --- |
| **Console > Management > ReportIt Reports** | Report list and report editor (`reportit.php`). |
| **Console > Templates > ReportIt** | Report template list and editor (`templates.php`). |
| **ReportIt** tab | Reports that the user may view (`view.php`, titled **Public Reports**). The tab is shown to users with the **ReportIt - Report Viewing** realm. |

The following screenshot shows the report list. It uses synthetic data: two
example reports with their period, schedule, state, next start and last
runtime.

![Reports list with two synthetic reports][img-reportit-reports]

The list has a search box, a rows selector and, for administrators, owner and
template filters. Select one or more reports and choose an action: **Run Now**,
**Delete**, **Disable**, **Duplicate**, **Enable** or **Take Ownership**. The
**State** column shows Idle, Running, FAILED or CRASHED.

The next screenshot shows the template list with synthetic data: two templates
with their data template, version, published and locked state, metrics,
variables and report counts.

![Template list with two synthetic templates][img-reportit-templates]

### Create a report template

Templates require **ReportIt - Manage Reports**.

1. Go to **Console > Templates > ReportIt** and add a template. The wizard asks
   for the data template the report is based on.
2. On the **General** tab, set the name, description, version and author.
   **Publish** makes the template available to users, and **Locked** blocks any
   change to the template, its metrics and its variables. The description
   advises leaving a new template unpublished while testing. An optional
   **Additional Pre-filter** limits the data items by description using SQL
   wildcards (`%` and `_`, not regular expressions).
3. On the **Variables** tab, define variables that report owners can set. Each
   has a name, internal name, maximum, minimum, default, stepping, input type
   (**Dropdown** or **Input field**) and options.
4. On the **Metrics** tab, define the calculations. Each metric has an
   abbreviation, group, unit, consolidation function, visible and separate
   flags and a calculation formula.
5. Clear **Locked** and keep **Publish** on. A template without metrics cannot
   be unlocked.

Template actions are **Delete**, **Duplicate**, **Lock**, **Unlock** and
**Export**. The **Import** button on the template list imports a template file.
Formulas can use the functions that the plugin provides, such as `f_avg`,
`f_max`, `f_min`, `f_sum`, `f_num`, `f_median`, `f_sd`, `f_xth` (percentile),
`f_dot` (duration over threshold), `f_sot` (sum over threshold) and `f_if`. The
template editor lists all of them with their parameters.

### Create a report

Creating a report requires **ReportIt - Create Reports**.

1. Go to **Console > Management > ReportIt Reports** and add a report. Choose
   one of the unlocked, published templates. If none exists, the page shows
   that no unlocked and enabled template is available.
2. On the **General** tab, set the name, **Enabled**, **Public**,
   **Enable Use of Graph Permissions** (default on) and **Auto Generated
   Email**.
3. Choose the reporting period. With **Sliding Time Frame** the period follows
   the time of calculation: pick a value under **Time Frames**, from **Today**
   to **Last 2 Years**, and optionally **Up To The Day of Calculation**.
   Otherwise enter a fixed start and end date as `yyyy-mm-dd`.
4. On the **Data Source Presets** tab, set the working time, working days and
   time zone. Optional pre-filters by site, device template and data source
   name limit the data sources, and **Auto Generated Data Items** adds and
   removes data items from those filters before each run.
5. On the **Data Sources** tab, add the data items to report on.
6. For scheduled reports, set the schedule with the scheduler fields that
   Cacti's report scheduler adds to the **General** tab (the plugin defines
   the frequencies Daily, Weekly, Monthly, Quarterly and Yearly), and enable
   the report.
7. If **Enable** under **Auto E-Mailing** is on, use the **Email** tab to set
   the subject, body, attachment format, a notification list, to and BCC
   addresses and individual recipients. The default subject is `Scheduled
   report - |title| - |period|`. The attachment formats are **None**, **Text
   CSV (.csv)**, **MS Excel 2003 XML (.xml)**, **Raw XML (.xml)**, **JSON Data
   (.json)** and, with the `yaml` extension, **YAML Data (.yaml)**.

### View a report

Open the **ReportIt** tab and choose a report. The filter offers **Public
Reports** or **My Reports**. The report page shows a table or a graph view,
a summary, and filters for metric and data source. Use the export dropdown
under the table to download the table as CSV, raw XML or MS Excel 2003 XML.

## Background Processing

ReportIt hooks into `poller_bottom`. On each poller run it:

1. Drops temporary result tables named `plugin_reportit_tmp_*` that have not
   been updated within the cache lifetime, and removes their rows from the
   `plugin_reportit_cache_*` tables. The lifetime comes from the
   `reportit_arc_lifecycle` setting and falls back to 300 seconds. The plugin
   does not add a settings field for it.
2. Checks every enabled report with Cacti's report scheduler. Reports that are
   due are placed in Cacti's report queue with their email and notification
   list information.
3. If any report was queued, starts `poller_reportit.php --scheduled` in the
   background.

The first poller run after installation only records the time and does not
queue reports.

Report calculations write their results into tables whose names are tied to
the report ID, so the database grows with the number of reports and data
items. The maximum run time of one calculation is the **Maximum Execution Time
(in seconds)** setting. Report errors and warnings are written to the Cacti log
with the `REPORTIT` tag, and the log viewer links report and data item IDs
written as `RIReport[...]` and `RIDataItem[...]` to their edit pages.

Version 3.0 removes the earlier archive and export workflow and uses Cacti's
report log instead.

## Command-Line Tools

`poller_reportit.php` launches reports. Run it as the Cacti poller user from
any directory.

```console
usage: poller_reportit.php [ --report-id=N ] [ --queue-id=N ] [ --scheduled ] [--verbose] [--debug]

Provide either of the following:
  --report-id=N  Run as specific report now
  --queue-id=N   The queued report id
Optional:
  --debug        Provide debug output
  --scheduled    Run the scheduled reports
  --verbose      Provide verbose output
```

The script also accepts `--help` and `--version`. An unknown option prints an
error and the usage text.

## Troubleshooting

- A report does not start: a run only accepts a report whose template is
  unlocked. Otherwise it prints "ERROR: Invalid report ID !".
- You cannot unlock a template: the interface shows "Unable to unlock this
  template without defined measurands". Add a metric first.
- A template save fails with "No data source item selected" or "Unselected
  data source items are still in use": adjust the data source item selection
  on the template.
- No reports are created on the first poller run after installation. This is
  expected.
- The YAML format is missing from the attachment list: the PHP `yaml`
  extension is not loaded. If YAML is requested without it, the plugin logs a
  warning with the `REPORTIT` tag.
- Results are missing for a data item: if the RRD file does not exist, the run
  logs a "Non existing RRD file" error for that data item.
- Cancel buttons do nothing: see the `cactiReturnTo` note under Installation.

## More Information

- [ReportIt repository](https://github.com/Cacti/plugin_reportit)
- [ReportIt README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-reportit-reports]: images/plugin-reportit-reports.png
[img-reportit-templates]: images/plugin-reportit-templates.png
[readme]: https://github.com/Cacti/plugin_reportit/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
