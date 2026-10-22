# Supported Devices in Cacti 1.2

Cacti can monitor devices that expose suitable SNMP objects, and can collect
other data through scripts. A device does not need a vendor-specific template
for basic interface monitoring. The available measurements depend on the
device's SNMP agent, firmware, credentials and permitted SNMP view.

This page lists the packages bundled with **Cacti 1.2.31**. Earlier 1.2 releases
and operating-system packages can contain a different selection. This is an
inventory of shipped templates and their intended measurements, not a list of
certified models or tested firmware versions. No live-device validation is
claimed by this inventory.

## Generic SNMP coverage

The bundled **Generic SNMP Device** package provides interface monitoring.
The interface query includes IF-MIB and IF-X-MIB counters, interface names,
descriptions, aliases, speeds and status. Available graph choices include
traffic, errors and discards. Use 64-bit traffic counters with SNMPv2c or
SNMPv3 when the agent exposes them, particularly on fast interfaces where
32-bit counters can wrap between polls.

The **Net-SNMP Device** package adds CPU, load, memory and storage monitoring
for agents exposing the corresponding UCD-SNMP-MIB and HOST-RESOURCES-MIB
objects. It also includes lmSensors queries where the agent exposes those
sensors. This does not mean that every SNMP device implements host-resource
or environmental measurements.

Configure access using [SNMP Options](SNMP-Options.md). An SNMP-enabled switch,
router, firewall or access point from another vendor may work with the generic
interface query even when it has no dedicated package below. A successful
interface query does not establish support for wireless clients, PoE, optical
diagnostics, firewall sessions or other vendor-specific measurements.

## Bundled network packages

These are installer-importable packages. Their names identify the intended
family; they do not establish compatibility with every product from a vendor.

###### Table 1. Network package inventory

| Package file | Intended device or service and measurements |
| --- | --- |
| `ACME.xml.gz` | ACME Session Director CPU, memory, temperature, voltage and sessions |
| `ArubaOS_switch.xml.gz` | ArubaOS CPU, memory, learned MAC addresses and interfaces |
| `Aruba_OSCX_switch_6x00.xml.gz` | Aruba AOS-CX 6x00 fans, temperatures, power supplies, VSF status and interfaces |
| `Aruba_Instant_AP_Cluster.xml.gz` | Aruba Instant AP/client counts, radio/AP statistics and WLAN clients |
| `Aruba_Wireless_Controller.xml.gz` | Aruba controller CPU, memory, users, associations, AP statistics and interfaces |
| `Cisco_Router.xml.gz` | Cisco CPU, BGP peer status/updates, HSRP state and interfaces |
| `Citrix_NetScaler_VPX.xml.gz` | NetScaler VPX resources, connections, protocol statistics and virtual-server/service state, traffic and timing |
| `Clearpass_policy_manager.xml.gz` | ClearPass uptime, memory, disk, requests, evaluations and authentication/service statistics |
| `Fortigate.xml.gz` | FortiGate CPU, memory, sessions, disk, SSLVPN users, HA, IPsec, IPS and interfaces |
| `Generic_SNMP_Device.xml.gz` | Generic SNMP interface monitoring |
| `MikroTik_Device.xml.gz` | MikroTik resources, wireless, queues, PPP, routes, ARP, DHCP, exposed environmental values and interfaces |
| `MikroTik_Switch_SWOS.xml.gz` | MikroTik SwOS generic interface/device graphs |

In particular, the Cisco Router package is not a model matrix for Catalyst,
Nexus, IOS XR or Meraki. Check the objects returned by the actual device before
selecting its graphs. Cloud management services and their managed devices can
expose different capabilities; a controller package does not imply direct
support for every managed access point.

The FortiGate package does not establish FortiSwitch or FortiAP coverage.
The SwOS package does not provide the RouterOS-specific measurements in the
MikroTik Device package. Some of these packages use PHP helpers to query SNMP;
they still require the device's SNMP objects.

## Bundled server and storage packages

###### Table 2. Server and storage package inventory

| Package file | Intended measurements or collection path |
| --- | --- |
| `Dell_iDrac.xml.gz` | iDRAC hardware health, disk, controller, battery, power-supply, temperature and cooling status |
| `HPE_iLO.xml.gz` | iLO system, CPU, memory and drive condition; fan and temperature sensors; management NIC statistics |
| `HPE_NimbleAlletra_storage.xml.gz` | Nimble/Alletra array and volume I/O, latency, cache and capacity measurements |
| `Synology_NAS.xml.gz` | Synology system, RAID, disk, SMART and performance measurements |
| `NetSNMP_Device.xml.gz` | Agent-exposed host resources and lmSensors |
| `ESXi_Device.xml.gz` | VMware ESXi collection; see [ESXi configuration](template_esxi_config.md) |
| `Local_Linux_Machine.xml.gz` | Local Linux script-based collection |
| `Windows_Device.xml.gz` | SNMP host resources and interfaces |

BMC health is different from operating-system utilization. The iDRAC and iLO
CPU and memory status fields do not establish CPU utilization or available
memory capacity. Some iLO fan measurements are speed states rather than RPM.
Availability depends on the management controller and its exposed tables.
The Nimble/Alletra package does not cover every HPE storage product, and iDRAC
disk monitoring does not establish support for Dell EMC SAN/NAS arrays.

## Bundled power and environmental packages

###### Table 3. Power and environmental package inventory

| Package file | Intended measurements |
| --- | --- |
| `SNMP_UPS.xml.gz` | UPS-MIB battery, runtime, alarms and input/output lines |
| `APC_InfraStruXure_PDU.xml.gz` | APC PDU breaker, phase and electrical measurements |
| `APC_InfraStruXure_InRow_CRAC.xml.gz` | APC InRow cooling, airflow, temperature, humidity and fluid measurements |
| `BayTech_PDU.xml.gz` | BayTech PDU measurements |
| `AKCP_Device.xml.gz` | AKCP environmental sensors |

The UPS package requires the relevant UPS-MIB objects. Its presence is not a
vendor-specific compatibility claim for all Schneider Electric, Eaton or
Vertiv models. The APC InRow package does not establish support for arbitrary
chillers, HVAC units or liquid-cooling distribution units.

## Other bundled packages

###### Table 4. Other package inventory

| Package file | Purpose |
| --- | --- |
| `Apache_Webserver.xml.gz` | Apache server statistics; see [Apache configuration](template_apache_config.md) |
| `Cacti_Stats.xml.gz` | Cacti operational statistics |
| `Motorola_SB6141.xml.gz` | Motorola SB6141 signal, power and error statistics through an HTTP scraper |
| `PING_Advanced_Ping.xml.gz` | Reachability and latency through ping collection |
| `SNMP_Printer.xml.gz` | SNMP printer monitoring |

These packages include collection methods other than SNMP. Their presence
does not mean that all services can be monitored solely through SNMP.

## Select and verify a template

Select the required bundled package in the installer. For an existing
installation, the main collector's `cli/import_package.php` accepts a signed
package through its `--filename` option. Run it from the Cacti installation
with PHP and consult its `--help` output before importing. The ordinary
[template import](Import-Template.md) workflow handles template XML, not these
signed `.xml.gz` packages and their embedded resources. Check that the
required queries and scripts are installed on the collector that will poll
the device.

Add the [device](Devices.md), configure its credentials and select a
[device template](Device-Templates.md). Check the returned data-query rows and
create graphs for measurements the device actually exposes. Follow
[How to Graph Your Network](How-to-Graph-Your-Network.md) for the graph-creation
workflow. Importing a template is separate from identifying a device or
creating all of its possible graphs.

For automatic device-template selection, configure
[device rules](Device-Rules.md). Indexed query graphs use
[graph rules](Graph-Rules.md) or manual selection. In Cacti 1.2.31, adding an
associated non-indexed graph template can also create its graph when **Enable
Automatic Graph Creation** is enabled, without a graph rule. A template name
alone does not prove that a device implements all of its measurements. Verify
the selected rows, units and resulting graphs before deploying across a fleet.

## Devices without a dedicated package

Cacti 1.2.31 does not bundle dedicated packages for every networking vendor,
GPU, AI cluster, InfiniBand fabric or storage platform. For example, the
inventory above contains no dedicated NVIDIA or AMD GPU, NetApp or Pure
Storage package. This does not prevent custom monitoring when the equipment
exposes suitable data.

Start with the generic interface query. Additional measurements can use a
[single SNMP OID](Graph-a-Single-SNMP-OID.md), an
[existing SNMP data query](How-To-Existing-SNMP-Data-Queries.md), or a
[new indexed query](How-To-New-SNMP-Data-Queries.md). Community templates are
separate from the bundled inventory; check their version requirements,
dependencies, units and supported agents before importing them.

Metrics available only through a REST API, cloud controller or telemetry
service require a separate collector or integration. Enabling SNMP on a
device does not make those measurements available through SNMP.

## Inventory sources

The package list comes from the [Cacti 1.2.31 installer][installer] and its
[bundled template archives][packages]. The generic interface fields are
defined in the [shipped interface query][interfaces].
Use the [release notes][release]
to identify the release; the moving maintenance branch can change after it.

[installer]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/install/functions.php#L464>
[packages]:<https://github.com/Cacti/cacti/tree/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/install/templates>
[interfaces]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/resource/snmp_queries/interface.xml>
[release]: <https://github.com/Cacti/cacti/releases/tag/release/1.2.31>

---

Copyright (c) 2004-2026 The Cacti Group
