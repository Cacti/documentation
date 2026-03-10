# Security Hardening

## Overview

This document describes how to restrict access to sensitive Cacti directories
and files at the web server configuration level. Applying these restrictions at
the server level is more reliable than `.htaccess` files for several reasons:

- `.htaccess` files have no effect on Nginx, IIS, or Lighttpd.
- Even on Apache, `.htaccess` processing requires `AllowOverride` to be enabled,
  adds per-request overhead, and is disabled in many hardened configurations.
- Server-level blocks are evaluated before PHP runs and cannot be bypassed by
  application-level bugs.

The Apache documentation explicitly
[discourages `.htaccess` use](https://httpd.apache.org/docs/current/howto/htaccess.html)
except when the server configuration cannot be changed.

## Directories and Files to Protect

The following table summarises what should be blocked from direct web access.

| Path (relative to Cacti root) | Reason |
|---|---|
| `include/*.php` | PHP files contain database credentials and global config; the subdirectories `js/`, `themes/`, `fa/`, and `vendor/` serve static assets that browsers must be able to load |
| `scripts/` | Poller scripts; should not be web-accessible |
| `resource/` | SNMP query XML files; not web content |
| `log/` | Log files; may contain sensitive polling data |
| `rra/` | RRDtool data files; binary, not web content |
| `cache/` | Graph image cache; directory listing should be disabled |
| `install/` | Installation wizard; remove or block after first-run |

## Apache

Configure these restrictions inside the `<VirtualHost>` block for your Cacti
site. Set `AllowOverride None` on the Cacti root to disable `.htaccess`
processing entirely, then add explicit `<Directory>` blocks for what should be
accessible.

```apache
<VirtualHost *:443>
    ServerName cacti.example.com
    DocumentRoot /var/www/html/cacti

    # Disable .htaccess processing
    <Directory /var/www/html/cacti>
        AllowOverride None
        Require all granted
    </Directory>

    # Block direct access to PHP files within include/.
    # The subdirectories include/js/, include/themes/, include/fa/, and
    # include/vendor/ serve static assets that browsers must load; only
    # PHP execution is blocked here.
    <Directory /var/www/html/cacti/include>
        <FilesMatch "\.php$">
            Require all denied
        </FilesMatch>
    </Directory>

    # Block poller scripts
    <Directory /var/www/html/cacti/scripts>
        Require all denied
    </Directory>

    # Block SNMP query resource files
    <Directory /var/www/html/cacti/resource>
        Require all denied
    </Directory>

    # Block log files
    <Directory /var/www/html/cacti/log>
        Require all denied
    </Directory>

    # Block RRD data files
    <Directory /var/www/html/cacti/rra>
        Require all denied
    </Directory>

    # Block install wizard after installation is complete
    <Directory /var/www/html/cacti/install>
        Require all denied
    </Directory>

    # Disable directory listing on image cache; allow file access
    <Directory /var/www/html/cacti/cache>
        Options -Indexes
        Require all granted
    </Directory>

    # PHP configuration
    <FilesMatch "\.php$">
        SetHandler application/x-httpd-php
    </FilesMatch>

    # SSL configuration (adjust paths for your certificate)
    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/cacti.crt
    SSLCertificateKeyFile /etc/ssl/private/cacti.key
</VirtualHost>
```

After editing, test and reload:

```shell
apachectl configtest
systemctl reload apache2   # Debian/Ubuntu
systemctl reload httpd     # RHEL/Rocky/AlmaLinux
```

## Nginx

Add `location` blocks inside your `server` block to deny access to sensitive
paths before the PHP handler processes the request.

```nginx
server {
    listen 443 ssl;
    server_name cacti.example.com;
    root /usr/share/nginx/html/cacti;
    index index.php;

    ssl_certificate     /etc/ssl/certs/cacti.crt;
    ssl_certificate_key /etc/ssl/private/cacti.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305;
    ssl_prefer_server_ciphers on;

    # Block direct PHP file access within include/.
    # Static assets in include/js/, include/themes/, include/fa/, and
    # include/vendor/ are served normally.
    location ~* ^/include/[^/]*\.php$ {
        return 404;
    }

    # Deny access to fully non-web-accessible directories
    location ~* ^/(scripts|resource|log|rra|install)(/|$) {
        return 404;
    }

    # Disable directory listing on image cache
    location /cache/ {
        autoindex off;
    }

    # Pass PHP requests to FastCGI
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Block direct access to hidden files (.htaccess, .git, etc.)
    location ~ /\. {
        deny all;
    }
}
```

After editing, test and reload:

```shell
nginx -t
systemctl reload nginx
```

## IIS (Windows)

Use the IIS Manager or `web.config` to deny access to sensitive paths. Place
the following `web.config` file in the Cacti web root
(`C:\inetpub\wwwroot\cacti\web.config`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <system.webServer>
    <security>
      <requestFiltering>
        <!-- Block hidden files -->
        <hiddenSegments>
          <add segment="scripts" />
          <add segment="resource" />
          <add segment="log" />
          <add segment="rra" />
          <add segment="install" />
        </hiddenSegments>
      </requestFiltering>
    </security>

    <!-- Disable directory browsing on image cache -->
    <directoryBrowse enabled="false" />
  </system.webServer>

  <!-- Block PHP execution in include/ while allowing static assets
       (JS, CSS, themes, FontAwesome, vendor libraries) to be served. -->
  <location path="include">
    <system.webServer>
      <handlers accessPolicy="Read" />
    </system.webServer>
  </location>

  <location path="cache">
    <system.webServer>
      <directoryBrowse enabled="false" />
    </system.webServer>
  </location>
</configuration>
```

Alternatively, use `appcmd` from an elevated command prompt:

```batchfile
%windir%\system32\inetsrv\appcmd set config "Default Web Site/cacti" ^
  /section:requestFiltering ^
  /+hiddenSegments.[segment='scripts'] ^
  /+hiddenSegments.[segment='resource'] ^
  /+hiddenSegments.[segment='log'] ^
  /+hiddenSegments.[segment='rra'] ^
  /+hiddenSegments.[segment='install']

rem Block PHP execution in include/ separately (static assets must remain accessible)
%windir%\system32\inetsrv\appcmd set config "Default Web Site/cacti/include" ^
  /section:handlers /accessPolicy:Read
```

## Removing the Install Wizard

Once Cacti is installed, the `install/` directory is no longer needed and
represents an unnecessary attack surface. Remove it rather than relying on
access controls:

```shell
# Linux
rm -rf /var/www/html/cacti/install

# Windows
rd /s /q C:\inetpub\wwwroot\cacti\install
```

If you need to run the installer again (for example, when upgrading), restore
the directory from the Cacti distribution tarball before proceeding, then
remove it again when the upgrade is complete.

## Additional Hardening

- **PHP open_basedir**: Restrict PHP's file access to the Cacti directory and
  its RRD path. Add to your PHP configuration or `VirtualHost` / `server`
  block:

  ```ini
  php_admin_value open_basedir /var/www/html/cacti:/var/lib/cacti/rra:/tmp
  ```

- **File permissions**: Cacti's web-writable directories (`rra/`, `log/`,
  `cache/`) should be owned by the web server account and not world-writable.
  No PHP files in those directories should be executable.

- **SELinux / AppArmor**: See the installation guides for your distribution for
  the boolean and file context settings required to allow Cacti to function
  under MAC frameworks without disabling enforcement.

---

Copyright (c) 2004-2026 The Cacti Group
