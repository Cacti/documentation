# Converting a Debian or Ubuntu Package Installation to Source

Use this procedure only on a [supported operating system][supported-os].
Changing installation ownership can affect paths, service accounts, package
upgrades, and database management. Test the migration on an isolated copy
before changing a production server.

## Record the installed layout

Record the Cacti version, database and grants, PHP configuration, web-server
configuration, scheduler, service accounts, plugins, Spine configuration,
and actual RRD, log, cache, script, and query-resource paths. Distribution
packages can keep configuration and data outside the web application tree.
Inspect symlinks and package-managed files; do not assume that copying the
web directory includes their external targets.

## Pause writers and take a complete backup

Follow [Upgrading Cacti](Upgrading-Cacti.md#stop-writers-before-backing-up)
to pause only Cacti's scheduler and other application writers, and take a
matching backup of the database, files, RRD history, configuration, and
external state. Do not stop the entire system cron service. Verify the backup
and rehearse restoring it before changing the package installation.

## Stage and verify the source installation

Use the [source installation guide][install] to select and stage the intended
Cacti revision and dependencies in a new directory. Its fresh-install schema
import is for an empty database. Preserve the existing database for this
migration; do not import `cacti.sql` over it or run the fresh-install procedure
against production data.

Copy the existing configuration, custom resources, plugins, and RRD data to
the intended paths, preserving permissions. Reconcile the new configuration
example, URL path, web restrictions, dependency versions, and service accounts.
Protect credentials and secret files. Use the package maintainer's documented
procedure to relinquish package ownership without deleting application data.
Do not purge the package or accept a database-removal prompt merely to switch
to source. Keep the old installation and verified backup available.

## Cut over and validate

With writers still paused, update the web mapping and the single Cacti
scheduler to the source installation. If changing Cacti versions, follow the
[database-upgrade procedure](Upgrading-Cacti.md#run-and-verify-the-upgrade)
against the preserved database. Verify paths, permissions, plugins, collector
connectivity, and any remote-collector upgrades before resuming collection.

Check scheduled polling, logs, RRD updates, and representative graphs.
Document how future source updates will be applied and prevent a later package
operation from overwriting the source deployment. If recovery is required,
restore the matching files, database, RRDs, and configuration as one set;
restoring application files alone does not undo a database migration.

[supported-os]: Requirements.md#supported-operating-systems
[install]: Installing-Under-Ubuntu-Debian.md

---

Copyright (c) 2004-2026 The Cacti Group
