# Upgrading Cacti Under UNIX Compatible Operating Systems

This procedure covers a source installation upgrading to Cacti 1.2.31. For a
package-managed installation, use the package maintainer's upgrade procedure
and configuration-file handling. See the separate guides for
[Windows](Upgrading-Cacti-Under-Windows.md) and
[FreeBSD](Upgrading-Cacti-Under-FreeBSD.md).

Review the [release notes][release] and [requirements](Requirements.md) first.
Schedule time to back up and restore the installation. Test the upgrade on an
isolated copy of the database and files before changing production. Keep
dependency upgrades separate unless a prerequisite requires them.

## Stop writers before backing up

Turn off **Data Collection Enabled** under the poller settings. Also suspend
the actual scheduler on each affected collector: disable only the Cacti cron
entry, or stop its installed `cactid` service. Preserve the scheduler settings
so they can be restored later. Do not disable all system cron jobs.

Wait for existing poller, Spine, script-server, Boost and other background
jobs to finish. Prevent web requests and plugin jobs from changing the
installation during the backup and upgrade. The application polling switch
alone does not stop every running process or administrative writer.

If collectors use `rrdcached`, drain its pending writes using the procedure
for that deployment before taking the RRD snapshot. Keep writers stopped
until the database and file backups are both complete. Coordinate this on
remote collectors as well as the main server.

## Back up the database and complete installation

Record the installed Cacti, Spine, PHP and database versions, installation
paths, service accounts, scheduler entries and remote-collector configuration.
Store backups outside the web root with access restricted to administrators.

Back up the Cacti database with a client compatible with the database server.
For example, with the application stopped and a backup account with the
required privileges:

```sh
umask 077
BACKUP_DIR=/srv/backups/cacti-before-1.2.31
mkdir "$BACKUP_DIR"
mysqldump --user=backup_user --password --lock-tables --quick \
  --routines --events --triggers cacti \
  > "$BACKUP_DIR/cacti.sql"
```

Adjust the database name, account and paths before running these examples.
Use `mariadb-dump` instead of `mysqldump` where appropriate. Enter the password
at the prompt. Stop if a command fails; an output file alone does not prove a
successful dump. The account needs the privileges required by the installed
dump client, including table locks for the example above.

`--single-transaction` provides a consistent snapshot for transactional
tables; it does not make nontransactional tables consistent. Inspect the
actual storage engines and choose the backup method accordingly. Keep all
application writers stopped for the corresponding file snapshot. See the
[database backup documentation][dump] for the option and privilege details.

Back up the complete installation, including the RRD files. For an example
installation at `/var/www/html/cacti`:

```sh
tar -czpf "$BACKUP_DIR/cacti-files.tar.gz" -C /var/www/html cacti
tar -tzf "$BACKUP_DIR/cacti-files.tar.gz"
```

Preserve `include/config.php`, plugins, custom scripts, query resources and
other local configuration. Include CSRF secret material, including an
alternate `$path_csrf_secret` from the configuration. Back up separately any
RRD, configuration or resource paths outside the installation tree. A tar
archive normally preserves a symlink rather than including its external
target. Retain the permissions and ownership needed for restoration.

Save the database user/grant definitions and any connection certificates
needed to recreate access. These are not included in a dump of the Cacti
database alone. Include site or plugin SQL routines and events, as in the
example, and account for their additional backup privileges.

Back up remote-collector databases and local files where they hold state.
Verify dump completion and archive contents, then rehearse restoration on an
isolated system. Excluding `*.rrd` would leave monitoring history outside the
recovery set.

## Install the release files

Download the intended 1.2.31 distribution from the release page and extract it
into a staging directory. Verify the package using the release's published
verification information before using it. Keep the existing installation and
its backup until the upgrade has been checked.

Copy the contents of the extracted directory into the existing installation,
not the directory itself. For example, after extraction:

```sh
STAGING_DIR=/var/tmp/cacti-1.2.31
CACTI_DIR=/var/www/html/cacti
cp -a "$STAGING_DIR"/. "$CACTI_DIR"/
```

Confirm that the new files are directly under the installation root, such as
`$CACTI_DIR/poller.php`, rather than a nested `cacti-1.2.31` directory. Preserve
the existing `include/config.php` and review new options in
`include/config.php.dist`. Reconcile local code changes and plugin
compatibility with the new files; copying the release is not a substitute for
reviewing those changes.

Check permissions using the accounts that actually run the web server,
poller and maintenance jobs. Those accounts need not be identical. Give the
poller the required access to RRD and log paths, and check configured cache,
resource and script paths. Preserve access needed by installation and package
imports. Do not make the entire application tree writable as a permissions
workaround.

## Run and verify the upgrade

Allow an administrator to open the Cacti URL and follow the database-upgrade
workflow. Review errors before proceeding. The release also provides
`cli/upgrade_database.php`; consult its `--help` output if using the CLI
workflow. Do not manually advance the database version or force a starting
version merely to bypass an upgrade check.

Confirm the installed version, database-upgrade result, credentials, paths,
plugin state and collector configuration. Check remote collectors individually
and follow the applicable synchronization procedure; do not assume that two
polling cycles prove their files and databases have upgraded successfully.

Restore web access and the saved scheduler configuration only after the
upgrade checks succeed, then re-enable collection. Use either the configured
cron path or the daemon for a collector, not both. Verify logs, data freshness
and representative RRD updates after normal polling resumes.

## Recovery

If the upgrade fails, keep writers stopped while deciding whether to retry or
restore. Replacing PHP files alone does not undo a database migration. Restore
the matching pre-upgrade database, application files, RRD data and external
configuration or secret material, including affected remote-collector state.
Verify the restored installation before re-enabling its schedulers. Restoring
an earlier backup discards changes collected after that backup.

[release]: <https://github.com/Cacti/cacti/releases/tag/release/1.2.31>
[dump]: <https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html>

---

Copyright (c) 2004-2026 The Cacti Group
