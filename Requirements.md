# Requirements

This manual follows the unreleased Cacti 1.3 `develop` branch. Use the
[1.2.x manual][manual-12] for released Cacti 1.2 installations. Verify the
requirements of the exact revision or release you deploy; development
requirements can change.

## Supported operating systems

Platform guidance checked on 26 October 2026. Use the current security-updated
point release in a vendor-supported stable branch. The examples below target
these maintained operating systems; vendor OS support does not certify every
Cacti, PHP, database, or third-party binary combination.

| Operating system | Versions used for installation guidance | Lifecycle source |
| --- | --- | --- |
| RHEL | Current supported minor release of 9 or 10 | [Red Hat lifecycle][os-rhel] |
| Rocky Linux | Current minor release of 9 or 10 | [Rocky releases][os-rocky] |
| AlmaLinux | Current minor release of 9 or 10 | [AlmaLinux releases][os-alma] |
| Ubuntu Server | 24.04 LTS, 26.04 LTS, or 26.10 | [Ubuntu lifecycle][os-ubuntu] |
| Debian | 13 stable; 12 only with applicable Debian LTS coverage | [Debian lifecycle][os-debian] |
| FreeBSD | 14.5-RELEASE or 15.1-RELEASE, with current patches | [FreeBSD security support][os-freebsd] |
| Windows Server | 2022 or 2025, with current updates | [Server 2022][os-win22], [Server 2025][os-win25] |

Check the linked lifecycle information before deployment. LTS coverage can
exclude architectures or packages. Use a maintained PHP and database version
that also meets this Cacti branch's requirements. A supported OS with an
incompatible default PHP version is not ready for installation. Do not use a
beta OS or an expired point release for these procedures.

## Software Requirements

| Component | Development requirement or recommendation |
| --- | --- |
| Web server | PHP-capable Apache, nginx, or IIS FastCGI |
| PHP | PHP 8.3 or later in the PHP 8 series (`^8.3` in Composer) |
| Database | MySQL 8.4+ or MariaDB 10.11+ recommended by the installer |
| RRDtool | Version 1.5 or later |
| SNMP | Net-SNMP command-line tools for operations using external binaries |
| Spine | Optional; use a version compatible with Cacti and its runtime libraries |

The PHP requirement comes from the [dependency manifest][manifest] and
[runtime minimum][constants]. The database values are the branch's
[installer recommendations][checks], rather than a certification of every
vendor release. Check the actual server and extensions before installation.

### PHP extensions

Cacti checks the CLI and web PHP environments separately. Install the
extensions required by the selected revision's Composer manifest and lock file,
and satisfy the installer checks. The combined requirements include:

- `ctype`, `curl`, `date`, `dom`, `filter`, `gd`, `gmp`, `hash`, `intl`,
  `json`, `ldap`, `mbstring`, `mysqlnd`, `openssl`, `pcre`, `PDO`,
  `pdo_mysql`, `Phar`, `session`, `simplexml`, `sockets`, `spl`, `sqlite3`,
  `standard`, `xml`, and `zlib`.
- `posix` and CLI `pcntl` on Unix.
- `com_dotnet` for the Windows installer checks.

Some modules are built into PHP. Check `php -v`, `php --ini`, and `php -m` for
the CLI, then check web PHP through the installer. Enabling an extension in one
PHP configuration does not enable it in the other.

The PHP SNMP extension is optional. External Net-SNMP tools are still needed
for collection paths such as some SNMPv3 and bulk requests. Configure their
paths and verify execution under the actual web and collector accounts.

### Composer and source deployments

A source checkout or GitHub source archive needs its locked PHP dependencies.
Run these commands from the Cacti source root as the deployment owner:

```console
composer install --no-dev
composer check-platform-reqs --no-dev
```

Use `composer install`, which reads `composer.lock`. Do not run `composer
update` during installation or upgrade. A complete release bundle can already
contain `include/vendor/autoload.php`; verify its generated platform checks and
the release's instructions rather than assuming every archive contains vendor
files.

The current manifest requires `ext-pcntl` and `ext-posix` unconditionally.
Native Windows PHP cannot supply these modules. Source dependency installation
is therefore blocked on native Windows, even though the installer has
Windows-specific checks. A bundled artifact must also pass its runtime platform
check. See [Installing Under Windows][windows] before choosing a build. Do not
bypass platform checks to force installation.

## Hardware Sizing

Size from the polling interval, number of data sources, retention profiles,
concurrent graph requests, collector settings, and measured storage latency.
Device count alone is not a reliable sizing rule. Test representative polling
and graphing load before increasing the deployment.

Use storage that can sustain RRD updates and database writes within the polling
window. Measure CPU, memory, I/O latency, database connections, and poll
completion time. Remote collectors can distribute collection work; they also
require connectivity, synchronization, and operational monitoring. Spine
process and thread counts should be tuned against those measurements.

## Database configuration

Enable timezone support and grant the application account `SELECT` access to
`mysql.time_zone_name`. The grant does not populate that table. Import the
vendor's timezone data using the procedure for your operating system.

Use `utf8mb4` and the `utf8mb4_unicode_ci` collation consistently for the Cacti
database. Changing server defaults does not convert existing tables; back up
and plan any conversion of an installed database separately.

Start with the database vendor's defaults and review the installer's checks for
the installed engine and version. Do not copy a fixed `my.cnf` block from
another server. Size global buffers and per-connection buffers together with
PHP and operating-system memory. Estimate Spine's connection demand as:

```text
total_connections = total_processes * (total_threads + script_servers + 1)
```

Allow additional connections for web requests, plugins, and maintenance.
Inspect actual storage engines before applying memory-table sizing guidance.

Keep InnoDB doublewrite protection enabled. Disabling it removes protection
against incomplete page writes; an SSD alone does not establish atomic page
writes. Review the durability consequences before changing commit flushing or
other crash-recovery settings.

Database variables differ by engine and release. Removed settings can prevent
startup. For example, MySQL 8 no longer accepts `innodb_file_format`,
`innodb_large_prefix`, or `innodb_additional_mem_pool_size`, and MariaDB 10.6
removed `innodb_buffer_pool_instances`. Validate settings against the installed
server's documentation and Cacti's version-aware checks before restarting. See
the [MySQL reference][mysql] or [MariaDB reference][mariadb].

## Accounts and platform controls

Keep application code owned by the administrator or deployment account. Give
web and collector identities the read, execute, and runtime-directory write
access they need. Grant temporary installation or import access only to the
required paths, and remove it afterward. Keep database credentials, CSRF
secrets, private caches, RRD files, and backups inaccessible over HTTP.

Configure SELinux, AppArmor, container permissions, or IIS request filtering
for the required operations. Do not remove confinement globally to make
installation checks pass. Follow the platform installation guide and
[Hardening a Cacti Installation](Hardening-Cacti-Installation.md).

[manual-12]:<https://github.com/Cacti/documentation/tree/1.2.x>
[manifest]:<https://github.com/Cacti/cacti/blob/develop/composer.json>
[constants]:<https://github.com/Cacti/cacti/blob/develop/include/global_constants.php>
[checks]:<https://github.com/Cacti/cacti/blob/develop/lib/utility.php>
[windows]: Installing-Under-Windows.md#development-packaging-prerequisite
[mysql]:<https://dev.mysql.com/doc/refman/8.4/en/innodb-parameters.html>
[mariadb]:<https://mariadb.com/docs/server/server-usage/storage-engines/innodb/innodb-system-variables>

[os-rhel]:<https://access.redhat.com/support/policy/updates/errata>
[os-rocky]:<https://docs.rockylinux.org/releases/>
[os-alma]:<https://wiki.almalinux.org/release-notes/>
[os-ubuntu]:<https://ubuntu.com/about/release-cycle>
[os-debian]:<https://www.debian.org/releases/>
[os-freebsd]:<https://www.freebsd.org/security/>
[os-win22]:<https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2022>
[os-win25]:<https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2025>

---

Copyright (c) 2004-2026 The Cacti Group
