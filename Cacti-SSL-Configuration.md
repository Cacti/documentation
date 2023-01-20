# Configuring and enabling SSL for Cacti with a self signed certificate

Enabling SSL for Cacti is mostly done at the webserver level.
An example SSL config for Http is as follows:

```bash

yum install -y mod_ssl -y
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr
openssl x509 -req -days 700 -in ca.csr -signkey ca.key -out ca.crt
cp ca.crt /etc/pki/tls/certs
cp ca.key /etc/pki/tls/private/ca.key
cp ca.csr /etc/pki/tls/private/ca.csr

```

Then we need to update the Apache SSL configuration file:

```ini
vi +/SSLCertificateFile /etc/httpd/conf.d/ssl.conf
SSLCertificateFile /etc/pki/tls/certs/ca.crt
SSLCertificateKeyFile /etc/pki/tls/private/ca.key
```

Restart the httpd service:

systemctl restart httpd

After configuring the web server to accept https, you can enable https in the GUI

### Note, if using multiple pollers

all must have HTTPS enabled for the remote polling feature to work properly.

cacti-ssl

### Note: If your Cacti system is public

it is recommended to get a certificate from a trusted certificate provider.

Copyright (c) 2004-2023 The Cacti Group
