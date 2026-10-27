# Frequently Asked Questions

These answers follow Cacti's **develop** branch, the unreleased 1.3 series.
Menu labels and available options can differ in released versions. For Cacti
1.2, use the [1.2.x manual][manual-1.2] and your installed version's code.

## Using Cacti

**Q:** How do I create traffic graphs?

**A:** First, configure read access to the device's SNMP interface counters.
Cacti's PHP SNMP functions use the PHP SNMP extension where supported and
fall back to Net-SNMP command-line tools for other requests. Configure the
installed binaries under **Console > Configuration > Settings > Paths**.
Installing the PHP extension does not eliminate every need for these tools.
Spine uses its own Net-SNMP support for polling.

1. Open **Console > Management > Devices** and add a device.

2. Enter a description and hostname or IP address, select a suitable **Device
   Template**, and configure the SNMP version and credentials. For SNMPv3,
   match the device's username, authentication, privacy, and context settings.

3. Save the device and check the SNMP information displayed on its edit page.
   Ensure **SNMP - Interface Statistics** is in **Associated Data Queries**.
   Add the query if the selected template did not supply it. Use **Verbose
   Query** if it returns no interfaces.

4. Select **Create New Graphs**, then select the interfaces in the interface
   statistics query and choose the desired graph type. Use a 64-bit counter
   graph where the device supports it, especially for high-speed interfaces.

5. Click **Create** and complete any additional fields presented. Allow
   polling to collect samples before expecting traffic data.

See [How to Graph Your Network](How-to-Graph-Your-Network.md) and
[Data Queries](Data-Queries.md) for the full workflow.

## General

**Q:** The website displays PHP source instead of a login page. What is wrong?

**A:** The web server is serving PHP files without passing them to PHP.
Configure its PHP handler, such as PHP-FPM or the Apache PHP module used by
your installation. Having a working `php` command in a terminal does not
confirm that the web server can execute PHP.

Keep the site inaccessible to other users until this is fixed: source files
can contain database credentials. Check the web server and PHP service logs,
then follow the [installation guide](General-Installing-Instructions.md) for
your operating system and web server.

---

**Q:** I have forgotten my local `admin` password. How do I reset it?

**A:** If another administrator can log in, use
[User Management](User-Management.md) to reset the local account. Otherwise,
connect to the Cacti database with an account permitted to update `user_auth`:

```sh
mariadb -u root -p cacti
```

Replace `cacti` with your database name and `newpassword` with a unique
temporary password, escaping any SQL quote characters in the value:

```sql
UPDATE user_auth
SET password = SHA2('newpassword', 256),
    password_change = 'on',
    must_change_password = 'on',
    lastchange = UNIX_TIMESTAMP()
WHERE username = 'admin' AND realm = 0;
```

The MySQL `mysql` client accepts the same connection arguments. Cacti accepts
this SHA-256 bootstrap hash and re-hashes it with its current password
algorithm after successful local authentication. The account must then change
the temporary password. The reset timestamp also preserves password-expiration
behavior. See the [local login provider][code-local-auth] and
[password verification][code-auth] implementations.

Changing the password does not unlock or enable an account. If login still
fails, check its status in User Management or inspect it in the database:

```sql
SELECT username, realm, enabled, locked, failed_attempts, lastfail
FROM user_auth
WHERE username = 'admin' AND realm = 0;
```

Have an administrator resolve an unintended lockout or disabled status. For
LDAP or another external login provider, reset the password at that provider.

## Monitoring

**Q:** Polling does not finish within the configured interval. What can I do?

**A:** Check the Cacti log for slow or unreachable devices, script timeouts,
database errors, and runtime warnings. Compare poller statistics with the
configured interval before changing concurrency.

[Spine](Spine.md) is the multithreaded C alternative to the PHP `cmd.php`
collector. `poller.php` still launches the selected collector and coordinates
the polling cycle. Install Spine, configure its database access and paths,
then select it under **Settings > Poller > Poller Type**.

Tune **Processes** and Spine **Threads** for the affected entry under
**Data Collectors**. Threads are per collector process, so consider the total
concurrency and database connections. Increase gradually while measuring
runtime, CPU, memory, database load, and storage I/O. More threads do not
guarantee faster polling; there is no fixed item throughput or CPU ratio that
applies to every installation. See [Data Collectors](Data-Collectors.md).

---

**Q:** I changed a setting or template and some graphs stopped updating.

**A:** Use [Data Debug](Data-Debug.md) and inspect the affected device's
**View Poller Cache** entries. Confirm that the data sources still have valid
polling commands, credentials, and OIDs.

If entries are missing or stale, use **Repopulate Poller Cache** on the device
edit page or save that device again. For a targeted CLI rebuild, run this from
the Cacti directory as the polling account, replacing `123` with the device ID:

```sh
php -q cli/rebuild_poller_cache.php --host-id=123
```

For a system-wide rebuild, use **Utilities > System Utilities > Rebuild Poller
Cache**, or omit `--host-id` from the CLI command. Large installations should
use the CLI. Rebuilding the cache does not repair a faulty template or restore
lost RRD data. Back up the database, RRD files, and custom scripts and query XML
before changing templates. See the [cache rebuild utility][code-cache].

---

**Q:** SNMP queries fail. Where should I start?

**A:** Test from the Data Collector assigned to the device, using the same
SNMP version, credentials, port, and context as Cacti. A successful query from
your workstation does not prove that the collector can reach the agent.

Check the agent's listening address, firewall rules, access controls, and
supported authentication/privacy protocols. For Cacti's PHP paths, verify the
PHP SNMP extension and the Net-SNMP binary paths. For Spine, also inspect its
configuration and log messages. Use the device's **Verbose Query** output to
distinguish an inaccessible agent from an empty or unsupported data query.

---

**Q:** How do I configure Net-SNMP's agent for Cacti?

**A:** Configure `snmpd` on the monitored system. `snmpconf -g basic_setup`
can help generate a configuration; confirm which file the installed service
actually reads. Paths differ between operating systems and packages.

Use read-only access and restrict requests to your Data Collectors. Prefer
SNMPv3 authentication and privacy where supported. If you use SNMPv2c, this
example restricts a community to one collector:

```text
# Replace both placeholders with your own values.
rocommunity REPLACE_WITH_UNIQUE_COMMUNITY 192.0.2.10
```

Replace the example IP with the collector's source address as seen by the
agent. Set matching credentials in Cacti and permit the configured SNMP UDP
port through the firewall only from the collectors. Apply the configuration
using your platform's service manager. On a systemd installation whose service
is named `snmpd`, for example:

```sh
sudo systemctl restart snmpd
```

Use the [Net-SNMP configuration manual][net-snmp-config] for SNMPv3 user
creation, views, and any disk-monitoring options required by your templates.

---

**Q:** I scheduled network discovery, but nothing is happening.

**A:** Open the **Log** tab and look for recent `SYSTEM` polling statistics,
`AUTOM8` messages, and errors. Missing statistics can indicate a stopped
poller, an early failure, or logging settings that suppress or redirect the
messages. Check the active log destination and filters before concluding
that polling has stopped.

Confirm **Settings > Poller > Data Collection Enabled** is checked. Verify
that your chosen scheduler, such as cron or `cactid`, is running under the
intended account and can execute PHP and access Cacti. Check its service or
scheduler logs for startup and permission errors. Use one scheduler for each
collector to avoid duplicate launches.

If polling works, inspect the enabled state, schedule, assigned collector,
address range, and SNMP options of the network under **Automation > Networks**.
Discovery is launched from the polling cycle and has its own scheduling and
process checks. See [Automation Networks](Automation-Networks.md),
[Discovered Devices](Discovered-Devices.md), and the
[automation implementation][code-automation].

## Graphs

**Q:** I just installed Cacti and my graphs appear as broken images.

**A:** A graph cannot read its data until the corresponding RRD files exist.
Confirm that polling has run successfully and inspect the Cacti log for RRD
creation errors. The normal local storage directory is `rra/`, but use the
actual data source path if you configured another storage layout or RRDproxy.

The polling account needs access to create and update those files. The web
server needs access to render graphs and, when it performs RRD updates or
maintenance, write access as well. See
[installation hardening](Hardening-Cacti-Installation.md) for permissions.

To diagnose a polling failure, run from the Cacti directory as the configured
polling account, while avoiding an overlapping scheduled run:

```sh
php -q poller.php --debug
```

Use the PHP CLI binary configured for your installation. If the files exist,
open the graph under **Management > Graphs**, select **Turn On Graph Debug
Mode**, and inspect the RRDtool command and response. Check the configured
RRDtool path and the web server's access to the files named in that command.

---

**Q:** My graphs render, but they do not contain data.

**A:** Start with [Data Debug](Data-Debug.md) to confirm that polling returns
valid values. Inspect the log for SNMP, script, and RRD update errors. Check
that the polling account can update the actual RRD path. A manual run as
another user can leave files with unsuitable ownership or permissions.

Check the data source type, minimum, maximum, heartbeat, and polling interval.
Values outside the RRD data source bounds become Unknown. For counters, the
bounds apply to the calculated rate, so use the data source's units when
choosing a maximum. A traffic graph may convert byte rates to bits for display.
Counter-based sources also need successive samples before a rate is available.
See [Data Sources](Data-Sources.md) and [Debugging](Debugging.md).

---

**Q:** Long `ifAlias` values are truncated in graph titles. Can I change this?

**A:** Under **Settings > Visual > Graph/Data Source/Data Query Settings**,
increase **Data Source Field Length** (`max_data_query_field_length`). Its
development-branch default is **40**, not 15. Also check **Maximum Title
Length**, whose default is **110**.

If existing names still contain the shortened text, use **Reapply Suggested
Names** for the affected graphs or data sources. This regenerates names from
their naming rules, so check custom names before applying it in bulk. See
[setting definitions][code-settings] and [query substitution][code-variables].

---

**Q:** A device rebooted and now there is a large spike on its traffic graph.

**A:** Counter resets or discontinuities can produce an implausible rate.
Check the counter type, interface speed, and the maximum for the RRD data
source. A realistic maximum lets RRDtool reject impossible calculated rates.
Use the source's units, such as bytes per second, rather than the graph's
displayed units.

For an existing spike, see [Spikekill](Spikekill.md). Back up the affected RRD
files before removing spikes because this changes stored history.

---

**Q:** A remote collector times out even though SNMP responses are fast.

**A:** SNMP is only one part of a remote collection cycle. Check the logs on
both collectors and verify connectivity, latency, and database access between
the remote collector and the main system. Also inspect replication/recovery
messages, database load, script runtimes, and RRD processing.

The **Remote Agent Timeout** setting controls how long the central web server
waits for remote device-information requests. It is not the polling cycle's
runtime limit. Diagnose the timed-out operation before changing it. See
[Remote Poller Setup](How-To-Setup-Remote-Pollers.md).

---

**Q:** RRDtool reports an unknown option or a malformed `COMMENT`. What next?

**A:** Check **Settings > Paths > RRDtool Binary Path** and
**Settings > General > RRDtool Version** against the executable actually used
by Cacti. A version mismatch can make Cacti generate unsupported options.

Enable Graph Debug Mode to inspect the failing command. A malformed `COMMENT`
can also come from graph text or escaping; a version mismatch is not the only
possible cause. Check the exact option or graph item named in the error.

## Windows Related

**Q:** PHP reports `Cannot redeclare title_trim()`. How do I fix it?

**A:** This means PHP loaded more than one definition of the function. Check
for a mixed installation, duplicate Cacti files, and custom PHP include or
`auto_prepend_file` settings that load Cacti code twice. Check the PHP
configuration used by the failing web or CLI process, since they can differ.

Do not add a Cacti directory to PHP's `include_path` as an installation step.
Use a complete, consistent release and follow the
[Windows installation guide](Installing-Under-Windows.md). The error alone
does not establish that `include_path` is the cause.

## Common Problems

### MySQL server has gone away

This means the database connection was lost. Check the database error log and
service status for restarts or crashes, then investigate network failures,
connection timeouts, and oversized packets. Inspect relevant settings:

```sql
SHOW GLOBAL VARIABLES LIKE 'wait_timeout';
SHOW GLOBAL VARIABLES LIKE 'max_allowed_packet';
SHOW GLOBAL VARIABLES LIKE 'max_connections';
SHOW GLOBAL STATUS LIKE 'Threads_connected';
SHOW GLOBAL STATUS LIKE 'Max_used_connections';
```

Connection exhaustion normally reports **Too many connections**. Raise
`max_connections` only when the logs and workload support that diagnosis and
the server has capacity. Increasing it alone does not fix a lost connection.
See the [MySQL troubleshooting guide][mysql-gone-away].

### Cron is out of sync with the Poller Interval

A scheduling warning can indicate that the launcher cadence and Cacti's
configuration disagree, or that launches were delayed or missed. Under
**Console > Configuration > Settings > Poller**, check **Cron/Daemon Interval**
and **Poller Interval**.

**Cron/Daemon Interval** is the launch frequency, with choices of 60 or 300
seconds. **Poller Interval** is the collection frequency; `poller.php` can
perform multiple collection passes during a single launch. Changing the
poller interval also requires rebuilding the poller cache; existing RRD
profiles need separate consideration. See the
[interval-change guide](How-To-Poller-5-to-1-min.md).

For cron, the schedule must match **Cron/Daemon Interval**. For example, these
are alternative entries in a system cron file. Replace the account and paths
with your installation's values:

```cron
# Every five minutes (300 seconds)
*/5 * * * * cacti /usr/bin/php -q /path/to/cacti/poller.php

# Every minute (60 seconds)
* * * * * cacti /usr/bin/php -q /path/to/cacti/poller.php
```

Install only the matching entry. A per-user crontab omits the `cacti` account
field. If using `cactid`, check its service configuration and disable the
equivalent cron entry. Also check for runtime overruns and scheduler errors.
See the [daemon installation instructions][code-service].

### Poller Runtime exceeded

```text
Maximum runtime of ... seconds exceeded. Exiting.
```

This means the poller reached its runtime limit. Check earlier log messages
and collector statistics to identify the slow or failing work:

- Spine cannot connect with its configured database credentials or cannot
  start from the configured binary/configuration paths.
- Unreachable devices, slow SNMP requests, or scripts consume the interval.
- Collector processes or Spine threads are insufficient for the workload,
  or excessive concurrency overloads the database or system.
- Database connection limits, CPU, memory, storage I/O, or remote connectivity
  constrain the cycle.

Resolve the measured bottleneck, then confirm subsequent cycles finish within
the configured interval. See [poller orchestration][code-poller].

### RRDtool reports Unknown Error

Edit the affected graph and select **Turn On Graph Debug Mode**. Inspect both
**RRDtool Command** and **RRDtool Says**. If necessary, run the displayed
command as the web server account, using the same executable, paths, and
environment. On Linux, an administrator can use `sudo -u` to select that
account.

Graph commands can write binary image data to standard output. When copying
one that uses `rrdtool graph -` or `graphv -`, change the output destination
from `-` to a writable temporary image path so diagnostics remain readable.

On Windows, reproduce the failure under the relevant application-pool or
scheduled-task identity. These accounts can have different permissions, PHP
configurations, and environment variables; an interactive administrator's
successful command does not prove that the service account can run it.

## Source References

Cacti behavior in this page was checked against development commit
[`883b334de`][code-revision]. The links below pin the relevant implementation
so that setting names, defaults, and authentication behavior can be checked
when updating this FAQ. Also see [SNMP method selection][code-snmp],
[device actions][code-device], [collector concurrency][code-collectors], and
[RRD creation and graph generation][code-rrd].

[manual-1.2]:
  <https://github.com/Cacti/documentation/tree/1.2.x>
[code-revision]:
  <https://github.com/Cacti/cacti/tree/883b334de>
[code-local-auth]:
  <https://github.com/Cacti/cacti/blob/883b334de/lib/Auth/LocalAuthLoginProvider.php>
[code-auth]:
  <https://github.com/Cacti/cacti/blob/883b334de/lib/auth.php#L4550-L4566>
[code-cache]:
  <https://github.com/Cacti/cacti/blob/883b334de/cli/rebuild_poller_cache.php>
[code-settings]:
  <https://github.com/Cacti/cacti/blob/883b334de/include/global_settings.php#L1404-L1421>
[code-variables]:
  <https://github.com/Cacti/cacti/blob/883b334de/lib/variables.php>
[code-automation]:
  <https://github.com/Cacti/cacti/blob/883b334de/poller_automation.php>
[code-poller]:
  <https://github.com/Cacti/cacti/blob/883b334de/poller.php>
[code-service]:
  <https://github.com/Cacti/cacti/blob/883b334de/service/README.md>
[code-snmp]:
  <https://github.com/Cacti/cacti/blob/883b334de/lib/snmp.php>
[code-device]:
  <https://github.com/Cacti/cacti/blob/883b334de/host.php>
[code-collectors]:
  <https://github.com/Cacti/cacti/blob/883b334de/pollers.php>
[code-rrd]:
  <https://github.com/Cacti/cacti/blob/883b334de/lib/rrd.php>
[net-snmp-config]:
  <https://www.net-snmp.org/docs/man/snmpd.conf.html>
[mysql-gone-away]:
  <https://dev.mysql.com/doc/refman/8.4/en/gone-away.html>

---

Copyright (c) 2004-2026 The Cacti Group
