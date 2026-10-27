# Debugging

Use this procedure when graphs show gaps, unknown values (`NaN`), or unexpected
zeros. Start with one affected device and data source, and identify the failing
stage: device or script, collector, database buffering, RRD storage, or graph
rendering. The commands and menu labels follow Cacti development (1.3).

Use [Data Source Debugging](Data-Debug.md) for the guided checks. Record the
device, data-source and collector IDs, the expected polling interval, and the
last successful sample. A down device or an idle counter can legitimately
produce a different result from a failed collector.

## Check Cacti Log File

Read the configured [Cacti log](Cacti-Log.md), including the affected remote
collector's log. The log path can be outside the application directory; the
FreeBSD package normally uses `/var/log/cacti`.

Look for timeouts, authentication failures, script errors, database errors and
poller overruns around the missing samples. Preserve the original log. Enable
additional logging only for the affected device where supported, or briefly
for a controlled polling cycle, then restore the previous logging level.
Redact credentials and sensitive device details before sharing diagnostics.

An SNMP timeout does not establish that bulk requests are the cause. Check
reachability, SNMP version, credentials, access controls and response time
first. If the agent fails larger requests, adjust that device's request limits
and retest rather than lowering global limits for every device.

## Check Basic Data Gathering

Run a data-input script as the actual poller account, using the configured
interpreter, arguments and environment. Compare its output with the expected
field names and numeric values in the [Data Input Method](Data-Input-
Methods.md).
For a script-server input, use the [PHP Script Server](PHP-Script-Server.md)
procedure; executing a function-based script directly is not an equivalent
test.

For SNMP, query the exact OID with the same version, context and access
settings
as Cacti. Configure secrets through the supported protected Net-SNMP
configuration rather than pasting real credentials into shared commands or
logs. Check both the device response and Cacti's configured timeout/retries.
A successful ping alone does not confirm that SNMP is available.

## Check Cacti's poller

Verify the responsible [Data Collector](Data-Collectors.md), its selected
polling engine, and **Data Collection Enabled**. Check the actual launcher and
**Cron/Daemon Interval** as well as **Poller Interval**. FreeBSD uses cron or
configured rc.d services; Linux systemd commands do not apply there.

If a manual collector test is needed, first pause the overlapping scheduled
work and wait for existing workers to finish. Restrict the test to the affected
device. The development PHP collector uses named ID arguments, as shown by its
[command help][cmd-help]:

```sh
php -q cmd.php --first=42 --last=42 --debug
```

Replace `42` with the device ID and run from the Cacti directory as the poller
account. This collects data; it is not a read-only inspection. Restore the
original schedule after the test. For Spine, use the installed binary's
`--help` and [Spine](Spine.md) instructions for its version and configuration.

## Check MySQL updating

Check the collector log for failed database writes, connection errors or
replication problems. Inspect the [Poller Cache](System-Utilities.md) and
confirm that the affected data source is assigned to the expected collector.

Cacti can buffer samples for later processing. With [Boost](Boost.md) or an
RRD cache enabled, collection and disk updates can occur at different times.
Check the relevant worker and pending-data state before concluding that a
missing direct `rrdtool update` log entry means collection failed.

Do not replay captured SQL writes against the production database as a debug
step; they can duplicate or overwrite application state.

## Check RRDfile updating

Use the RRD path shown by the data source and its configured collector. Do not
assume it is under the web application's `rra` directory. On a default FreeBSD
package installation, RRDs are under `/var/db/cacti/rra`.

Check the file's timestamps, data-source names and last update:

```sh
rrdtool info /path/to/device.rrd
rrdtool lastupdate /path/to/device.rrd
```

Use the configured RRDtool binary and, when applicable, the configured RRD
cache
connection. Account for pending cache writes before comparing disk timestamps.
Do not issue manual production `rrdtool update` commands to fill a gap.

## Check RRDfile ownership

The poller or RRD-writing service must be able to traverse the parent
directories
and write the RRD file. The graph-rendering process needs the access required
by the configured storage/cache arrangement. Check those actual service
identities rather than assuming they are the same user.

Inspect the affected file and its parent directories. Correct the specific
ownership or permissions that differ from the deployment's policy. Avoid
blanket ownership changes to application code, credentials, or every RRD file.
See the [FreeBSD installation guidance][freebsd] for package defaults.

## Check RRDfile numbers

Read recent stored values and metadata:

```sh
rrdtool fetch /path/to/device.rrd AVERAGE --start -1h
rrdtool info /path/to/device.rrd
```

Check data-source type, minimum, maximum, step and heartbeat against the
[Data Source Template](Data-Source-Templates.md) and
[Data Profile](Data-Profiles.md). An out-of-range value, counter reset or gap
beyond the heartbeat can produce unknown data even when collection succeeds.

Changing a template does not necessarily rewrite existing RRD definitions.
Plan any RRD repair or tuning against the actual files, preserve a consistent
backup, and verify the result before applying it to other data sources.
Increasing heartbeat can permit interpolation; it does not recover observed
measurements that were never collected.

## Check `rrdtool graph` statement

In Graph Management, open the affected graph and enable **Graph Debug Mode**.
Inspect the command and RRDtool response. Check the `DEF` paths, data-source
names, consolidation functions, requested time range and graph permissions.

If reproducing the command as the web account, preserve its binary paths and
environment. Replace a `graph -` or `graphv -` output destination with a
writable
temporary image path so binary image output does not obscure diagnostics.

## Duplicate Poller Entries

Inspect Cacti-specific cron entries, service configuration and running workers
on the responsible collector. A package may have supplied a schedule in
addition to one added manually. Keep one intended launcher; do not disable the
system-wide cron service to stop a single Cacti job.

After resolving duplicate launches, verify a complete polling cycle and fresh
RRD samples. Preserve the original service and scheduling configuration for
rollback. See [Settings - Poller](Settings-Poller.md).

## Not NaN, but 0 (zero) values

Distinguish a valid zero from a script failure converted to zero. Run the input
under the poller account, check its exit status and output, and verify external
command paths. A successful interactive command as root does not establish
that the collector has the same permissions or environment.

For tools that require elevated access, use a narrowly scoped mechanism
supported by that tool or its package. Do not make a script or general-purpose
interpreter setuid as a troubleshooting shortcut.

[cmd-help]:
  <https://github.com/Cacti/cacti/blob/ff31e051d/cmd.php#L1372-L1391>
[freebsd]: General-Installing-Instructions.md#freebsd

---

Copyright (c) 2004-2026 The Cacti Group
