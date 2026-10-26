# Requirements

This manual covers released Cacti 1.2.31. Use maintained operating systems and
dependencies compatible with this release. Historical minimum-version checks
are not recommendations to install software that no longer receives security
updates. The development branch has [different requirements][development].

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

## Software requirements

| Component | Deployment guidance |
| --- | --- |
| Web server | Maintained PHP-capable Apache, nginx, or IIS FastCGI |
| PHP | A vendor-maintained PHP branch compatible with Cacti 1.2.31; validate CLI and web PHP with the installer |
| Database | A maintained MySQL or MariaDB branch; check the actual server with the installer |
| RRDtool | A maintained distribution package; version 1.5 or later is recommended by the release |
| SNMP | Net-SNMP command-line tools for the collection paths that require them |
| Spine | Optional; choose a release compatible with Cacti 1.2.31 |

Use the selected operating system's supported packages and their security
updates. Check the [PHP lifecycle][php-support], [MySQL
lifecycle][mysql-support], and [MariaDB maintenance policy][mariadb-support]
when choosing dependencies. Vendor maintenance alone does not establish
compatibility with every Cacti release or plugin. Test the intended combination
before production upgrades.

Cacti 1.2.31 ships its runtime libraries. Do not apply development-branch
Composer instructions or extension requirements to this release. A later source
revision may change packaging; use that revision's requirements.

## PHP configuration and extensions

The [released extension checks][extensions] cover CLI and web PHP separately.
Required modules include `ctype`, `date`, `filter`, `gettext`, `gd`, `gmp`,
`hash`, `json`, `ldap`, `mbstring`, `openssl`, `pcre`, `PDO`, `pdo_mysql`,
`session`, `simplexml`, `sockets`, `spl`, `standard`, `xml`, and `zlib`, with
`posix` on Unix and `com_dotnet` on Windows. The Unix polling daemon also needs
CLI PCNTL support for its forking service mode.

Check `php -v`, `php --ini`, and `php -m`, then inspect the web environment in
the installer. Modules built into PHP do not need an extra extension load. The
PHP SNMP extension is optional; external Net-SNMP tools are needed for
collection paths including SNMPv3 in the PHP poller. Configure executable paths
and verify them under the actual collector and web accounts.

## Database configuration

Create a dedicated application database and account. Use `utf8mb4` and
`utf8mb4_unicode_ci` consistently. Load timezone information and grant `SELECT`
on `mysql.time_zone_name`; the grant alone does not populate it.

Use the installer's version-aware recommendations and the database vendor's
configuration reference. Do not paste one `my.cnf` block onto every server.
Removed variables can prevent startup, and global or per-connection buffers can
exhaust memory when sized without accounting for concurrency.

Estimate Spine's connections as:

```text
total_connections = total_processes * (total_threads + script_servers + 1)
```

Allow headroom for web requests, plugins, maintenance, and other clients.
Inspect storage engines before sizing memory-table limits. Keep InnoDB
doublewrite protection enabled; storage advertised as SSD does not by itself
provide atomic page writes. Review durability before changing commit flushing,
and do not disable strict SQL modes as a setup shortcut.

Refer to the [MySQL configuration reference][mysql-variables] or
[MariaDB InnoDB reference][mariadb-variables] for the exact installed version.
For backups, pause writers and account for nontransactional tables as well as
RRD files; see [Upgrading Cacti](Upgrading-Cacti.md).

## Resources and permissions

Size CPU, RAM, storage, and database connections from representative polling
and graphing load. Account for data-source count, polling interval, retention,
collector threads, concurrent users, and storage latency. Device count alone is
not a capacity guarantee. Monitor polling duration and graph freshness.

Keep executable code owned by an administrator. Give web and collector accounts
access only to their required tools, configuration, and runtime paths. Restrict
temporary installation/import write permissions afterward. Keep credentials,
CSRF secrets, RRDs, private caches, and backups inaccessible over HTTP.
Configure platform security controls for the operations needed; do not disable
them globally to complete installation.

[development]:<https://github.com/Cacti/documentation/tree/develop>
[extensions]:<https://github.com/Cacti/cacti/blob/release/1.2.31/lib/utility.php>
[php-support]:<https://www.php.net/supported-versions.php>
[mysql-support]:<https://www.mysql.com/support/supportedplatforms/database.html>
[mariadb-support]:<https://mariadb.org/about/maintenance-policy/>
[mysql-variables]:<https://dev.mysql.com/doc/refman/8.4/en/innodb-parameters.html>
[mariadb-variables]:<https://mariadb.com/docs/server/server-usage/storage-engines/innodb/innodb-system-variables>
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
