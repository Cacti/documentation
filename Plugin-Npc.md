# Nagios Plugin for Cacti

The Nagios Plugin for Cacti (NPC) shows the status and history that Nagios
stores through NDOUtils inside the Cacti interface. It adds an **NPC** tab with
host and service status, comments, scheduled downtime, the Nagios event log and
process information, and it can send a small set of commands to the Nagios
command file. It is for administrators who run Nagios next to Cacti and want
one place to view status and graphs.

This page follows the plugin's `develop` branch, which is unreleased and can
change. That branch declares version 3.1 and Cacti compatibility 1.2.1 in its
`INFO` file. No release of the plugin is published. The plugin README describes
the plugin as a port of an older plugin and advises using it in a non-production
setup until the Cacti community has tested the migration further.

## Requirements

- Cacti 1.2.1 or later, as declared in `INFO`. The plugin README states that
  its tests run against the Cacti 1.2.x branch.
- PHP 8.2 or later, as stated in the plugin README.
- MySQL or MariaDB, as required by Cacti.
- Nagios 3.x with the NDOUtils event broker module (`ndomod`) and the `ndo2db`
  daemon. The README names NDOUtils 1.4b7.
- No other Cacti plugin is listed in `INFO` as required.
- No PHP extension beyond the ones Cacti needs.
- The `php` program must be in the path of the web server user if you import
  Nagios hosts, because the import runs Cacti's `cli/add_device.php` with
  `exec()`.

The README notes that the default PHP `memory_limit` may not be enough for NPC.
Raise it in `php.ini` if NPC runs out of memory.

## Installation

Follow [Plugin Management](Plugins.md) for the generic steps. Place the code in
`<path_cacti>/plugins/npc`; the directory must be named `npc`. The plugin is
listed as **Nagios Plugin for Cacti** on **Console > Configuration > Plugins**.

Installing creates 62 tables with the `npc_` prefix in the Cacti database, adds
the `npc_host_object_id` column to the Cacti `host` table, registers the realms
described below, and creates the settings `npc_date_format`, `npc_time_format`
and `npc_log_level`. Without ndo2db feeding Nagios data into these tables, the
NPC screens are empty.

### Configure Nagios

In `nagios.cfg`, enable external commands and the event broker, and point
Nagios at the NDOUtils module. Adjust the paths to your installation:

```ini
check_external_commands=1
command_check_interval=-1
event_broker_options=-1
broker_module=/usr/local/nagios/bin/ndomod.o
config_file=/usr/local/nagios/etc/ndomod.cfg
process_performance_data=1
```

Set `process_performance_data=1` only if you want to graph Nagios performance
data in Cacti. In `ndomod.cfg`, `config_output_options` must be `2`.

### Configure ndo2db

Install NDOUtils following its own README, but skip its database
initialization: NPC creates the tables. In `ndo2db.cfg`, point ndo2db at the
Cacti database and use the `npc_` prefix:

```ini
db_servertype=mysql
db_host=localhost
db_port=3306
db_name=cacti
db_prefix=npc_
db_user=<database user>
db_pass=<database password>
```

The database account needs select, insert, update and delete on the `npc_`
tables. The socket type and port must be the same in `ndo2db.cfg` and
`ndomod.cfg`.

## Permissions

| Realm | Pages covered |
| --- | --- |
| NPC | `npc.php`, the NPC tab and all of its screens |
| NPC Global Commands | Sending Nagios commands from the NPC screens |

Grant the realms on the **Realm Permissions** tab of each user under
**Console > Configuration > Users**. The plugin checks the **NPC Global
Commands** realm before it sends a command, so a user needs this realm in
addition to **NPC** to send commands.

## Settings

Settings are on the **NPC** tab of **Console > Configuration > Settings**.

| Setting | Default | Purpose |
| --- | --- | --- |
| Remote Commands | off | Allow commands to be written to the Nagios command file. System wide. |
| Nagios Command File Path | empty | Path to the Nagios command file (`nagios.cmd`). The web server user must be able to read and write it. |
| Nagios URL | empty | Full URL of the Nagios installation. The value is passed to the page, but no screen uses it in this version. |
| Date Format | Y-m-d | Format for displayed dates. |
| Time Format | H:i | Format for displayed times. |
| Portlet Refresh Rate | 60 | Seconds before the Hosts, Services and Event Log screens refresh. The field text names 30 seconds as the minimum. |
| Host/Service Config Type | 1 | Selects the host and service rows with this `config_type`, 0 or 1. If you see groups but no hosts or services, try the other value. |
| Host Icons | off | Stored, but no screen uses it in this version. |
| Service Icons | off | Stored, but no screen uses it in this version. |
| Logging Level | None | Detail written to the Cacti log: None, ERROR, WARN, INFO or DEBUG. |

Debug logging fills the Cacti log quickly. NPC writes with the component
`NPC`.

## Using NPC

Open the **NPC** tab in the Cacti header. The screens are tabs on the NPC page:

- **Dashboard**: host and service status counts (Host Status Summary, Service
  Status Summary) and the Host Problems and Service Problems lists.
- **Hosts**: hosts with address, state, output and last check, with a state
  filter (Any, Up, Down, Unreachable, Problems).
- **Services**: services by host, with a state filter (Any, Ok, Warning,
  Critical, Unknown, Problems).
- **Comments**: host and service comments.
- **Downtime**: host and service downtime.
- **Event Log**: the Nagios log entries.
- **Process Info**: Nagios process properties.

The screenshot shows the **Dashboard** with the summary tables and problem
lists. The example uses synthetic data.

![NPC Dashboard with synthetic summaries and problems][dashboard-image]

To see details and send a command for a host or service:

1. Open **NPC > Hosts** or **NPC > Services**.
2. Select the host or service name to open a dialog with its details.
3. Select the gear icon in the **Actions** column to open the command dialog.
4. Choose a command (Acknowledge Problem, Add Comment, Schedule Downtime,
   Schedule Check, Enable Notifications or Disable Notifications), fill in the
   fields, and select **Submit**.

Commands are written to the Nagios command file. They need **Remote
Commands** enabled, a **Nagios Command File Path**, and the **NPC Global
Commands** realm. A failed command shows the reason in a message.

On the **Comments** screen, the cross at the end of a host comment deletes it
after a confirmation.

On a Cacti device, the **Nagios Host Mapping** field on **Console > Management
> Devices** links the device to a Nagios host.

## Background Processing

NPC registers no poller hook and has no process of its own. Data arrives in the
`npc_` tables from ndo2db, outside Cacti. The Hosts, Services and Event Log
screens request new data from the plugin every **Portlet Refresh Rate**
seconds. The tables grow with the Nagios data. Retention is set in `ndo2db.cfg`
with the `max_*_age` options, not in Cacti.

## Command-Line Tools

`perfdata.php` and `cli.php` print Nagios performance data in the form a Cacti
script data input method reads. Run them with `php`. Usage text:

```console
usage: perfdata.php --type=[host|service] --id=[ID] --datasource=[DS]

Required:
    --type          Type specifies that we are querting perfdata for a host or service
    --id            The host or service object ID
Optional:
    --ds            Return only the specified datasource. All returned by default.
List Options:
    --list-hosts [--hostgroup=<name>]
    --list-hostgroups
    --list-services
```

The usage text names `--datasource`, which the code does not read, and does not
list all options. The code also accepts `--host=<name>` and
`--service=<description>` to select an object by name. `cli.php` takes the same
options and adds `--perfdata` (the default) and `--perf-history`, which uses
`--host`, `--service`, `--begin=<date>` and `--end=<date>` to print the checks
in a range.

## Troubleshooting

- The NPC screens are empty: ndo2db is not writing into the `npc_` tables.
  Check `ndomod.cfg`, `ndo2db.cfg` and the database account.
- Groups are visible but hosts and services are not: change **Host/Service
  Config Type** to the other value.
- A command fails with "You do not have permission to execute this command.":
  the user lacks the **NPC Global Commands** realm.
- A command fails with "Remote Commands must be enabled under
  console->Settings->NPC" or "The Nagios Command File Path must be set under
  console->Settings->NPC": set the matching setting.
- A command fails with a message from the command file check: the web server
  user must be able to read and write the Nagios command file. If Nagios runs
  on another system, the file must be reachable from the Cacti system.
- The plugin writes `SECURITY: NPC rejected ...` entries to the Cacti log for
  requests with an unknown module or action.
- Importing Nagios hosts into Cacti and per-user screen layouts have server
  side code but no screen in this version.

## More Information

- [Nagios Plugin for Cacti repository](https://github.com/Cacti/plugin_npc)
- [NPC README](https://github.com/Cacti/plugin_npc/blob/develop/README.md)
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[dashboard-image]: images/plugin-npc-dashboard.png

---

Copyright (c) 2004-2026 The Cacti Group
