# Graph Export

The Graph Export plugin (`gexport`) exports Cacti graphs, graph trees, and
sites as static pages and image files. Each export definition has a schedule, a
destination, and a Cacti user whose permissions decide which graphs are
included. It replaces the Graph Export feature that was removed from Cacti
core, and it suits administrators who publish graphs to a web server outside
Cacti.

This page follows the plugin's `develop` branch, which is unreleased and can
change. The branch declares version 2.1 and Cacti compatibility 1.2.29 in its
`INFO` file. It is not presented here as a released version.

## Requirements

- Cacti 1.2.29 or later, as declared in `INFO` (version 2.1).
- No other plugins are required.
- The poller runs exports, so the **PHP Binary Path** setting in Cacti must
  point at a working PHP binary.

Requirements by export method:

| Export method | Requirement |
| --- | --- |
| Local | None beyond a writable export directory. |
| FTP | PHP FTP functions (`ftp_connect`). |
| SFTP | PHP `ftp_ssl_connect()`, which needs PHP built with OpenSSL. |
| FTP NC | The `ncftpput` program. Not available on Windows. |
| RSYNC | The `rsync` program, reachable from the poller's path. |
| SCP | The `scp` program, reachable from the poller's path. |

## Installation

Copy the plugin into `plugins/gexport` in the Cacti directory (rename
`plugin_gexport` to `gexport`), then install and enable it as described in
[Plugin Management](Plugins.md). Installing creates the `graph_exports` and
`graph_exports_tasks` tables. Uninstalling the plugin drops both tables, which
deletes all export definitions.

If you run a Cacti version older than 1.2.31, the plugin README describes a
JavaScript function to add to `include/layout.js` so that **Cancel** buttons
on forms work.

## Permissions

| Realm | Pages |
| --- | --- |
| **Export Cacti Graphs Settings** | `gexport.php` |

Assign the realm to users or groups in **Console > Configuration > Users** or
**User Groups**. When the Cacti version provides role augmentation, the realm is
also added to the **General Administration** role.

## Settings

The plugin adds no page to **Console > Configuration > Settings**. All
configuration is stored per export definition and is edited on the export's
edit form, reached from **Console > Utilities > Graph Exports**. The form has
the sections below.

### General

| Setting | Default | Purpose |
| --- | --- | --- |
| **Export Name** | New Graph Export | The name of the export definition. |
| **Enabled** | on | Whether the definition runs. |
| **Export Method** | disabled | Local, FTP, SFTP, FTP NC, SCP, or RSYNC. |
| **Export Command Arguments** | -zav | Arguments for the non-local methods: `rsync -zav`, `rsync -avpro`, `rsync -avpro --delete-excluded`, or `scp -rp`. |
| **Theme** | modern | The Cacti theme used to skin the exported pages. |
| **Presentation Method** | disabled | **Site** keeps all graphs in one page. **Tree** keeps the graph tree structure in the static pages. |

### Export Timing

| Setting | Default | Purpose |
| --- | --- | --- |
| **Timing Method** | export_hourly | **Periodic**, **Hourly**, or **Daily**. |
| **Periodic Export Cycle** | none | Run every 1 to 12 polling cycles. |
| **Hourly at specified minutes** | 00 | Minute of the hour for hourly exports. The value is rounded to the poller's run time. |
| **Daily at specified time** | 00:00 | Time of day for daily exports, in `HH:MM`. |
| **Use x Threads** | 0 | Number of background threads. 0 runs the export in the poller process. |

### Graph Selection & Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| **Effective User** | 0 (N/A) | The Cacti user whose permissions limit which graphs and trees are exported. N/A applies no permission checks. |
| **Tree** | 0 (All Trees) | The trees to export. |
| **Expand Devices/Sites** | off | When on, each device gets a subfolder with its graph templates or data query items. |
| **Site** | 0 (All Sites) | The sites to export. |
| **Graph Thumbnail Width** | 300 | Thumbnail width in pixels. |
| **Graph Thumbnail Height** | 100 | Thumbnail height in pixels. |
| **Default View Thumbnails** | unset | Show thumbnails by default in the exported view. |
| **Default Graph Columns** | 2 | Columns used to display graphs. |
| **Graphs Per Page** | 20 | Graphs per page in the exported view. |
| **Maximum Graphs to Export** | 2000 | After this number an error is generated but exporting continues. 0 means no limit. |

### Export Location Information

| Setting | Default | Purpose |
| --- | --- | --- |
| **Export Thumbnails** | unset | Export thumbnail mode. |
| **Clear Directory** | unset | Clear the final directory before populating it. |
| **Export Directory** | none | The directory, local or remote, that receives the exported data. |
| **Local Scratch Directory** | the system temporary directory | Where output is staged before transfer by a remote method. Its contents are deleted after the transfer. |

### Remote Options

| Setting | Default | Purpose |
| --- | --- | --- |
| **Sanitize remote directory** | unset | Delete existing files in the remote directory. Applies only to the PHP FTP functions. |
| **Remote Host** | none | Host that receives the export. |
| **Remote Port** | none | Port for a non-standard setup. Empty uses the default. |
| **Use passive mode** | unset | Connect to the FTP server in passive mode. |
| **User** | none | Account on the remote server. |
| **Password** | none | Password for the remote account. |
| **Private Key Path** | none | Private key for SCP and RSYNC, when required. |

## Using Graph Export

Open **Console > Utilities > Graph Exports**. The list is titled **Graph Export
Definitions** and has a search box, a rows selector, and a refresh selector.

The following example uses synthetic data.

![Graph Export Definitions list with three synthetic exports][gexport-img]

The columns are **Export Name**, **ID**, **Schedule**, **Next Start**,
**Enabled**, **Status** (Idle, Running, or Error), **Exporting (Sites/Trees)**,
**Effective User**, **Last Runtime**, **Graphs** (exported on the last run),
**Last Started**, and **Last Errored**.

To create an export:

1. Open **Console > Utilities > Graph Exports** and click the **+** button.
2. Enter an **Export Name** and choose an **Export Method**.
3. Choose the timing under **Export Timing**.
4. Under **Graph Selection & Settings**, choose an **Effective User** and the
   **Tree** or **Site** entries to export.
5. Set the **Export Directory** and, for remote methods, the **Remote
   Options**.
6. Click **Save**.

To act on several definitions, select them and choose an action: **Delete**,
**Enable**, **Disable**, or **Export Now**.

## Background Processing

The plugin registers a `poller_bottom` hook. At the end of each polling cycle,
on the main poller (poller ID 1) only, it checks for enabled definitions and, if
there are any, starts `poller_export.php` in the background with the PHP binary
from the **PHP Binary Path** setting.

For each enabled definition, the script compares the stored next start time with
the current time and runs the export when it is due. It then records the next
start time. A definition whose previous run is still alive is not started again.
Results are written to the Cacti log with the `EXPORT` tag, including a
`MASTER STATS` line with the time, the number of definitions checked, and the
number started.

When **Use x Threads** is greater than 0, the export spawns background tasks
that are tracked in the `graph_exports_tasks` table. An export refuses to run
when its export path is inside a Cacti system directory, the Cacti web root, a
parent of the web root, or a protected system path.

## Command-Line Tools

Run `poller_export.php` from the Cacti directory as the poller user:

```console
php plugins/gexport/poller_export.php [--id=N] [--force] [--debug]
```

| Option | Effect |
| --- | --- |
| `--id=N` | Export only the definition with this ID. |
| `-f`, `--force` | Run the export now, regardless of its schedule. |
| `-d`, `--debug` | Display verbose output during execution. |
| `-V`, `-v`, `--version` | Print the version. |
| `-H`, `-h`, `--help` | Print usage. |

The `--thread` option is used internally when the poller starts a background
task. Do not pass it by hand.

## Troubleshooting

- **Nothing exports:** exports run only from the main poller. Check that the
  definition is **Enabled** and that **Next Start** is set. Use **Export Now**
  or `--force` to run it immediately.
- **Status shows Error:** read the Cacti log and filter for `EXPORT`. The export
  functions write each step there.
- **Export path refused:** the export stops with a message that the path is
  within a Cacti system path, a system path, the Cacti web root, or a parent of
  the web root. Choose a different **Export Directory**.
- **Secure FTP Function does not exist:** SFTP needs PHP `ftp_ssl_connect()`.
  Install an OpenSSL-enabled PHP FTP extension.
- **ncftpput only available in unix environment:** FTP NC cannot run on
  Windows.
- **Previous run ended in an unclean state, or is still running:** the export
  logs a warning and does not start a second run while the earlier process is
  alive.
- **Graph limit reached:** when **Maximum Graphs to Export** is reached an
  error is logged and the export continues.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_gexport)
- [Plugin README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[gexport-img]: images/plugin-gexport-exports.png
[readme]: https://github.com/Cacti/plugin_gexport/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
