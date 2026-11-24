# Supported plugins

The Cacti Group has developed, and is still developing, a large number of
plugins extending Cacti. Some of them are adopted from the community.

Of course, plugins can be developed by anyone; our documentation contains
everything needed. We do our best to keep the plugins we support working
with current versions of Cacti.

Here is a list of the plugins we support and a short description of them.

- **Thold**

  The Cacti thold plugin is designed to be a fault management system driven by Cacti's Graph information.
  It provides the facility to inspect data in a Cacti Graph and the underlying RRDfile, and generate alerts
  for management and operations personnel. It provides Email, Syslog, and SNMP Trap or Inform escalations.
  In addition, it can notify personnel of Cacti Device status changes through
  Email, Syslog, and either SNMP Trap or Inform.
  - Hi/Low, Time Based and Baseline deviation thresholds
  - Realerting
  - Multiple Data Manipulation types, including: Exact Value, CDEF, Percentage, and RPN Expression
  - Ability to Generate Tickets to Ticketing Systems through Script Execution
  - Acknowledgment levels

  [Thold plugin homepage](https://github.com/Cacti/plugin_thold)

- **Intropage**

  User-defined dashboards for Cacti. Each user can create their own
  dashboards (up to nine).
  - Displays useful information about Cacti
  - Add graphs to dashboard
  - Support plugins like thold, syslog, ...
  - Share dashboards between users
  - Respects Cacti's user permissions

  [Intropage plugin homepage](https://github.com/Cacti/plugin_intropage)

- **Maint**

  This plugin is for scheduling maintenance, so that Thold, Webseer, Servcheck,
  and other plugins will not alert during that time period.
  - One time or Recurring schedule

  [Maint plugin homepage](https://github.com/Cacti/plugin_maint)

- **Monitor**

  This plugin allows you to view at a glance all your critical Cacti
  hosts, and will alert you audibly and via Email when a Device or Devices go down.
  It requires the Thold plugin, version 1.2.1 or later.
  - Data Center Dashboard
  - Audible and Visual Alerting
  - Respects Cacti's user permissions
  - Monitoring can be enabled or disabled at the Device level
  - Supports Monitoring Devices by Criticality

  [Monitor plugin homepage](https://github.com/Cacti/plugin_monitor)

- **Mikrotik**

  This plugin provides support for the MikroTik RouterOS available from MikroTik and other router
  and switch hardware suppliers. It is not a replacement for MikroTik's GUI interface, but provides
  nice Cacti Graphs.
  - Automatic Discovery of Cacti Devices that are MikroTik's
  - Enhanced Traffic Graphs
  - Graphs of Wireless and PPPoE Users
  - Table views of Wireless and PPPoE User utilization
  - Graphs of MikroTik environmental data such as temperature and voltage
  - Viewing of Devices and summary statistics, Users, Queue Trees, Access Points, HotSpots, Interfaces, Wireless Station, and Health (sensor) information

  [Mikrotik plugin homepage](https://github.com/Cacti/plugin_mikrotik)

- **Routerconfigs**

  The routerconfigs plugin is designed to receive and create backups from your network devices.
  It also provides the ability to view and diff those router configurations as they change over time.
  Devices are backed up with TFTP transfers or SSH command capture, depending
  on the device type, and the built-in device types cover many vendors, not
  only Cisco. TFTP device types need a reachable TFTP server; SSH capture
  device types need PHP's `ssh2` extension.

  [Routerconfigs plugin homepage](https://github.com/Cacti/plugin_routerconfigs)

- **ReportIt**

  This plugin creates tabular reports that can also be exported to CSV, SML,
  and XML. Version 3.0, on the plugin's development branch, requires Cacti
  1.3.0; the published 1.1.4 release requires Cacti 1.2.27 or later.
  - Definition of individual report templates by using measurands and variables in a mathematical way
  - Individual configuration of working days, working time, timezone and subheads per data item
  - Scheduled reporting with sliding time frames
  - Export to CSV, SML and XML
  - Different ways of connecting RRDtool
  - Scheduled reports via email

  [Reportit plugin homepage](https://github.com/Cacti/plugin_reportit)

- **Evidence**

  Plugin provides information about device serial numbers, software/firmware versions
  and much more information from SNMP Entity MIB
  - Search serial number, problematic firmware version
  - Email notification when changes
  - Saves past configurations, ability to view changes in time
  - Vendor specific information

  [Evidence plugin homepage](https://github.com/Cacti/plugin_evidence)

- **Mactrack**

  Scan network devices (switches, routers, ..) for connected devices
  - Find MACs, IPs, VLANs
  - Associate IP and MAC
  - Where is device connected
  - ARPwatch support
  - Finds Stolen/Lost PCs
  - Tells you when someone is connected who shouldn't be

  [Mactrack plugin homepage](https://github.com/Cacti/plugin_mactrack)

- **FlowView**

  This plugin allows you to view NetFlow data from inside of Cacti
  and to generate Email based reports of the data.
  - Ability to view Flow Data in Table Form or three Chart Forms
  - Parallel Query Execution to increase the speed of report generation
  - Support for Shard Query and Horizontal Scaling through use of technologies such as MariaDB MaxScale
  - Tracking of IP addresses that do not resolve through DNS by using ARIN's whois service
  - Customizable Scheduled Reports

  [Flowview plugin homepage](https://github.com/Cacti/plugin_flowview)

- **Servcheck**

   Internet services (http, imap, ldap, ...)  monitoring plugin. This plugin allows you to add
   service monitoring to Cacti. You simply add service check, allow service specific test
   (like certificate test) and you can add the expected response. Servcheck periodically runs tests
   and notifies if a service check fails. The plugin records statistics about the connection
   and its response, and can send an email or run a script when the status changes.
   - tests for scp, tftp, ftp, smb, ..
   - import own certificate for test
   - notify about soon certificate expiration
   - notify when last result is different

  [Servcheck plugin homepage](https://github.com/Cacti/plugin_servcheck)

- **HMIB**

  The hmib plugin is designed to collect SNMP information from Cacti Devices that support the
  SNMP Host Resources MIB (HOST-RESOURCES-MIB). This SNMP information includes
  performance metrics like CPU utilization, running processes and applications,
  memory and storage utilization, hardware details, and installed software.

  [Hmib plugin homepage](https://github.com/Cacti/plugin_hmib)

- **Weathermap**

  Weathermap is one of many implementations of the same basic idea - take data from
  your network devices and use it to provide a single-page overview of the current
  state of the network.

  [Weathermap plugin homepage](https://github.com/Cacti/plugin_weathermap)

- **Syslog**

  It provides a simple Syslog event search, alert generation, and notification
  interface that can generate both HTML and SMS messages for operations personnel
  who wish to receive notifications inside of a data or network operations center.
  When combined with the Linux SNMPTT package, it can be converted into an SNMP Trap
  and Inform receiver and notification engine as the SNMPTT tool will receive SNMP
  Traps and Informs and convert them into Syslog messages on your log server.
  These syslog messages can then be consumed by the syslog plugin.
  - Message filtering
  - Message searching
  - Message Alerting
  - Alert Methods of Individual and Threshold Based
  - Remote Log Server connection capabilities
  - Ability to Generate Tickets to Ticketing Systems through Script Execution
  - Ability to run alert specific commands at Alert and Re-alert times

  [Syslog plugin homepage](https://github.com/Cacti/plugin_syslog)

- **Slowlog**

  The plugin allows a Cacti Administrator to import a MySQL or MariaDB slow
  query log into the Cacti database and analyze it.

  [Slowlog plugin homepage](https://github.com/Cacti/plugin_slowlog)

- **Apcupsd**

  This plugin is to be used to track UPS status from the apcupsd daemon
  as well as SNMP enabled UPS.  The apcupsd daemon is able to provide information
  on APC and other types of UPS' over various network topologies such as USB,
  Modbus, Ethernet, etc. We have added basic SNMP support in order to provide
  direct access to certain models over the SNMP protocol, thus removing the need
  for an apcupsd host to provide the monitoring details as well. Version 1.4.0
  also adds support for UPSs served by a Network UPS Tools (NUT) server.
  - Track UPS status
  - Log information to Cacti database

  [Apcupsd plugin homepage](https://github.com/Cacti/plugin_apcupsd)


- **WMI**

  The WMI Plugin provides data collection services for devices that support the
  WMI protocol. It operates asynchronously to the Cacti data collection and
  stores the resulting information into cache tables. These cache tables can
  then be used to generate graphs, thresholds and alerts. On a Linux Cacti
  server it relies on the 'wmic' client; on a Windows Cacti server it uses
  PowerShell (CIM) over WinRM. The plugin is still under development and is
  not recommended for production systems.

  [WMI plugin homepage](https://github.com/Cacti/plugin_wmi)
