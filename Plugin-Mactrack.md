# MacTrack

The MacTrack plugin is designed to scan network switches, routers and intelligent 
hubs for connected devices, and record their location either based upon the portname
or alias of the switch or hub. It also attempts to discover the ip address of the mac 
address from the routers included in the MacTrack database. MacTrack can also 
use arpwatch to gether IP to MAC address associations.

MacTrack has the ability to also notify admins or security personnel when the MAC 
address of a missing or stolen computer re-appears on the network. This can be helpful
in recovering lost equipment. Through MacTrack's interface monitoring feature, 
a Network Administrator can get a very good idea of where utilization is,
where there are errors, etc within their network.

In howto is mentioned menu item "Mactrack" or "Mactrack tab". In older versions 
is called "Device tracking".

## Mactrack setup

- Check default settings
  Configuration -> Settings -> Mactrack tab (or Device tracking in older version)

- Create sites (mandatory)
  At this moment Mactrack's sites have no relation to Cacti's sites

- Define Device Types (mandatory)
  Several device types are provided as an example with the current version. 
  Devices without device type match will not be processes

- Import IEEE OUI Database (optional)
  Define SNMP set options to use


##Create site
One of the mandatory steps to start setting Mactrack up is to create sites 
where we are going to allocate our Mactrack devices.
Console -> Mactrack -> Sites
You need add devices to site. You can import some existing Cacti devices into 
Mactrack or add devices manually on Console -> Mactrack -> Devices



## Device types
Device Types

Console -> Mactrack (Device Tracking in previous versions) -> Device Types menu

Create as many device types as you need following this instrunctions. 
**Description** - give this device type a meaningful description
**Vendor** - fill in the name for the vendor of this device type
**Device Type** - choose the type of device. What kind of device is it? Meaning that 
some scanning functions will be available for some of these types only. 
Eg: If you set a switch/hub as "Switch/Router" you will then be able to pick 
an IP scanning function up when the device doesn't really supports it.
**System Description Match**  - provide key information to help Device 
Tracking detect the type of device. The wildcard character is the % sign.
  When you open a device in Cacti, you normally see the following on top of the page.
  ``
  System: Cisco IOS Software, C2960 Software (C2960-LANBASEK9-M), Version 12.2(53)SE2, RELEASE SOFTWARE (fc3)Technical Support: http://www.cisco.com/techsupportCopyright (c) 1986-2010 by Cisco Systems, Inc.Compiled Wed 21-Apr-10 05:52 by prod_rel_team
  Uptime: 3176562306
  Hostname: myswitch101.com
  ObjectID: .1.3.6.1.4.1.9.1.696
  ``
  What you want to make Mactrack look at is something like "C2960" which quickly identify 
  the hardware platform. Don't waste your time try to match something different 
  or more complex like "12.2(53)SE2".

**Vendor SNMP Object ID Match** - this is the SNMP OID on this format: .1.3.6.1.4.1.9.1.696
**MAC Address Scanning Function** - we assume you know what you are looking for here. This function should only be set to switches L2/L3 and not Routers.
**IP Address Scanning Function** - this function allows you to look at the ARP table and map IP vs MAC. There is an special function for Cisco devices called get_cisco_dhcpsnooping_table that will look at the DHCP Snooping table for switches if enabled.
**802.1x Scanning Function** - this scanning function was introduced on 4.2 version and it's only for Cisco devices.
**Serial Number Base OID** - this isn't mandatory but you can specify the SNMP OID to find the serial number to the device.
**Serial Number Collection Method** - how is the serial number collected for this OID. If 'SNMP Walk', we assume multiple serial numbers. If 'Get', it will be only one.
**Low User Port Number** - provide the low user port number on this switch. Leave 0 to allow the system to calculate it. Empty assumes 0
**High User Port Number** - provide the low user port number on this switch. Leave 0 to allow the system to calculate it. Empty assumes 0

Export device types option allows you to export the existing devices types 
to CSV format so you can later on import them onto new installations, 
to share them or just to back them up.
Go to Console -> Mactrack -> Device Types and click the export button.
For import Device Types you can use button "Import" on the same page.


##Import OUI Database from IEEE

This function will download and install the latest OUI database from the 
IEEE Website. Each Network Interface Card (NIC) has a MAC Address. 
The MAC Address can be broken into two parts. The first part of the MAC Addess 
contains the Vendor MAC. The Vendor MAC identifies who has manufactured the part. 
This will be helpful to check for rogue devices on your network.

Go to Mactrack -> Tracking Utilities and click on **Refresh IEEE Vendor MAC/OUI Database**

This option requires internet access so if for some reason your server cannot 
access internet you could manually download the file from OUI Database copy it 
to your Cacti's box and import it by hand as follow.

Go to **<cacti_path>/plugins/mactrack**

Assuming that you have copied the file to /tmp
``
[root@mycactiserver mactrack]#php mactrack_import_ouidb.php -f=/tmp/out.txt
Getting OUI Database from the IEEE
OUI Database Download from IEEE Complete
........................
There were '23126' Entries Added/Updated in the database.
There were '0' Records Removed from the database.
``

##Troubleshooting
Running poller in debug mode
  Go to <cacti_path>/plugins/mactrack
  php -q poller_mactrack.php -d -sid=1
  Run php poller_mactrack.php -h for more options

Run scanner in debug mode for an specific device
  Go to <cacti_path>/plugins/mactrack
  php -q mactrack_scanner.php -d -id=23
  Run php -q mactrack_scanner.php -h for more options

The scanning function you are looking for does not show up
  Go to Tracking Tools Menu and click on "Refresh Scanning Functions"
  Deletes old and potentially stale Device Tracking scanning functions 
  from the drop-down you see when you edit a device type.



Copyright (c) 2004-2024 The Cacti Group
