# Proxmox - external storage usage

The Linux template is used for Proxmox, it allows you to create disk usage graphs.
However, this is not always possible with external storage.

You can check the usage of volumes on external storage with the `pvesm status` command.

Here are instructions on how to get this value into SNMP and use it in Cacti.

We will work with volumes named alletra-lvm and local
```console
pvesm status
Name               Type     Status           Total            Used       Available        %
alletra-lvm         lvm     active     10737401856      1927315456      8810086400   17.95%
local               dir     active        98497780        23395264        70052968   23.75%
```

```console
apt-get install sudo
```

Run `visudo` and add line
```console
Debian-snmp ALL=(ALL) NOPASSWD: /usr/sbin/pvesm status
```

Modify file `/etc/systemd/system/multi-user.target.wants/snmpd.service`, 
add these lines to the service section:
```console
ProtectSystem=off
ProtectHome=off
PrivateTmp=false
```

Create new shell script `/usr/local/bin/monitoring.sh`:
```console
#!/bin/bash

STORAGE="$1"

/usr/bin/sudo /usr/sbin/pvesm status | /usr/bin/awk -v lv="$STORAGE" '$1==lv {gsub("%","",$NF); print $NF}'
```

Make it executable:
`chmod 755 /usr/local/bin/monitoring.sh`

Add these lines to `/etc/snmp/snmpd.conf`. Alletra-lvm and local are from `pvesm status`:
```console
extend-sh alletra-lvm /usr/local/bin/monitoring.sh alletra-lvm
extend-sh local /usr/local/bin/monitoring.sh local
```

Restart snmpd:
```console
systemctl daemon-reload
systemctl restart snmpd
```

Now we can check if data are in snmp:
```console
snmpwalk -v2c -c your_community -On  localhost .1.3.6.1.4.1.8072.1.3 
.1.3.6.1.4.1.8072.1.3.2.1.0 = INTEGER: 2
.1.3.6.1.4.1.8072.1.3.2.2.1.2.5.108.111.99.97.108 = STRING: "/usr/local/bin/monitoring.sh"
.1.3.6.1.4.1.8072.1.3.2.2.1.2.11.97.108.108.101.116.114.97.45.108.118.109 = STRING: "/usr/local/bin/monitoring.sh"
.1.3.6.1.4.1.8072.1.3.2.2.1.3.5.108.111.99.97.108 = STRING: "local"
.1.3.6.1.4.1.8072.1.3.2.2.1.3.11.97.108.108.101.116.114.97.45.108.118.109 = STRING: "alletra-lvm"
.1.3.6.1.4.1.8072.1.3.2.2.1.4.5.108.111.99.97.108 = ""
.1.3.6.1.4.1.8072.1.3.2.2.1.4.11.97.108.108.101.116.114.97.45.108.118.109 = ""
.1.3.6.1.4.1.8072.1.3.2.2.1.5.5.108.111.99.97.108 = INTEGER: 5
.1.3.6.1.4.1.8072.1.3.2.2.1.5.11.97.108.108.101.116.114.97.45.108.118.109 = INTEGER: 5
.1.3.6.1.4.1.8072.1.3.2.2.1.6.5.108.111.99.97.108 = INTEGER: 2
.1.3.6.1.4.1.8072.1.3.2.2.1.6.11.97.108.108.101.116.114.97.45.108.118.109 = INTEGER: 2
.1.3.6.1.4.1.8072.1.3.2.2.1.7.5.108.111.99.97.108 = INTEGER: 1
.1.3.6.1.4.1.8072.1.3.2.2.1.7.11.97.108.108.101.116.114.97.45.108.118.109 = INTEGER: 1
.1.3.6.1.4.1.8072.1.3.2.2.1.20.5.108.111.99.97.108 = INTEGER: 4
.1.3.6.1.4.1.8072.1.3.2.2.1.20.11.97.108.108.101.116.114.97.45.108.118.109 = INTEGER: 4
.1.3.6.1.4.1.8072.1.3.2.2.1.21.5.108.111.99.97.108 = INTEGER: 1
.1.3.6.1.4.1.8072.1.3.2.2.1.21.11.97.108.108.101.116.114.97.45.108.118.109 = INTEGER: 1
.1.3.6.1.4.1.8072.1.3.2.3.1.1.5.108.111.99.97.108 = STRING: "23.75"
.1.3.6.1.4.1.8072.1.3.2.3.1.1.11.97.108.108.101.116.114.97.45.108.118.109 = STRING: "17.95"
.1.3.6.1.4.1.8072.1.3.2.3.1.2.5.108.111.99.97.108 = STRING: "23.75"
.1.3.6.1.4.1.8072.1.3.2.3.1.2.11.97.108.108.101.116.114.97.45.108.118.109 = STRING: "17.95"
.1.3.6.1.4.1.8072.1.3.2.3.1.3.5.108.111.99.97.108 = INTEGER: 1
```

These OIDs contain requested information. OID depends on names used in snmpd.conf:
```console
.1.3.6.1.4.1.8072.1.3.2.3.1.1.5.108.111.99.97.108 = STRING: "23.75"
.1.3.6.1.4.1.8072.1.3.2.3.1.1.11.97.108.108.101.116.114.97.45.108.118.109 = STRING: "17.95"
```

We can graph these OIDs with SNMP - generic OID template (Graph-a-Single-SNMP-OID.md)

---

Copyright (c) 2004-2026 The Cacti Group
