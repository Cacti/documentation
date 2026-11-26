# ReportIt

ReportIt builds tabular reports from the RRDfiles behind Cacti **Data
Sources**. An administrator defines **Report Templates** that apply
calculations, called measurands, to the data of one **Data Template**; users
then create reports from those templates, choose the data items to include and
the reporting period, and view the results in Cacti or export them to CSV or
XML. Reports can run on a schedule, be archived, be exported to a folder, and
be sent by email. It is meant for administrators who need periodic figures,
such as average or peak utilization per interface over a month, rather than
graphs.

## Requirements

- This page documents ReportIt 1.1.4 (release tag `v1.1.4`).

- Cacti 1.2.27 or later.

- No other plugin is required.

- ReportIt reads RRDfiles through Cacti's own RRDtool interface, so the
  RRDtool binary configured in Cacti must work. When Boost is enabled, a
  report flushes pending Boost output for its data sources before reading
  them.

- Scheduled reports need a cron job, or another scheduler, that runs
  `runtime.php`. ReportIt does not schedule reports by itself.

- Emailed reports use Cacti's mail settings.

## Installation

Install and enable the plugin as described in
[Plugin Management](Plugins.md). The plugin directory must be named
`reportit`.

After enabling the plugin:

1. Assign the ReportIt realms to the users who need them (see
   [Permissions](#permissions)).

2. Review the settings under **Console > Configuration > Settings > Reports**.

3. If you use scheduled reports with archiving or exporting, make sure the
   user that runs `runtime.php` can write to the plugin's `tmp` and `archive`
   folders and to the export folder.

The release README states that an upgrade requires an installed ReportIt
release of 0.4.0 or later, and that older releases must be uninstalled first.
Back up the Cacti database and the ReportIt folder before upgrading.

## Permissions

ReportIt registers three realms. The realm a user holds also decides the role
ReportIt gives that user: viewer, report owner, or report administrator.

###### Table 1. ReportIt realms

| Realm                       | Pages                                                     | Purpose                                              |
| --------------------------- | --------------------------------------------------------- | ---------------------------------------------------- |
| **ReportIt - View Reports**   | `view.php`, `charts.php`                                  | View reports on the **ReportIt** tab                 |
| **ReportIt - Create Reports** | `reports.php`, `rrdlist.php`, `items.php`, `run.php`      | Create, edit, run and delete reports                 |
| **ReportIt - Manage Reports** | `templates.php`, `measurands.php`, `variables.php`        | Manage report templates, measurands and variables    |

Only a user with the **ReportIt - Manage Reports** realm sees the
**Administration** tab when editing a report.

## Settings

ReportIt adds a **Reports** tab under
**Console > Configuration > Settings**.

###### Table 2. Reports settings

| Section         | Label                                    | Default                          | Purpose                                                                                     |
| --------------- | ---------------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------- |
| General         | **Maximum Execution Time (in seconds)**  | 300                              | Maximum run time of one calculation; reports running longer are marked as crashed           |
| General         | **Maximum Record Count Change**          | 100                              | Do not change a report's data item list automatically if the change exceeds this number     |
| General         | **Time Zones**                           | Off                              | Use time zones for data item configuration and calculation; the server must run in GMT/UTC  |
| General         | **Show Local Time Zone**                 | On                               | Show the server time zone in headlines                                                      |
| General         | **Allow Scheduling by Operators**        | Off                              | Let report owners change scheduling; when off only administrators can                       |
| General         | **SI-Prefixes**                          | On                               | Use binary SI prefixes under IEEE 1541 and IEC 60027-2                                      |
| Export Settings | **Filename Format**                      | `cacti_report_<report_id>`       | File name for exports created on demand                                                     |
| Export Settings | **Export Header**                        | `# Your report header # <cacti_version> <reportit_version>` | Header text written to export files                              |
| Auto Archiving  | **Enabled**                              | Off                              | Archive the result of every scheduled report                                                |
| Auto Archiving  | **Cache Life Cycle (in seconds)**        | 300                              | How long an archived report stays cached without being viewed                               |
| Auto Archiving  | **Archive Path**                         | `plugins/reportit/archive/`      | Folder that holds archives                                                                  |
| Auto E-Mailing  | **Enable**                               | Off                              | Allow scheduled reports to be emailed to a list of recipients                               |
| Auto Exporting  | **Enabled**                              | Off                              | Allow scheduled reports to be exported to a folder                                          |
| Auto Exporting  | **Export Path**                          | `plugins/reportit/exports/`      | Main folder for automatic exports                                                           |

Automatic exports are stored as main folder, then the template's folder (or
the template ID), then the report ID.

The **Email** tab of a report only appears when **Auto E-Mailing > Enable** is
on.

## Using ReportIt

The typical sequence is: create a report template for a data template, define
its measurands, publish it, create a report from it, add data items, and run
the report.

### Report Templates

Report templates are managed under **Console > Templates > ReportIt**. The
list shows each template's name, ID, author, version, data template, whether it
is published and locked, and the number of measurands, variables and reports
that use it. The actions menu offers **Delete**, **Duplicate** and **Export**,
and the **Import** button loads a template exported from another system.

A template has these fields:

- **Name**, **Description**, **Version** and **Author**.

- **Publish**: makes the template available to users. Leave it off while
  testing a new or changed template.

- **Locked**: prevents any change to the template, its measurands and its
  variables. A template cannot be unlocked until it has measurands.

- **Additional Pre-filter**: an optional SQL `LIKE` pattern (`%` and `_`)
  applied to data item descriptions. Regular expressions are not supported.

- **Export Path**: an optional folder for this template's automatic exports.

- **Data Template**: the Cacti **Data Template** the report template depends
  on. It is chosen when the template is created.

To create a report template:

1. Go to **Console > Templates > ReportIt** and click the add icon.

2. Choose the **Data Template** whose data the reports will use.

3. Fill in the general fields and save.

4. Use **Create a new variable** to add variables, which report owners can set
   per report, and **Create a new measurand** to add calculations.

5. Check **Publish** and clear **Locked** so users can build reports from the
   template.

### Measurands and Variables

A measurand is one output column of a report. Its fields are **Description**,
**Abbreviation**, **Unit**, **Consolidation function**, **Visible**,
**Separate**, the formatting options **Type**, **Precision** and **Prefixes**,
and the **Calculation Formula**. The formula editor lists the available
**Operators & Operands**, which include per data source functions such as
average, maximum, minimum, sum, number of values, last and first value,
median, mode, range, interquartile range, standard deviation, percentile, and
time or sum over a threshold, plus arithmetic and comparison operators.

A variable gives a formula a value that the report owner sets per report. Its
fields are **Internal name**, **Name**, **Description**, **Maximum Value**,
**Minimum Value**, **Default Value**, **Type** and **Stepping**.

### Reports

Reports are managed under **Console > Management > ReportIt**. The list shows
each report's name, ID, state, last run time, runtime, whether it is public or
scheduled, and its data items. The actions menu offers **Run**, **Delete** and
**Duplicate**. A report's state is **Idle**, **Running**, **FAILED** or
**CRASHED**.

To create a report:

1. Go to **Console > Management > ReportIt** and click the add icon.

2. Choose a published, unlocked report template.

3. On the **General** tab, set the **Name**, **Owner** and **Public** options
   and the reporting period. Either check **Sliding Time Frame** and pick a
   **Time Frames** value such as **Last Month**, or enter
   **Fixed Time Frame - Start Date (From)** and
   **Fixed Time Frame - End Date (To)** as `yyyy-mm-dd`.

4. Under **Scheduled Reporting**, check **Enable** and pick a **Frequency**
   (daily, weekly, monthly, quarterly or yearly) if the report should run on a
   schedule. Set **Auto Generated Data Items**, **Auto Generated Archive**,
   **Auto Generated Email**, **Auto Generated Export**, **Export Limitation**
   and **Raw Data Export** as needed.

5. Save, then click **Add Data Items** and select the data sources to
   include.

6. On the **Data Item Presets** tab, set the defaults for new data items:
   **Subhead (optional)**, **Time Zone**, **Working Time** and
   **Working Days**, and the optional **Device Template Filter (optional)** and
   **Data Items Filter (optional)**.

7. If emailing is enabled, use the **Email** tab to set the **Subject**,
   **Body (optional)**, **Attachment** format and the recipients.

8. Select the report in the list, choose **Run** and click **Go**.

A report administrator can also use the **Administration** tab to
**Change Report Owner** and to turn **Enable Use of Graph Permissions** on or
off. When it is on, the data items offered to the owner are limited by the
owner's graph permissions by device.

### Viewing and Exporting Reports

The **ReportIt** tab at the top of the Cacti window lists the reports a user
may see, filtered by **Public Reports** or **My Reports**. Opening a report
shows a summary (title, owner, period, sliding time frame, scheduler state,
last run and runtime) and a table with one row per data item and one column per
measurand. Filters select a **Measurand**, a **Data Source**, and options such
as **Show Top 10 Graphs**, **Show Subheads** and **Show Summary**. When
archiving is enabled, the **Archive** filter selects an older run instead of
the current result.

Reports can be exported as **Text CSV (.csv)**, **Raw XML (.xml)** or
**MS Excel 2003 XML (.xml)**.

## Background Processing

ReportIt adds a `poller_bottom` hook. After each Cacti polling cycle it:

- marks reports that have been running longer than
  **Maximum Execution Time (in seconds)** as crashed, and

- drops cached report tables (`reportit_tmp_*`) that have not been used for
  longer than **Cache Life Cycle (in seconds)**, and removes their entries from
  the `plugin_reportit_cache_*` tables.

The hook does not run reports. Scheduled reports are calculated by
`runtime.php`, which must be started by cron or another scheduler for each
frequency in use. During a scheduled run ReportIt can rebuild the data item
list, archive the result, export it, and send the email, according to the
report's settings and the global settings.

## Command-Line Tools

`runtime.php` calculates one report, or all scheduled reports of one
frequency. Run it as the user that runs the Cacti poller.

```console
php runtime.php [OPTIONS] <Report Config ID>
```

The help text of the script describes these options:

###### Table 3. runtime.php options

| Option    | Meaning                                  |
| --------- | ---------------------------------------- |
| `-d`      | Run all daily scheduled reports          |
| `-w`      | Run all weekly scheduled reports         |
| `-m`      | Run all monthly scheduled reports        |
| `-q`      | Run all quarterly scheduled reports      |
| `-y`      | Run all yearly scheduled reports         |
| `-v`      | Verbose output                           |
| `--debug` | Debug mode                               |

Give either a report ID or a frequency, not both. Examples from the help text:

```console
php runtime.php 12
php runtime.php -d -v
php runtime.php --debug -v 12 > log.txt
```

## Troubleshooting

- A scheduled report never runs: check that a cron entry exists for the
  report's **Frequency**. The **Frequency** field states that ReportIt does not
  create it.

- A report stays in the **CRASHED** state: it ran longer than
  **Maximum Execution Time (in seconds)**. Raise the value or reduce the number
  of data items.

- No templates are offered when creating a report: only published, unlocked
  templates can be used. ReportIt reports how many templates are locked or
  disabled.

- Archives or exports are not written: the user that runs `runtime.php` needs
  write access to the `tmp`, `archive` and export folders.

- The Cacti log shows `REPORTIT WARNING: Unable to clean up report cache` when
  the cache cleanup in the poller hook fails to drop expired tables.

- Run a single report with `php runtime.php --debug -v <id>` to see each step
  of the calculation.

## More Information

- [ReportIt plugin repository][repo]

- [ReportIt 1.1.4 README][readme]

The release also ships a `MANUAL.PDF` in the plugin directory.

[repo]: https://github.com/Cacti/plugin_reportit
[readme]: https://github.com/Cacti/plugin_reportit/blob/v1.1.4/README.md

---

Copyright (c) 2004-2026 The Cacti Group
