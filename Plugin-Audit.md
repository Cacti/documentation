# Audit

The Audit plugin records who changed what in Cacti, when, and from which IP
address, so that administrators can trace a problem back to a user action. It
logs submitted web requests and command-line scripts to the Cacti database, can
copy events to a file or to a remote Syslog receiver, and can record login and
access-denied events. Administrators who need an activity trail for compliance
or troubleshooting use it.

This page follows the plugin's `develop` branch, which is unreleased and can
change. In its `INFO` file that branch declares version 1.7 and compatibility
with Cacti 1.2.29. Check the release you install for differences.

## Requirements

- Cacti 1.2.29 or later, as declared in the `INFO` file. The `INFO` file lists
  no required plugins.
- Remote Syslog delivery uses PHP stream sockets. The **TLS** transport needs a
  PHP build with TLS stream support.
- Authentication auditing reads Cacti's `user_log` table and needs indexes that
  you create once with a command-line script (see
  [Authentication events](#authentication-events)).

## Installation

Follow the generic steps in [Plugin Management](Plugins.md). The plugin
directory must be named `audit`. Plugin-specific points:

- Installing creates the tables `audit_log`, `audit_syslog_delivery` and
  `audit_user_log_state`, registers the hooks and realms, and grants both
  realms to the user who installs the plugin.
- Authentication auditing, failed-login detection and remote Syslog are off
  after installation. Turn them on in the settings when you need them.
- Uninstalling drops the three tables and removes the plugin's settings, so
  export any events you need first.

## Permissions

The plugin registers two realms in `setup.php`. They appear under **Audit
Plugin** in the user permissions.

| Realm | Page | Allows |
| --- | --- | --- |
| Audit Log User | `audit.php` | Viewing, searching and exporting the audit log. |
| Audit Log Admin | `audit_manage.php` | Purging the log, the plugin's settings, Test Syslog and Retry Dead-letter. |

## Settings

Settings are under **Console > Configuration > Settings > Audit**. The fields
are shown to users with the Audit Log Admin realm.

### Audit Log Settings

| Setting | Default | Purpose |
| --- | --- | --- |
| Enable Audit Log | on | Track GUI activity. |
| Audit Log Retention | 3 Months | How long entries are kept: 2 Weeks, 1 Month, 2 Months, 3 Months, 4 Months, 6 Months, 1 Year, 2 Years, 3 Years or Indefinitely. |
| External Audit Log | off | Also write each event to an external file. |
| External Audit Log Format | JSON | Text or JSON. |
| External Audit Log Log file  Path | `/var/www/html/cacti/log/audit.log` | Path of the external file. |

### Authentication Auditing

| Setting | Default | Purpose |
| --- | --- | --- |
| Enable Authentication Auditing | off | Capture new login, logout, token, password-change and authorization-denied events from this point forward. |
| Enable Failed-login Volume Detection | off | Emit one global anomaly event when installation-wide failed logins exceed the threshold. |
| Failed-login Window (minutes) | 5 | Rolling window, 1 through 1440. |
| Failed-login Volume Threshold | 10 | Failed-login count, 1 through 1000, that triggers the event. |
| User Log Ingestion Batch Size | 1000 | Maximum `user_log` rows ingested per poller cycle, 1 through 5000. |

### Remote Syslog

| Setting | Default | Purpose |
| --- | --- | --- |
| Enable Remote Syslog | off | Queue finalized events for Syslog delivery. The external file stays independent. |
| Syslog Receiver | empty | Host name or IP address, without scheme, path or credentials. |
| Syslog Port | empty | 1-65535. Empty means 514 for UDP and TCP, and 6514 for TLS. |
| Syslog Transport | UDP | UDP, TCP or TLS. TCP and TLS use RFC 6587 octet-count framing. |
| Syslog Payload Format | JSON | RFC 5424, CEF or JSON. All use an RFC 5424 header. |
| Syslog Facility | `local0` | Facility used to calculate the RFC 5424 priority. |
| Syslog Application Name | `cacti-audit` | RFC 5424 APP-NAME, up to 48 printable ASCII characters. |
| Audit Node Identity | the server host name | Stable identity of this Cacti node. |
| Connection and Write Timeout | 5 | Seconds, 1 through 30. |
| Maximum UDP Record Size | 8192 | Larger records are dead-lettered, never truncated. |

The **Syslog TLS** group has **TLS CA File**, **TLS Client Certificate** and
**TLS Client Private Key** (all optional, default empty). Peer and host name
verification are always on.

The **Syslog Delivery Queue** group controls retries:

| Setting | Default | Purpose |
| --- | --- | --- |
| Retry Base Delay | 30 | Initial retry delay in seconds, 1 through 3600. |
| Maximum Retry Delay | 3600 | Seconds, from the base delay through 86400. |
| Maximum Delivery Attempts | 10 | Attempts before dead-letter, 1 through 100. |
| Poller Batch Size | 100 | Records processed per poller cycle, 1 through 1000. |
| Pending Age Warning | 900 | Seconds the oldest queued record may wait before an unhealthy warning. |
| Dead-letter Warning Count | 1 | Dead-lettered records that trigger the warning. |

## Using Audit

Open **Console > Utilities > Audit Log**. On Cacti versions before 1.3 the page
is also listed as **View Audit Log** under Technical Support on the System
Utilities page.

The screenshot shows the page filtered to one user, with synthetic events. The
**Remote Syslog Delivery** box above the log shows the queue status when Syslog
is enabled, and is disabled here.

![Audit Log page listing synthetic events][audit-image]

The filter row has **Search** (matches the page name or the submitted data),
**Page**, **User** (including `cli` for command-line activity) and **Events**
(rows per page), plus the buttons **Go**, **Clear**, **Export** and, for Audit
Log Admin users, **Purge**. The table columns are **Page Name**, **User Name**,
**Requested Action**, **Request Status**, **External File Delivery**, **User
Agent**, **IP Address** and **Event Time**. Hover over an action to see the
request data, including the event ID, request status and operation outcome.
Sensitive values in submitted data are redacted before they are stored.

An event starts as started and is finalized as completed or failed. Completed
does not guarantee that every operation behind the request succeeded.

Only web requests that submit data are logged, together with command-line
scripts. Pages such as the graph view and the console index are skipped.

### Purge the log

1. Open **Console > Utilities > Audit Log** as an Audit Log Admin user.
2. Click **Purge** and confirm.

Events whose Syslog delivery is pending, retrying, sending or dead-lettered are
kept, and the page reports how many were protected.

### Test Remote Syslog

1. Configure and enable the Remote Syslog settings.
2. On the Audit Log page, click **Test Syslog** in the **Remote Syslog
   Delivery** box.

The result says the test record was written to the local socket. Syslog does
not confirm that the receiver stored it. When dead-lettered records exist,
**Retry Dead-letter** resets them for another attempt.

### Authentication events

Run this once as the Cacti user from the Cacti directory before you enable
**Enable Authentication Auditing**:

```console
php plugins/audit/audit_auth_indexes.php
```

It checks the primary key of Cacti's `user_log` table and adds indexes used for
ingestion. It prints `Authentication audit indexes are ready.` on success, or
an error and exit code 1 when the key is unsupported or the indexes cannot be
created. Uninstalling removes only the indexes that the plugin added.

## Background Processing

The `poller_bottom` hook runs after every polling cycle and does the following:

- Retries failed appends to the external file.
- Sends queued Syslog records in batches of **Poller Batch Size**.
- When authentication auditing is on, ingests up to **User Log Ingestion Batch
  Size** new rows from `user_log` and checks for failed-login volume. History
  from before you enabled it is not imported.
- Once per day, deletes events older than **Audit Log Retention**, except
  events whose Syslog delivery is unfinished, and writes a `NOTE: Purged ...
  Audit Log Records from Cacti` line to the Cacti log.

Web requests never send over the network. Events are queued in
`audit_syslog_delivery` and the poller sends them.

## Command-Line Tools

`audit_auth_indexes.php` is the only script. See
[Authentication events](#authentication-events).

## Troubleshooting

- An external file that is not written: the Cacti log shows `ERROR: Unable to
  create Audit Log file` or `ERROR: Audit Log file path ... does not exist and
  the path is not writeable`. Make the directory writable by the web server and
  poller user. The file must be a regular file and not a symbolic link.
- Syslog problems appear in the **Remote Syslog Delivery** box as **Last
  Error**, or as **Configuration Error** when a setting is invalid.
- A record larger than **Maximum UDP Record Size** is dead-lettered. Use TCP or
  TLS for large events.
- A successful write is shown as **Sent (Unconfirmed)** because Syslog gives no
  receipt. Retries reuse the same event ID, so receivers can deduplicate on it.

## More Information

- [Audit repository](https://github.com/Cacti/plugin_audit)
- [Audit README][audit-readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[audit-image]: images/plugin-audit-log.png
[audit-readme]: https://github.com/Cacti/plugin_audit/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
