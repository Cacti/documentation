# Webseer

Webseer monitors web sites and web services from Cacti. An administrator adds
a service check with a URL and, optionally, a string that a working response
must contain. On every poller cycle Webseer requests the URL, records the HTTP
code, the DNS, connect, redirect and total times, and sends email when a site
goes down or recovers. It is for administrators who want availability and
response-time checks for web sites next to their device monitoring.

This page follows the plugin's `develop` branch, which is unreleased and can
change. The branch declares version 3.3 and Cacti compatibility 1.2.29 in its
`INFO` file. Its display name in `INFO` is Service Monitor, and its menu entry
is **Service Checks**. Do not treat this page as a description of a released
version.

## Requirements

- Version 3.3 and Cacti 1.2.29 or later, as declared in `INFO`. No other
  plugin is required.
- The PHP cURL extension. The poller script prints "FATAL: You must install
  php-curl to use this Plugin" when `curl_init` is missing.
- The Maintenance (`maint`) plugin is optional. When it is enabled, Webseer
  skips a check that has an active maintenance schedule.
- The PHP binary path from Cacti's **Paths** settings, which the poller uses
  to start the check processes. If it is empty, `php` is used.

## Installation

Follow the generic steps in [Plugin Management](Plugins.md), installing the
plugin in `plugins/webseer`. Grant the **Web Service Check Admin** realm to
the users who create or edit service checks, servers and proxies. Then open
**Console > Management > Service Checks**.

When you upgrade the plugin files, restart the Webseer background process:
`poller_webseer.php` can keep running and holds the old code in memory. Stop
the running `poller_webseer.php`, and Cacti's poller starts it again on the
next cycle. On upgrade the plugin also removes its own development-only
files, such as the `tests` directory.

On Cacti releases below 1.2.31, the Cancel buttons on forms need a click
binding for the `cactiReturnTo` class in `include/layout.js`. The README has
the snippet.

Uninstalling the plugin drops its tables, including all checks and history.

## Permissions

The plugin registers one realm in `setup.php`.

| Realm | Pages covered |
| --- | --- |
| Web Service Check Admin | `webseer.php`, `webseer_servers.php`, `webseer_proxies.php` |

## Settings

Webseer adds no tab to **Console > Configuration > Settings**. Configuration
is done per service check, per server and per proxy on the pages described
below.

## Using Webseer

Open **Console > Management > Service Checks**. The page has three tabs:
**Checks**, **Servers** and **Proxies**.

The following screenshot shows the **Checks** tab with synthetic data: healthy
checks, one failing check and one disabled check, with their status, HTTP
code, timing columns and last check.

![Check list with synthetic checks in several states][img-webseer-checks]

The list columns are **Name**, **Status**, **Enabled**, **Compression**,
**HTTP Code**, **Auth**, **DNS**, **Connect**, **Redirect**, **Total**,
**Timeout** and **Last Check**. Each row has icons to edit the check, enable or
disable it, and view its history. The history page lists each result with
date, URL, error, HTTP code and the DNS, connect, redirect and total times, and
the history of one check can be purged. Bulk actions are **Delete**,
**Disable**, **Enable** and **Duplicate**.

### Add a service check

1. On the **Checks** tab, add a check.
2. Under **General Settings**, set **Service Check Name** and **Enable Service
   Check** (default on), then enter the **URL** to monitor. **IP Address**
   forces a connection to a given address instead of DNS resolution.
3. Select a **Proxy Server** if the connection needs one, otherwise choose
   **None**. **Compression** sets the compression the server requires. The
   description notes that most servers do not need it.
4. Under **Available Checks**, tick **Requires Authentication** if the site
   normally returns a 401 error, and **Check Certificate** (default off in the
   form) to validate the TLS certificate. The description says to leave
   validation off for a site with a self-signed certificate.
5. Under **Notification Timing**, set **Trigger** (default 3) and **Time Out**
   (default 4). **Trigger** is how many minutes the URL must be down before an
   alert is sent. For a **Site Recovered** email, the URL must also be up for
   that many minutes. **Time Out** is how many seconds to wait before the page
   is reported as down.
6. Under **Verification Strings**, set **Response Search String**,
   **Response Search String - Maintenance Page** and **Response Search String
   - Failed**. The maintenance string marks a response that shows the service
   is under maintenance. The failed string alerts only when it is found,
   ignoring time-outs and the other strings.
7. Under **Notification Settings**, set **Notify Format** (html or plain),
   **Notification List**, **Notify Accounts** and **Extra Alert Emails**.

### Servers

The **Servers** tab lists the servers that run checks. A server has a name,
**Enable Server**, **Is this server the local server?**, **Master Server**,
**IP Address**, **URL** (the address of `remote.php` on that server) and
**Location**. The master server handles all email operations. Bulk actions are
**Delete**, **Disable** and **Enable**, and a history page lists results
reported by a server.

A registered server reports back to the main installation through
`remote.php`, which accepts heartbeat and result requests only from the IP
address of a registered server. The plugin replicates its server, proxy,
contact and URL tables to remote pollers.

### Proxies

The **Proxies** tab holds web proxies. A proxy has a **Name**, **Hostname**,
**HTTP Port** (default 80), **HTTPS Port** (default 443) and, if the proxy
requires it, a **User Name** and **Password**. Select a proxy in a check.

## Background Processing

Webseer hooks into `poller_bottom` and starts `poller_webseer.php` in the
background on every poller cycle. The script registers the local server,
then starts one `webseer_process.php` for each enabled check of that poller,
with at most 12 running at the same time, and waits for them to finish. Each
check tries up to three times and stops at the first success. After a check
finishes, Webseer evaluates the **Trigger** timing and sends a **Site Down** or
**Site Recovered** email. A check with an active maintenance schedule is
skipped.

At the end of a run, `poller_webseer.php` writes a `WEBSEER STATS` line to the
Cacti log. On poller 1 it deletes history rows older than 30 days. The history
table grows by one row per check per run, until the purge.

## Command-Line Tools

Run these as the Cacti poller user.

```console
usage: poller_webseer.php [--debug] [--force]

This binary will exec all the Web Service check child processes.

--force    - Force all the service checks to run now
--debug    - Display verbose output during execution
```

```console
usage: webseer_process.php --id=N [--debug]

--id=N     - The url ID from the WebSeer database.
--debug    - Display verbose output during execution
```

## Troubleshooting

- Nothing is checked and the poller output says php-curl is required:
  install the PHP cURL extension.
- A check never alerts: **Trigger** counts minutes of downtime. A site that
  recovers within the trigger time does not alert.
- A site with a self-signed certificate shows as down: turn off **Check
  Certificate** for that check.
- A check shows an error while the site is in a planned outage: set up a
  maintenance schedule with the Maintenance plugin, or use **Response Search
  String - Maintenance Page**.
- The log shows "ERROR: Unable to obtain Proxy settings": the proxy selected
  in the check no longer exists. Select another proxy or **None**.
- The log shows "ERROR: No users to send WEBSEER Notification": the check has
  no notification list, accounts or extra emails that resolve to an address.
- A remote server does not report: `remote.php` accepts requests only from
  the IP address of a registered server, so the **IP Address** on the
  **Servers** tab must match the address the server connects from.

## More Information

- [Webseer repository](https://github.com/Cacti/plugin_webseer)
- [Webseer README][readme]
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-webseer-checks]: images/plugin-webseer-checks.png
[readme]: https://github.com/Cacti/plugin_webseer/blob/develop/README.md

---

Copyright (c) 2004-2026 The Cacti Group
