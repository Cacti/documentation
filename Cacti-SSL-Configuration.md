# Configuring SSL for Cacti

Enabling HTTPS for Cacti is done at the web server level. This page covers
self-signed certificates for internal use and Let's Encrypt for public-facing
servers.

> **Note**: If using multiple Data Collectors, all must have HTTPS enabled for
> the remote polling feature to work correctly.

## Self-Signed Certificate (Internal Use)

Self-signed certificates are suitable for internal networks where you control
the clients. Use ECDSA (secp384r1) for best performance, or RSA 4096 if your
environment requires RSA.

### ECDSA (recommended)

```shell
# RHEL/Rocky/AlmaLinux
dnf install -y mod_ssl

# Generate a 384-bit EC private key and self-signed certificate (valid 3 years)
openssl req -x509 -nodes -newkey ec -pkeyopt ec_paramgen_curve:P-384 \
    -keyout /etc/pki/tls/private/cacti.key \
    -out /etc/pki/tls/certs/cacti.crt \
    -days 1095 \
    -subj "/CN=cacti.example.com" \
    -addext "subjectAltName=DNS:cacti.example.com"

chmod 600 /etc/pki/tls/private/cacti.key
```

### RSA (alternative)

```shell
# 4096-bit RSA — use when EC is not supported by your TLS client pool
openssl req -x509 -nodes -newkey rsa:4096 \
    -keyout /etc/pki/tls/private/cacti.key \
    -out /etc/pki/tls/certs/cacti.crt \
    -days 1095 \
    -subj "/CN=cacti.example.com" \
    -addext "subjectAltName=DNS:cacti.example.com"

chmod 600 /etc/pki/tls/private/cacti.key
```

> **Key size**: RSA 2048-bit is below NIST SP 800-131A Rev 2 guidance for
> long-term use. Use 4096-bit RSA or an ECDSA key.

## Apache Configuration

Update `/etc/httpd/conf.d/ssl.conf` (RHEL/Rocky/AlmaLinux) or
`/etc/apache2/sites-available/cacti-ssl.conf` (Debian/Ubuntu):

```apache
<VirtualHost *:443>
    ServerName cacti.example.com
    DocumentRoot /var/www/html/cacti

    SSLEngine on
    # RHEL/Rocky/AlmaLinux cert paths:
    #   SSLCertificateFile    /etc/pki/tls/certs/cacti.crt
    #   SSLCertificateKeyFile /etc/pki/tls/private/cacti.key
    # Debian/Ubuntu cert paths:
    SSLCertificateFile    /etc/ssl/certs/cacti.crt
    SSLCertificateKeyFile /etc/ssl/private/cacti.key

    # Require TLS 1.2 or 1.3; TLS 1.0 and 1.1 are prohibited (RFC 8996)
    SSLProtocol           -all +TLSv1.2 +TLSv1.3

    # TLS 1.2 cipher suites -- no RC4, 3DES, or export ciphers
    SSLCipherSuite        ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:\
ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:\
ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305
    SSLHonorCipherOrder   on

    # TLS 1.3 cipher suites (SSLCipherSuite does not apply to TLS 1.3)
    SSLOpenSSLConfCmd     Ciphersuites TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256
</VirtualHost>

# Optional: redirect HTTP to HTTPS (uncomment to enable)
#<VirtualHost *:80>
#    ServerName cacti.example.com
#    Redirect permanent / https://cacti.example.com/
#</VirtualHost>
```

Restart Apache after editing:

```shell
apachectl configtest
systemctl restart httpd        # RHEL/Rocky/AlmaLinux
systemctl restart apache2      # Debian/Ubuntu
```

## Let's Encrypt (Public-Facing Servers)

For servers reachable from the internet, use Let's Encrypt for a
browser-trusted certificate at no cost.

### RHEL/Rocky/AlmaLinux

```shell
dnf install -y certbot python3-certbot-apache
certbot --apache -d cacti.example.com
```

### Debian/Ubuntu

```shell
apt-get install -y certbot python3-certbot-apache
certbot --apache -d cacti.example.com
```

Certbot configures Apache and sets up automatic renewal. Verify auto-renewal
works:

```shell
certbot renew --dry-run
```

## Verifying the Configuration

After restarting Apache, confirm TLS is working and that weak protocols are
disabled:

```shell
# Check the certificate and protocol support
openssl s_client -connect cacti.example.com:443 -tls1_2 < /dev/null
openssl s_client -connect cacti.example.com:443 -tls1   < /dev/null  # should fail
```

For a comprehensive scan, use [SSL Labs](https://www.ssllabs.com/ssltest/) on
public servers or `testssl.sh` on internal hosts:

```shell
# testssl.sh (download from https://testssl.sh/)
./testssl.sh cacti.example.com
```

---

Copyright (c) 2004-2026 The Cacti Group
