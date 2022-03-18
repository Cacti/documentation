# rrdproxy

Cacti RRD Proxy is a standalone proxy interface to Tobi Oetiker's great RRDtool.

The main focus of this project is to allow the relocation of RRDfiles, data
replication, support of Cacti Boost and, if needed, the RRDcached daemon. It
allows system administrators to split Cacti's access resources across machines
without the need for NFS.

Due the fact that updates to files may contain sensitive data and to prevent
undesired updates, RRDtool proxy utilitizes high encrypted connections (RSA2048
and AES192) with continuously changing keys.  This ensures a secured connection
between the proxy and registered clients and/or other proxies.

A local service port is provided to allow administrators are able to access a
separate command line interface which provides easy access to configure and
debug the proxy.

## Contribute

Get involved in development by participating in active development on
[GitHub](https://github.com/Cacti/rrdproxy/).

## Requirements

RRDproxy runs on any Unix-based operating system that can meet the minimum
requirements, though it will perform better with the recommended (or higher).

### Minimum Requirements

- PHP Version 7.1 or higher
  Installation must include and enable the following modules:

  - Sockets

  - Posix

  - PCntl

  - GMP

  - ZLIB

- RRDtool Version 1.5 or higher

- Cacti Version 1.2.7 or higher

### Recommended Requirements

All minimum requirements must be met, though the following are more optinal:

- PHP Version 7.3 or higher
  Include all minimum recommendation modules

- RRDtool 1.7 or higher

- Cacti 1.2.7

## Usage

Before using the RRDproxy, you must install the system using the setup wizard
which can be run at any point using the -w parameter.

```shell
 php rrdtool-proxy.php --help

 RRDtool Proxy v1.2.7
 Copyright (C) 2004-2022 The Cacti Group
 usage: rrdtool-proxy.php [--wizard] [-w] [--version] [-v]
 Optional:
 -v --version   - Display this help message
 -w --wizard    - Start Configuration Wizard
```

When running through the wizard, the status of items will appear on the right
hand side of the screen.  When an item is successfully completed, the status of
`[OK]` will be shown in green (when color is supported) as seen below:

```shell
Checking System Requirements...
[0.00001] test: operation system supported                                  [OK]
[0.00007] test: php module 'sockets'                                        [OK]
[0.00011] test: php module 'posix'                                          [OK]
```

Should any item have an issue, the status will be displayed as something other
than `[OK]` such as `[FAILED]`:

```shell
[0.40270] read: RRDproxy configuration file                             [FAILED]
```

Status Color | Description
: --- | : ---
Green | Success and without issue
Yellow | Warnings and will be ignored, correct the problem if needed
Red | Errors and will not be ignored, may prevent continuation

When the wziard prompts for the various settings that are available, you can
accept the default value simply by pressing return to accept it. Below are a few
of these settings and the default values that can be accepted:

Setting | Default | Comment
: --- | : --- | : ---
CLI System Prompt | rrdp | Max 8 chars
IPv4 Listen Addr | 0.0.0.0 | Listen all addr
Client Proxy Port | 40301 | Connections from a client
Proxy Proxy port | 40302 | Connections from another proxy
Dedicated CLI port | 40303 | Connections to the RRDproxy cli

## Command Line Interface

Use '?' to get a list of all commands being supported by the proxy or hints
about missing parameters.

```console
telnet localhost 40303
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
rrdp>?
  enable          Turn on privileged commands
  help            Display help
  show            Show running system information
  quit            Close terminal session

rrdp>ena
rrdp#sh version

#     ___           _   _     __    __    ___     ___
#    / __\__ _  ___| |_(_)   /__\  /__\  /   \   / _ \_ __ _____  ___   _
#   / /  / _` |/ __| __| |  / \// / \// / /\ /  / /_)/ '__/ _ \ \/ / | | |
#  / /__| (_| | (__| |_| | / _  \/ _  \/ /_//  / ___/| | | (_) >  <| |_| |
#  \____/\__,_|\___|\__|_| \/ \_/\/ \_/___,'   \/    |_|  \___/_/\_\__, |
#                                                                   |___/

 RRDtool Proxy v1.2.7
 Copyright (C) 2004-2022 The Cacti Group
 rrdp uptime is 14 days, 0 hours, 4 minutes, 14 seconds
 Memory usage 0.18872917 % (2026464/1073741824 in bytes)
 a8:29:6a:b7:5d:be:c3:8a:be:13:7a:61:ee:0c:8b:d3
 Process ID: 13996
 Session usage (1/399)

 Server IP [192.168.10.10]
 Administration: [localhost       :40303]
 Replication:    [192.168.10.10   :40302]
 Clients:        [192.168.10.10   :40301]

rrdp#
```

## Missing features

- Data replication has been completed to 95%, but is still not ready

- NET-SNMP pass persistent daemon and MIB needs to written to make proxy stats
  available through SNMP

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
