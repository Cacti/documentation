# Move a historical Solaris installation to a maintained platform

This guide replaces the archived Solaris installation procedure with a
migration procedure. It does not certify a new Solaris installation of Cacti
1.3. Solaris is not among the platforms with maintained installation guidance
in this manual. Choose a target from [Requirements](../../Requirements.md).
For released Cacti 1.2, use the [1.2.x manual][stable]; this documentation
otherwise follows the unreleased Cacti 1.3 development branch.

## Inventory the source

Record the exact Cacti, PHP, database, RRDtool, Spine, and plugin versions;
collector IDs and hostnames; database encoding; configured paths; schedules;
and the poller and web identities. Include scripts, query definitions,
templates, credentials, certificates, and RRD files outside the application
folder. Keep credentials out of screenshots and support messages.

Take database and filesystem backups before any change. Test restoring them
in an isolated environment. An old Cacti database may need intermediate
upgrades: follow the version-specific release notes and
[upgrade instructions](../../Upgrading-Cacti.md) for each required step rather
than importing an unknown historical schema into the newest application.
Never import a new-install `cacti.sql` over the preserved database.

## Prepare an isolated target

Install a maintained Linux or FreeBSD system with dependencies compatible with
the chosen Cacti release. Follow the platform's installation guide and
[general instructions](../../General-Installing-Instructions.md). Keep its
poller schedule disabled and restrict web access while restoring data.

Restore copies of the database, configuration, and required assets. Adjust
absolute paths, service identities, and permissions to the target. Reinstall
compatible plugins and dependencies from trusted sources. Keep application
code protected from runtime write access. Complete upgrades once, in the
sequence required by the selected releases, against the isolated copy.

## Transfer RRD data between architectures

Do not assume binary RRD files are portable between Solaris and the new host.
Use RRDtool's [dump][rrddump] on the source and [restore][rrdrestore] on the
target when the binary format or architecture differs. For one example file:

```sh
# Source host, after pausing writes:
rrdtool dump /source/rra/example.rrd > /backup/example.xml
# Target host; choose a new destination that does not already exist:
rrdtool restore /backup/example.xml /target/rra/example.rrd
rrdtool info /target/rra/example.rrd
rrdtool lastupdate /target/rra/example.rrd
```

Replace every example path. Test conversion on copies with the RRDtool versions
actually installed. Preserve filenames and Cacti's association with each RRD.
Compare data source definitions, last timestamps, and representative historical
graphs. XML dumps can be large; allow enough storage for backups and
conversion.

## Validate, cut over, and retain rollback

Check web and CLI PHP, SNMP access from the new collector, database
connectivity,
permissions, graph history, and [data debugging](../../Data-Debug.md). Do not
poll production devices from both installations during validation.

Schedule a maintenance window. Stop source polling and verify that no poller
is running. Take the final backup and transfer changed data. Enable exactly
one target schedule only after validation. Verify new samples arrive and
historical graphs remain readable. Update DNS, access controls, backups, and
monitoring deliberately; apply
[hardening](../../Hardening-Cacti-Installation.md).

Retain the stopped source and backups for rollback. If rollback is needed,
stop target polling first. Decide how to preserve any samples collected after
cutover before restoring the source. Never run both schedules to fill gaps.

[stable]: https://github.com/Cacti/documentation/blob/1.2.x/README.md
[rrddump]: https://oss.oetiker.ch/rrdtool/doc/rrddump.en.html
[rrdrestore]: https://oss.oetiker.ch/rrdtool/doc/rrdrestore.en.html

---

Copyright (c) 2004-2026 The Cacti Group
