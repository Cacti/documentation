# Upgrading Cacti Under FreeBSD

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

These instructions cover the FreeBSD upgrade procedure. This manual describes
Cacti development (1.3), while the FreeBSD port currently supplies Cacti 1.2.31.
Use the [1.2.x manual][manual-12] for release-specific requirements when
upgrading the packaged release. Determine whether Cacti is maintained by
`pkg`, by ports or from a source archive. Keep that installation
method for the upgrade; do not overlay an archive onto package-managed files.
Review the target Cacti [release notes](Version-Specific-Release-Notes.md),
[requirements](Requirements.md) and package or port notes before proceeding. Do
not make an unrelated operating-system, PHP or database major-version upgrade
part of this procedure without a separate compatibility plan.

## Pause collection and back up

1. Clear **Data Collection Enabled** under `Console > Configuration > Settings
   > Poller`. Disable the Cacti-specific cron entry or stop its configured
   poller service on every collector. Record what you change; do not stop the
   system-wide cron service merely to pause Cacti. Wait for pollers, Spine,
   script servers and other background writers to finish. Restrict web access
   to the upgrade administrator and pause plugin jobs that write to Cacti.
   Flush pending RRD-cache writes and confirm that the database and RRD files
   remain unchanged before taking the backup.

2. Use the dump client appropriate to the installed MySQL or MariaDB server.
   The following example requires an existing, protected backup directory and a
   database account with the server's required backup privileges. Replace the
   account, database name and filename for your installation. Use its actual
   database host, port and TLS options.

   ```sh
   mysqldump --user=YOUR_BACKUP_USER --password \
     --lock-tables --quick --routines --events --triggers \
     --databases cacti --result-file=/protected/backup/cacti-YYYYMMDD.sql
   ```

   The password is prompted. With all Cacti writers paused, this [dump
   method][dump] uses table locks for the Cacti database, including
   nontransactional tables. A transaction-only dump does not cover those
   tables. Verify the command succeeded and test restoring the dump separately;
   a nonempty file alone is not proof of a complete backup. Use a new filename
   rather than overwriting a known good backup.

3. Back up the Cacti application files, RRDs and local configuration together
   with the database dump. Preserve ownership, permissions and hidden files.
   Include `include/config.php`, custom scripts, query resources, plugins,
   secret files, including any alternate `path_csrf_secret`, and configured
   paths outside the application tree. Record symbolic links and back up their
   targets separately. Also record the Spine configuration, cron/service
   settings, web-server settings, database grants, certificates/keys and
   installed versions. Package layouts may keep configuration and data outside
   `/usr/local/share/cacti`; inspect the installed paths rather than backing up
   that directory alone. Include `/var/db/cacti/rra` and `/var/log/cacti`
   when those are the configured package paths, and protect the backup directory
   from other users because the configuration contains credentials.

## Upgrade using the existing installation method

For a binary package installation, review the proposed package transaction
before applying it. The [FreeBSD Handbook][packages] describes package
upgrades. Run the following with appropriate administrator privileges:

Discover the installed flavor first:

```sh
pkg info -o -x '^cacti'
pkg update
```

For an installed `cacti-php84` package, for example:

```sh
pkg upgrade -n cacti-php84
pkg upgrade cacti-php84
pkg info -D cacti-php84
```

Replace `cacti-php84` with the installed package name. Keep the PHP flavor
unless a separate migration is intended. If Spine is installed, review its
upgrade and verify its version remains compatible with Cacti. See the
[FreeBSD installation section][freebsd-install] for package paths and the
`net-mgmt/cacti-spine` port.

Check the proposed version and dependency changes before accepting the actual
upgrade. A package repository normally supplies a release rather than
development source. Stop if that is not your approved target and select an
appropriate repository or installation method. Do not delete Cacti first or
assume that upgrading one package cannot affect its dependencies.

For a ports-managed installation, follow the handbook's [ports upgrade
procedure][ports] and applicable `/usr/ports/UPDATING` entries. Use the
existing ports management method; do not switch between ports and binary
packages without reviewing their options and dependencies. A source
installation instead follows [Upgrading Cacti](Upgrading-Cacti.md).

Preserve the working configuration and merge required changes from the new
configuration example. Keep existing database credentials, collector IDs, paths
and secrets. Review package-generated configuration changes and restore local
resources only after checking compatibility. Recreate cache or data directories
only where the installed configuration requires them, with access for the
actual service account; do not assume a universal account or apply recursive
ownership changes to the whole installation.

## Check development dependencies

Development source requires PHP 8.3 or later in the PHP 8 series, with the
extensions declared by the selected revision. Install locked dependencies in
the staging directory with `composer install --no-dev`, then run `composer
check-platform-reqs --no-dev`. Preserve this complete dependency tree when
deploying the staged application. Do not run `composer update` against a live
installation. A complete release bundle can already include dependencies;
verify its platform checks instead of assuming that every archive is complete.

## Complete the application upgrade

Open the existing Cacti URL as an administrator and complete its database
upgrade. Review the installer and logs before resuming collection. Upgrade
remote collectors' local files and configuration through their installation
method, complete the applicable upgrade/synchronization, and verify their
versions, connectivity and logs. Do not rely on a fixed number of poll cycles
for completion. Check the matching Spine version on collectors using Spine.

After successful checks, re-enable **Data Collection Enabled** and restore the
recorded Cacti cron entry or service. Verify a complete poll cycle, recent RRD
samples and representative graphs on every collector. If recovery is needed,
stop all writers again and restore the matching files, database, RRDs and
configuration as one set; restoring old application files alone does not undo a
database upgrade.

[dump]:<https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html>
[packages]:<https://docs.freebsd.org/en/books/handbook/ports/#pkgng-upgrading>
[ports]:<https://docs.freebsd.org/en/books/handbook/ports/#ports-upgrading>

[supported-os]: Requirements.md#supported-operating-systems
[manual-12]: <https://github.com/Cacti/documentation/tree/1.2.x>
[freebsd-install]: General-Installing-Instructions.md#freebsd

---

Copyright (c) 2004-2026 The Cacti Group
