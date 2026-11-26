# MySQL/MariaDB Slow Log Viewer

The Slowlog plugin imports a MySQL or MariaDB slow query log into the Cacti
database and summarizes it by query method and by table, with charts and a
searchable list of individual queries. Cacti administrators and database
administrators use it to find which statements and tables account for slow
queries, whether the log comes from the Cacti database or from another
database server.

## Requirements

- This page documents Slowlog 2.1 (release tag `v2.1`).

- Cacti 1.2.23 or later (INFO `compat`).

- No other plugin is required.

- The installer creates the `plugin_slowlog_details`,
  `plugin_slowlog_details_methods` and `plugin_slowlog_details_tables` tables
  with the Aria storage engine, which MariaDB provides.

- The web server's PHP `upload_max_filesize` and `post_max_size` limits must
  be larger than the log files you upload. The import page shows the current
  values.

## Installation

Install the plugin as described in [Plugin Management](Plugins.md). The
plugin needs no configuration file. Installing it creates the
`plugin_slowlog` tables and loads the query methods and the reserved word
list from `keywords.txt`. Uninstalling it drops all `plugin_slowlog` tables
and the imported logs with them.

## Permissions

The plugin registers one realm. Users without it do not see the
**SlowLog** tab.

###### Table 1. Slowlog realm

| Realm                           | Pages         |
| ------------------------------- | ------------- |
| Plugin -> MySQL Slow Log Viewer | `slowlog.php` |

## Settings

The plugin adds no settings to **Console > Configuration > Settings**. The
options that control an import are on the import form described below.

## Using Slowlog

Click the **SlowLog** tab. The page has up to five tabs: **Summary**,
**By Method**, **By Table**, **Details** and, when a single query is open,
**Query**. Only **Summary** is shown until a log is selected.

### Importing a slow log

1. On the **Summary** tab, click the add icon in the
   **MariaDB/MySQL SlowLog File Filters** box.

2. Under **Import Template from Local File**, choose the slow log file.

3. Enter a **LogFile Description**. The default is `New Slow Log`.

4. Choose **Max Query Length**: **All**, or the first 1024 to 16384
   characters of each query.

5. To get per-table statistics, either check **Use This Cacti Database** if
   the log comes from this Cacti server's database, or paste a space-delimited
   list of table names into **Tables of Interest**. Leave both empty to let
   post-processing detect the tables from the queries.

6. Click **Import**.

The file is read in the web request and its entries are stored. Post
processing, which assigns each query to a method and to tables, continues in
the background. The **Summary** list shows the **Import Status** as
**Pre-Processing**, **Post-Processing** or **Complete** together with the
**Status String**, the number of **Lines**, and the log's **Start Date**,
**End Date** and **Duration**. Start analyzing the details once the status is
**Complete**.

### By Method and By Table

Each log on the **Summary** list has three icons: **View Methods**,
**View Tables** and **View Details**. They open the **By Method**,
**By Table** and **Details** tabs for that log. **By Method** and
**By Table** each draws six charts: the number of
queries, total query time, rows examined, rows sent, rows affected and bytes
sent, grouped by method or by table. The methods are **SELECTS**,
**DISTINCTS**, **JOINS**, **UNIONS**, **INSERTS**, **REPLACES**,
**UPDATES**, **DELETES**, **RENAMES**, **FLUSHES**, **TRUNCATES**,
**LOAD DATA**, **OUTFILES** and **OTHERS**.

### Details and Query

The **Details** tab lists the log entries with **Table Name**, **Method**,
**Date**, **User**, **Host**, **Query Time**, **Lock Time**, **Sent**,
**Examined**, **Affected** and **Bytes Sent**. Filter it by **LogFile**,
**Method**, **Tables**, **User**, **Host**, a search string and a **From** /
**To** time range. In **Tables**, **Others** shows entries that matched no
table, and **N/A** lists the entries without splitting them by table.
Click an entry to open the **Query** tab, which shows the entry's
statistics and the **Original Query**.

### Deleting a log

On the **Summary** tab, select one or more logs, choose **Delete** from the
actions list and click **Go**.

## Background Processing

The plugin has no poller hook. Each web import starts `import_log.php` in the
background with the new log's ID to finish post-processing. Table statistics
are written to `plugin_slowlog_tables` and `plugin_slowlog_details_tables`,
and `STATS:` lines with the `SLOWLOG` prefix are written to the Cacti log
when the method and table passes finish. Imported data stays in the database
until you delete the log.

## Command-Line Tools

`import_log.php` imports a log file from the server without the upload size
limits, or reruns post-processing for an existing log. Run it from the plugin
directory:

```console
cd plugins/slowlog
php import_log.php --logfile=/path/to/slow.log [--usecacti]
php import_log.php --logid=N [--usecacti]
```

- `--logfile=S` imports the file and post-processes it in the same run.

- `--logid=N` runs post-processing for a log that has already been imported.

- `--usecacti` uses the tables of the current Cacti database as the
  tables of interest.

- `--version` and `--help` print the version or usage.

## Troubleshooting

- A file larger than **Max Upload Filesize** or **Max Post Size** on the
  import form cannot be uploaded. Raise `upload_max_filesize` and
  `post_max_size` in the web server's `php.ini` and restart the web server,
  or import the file with `import_log.php --logfile`.

- `FATAL: Can not find file` from `import_log.php` means the path given to
  `--logfile` does not exist.

- An import only starts storing entries after the first `# Time:` line of
  the log.

## More Information

- [Slowlog plugin repository](https://github.com/Cacti/plugin_slowlog)

- README for release 2.1:
  [README.md](https://github.com/Cacti/plugin_slowlog/blob/v2.1/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
