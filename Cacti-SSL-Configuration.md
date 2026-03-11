# Configuring and enabling SSL for Cacti with a self-signed certificate

Enabling SSL for Cacti is done at the web server level. An example HTTPS
configuration for Apache is as follows:

```bash
yum install -y mod_ssl
openssl genrsa -out ca.key 4096
openssl req -new -key ca.key -out ca.csr
openssl x509 -req -days 700 -in ca.csr -signkey ca.key -out ca.crt
cp ca.crt /etc/pki/tls/certs
cp ca.key /etc/pki/tls/private/ca.key
cp ca.csr /etc/pki/tls/private/ca.csr
```

> **Note on key size**: A 4096-bit RSA key is used above. NIST SP 800-57
> recommends a minimum of 3072 bits for RSA keys through 2030. 2048-bit keys
> are below that threshold and should not be used for new certificates.

Then we need to update the Apache SSL configuration file:

```ini
vi +/SSLCertificateFile /etc/httpd/conf.d/ssl.conf
SSLCertificateFile /etc/pki/tls/certs/ca.crt
SSLCertificateKeyFile /etc/pki/tls/private/ca.key
```

Restart the httpd service:

```bash
systemctl restart httpd
```

After configuring the web server to accept HTTPS, you can enable HTTPS in the
GUI.

> **Note for public-facing servers**: Instead of a self-signed certificate,
> use a certificate from a trusted CA. [Certbot](https://certbot.eff.org/)
> from Let's Encrypt provides free, automatically-renewed certificates and
> is the recommended approach for any internet-accessible Cacti instance.

---

**Note**: if using multiple pollers, all must have HTTPS enabled for the remote polling feature to work properly.

---

Copyright (c) 2004-2026 The Cacti Group
