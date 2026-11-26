# Alarm Manager

Alarm Manager lets Cacti administrators route alarms to notification services
and scripts. It records each alarm event, tracks which conditions are active,
uses alarm rules to decide which destinations should be told, queues the
deliveries and keeps the results. Other plugins submit alarms through the
`alarmmanager_submit` hook, and the plugin also captures confirmed Cacti device
down and recovery states after each polling cycle.

This page follows the plugin's `main` branch, which is unreleased and can
change. In its `INFO` file that branch declares version 0.12.2 and
compatibility with Cacti 1.2.29. Check the release you install for differences.

## Requirements

- Cacti 1.2.29 or later, as declared in the `INFO` file. The `INFO` file lists
  no required plugins.
- PHP 8.2 or later with the `openssl` extension. Installation returns failure
  when either is missing.
- MariaDB 10.11 or later. The schema step stops with `requires_mariadb_10_11`
  on other databases.
- The PHP `curl` extension for REST API and webhook destinations.
- The PHP `pcntl` and `posix` extensions for delivery workers and the daemon,
  and `/usr/bin/setsid` for email, script and SNMP trap delivery.
- Cacti's `snmptrap` binary (the `path_snmptrap` setting) for SNMP trap
  destinations. The path must be absolute.
- Cacti's `DEBUG_SQL_FLOW` option must not be defined. The plugin does not run
  while it is set.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md). The plugin
directory must be named `alarmmanager`. Plugin-specific points:

- Installing creates the database schema and an encryption key. The key is
  stored in the `settings_user` table as `alarmmanager_key` for user 1. Back it
  up: encrypted destination credentials cannot be read without it, and enabling
  or upgrading the plugin fails when the key is missing or malformed.
- Uninstalling keeps the key and the alarm history for recovery.
- On a distributed installation, put the plugin files on the main poller and on
  every collector, and enable the plugin on the main poller. Manage
  destinations, rules and credentials on poller 1. Script executables and
  custom CA files must exist at the same paths on each collector that delivers
  with them.
- To run workers in a resident service, copy `service/alarmmanager.service` from
  the plugin to your systemd unit directory, edit the user, group, working
  directory and PHP path, and start it. Then tick **Enable Daemon** in the
  settings.

## Permissions

The plugin registers two realms in `setup.php`.

| Realm | Page | Allows |
| --- | --- | --- |
| Alarm Manager View | `alarmmanager.php` | The **Alarm Manager** tab: Dashboard, Active conditions and Events. |
| Alarm Manager Administration | `alarmmanager_admin.php` | The **Alarm Manager Settings** group. Also requires Cacti realm 1 and an enabled authentication method. |

Users with only the view realm see alarms for the devices they are allowed to
see in Cacti.

## Settings

Settings are under **Console > Configuration > Settings > Alarm Manager**.
Cacti replicates them to collectors.

| Setting | Default | Purpose |
| --- | --- | --- |
| Offline Summary | Device Offline | Summary of new device down alarms. Existing history keeps its original summary. |
| Recovering Summary | Device Recovering | Summary for recovering updates within the same outage. |
| Online Summary | Device Online | Summary for recovery alarms once Cacti confirms the device is up. |
| Keep Alert History For | 90 | Number of days, weeks or months to keep history. Maximum 3650 days, 520 weeks or 120 months. |
| Retention Unit | Indefinitely | Days, Weeks, Months or Indefinitely. With Indefinitely, nothing is purged and the number is ignored. |
| Enable Daemon | off | Run processing and delivery workers in the resident service instead of the Cacti poller. |
| Processing Workers | 2 Worker Processes | Daemon workers that evaluate rules: 1, 2, 4, 6, 8 or 16. |
| Delivery Workers | 4 Worker Processes | Daemon workers that deliver notifications: 0, 1, 2, 4, 6, 8 or 16. |

The purge job runs with the poller. It removes aged events together with their
decisions, deliveries and attempts, and never removes active conditions or
queued or failed work. Each collector purges its own history.

## Using Alarm Manager

### The Alarm Manager tab

Users with the view realm get an **Alarm Manager** tab in the Cacti header. It
has three pages: **Dashboard**, **Active conditions** and **Events**. The
screenshot shows the Events page with synthetic demo alarms. Above the table
are search conditions that you build with AND, OR, NOT and groups, a time range
and refresh choice, and quick filters for source, severity, device and
collector.

![Alarm Manager Events page with synthetic alarms][alarmmanager-image]

The table lists the collector, time received, source, transition, severity,
device, event ID, summary, payload, routing decision and integration status of
each event. Open one event to see its deliveries and to replay failed jobs.
Time ranges on the history pages use UTC, while current conditions and queues
ignore the time window.

### Administration pages

Users with the administration realm get a **Alarm Manager Settings** group in
the console menu, placed after **Import/Export**. It has these pages:

| Page | Purpose |
| --- | --- |
| Alarm Destinations | Create destinations, preview the payload, send a test and enable them. |
| Alarm Rules | Create rules that match alarms and select destinations. |
| Credentials | Manage the encrypted credentials used by destinations. |
| Configuration Backup/Restore | Export and import configuration. |
| Alarm Queue | Inspect waiting messages, pause and resume delivery, and clear waiting deliveries. |
| Workers and failed processing | Worker status and failed jobs. |

Destination types are Webhook / REST API, Email, Script, SNMP trap and Syslog.
Presets exist for Slack, Microsoft Teams (Workflows), Telegram, Twilio SMS,
Twilio WhatsApp, PagerDuty Events v2, ServiceNow incidents and ServiceNow
events. A WebSocket destination type is not implemented.

### Set up your first alarm route

1. Open **Alarm Manager Settings > Alarm Destinations** and add a destination,
   from a preset or a generic type.
2. Replace the placeholder values and enter the credentials.
3. Preview the payload and use **Test destination** to queue one test send.
4. Enable the destination.
5. Open **Alarm Rules** and create an enabled rule with conditions and the
   destination selected. An enabled destination alone sends nothing.
6. Check the **Events** page for the routing decision and the delivery result.

## How It Collects Data

Alarm Manager has two sources of alarms. Source plugins call the
`alarmmanager_submit` hook with an event envelope (see `examples/event.json` in
the plugin), and Cacti's `admin_alert` hook is handled as well. The plugin also
checks device status after each poller cycle and records device down,
recovering and online alarms.

The `poller_bottom` hook does the work after every polling cycle:

- It applies daemon settings and checks device status.
- It purges aged history according to **Keep Alert History For**.
- Unless the daemon is enabled and running, it runs one pass of the processing
  and delivery workers inside the poller and logs a line starting with
  `ALARMMANAGER STATS:`.

With **Enable Daemon** on, the resident service runs the workers instead.
Disabling it lets current jobs finish and returns processing to the poller.
On collectors, each collector processes and delivers its own alarms, and
collector history is sent back to the main poller.

## Command-Line Tools

Run these as the Cacti poller user from the plugin directory. Each prints its
usage with `--help`.

```console
php cli/status.php
php cli/submit_event.php --file=examples/event.json
php cli/endpoint.php --endpoint=1 --file=examples/event.json --preview|--test-send
php cli/producers.php --retry-pending [--limit=100]
php cli/credentials.php --save=ENDPOINT_ID --file=/secure/credentials.json
php cli/credentials.php --backup-dir=/secure/new-backup
php cli/credentials.php --rotate
php cli/credentials.php --restore=/secure/credentials.json --key-file=/secure/key.txt --replace-local-credentials
php cli/remote.php --identity
php cli/remote.php --export-for=2 --endpoints=1,2 --output=/secure/poller-config.json
php cli/remote.php --provision=/secure/poller-config.json
php cli/remote.php --configure=/secure/routing.json
php cli/remote.php --grant-file=/secure/device-grant.json
php cli/remote.php --send [--limit=100]
php cli/remote.php --seed=event|processing|decision|delivery|attempt [--after=0 --limit=100]
php alarmmanager_daemon.php [--config=/path/to/workers.json]
```

- `--preview` sends nothing. `--test-send` queues one explicit test for the
  delivery workers.
- For `cli/credentials.php`, use `--file=php://stdin` to avoid storing
  plaintext input. Restore also provisions an authorized remote poller and
  replaces its entire local key and credential set.
- `cli/producers.php` retries bounded pending receipts from source plugins,
  using their original event IDs.
- `alarmmanager_daemon.php` is the command the service runs. Without
  `--config`, worker counts come from the settings.

## Troubleshooting

- The plugin does not enable or upgrade: check the PHP version, that `openssl`
  is loaded, that the MariaDB version is 10.11 or later, and that the
  `alarmmanager_key` row in `settings_user` exists.
- No notification is sent: confirm that an enabled rule matches the alarm and
  selects an enabled destination. The Events page shows `No matching rule` when
  nothing matched.
- Deliveries wait in the queue: check whether the queue is paused on the **Alarm
  Queue** page, and whether workers run (**Workers and failed processing**).
- SNMP trap delivery fails with `snmptrap_unavailable` when `path_snmptrap` is
  not an absolute executable path, or when `posix` or `/usr/bin/setsid` is
  missing.
- Cacti log lines from this plugin use the name `Alarm Manager`.

## More Information

- [Alarm Manager repository](https://github.com/Cacti/plugin_alarmmanager)
- [Alarm Manager README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[alarmmanager-image]: images/plugin-alarmmanager-events.png
[readme]: https://github.com/Cacti/plugin_alarmmanager/blob/main/README.md

---

Copyright (c) 2004-2026 The Cacti Group
