# Install and operate Cacti on Linux

This guide replaces the archived Linux how-to for new installations. It uses
Cacti 1.3 development documentation, not a released Cacti manual. Use the
[1.2.x manual][stable] for released Cacti 1.2 installations. The downloadable
edition includes the complete linked installation and operating chapters.

## Choose an installation path

Read [Requirements](../../Requirements.md) before installing software. Choose
[Enterprise Linux with Apache](../../Install-Under-Enterprise-Linux-LAMP.md),
[Enterprise Linux with nginx](../../Install-Under-Enterprise-Linux-LEMP.md),
[Ubuntu/Debian with Apache](../../Installing-Under-Ubuntu-Debian.md), or
[Ubuntu with nginx](../../Installing-Under-Ubuntu-LEMP.md). Do not combine
package names, PHP handlers, or service configuration from different guides.

Install a supported OS with current security updates. Source deployments need
Composer dependencies from the committed lock file. Check CLI and web PHP
separately. Keep deployment ownership separate from runtime write permissions.
Import the bundled schema only into a new database; existing installations
use the upgrade procedure.

## Complete and verify the installation

Follow [General Installing
Instructions](../../General-Installing-Instructions.md)
for database permissions, configuration, runtime directories, and scheduling.
Use one poller schedule with the intended account and absolute paths. Complete
the web installer over restricted HTTPS access and change initial credentials.
[Spine](../../Spine.md) is optional and must match the Cacti version.

Add a device, confirm its SNMP settings, create graphs, and wait several
polling
intervals. Follow [How to Graph Your
Network](../../How-to-Graph-Your-Network.md).

![Example graph with populated historical data](../../images/graphs-edit.png)

The screenshot shows historical example measurements and an earlier interface.

## Maintain the installation

Use [Data Debugging](../../Data-Debug.md) and [Debugging](../../Debugging.md)
before changing configuration or data. Check clocks, PHP environments, service
status, executable paths, permissions, and logs. Scope detailed logging to the
problem and restore normal logging afterward. Do not delete RRD files or
reinitialize the database to diagnose a blank graph.

Apply [hardening](../../Hardening-Cacti-Installation.md) before opening access.
Before an [upgrade](../../Upgrading-Cacti.md), back up the database, RRD files,
configuration, plugins, external data paths, and schedules. Verify restoration
and test the upgrade separately. Avoid overlapping scheduled and manual
pollers.

[stable]: https://github.com/Cacti/documentation/blob/1.2.x/README.md

---

Copyright (c) 2004-2026 The Cacti Group
