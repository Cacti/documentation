# Upgrading Cacti under Windows

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

These instructions cover upgrading a source/archive installation to Cacti
1.2.31. For a managed Windows installation, also follow its package or
installer upgrade procedure; do not overwrite package-managed files with an
unrelated archive. Review the [release
notes](Version-Specific-Release-Notes.md) and [requirements](Requirements.md)
for the target Cacti version first. An upgrade of Cacti does not automatically
require upgrading Windows, PHP or the database.

## Pause collection and take a recoverable backup

1. In `Console > Configuration > Settings > Poller`, clear **Data Collection
   Enabled** and save. Disable the actual Windows Scheduled Task that launches
   `poller.php`, or stop the service that manages your poller. Record the task
   or service settings so you can restore them. Use [Task Scheduler][tasks] to
   disable future starts; this alone does not finish an already running poll.

2. Wait for running pollers, Spine processes, script servers and background
   writers to finish. Include remote collectors and plugin jobs. Restrict web
   access to the upgrade administrator so configuration changes cannot race the
   backup. Flush pending RRD-cache writes before copying RRD files and confirm
   that writers have stopped. Do not start a manual poll during this
   maintenance window.

3. Create a protected backup directory outside the web root. From Command
   Prompt, use the dump utility matching your database server. Replace the
   executable path, account, database name and output path in this example. Use
   the actual database host, port and TLS options for your installation. The
   account needs the backup privileges required by the installed server;
   `--password` prompts rather than putting a password in the command.

   ```bat
   "C:\path\to\mysqldump.exe" --user=YOUR_BACKUP_USER --password ^
     --lock-tables --quick --routines --events --triggers ^
     --databases cacti --result-file="D:\CactiBackup\cacti-YYYYMMDD.sql"
   ```

   With all Cacti writers paused, this [dump example][dump] uses table locks to
   cover transactional and nontransactional tables in the Cacti database. A
   transaction-only dump does not protect nontransactional tables. Use a new
   output filename and verify successful completion: a failed dump may leave a
   partial file. Do not proceed until the backup can be restored in a separate
   test environment.

4. Back up the existing Cacti tree, including hidden files, using a separate
   destination outside the web root. For example, [Robocopy][robocopy] can
   preserve file permissions as well as contents when run with the required
   privileges:

   ```bat
   robocopy "C:\inetpub\wwwroot\cacti" "D:\CactiBackup\cacti-YYYYMMDD" /E /COPYALL /SL /XJ /R:2 /W:2
   ```

   Inspect its report; exit codes of 8 or greater indicate copy failures.
   Confirm that the backup includes `include/config.php`, RRDs, custom scripts,
   query resources, plugins and secret files, including any alternate
   `path_csrf_secret`. Also save configured paths outside this tree, the Spine
   configuration, scheduler settings, web-server configuration, database grants
   and required certificates/keys. Record symbolic links and junctions and back
   up their external targets separately; the example copies symbolic links and
   excludes junctions. Preserve permissions and record the installed versions.
   Keep this file backup and database dump together as one recovery set.

## Install and verify the upgrade

1. Extract the target [Cacti release][download] into a staging directory. Keep
   the existing tree and verified backup available. Deploy the release files
   using your existing installation layout, preserving the working
   `include/config.php` and local resources. Compare the new
   `include/config.php.dist` for changes; do not replace existing credentials,
   collector IDs, paths or secrets with example defaults. Check plugin and
   custom-script compatibility before restoring or enabling them.

2. Verify file permissions for the web server and poller accounts. Open the
   existing Cacti URL as an administrator and complete the database upgrade.
   Review installer checks and logs. Use version-appropriate database settings
   from [Requirements](Requirements.md), rather than applying fixed global SQL
   tuning commands.

3. For remote collectors, keep their schedulers paused while updating their
   local application files and configuration and completing the applicable
   upgrade and synchronization. Verify each collector's reported version,
   connectivity and logs; completion is not guaranteed after two poll cycles.
   Check the matching Spine version where it is used.

4. Re-enable **Data Collection Enabled** and restore the recorded scheduler or
   service only after the upgrade succeeds. Check a complete poll cycle,
   collector status, new RRD samples and representative graphs. If recovery is
   necessary, stop writers again and restore the matching application files,
   database, RRDs and configuration together; copying old PHP files over an
   upgraded database is not a rollback.

[tasks]:<https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/schtasks-change>
[dump]:<https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html>
[robocopy]:<https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy>
[download]:<https://github.com/Cacti/cacti/releases/tag/release/1.2.31>

[supported-os]: Requirements.md#supported-operating-systems

---

Copyright (c) 2004-2026 The Cacti Group
