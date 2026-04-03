# Hardening a Cacti Installation

This page covers OS-level hardening controls for a production Cacti host.
The goal is defense in depth: even if a vulnerability in Cacti's PHP code
is exploited, the attacker's reach should be limited.

## Why These Controls Matter

A recurring class of vulnerability in Cacti involves writing an arbitrary
file into the `resource/` or `scripts/` tree and then reaching that file
over the web.  The package-import advisory (GHSA-jj7m-3x5c-9xvr) is a
concrete example: a crafted package archive could write `resource/test.php`
and execute it as a web request.  The controls below close or limit that
path at the OS and web-server layers, independent of the PHP fix.

---

## 1. File Permissions

Cacti writes to three paths at runtime.  Everything else should be owned
by root (or a non-web user) and not writable by the web process.

| Path | Purpose | Recommended mode |
|------|---------|-----------------|
| `rra/` | RRDtool data files | `www-data:www-data 750` |
| `log/` | Cacti log files | `www-data:www-data 750` |
| `cache/` | Boost / poller cache | `www-data:www-data 750` |
| `resource/` | XML templates | `root:root 755` (read-only for web) |
| `scripts/` | Data-source scripts | `root:root 755` (read-only for web) |
| `lib/`, `include/` | PHP libraries | `root:root 755` |

Apply once after installation:

```bash
# Writable paths (web user only)
chown -R www-data:www-data /var/www/html/cacti/rra \
                           /var/www/html/cacti/log \
                           /var/www/html/cacti/cache
chmod -R 750              /var/www/html/cacti/rra \
                           /var/www/html/cacti/log \
                           /var/www/html/cacti/cache

# Everything else read-only for the web user
chown -R root:root         /var/www/html/cacti
chmod -R 755               /var/www/html/cacti
# Re-apply writable exceptions after the recursive chmod
chown -R www-data:www-data /var/www/html/cacti/rra \
                           /var/www/html/cacti/log \
                           /var/www/html/cacti/cache
```

> **Note:** The `scripts/` and `resource/` paths may be written during
> template import or package import by a privileged CLI process running
> as root, not by the web process.  If your workflow requires the web
> process to write there, use a strict code-review policy for any import
> and consider the compat profile instead.

---

## 2. Web Server — Block Direct Access to Scripts and Resources

PHP files inside `scripts/` and `resource/` must not be reachable via HTTP.
These directories hold data-source scripts and XML templates; a web request
to a `.php` file written there is the direct exploitation path.

### Apache

Add inside your Cacti `<VirtualHost>` or `.htaccess`:

```apache
# Deny direct HTTP access to the script and resource trees.
# A PHP file written here via import cannot be reached over the web.
<DirectoryMatch "^/var/www/html/cacti/(scripts|resource)/">
    <FilesMatch "\.php$">
        Require all denied
    </FilesMatch>
</DirectoryMatch>
```

Or, more broadly, deny all non-XML/non-script files from direct access:

```apache
<Directory "/var/www/html/cacti/scripts">
    Require all denied
</Directory>

<Directory "/var/www/html/cacti/resource">
    <FilesMatch "\.php$">
        Require all denied
    </FilesMatch>
</Directory>
```

### Nginx

Add inside your `server {}` block:

```nginx
# Block PHP execution in scripts/ and resource/
location ~ ^/cacti/(scripts|resource)/.*\.php$ {
    return 403;
}
```

---

## 3. PHP-FPM Pool Hardening

PHP itself warns that php-fpm pools are not a true security boundary, but
they provide useful knobs.  Create a dedicated pool for Cacti
(`/etc/php/8.x/fpm/pool.d/cacti.conf`):

```ini
[cacti]
user  = www-data
group = www-data

listen = /run/php/php-cacti.sock
listen.owner = www-data
listen.group = www-data

; Drop all inherited environment variables — pass only what Cacti needs.
clear_env = yes

; Only execute .php files — blocks .phtml, .php3, .phar, etc.
security.limit_extensions = .php

; Disable dangerous functions at the pool level (not overridable by ini_set).
php_admin_value[disable_functions] = exec,passthru,shell_exec,system,popen,proc_open,pcntl_exec

; Restrict file operations to the Cacti tree.
; NOTE: open_basedir disables the PHP realpath cache.  Measure the
; performance impact before enabling in production.  It is an extra
; safety net, not a full security boundary (PHP documentation).
; php_admin_value[open_basedir] = /var/www/html/cacti:/tmp

; Suppress PHP version disclosure.
php_admin_flag[expose_php] = Off
```

Reload php-fpm after changes:

```bash
systemctl reload php8.x-fpm   # Debian/Ubuntu
systemctl reload php-fpm       # RHEL/Rocky/Alma
```

---

## 4. SELinux (RHEL / AlmaLinux / Rocky Linux)

SELinux ships enforcing on RHEL-family systems.  These commands apply
the correct file contexts so Apache can serve Cacti while limiting what
the web process can write.

### File Contexts

```bash
CACTI=/var/www/html/cacti

# Read-only web content (Apache can read, not write)
semanage fcontext -a -t httpd_sys_content_t      "${CACTI}(/.*)?"
semanage fcontext -a -t httpd_sys_content_t      "${CACTI}/scripts(/.*)?"
semanage fcontext -a -t httpd_sys_content_t      "${CACTI}/resource(/.*)?"

# Read-write content for runtime paths only
semanage fcontext -a -t httpd_sys_rw_content_t   "${CACTI}/rra(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t   "${CACTI}/log(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t   "${CACTI}/cache(/.*)?"

# Apply the contexts
restorecon -Rv "${CACTI}"
```

### Database Network Access

If your database server is reached over TCP (not a local Unix socket),
enable the SELinux boolean that permits it:

```bash
setsebool -P httpd_can_network_connect_db on
```

### Poller Systemd Drop-in

The Cacti spine poller runs as a separate process and may need to connect
outward for SNMP.  Add a drop-in under
`/etc/systemd/system/cactid.service.d/selinux.conf`:

```ini
[Service]
# Allow spine to connect to arbitrary network hosts for SNMP polling.
SELinuxContext=system_u:system_r:httpd_t:s0
```

Run `systemctl daemon-reload && systemctl restart cactid` after changes.

> **Verify:** After applying contexts, confirm Apache can still serve pages
> and the poller can poll.  Use `audit2why` on any AVC denials in
> `/var/log/audit/audit.log`.

---

## 5. AppArmor (Debian / Ubuntu)

Ubuntu Server ships AppArmor enforcing by default.  Create a profile for
the Cacti php-fpm pool at `/etc/apparmor.d/cacti-fpm`:

```
#include <tunables/global>

profile cacti-fpm /usr/sbin/php-fpm* {
    #include <abstractions/base>
    #include <abstractions/php>
    #include <abstractions/mysql>

    # Cacti tree — read-only by default
    /var/www/html/cacti/           r,
    /var/www/html/cacti/**         r,

    # Allow execution of Cacti PHP files
    /var/www/html/cacti/*.php      r,
    /var/www/html/cacti/**/*.php   r,

    # Runtime write paths
    /var/www/html/cacti/rra/**     rw,
    /var/www/html/cacti/log/**     rw,
    /var/www/html/cacti/cache/**   rw,

    # Temp files
    /tmp/**                        rw,
    /var/tmp/**                    rw,

    # Deny write to scripts/ and resource/
    deny /var/www/html/cacti/scripts/**  w,
    deny /var/www/html/cacti/resource/** w,
}
```

Load and enforce the profile:

```bash
apparmor_parser -r /etc/apparmor.d/cacti-fpm
aa-enforce /etc/apparmor.d/cacti-fpm
```

### Attach the Profile to the php-fpm Service

Add a drop-in at `/etc/systemd/system/php8.x-fpm.service.d/apparmor.conf`:

```ini
[Service]
AppArmorProfile=cacti-fpm
```

Reload and restart:

```bash
systemctl daemon-reload
systemctl restart php8.x-fpm
```

Use complain mode (`aa-complain`) first to test without blocking, then
switch to enforce once logs show no legitimate denials:

```bash
# Test mode
aa-complain /etc/apparmor.d/cacti-fpm

# Enforce when ready
aa-enforce  /etc/apparmor.d/cacti-fpm
```

---

## 6. Verification Checklist

After applying all controls, confirm:

- [ ] `curl -s http://localhost/cacti/scripts/ss_webseer.php` returns 403
- [ ] `curl -s http://localhost/cacti/resource/` returns 403 for any `.php` inside
- [ ] The Cacti web UI loads and graphs render (rra/ is writable)
- [ ] The poller runs without errors (`tail -f /var/www/html/cacti/log/cacti.log`)
- [ ] On RHEL: no AVC denials in `ausearch -m avc -ts recent`
- [ ] On Debian/Ubuntu: no AppArmor denials in `journalctl -k | grep apparmor`

---

## See Also

- [Installing Under Ubuntu/Debian](Installing-Under-Ubuntu-Debian.md)
- [Installing Under CentOS (LAMP)](Install-Under-CentOS_LAMP.md)
- [Standards Security](Standards-Security.md)
