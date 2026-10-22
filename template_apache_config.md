# Apache Template Config

The Apache webserver template collects server statistics over HTTP using
Apache's `mod_status` module. These examples configure local access to the
machine-readable `/server-status?auto` endpoint. See the
[Apache mod_status documentation][mod-status] for the available statistics.

![apache template view](images/apache-template-preview.png)

## CentOS/RedHat Specific Configuration

For Centos/Redhat implementations the config will look as follows

Place the below config in /etc/httpd/conf/httpd.conf

```console
LoadModule status_module modules/mod_status.so
ExtendedStatus On

<Location /server-status>
    SetHandler server-status
    Require local
</Location>
```

## Debian Specific Configuration

Configure the Apache `status` module:

Place the below config into a new file (eg, 80-server-status.conf) within
`/etc/apache2/conf-available`

```apache
ExtendedStatus On

<Location /server-status>
    SetHandler server-status
    Require local
</Location>
```

Run the following commands with administrator privileges to enable the module
and configuration. Check the syntax, then restart Apache only if the check
succeeds:

```bash
a2enmod status
a2enconf 80-server-status
apache2ctl configtest && systemctl restart apache2
```

**Note**: This configuration restricts the `/server-status` url to local access
only via the `Require local` directive

[mod-status]: <https://httpd.apache.org/docs/2.4/mod/mod_status.html>

---

Copyright (c) 2004-2026 The Cacti Group
