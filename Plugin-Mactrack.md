# MacTrack

The MacTrack plugin is designed to scan network switches, routers and
intelligent hubs for connected devices, and record their location either based
upon the port name or alias of the switch or hub. It also attempts to discover
the IP address of the MAC address from the routers included in the MacTrack
database. MacTrack can also use arpwatch to gather IP to MAC address
associations.

MacTrack has the ability to also notify admins or security personnel when the
MAC address of a missing or stolen computer re-appears on the network. This can
be helpful in recovering lost equipment. Through MacTrack's interface
monitoring feature, a Network Administrator can get a very good idea of where
utilization is, where there are errors, etc. within their network.

MacTrack requires Cacti 1.2.29 or later and PHP 8.2.

This how-to refers to the menu item "Mactrack" or "Mactrack tab". In older
versions it is called "Device tracking".

## Requirements

- This page documents MacTrack 5.0 (release tag `v5.0`), the latest published
  release for Cacti 1.2.x.

- Cacti 1.2.29 or later, from the plugin's `INFO` file, and PHP 8.2, from the
  release README.

- No other plugin is required.

- The DNS resolver, Net_DNS2, ships with the plugin under `Net/`, so nothing
  else needs to be installed for reverse DNS lookups.

- The **Refresh IEEE Vendor MAC/OUI Database** utility downloads the OUI
  database from the IEEE web site. Without Internet access, import the file
  by hand as described below.

- ArpWatch support is optional and reads an ArpWatch database file on the
  Cacti server.

## Installation

Install MacTrack with the generic steps in
[Plugin Management](Plugins.md): place the release in Cacti's `plugins`
directory, rename the directory to `mactrack`, then install and enable it in
**Console > Configuration > Plugins**.

Scanning is off after installation. The **Scanning Frequency** setting
defaults to **Disabled**, so choose a frequency in the **Mactrack** settings
tab before expecting results.

## Permissions

MacTrack registers two realms.

###### Table 1. MacTrack realms

| Realm                      | Pages                                                                                                                                                                                                 |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Mactrack Viewer**        | `mactrack_view_dashboard.php`, `mactrack_view_ips.php`, `mactrack_view_arp.php`, `mactrack_view_macs.php`, `mactrack_view_dot1x.php`, `mactrack_view_sites.php`, `mactrack_view_devices.php`, `mactrack_view_interfaces.php`, `mactrack_view_graphs.php`, `mactrack_ajax.php` |
| **Mactrack Administrator** | `mactrack_ajax_admin.php`, `mactrack_devices.php`, `mactrack_snmp.php`, `mactrack_sites.php`, `mactrack_device_types.php`, `mactrack_utilities.php`, `mactrack_macwatch.php`, `mactrack_macauth.php`, `mactrack_vendormacs.php` |

**Mactrack Viewer** gives access to the **MacTrack** tab. **Mactrack
Administrator** gives access to the **Mactrack** and **Mactrack Tools**
sections of the Console.

## Settings

Most settings are in the **Mactrack** tab of **Console > Configuration >
Settings**. The tab has these sections: **General Settings**, **DNS
Settings**, **Notification Settings**, **Mactrack ArpWatch Settings** and
**SNMP Presets**. The settings an administrator must decide on are listed
below; the rest are described in the interface.

###### Table 2. Main MacTrack settings

| Label                                                   | Default          | Purpose                                                                                                   |
| ------------------------------------------------------- | ---------------- | --------------------------------------------------------------------------------------------------------- |
| **Scanning Frequency**                                  | Disabled         | When to collect MAC and IP addresses and interface statistics, from every 5 minutes to every day          |
| **Concurrent Processes**                                | 7                | How many devices are polled at the same time                                                              |
| **Scanner Max Runtime**                                 | 20               | Minutes a scanning function may run before it is assumed to have completed                                |
| **Start Time for Data Collection**                      | 1:00am           | Time of the first collection; later collections are based on it                                           |
| **Database Maintenance Time**                           | 12:00am          | Time of the daily database maintenance                                                                    |
| **Data Retention**                                      | 14 Days          | How long port MAC details are kept                                                                        |
| **Data Retention IPs**                                  | 3 Days           | How long discovered IP details are kept                                                                   |
| **Port and IP Address Partition Size**                  | Weekly           | Partition size of the port and IP tables, or **Disabled** for unpartitioned tables                         |
| **Ports to Ignore While Scanning (Regular Expression)** | Empty            | Ports whose name or alias matches are not used for MAC collection                                          |
| **Mac Address Output Format**                           | `aa:bb:cc:dd:ee:ff` | Format used for display                                                                                |
| **Perform Reverse DNS Name Resolution**                 | Unchecked        | Look up the DNS names of the IP addresses found on ports                                                   |
| **Enable ArpWatch**                                     | Unchecked        | Use ArpWatch data to supplement MAC to IP and DNS resolution                                               |
| **MacAuth Report Frequency**                            | Disabled         | How often the MacAuth reports are Emailed                                                                  |
| **Update Policy for SNMP Options**                      | None             | Whether Cacti device and MacTrack device SNMP settings are synchronized                                    |

MacTrack also adds:

- **snmpbulkwalk Binary Path** to the **Paths** tab.

- **Internet Proxy Address**, **Internet Proxy User** and **Internet Proxy
  Password** to the **Mail/Reporting/DNS** tab, for Internet access through a
  proxy.

- A **Default Tab** user setting, default **Sites**, under **MacTrack
  Settings** in each user's graph settings.

## Mactrack setup

- Check default settings
  Configuration -> Settings -> Mactrack tab (or Device tracking in older
  version)

- Create sites (mandatory)
  At this moment Mactrack's sites have no relation to Cacti's sites

- Define Device Types (mandatory)
  Several device types are provided as an example with the current version.
  Devices without a device type match will not be processed

- Import IEEE OUI Database (optional)
  Define SNMP set options to use

## Create site

One of the mandatory steps to start setting Mactrack up is to create sites
where we are going to allocate our Mactrack devices.
Console -> Mactrack -> Sites
You need add devices to site. You can import some existing Cacti devices into
Mactrack or add devices manually on Console -> Mactrack -> Devices

## Device types

Device Types

Console -> Mactrack (Device Tracking in previous versions) -> Device Types
menu

Create as many device types as you need, following these instructions.

**Description** - give this device type a meaningful description

**Vendor** - fill in the name for the vendor of this device type

**Device Type** - choose the type of device. What kind of device is it?
Meaning that some scanning functions will be available for some of these types
only. E.g., if you set a switch/hub as "Switch/Router" you will then be able to
pick an IP scanning function up when the device doesn't really support it.

**System Description Match** - provide key information to help Device
Tracking detect the type of device. The wildcard character is the * sign.
When you open a device in Cacti, you normally see the following on top of the
page.

```text
System: Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 12.2(53)SE2, RELEASE SOFTWARE (fc3)Technical Support: http://www.cisco.com/techsupportCopyright (c) 1986-2010 by Cisco Systems, Inc.Compiled Wed 21-Apr-10 05:52 by prod_rel_team
Uptime: 3176562306
Hostname: myswitch101.com
ObjectID: .1.3.6.1.4.1.9.1.696
```

What you want to make Mactrack look at is something like "C2960" which quickly
identify the hardware platform. Don't waste your time trying to match something
different or more complex like "12.2(53)SE2".

**Vendor SNMP Object ID Match** - this is the SNMP OID on this format:
.1.3.6.1.4.1.9.1.696

**MAC Address Scanning Function** - we assume you know what you are looking
for here. This function should only be set to switches L2/L3 and not Routers.

**IP Address Scanning Function** - this function allows you to look at the ARP
table and map IP vs MAC. There is a special function for Cisco devices called
get_cisco_dhcpsnooping_table that will look at the DHCP Snooping table for
switches if enabled.

**802.1x Scanning Function** - this scanning function was introduced in
version 4.2 and is only for Cisco devices.

**Serial Number Base OID** - this isn't mandatory but you can specify the SNMP
OID to find the serial number to the device.

**Serial Number Collection Method** - how is the serial number collected for
this OID. If 'SNMP Walk', we assume multiple serial numbers. If 'Get', it will
be only one.

**Low User Port Number** - provide the low user port number on this switch.
Leave 0 to allow the system to calculate it. Empty assumes 0

**High User Port Number** - provide the high user port number on this switch.
Leave 0 to allow the system to calculate it. Empty assumes 0

The export device types option allows you to export the existing device types
to CSV format so you can later import them onto new installations,
share them, or just back them up.
Go to Console -> Mactrack -> Device Types and click the export button.
To import Device Types, use the "Import" button on the same page.

## Import OUI Database from IEEE

This function will download and install the latest OUI database from the
IEEE website. Each Network Interface Card (NIC) has a MAC Address.
The MAC Address can be broken into two parts. The first part of the MAC Address
contains the Vendor MAC. The Vendor MAC identifies who has manufactured the
part. This will be helpful to check for rogue devices on your network.

Go to Mactrack Tools -> Tracking Utilities and click on **Refresh IEEE Vendor
MAC/OUI Database**

This option requires Internet access, so if for some reason your server cannot
access the Internet, you can manually download the file from the OUI Database,
copy it to your Cacti server, and import it by hand as follows.

Go to `<cacti_path>/plugins/mactrack`

Assuming that you have copied the file to /tmp

```console
[root@mycactiserver mactrack]#php mactrack_import_ouidb.php -f=/tmp/out.txt
Getting OUI Database from the IEEE
OUI Database Download from IEEE Complete
........................
There were '23126' Entries Added/Updated in the database.
There were '0' Records Removed from the database.
```

## History partitioning and ignored ports

MacTrack keeps its MAC address, IP address and 802.1x history in the
`mac_track_ports`, `mac_track_ips` and `mac_track_dot1x` tables. New installs
partition them by scan date where MySQL 8.0 or later, or MariaDB with
partitioning, allows it; existing installs are rebuilt with
`cli/upgrade_partitioning.php` or from the MacTrack utilities. Ports that carry
many MAC addresses, such as uplinks, can be kept out of the collected data with
the Ports to Ignore settings. See the README at
[plugin_mactrack](https://github.com/Cacti/plugin_mactrack#readme) for the
partitioning procedure and the other command-line scripts.

## Using MacTrack

Users with the **Mactrack Viewer** realm see a **MacTrack** tab at the top of
the page. It has these tabs: **Dashboard**, **Sites**, **Devices**,
**Interfaces**, **IP Ranges**, **IP Addresses**, **MAC Addresses**, **Dot1x**
and **Graphs**. Each tab has a filter, and the list tabs can **Export** the
filtered list. Each user picks the tab that opens first with the **Default
Tab** user setting.

The **Devices** tab lists the scanned devices with their site, status, device
type, port counts, active MAC addresses, VLAN count and last scan duration. The
line below the list shows the scanning rate, status and next run time.

![MacTrack Devices tab listing three test switches and routers at one site with
port and MAC counts](images/plugin-mactrack-devices.png)

The **MAC Addresses** tab is the MAC to IP report. It shows where each MAC
address was found: site, switch, port number and name, VLAN, IP address and
vendor, and whether the address is authorized.

![MacTrack MAC Addresses tab listing six test MAC addresses with their
switch ports, VLANs and authorization state](images/plugin-mactrack-macs.png)

Administrators with the **Mactrack Administrator** realm configure MacTrack
from the Console:

- **Console > Mactrack**: **Sites**, **Devices**, **SNMP Options**, **Device
  Types** and **Vendor Macs**

- **Console > Mactrack Tools**: **Mac Watch**, **Mac Authorizations** and
  **Tracking Utilities**

To find where a MAC address is connected:

1. Open the **MacTrack** tab and select **MAC Addresses**.

2. Choose the **Site**, enter the address in the **MAC** filter and press
   **Go**.

3. Read the **Switch Name**, **Port Number** and **Port Name** columns.

**Mac Watch** entries Email a notification when a watched MAC address is
found. The body is set by the **MacWatch Default Body** setting, which can use
the `<MAC>`, `<IP>`, `<TICKET>`, `<SITENAME>`, `<DEVICENAME>`, `<DEVICEIP>`,
`<PORTNUMBER>` and `<PORTNAME>` placeholders.

## Background Processing

MacTrack uses Cacti's `poller_bottom` hook. After each Cacti polling cycle it
starts `poller_mactrack.php` in the background. When a scan is due according
to **Scanning Frequency** and **Start Time for Data Collection**, the poller
starts one `mactrack_scanner.php` process per device, up to **Concurrent
Processes** at a time, and `mactrack_resolver.php` for IP and DNS resolution.

Once a day, at **Database Maintenance Time**, MacTrack removes history older
than **Data Retention** and **Data Retention IPs**. The tables that grow are
the port, IP address and 802.1x history tables named above.

## Command-Line Tools

Run these scripts from the `plugins/mactrack` directory as the user that runs
the Cacti poller.

`poller_mactrack.php` runs a collection:

```console
php poller_mactrack.php [-sid=site_id] [--web] [--force] [--debug]
```

- `-sid=site_id`: the MacTrack site to scan

- `-w` or `--web`: display output suitable for the web

- `-f` or `--force`: force the execution of a collection process

- `-d` or `--debug`: display verbose output during execution

`mactrack_scanner.php` scans one device:

```console
php mactrack_scanner.php -id=host_id [-w] [-d] [-t]
```

- `-id=host_id`: the MacTrack device to scan

- `-d` or `--debug`: display verbose output during execution

- `-w` or `--web`: display web compatible output

- `-t`: test mode, which does not log a process id

`mactrack_resolver.php` resolves IP addresses and DNS names for a site:

```console
php mactrack_resolver.php [-sid=ID] [-d]
```

`mactrack_import_ouidb.php` imports the IEEE OUI database. With `-f=file` it
imports a file that was downloaded by hand.

`cli/upgrade_database.php` runs the MacTrack database upgrade. It normally
starts by itself when a Console page detects a pending upgrade.

```console
php cli/upgrade_database.php [--debug] [--force]
```

`cli/upgrade_partitioning.php` checks and rebuilds the partitioning of the
port and IP address tables. Without `--partition`, it uses the **Port and IP
Address Partition Size** setting. Scans are paused and MAC and IP address
searches show a maintenance message until it finishes, which can take hours on
a large history.

```console
php cli/upgrade_partitioning.php [--partition=daily|weekly|disabled] [--debug]
```

## Troubleshooting

Running poller in debug mode

```console
cd <cacti_path>/plugins/mactrack
php -q poller_mactrack.php -d -sid=1
```

Run `php poller_mactrack.php -h` for more options.

Run scanner in debug mode for an specific device

```console
cd <cacti_path>/plugins/mactrack
php -q mactrack_scanner.php -d -id=23
```

Run `php -q mactrack_scanner.php -h` for more options.

The scanning function you are looking for does not show up.
Go to Mactrack Tools -> Tracking Utilities and click on "Refresh Scanning
Functions". This deletes old and potentially stale Device Tracking scanning
functions from the drop-down you see when you edit a device type.

If the poller prints `NOTE: A port table conversion or another scan is
running, exiting.`, a partitioning rebuild or an earlier scan is still
running. Scheduled scans resume when it ends. While the tables are
repartitioned, the daily maintenance is also skipped and the Cacti log shows
`MACTRACK: Database maintenance skipped while the port and IP tables are
repartitioned.`

## More Information

- [MacTrack plugin repository](https://github.com/Cacti/plugin_mactrack)

- [README](https://github.com/Cacti/plugin_mactrack/blob/v5.0/README.md) for
  MacTrack 5.0

---

Copyright (c) 2004-2026 The Cacti Group
