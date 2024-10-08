# Supported plugins

Cacti group has developed and is still developing a large number of plugins
extending cacti. Some of them are adopted from the community.

Of course plugins can be developed by anyone, our documentation contains
everything needed. We do our best to keep the plugins we support working
with current versions of cacti.

Here is a list of the plugins we support and a short description of them.

- **Thold**
  The Cacti thold plugin is designed to be a fault management system driven by Cacti's Graph information.
  It provides the facility to inspect data in a Cacti Graph and the underlying RRDfile, and generate alerts
  for management and operations personnel. It provides Email, Syslog, and SNMP Trap or Inform escalations.
  In addition, it also can notify personnel of Cacti Device status changes.
  - Hi/Low, Time Based and Baseline deviation thresholds
  - Realerting
  - Multiple Data Manipulation types, including: Exact Value, CDEF, Percentage, and RPN Expression
  - Ability to Generate Tickets to Ticketing Systems through Script Execution
  - Acknowledgment levels

- **Intropage**
  User defined dashboards for Cacti. Each user can create own dashboards.
  - Displays useful information about Cacti
  - Add graphs to dashboard
  - Support plugins like thold, syslog, ...
  - Share dashboards between users
  - Respects Cacti's user permissions

- **Maint**
  Plugin is for the scheduling of maintenance so that Thold/Servcheck and other plugins will not alert during that time period.
  - One time or Recurring schedule

- **Monitor**
  This plugin allows you to view at a glance all your critical Cacti
  hosts, and will alert you audibly and via Email when a Device or Devices go down.
  - Data Center Dashboard
  - Audible and Visual Alerting
  - Respects Cacti's user permissions
  - Monitoring can be enabled or disabled at the Device level
  - Supports Monitoring Devices by Criticality

- **Mikrotik**
  This plugin provides support for the MikroTik RouterOS available from MikroTik and other router
  and switch hardware suppliers. It is not a replacement for MikroTik's GUI interface, but provides
  nice Cacti Graphs.
  - Automatic Discovery of Cacti Devices that are MikroTik's
  - Enhanced Traffic Graphs
  - Graphs of Wireless and PPPoE Users
  - Table views of Wireless and PPPoE User utilization
  - Graphs of MikroTik environmental data such as temperature and voltage
  - Viewing of Devices and summary statistics, Users, Queue Trees, Access Points, HotSpots, Interfaces, and Wireless Station information

- **Routerconfigs**
  The routerconfigs plugin is designed to receive and create backups from your network devices.
  It also provides the ability to view and diff those router configurations as they change over time.
  It is designed primarily for Cisco device types, but may work with other device types.

- **ReportIt**
  This plugin creates tabular reports which can be exported to CSV, SML and XML as well.
  - Definition of individual report templates by using measurands and variables in a mathematical way
  - Individual configuration of working days, working time, timezone and subheads per data item
  - Scheduled reporting with sliding time frames
  - Export to CSV, SML and XML
  - Different ways of connecting RRDtool
  - Scheduled reports via email

- **Evidence**
  Plugin provides information about device serial numbers, software/firmware versions
  and much more information from SNMP Entity MIB
  - Search serial number, problematic firmware version
  - Email notification when changes
  - Saves past configurations, ability to view changes in time
  - Vendor specific information

- **Mactrack**
  Scan network devices (switches, routers, ..) for connected devices
  - Find MACs, IPs, VLANs
  - Associate IP and MAC
  - Where is device connected
  - ARPwatch support
  - Finds Stolen/Lost PC's
  - Tells you when someone is connected who shouldn't be

- **FlowView**
  This plugin allows you to view NetFlow data from inside of Cacti
  and to generate Email based reports of the data.
  - Ability to view Flow Data in Table Form or three Chart Forms
  - Parallel Query Execution to increase the speed of report generation
  - Support for Shard Query and Horizontal Scaling through use of technologies such as MariaDB MaxScale
  - Tracking of IP addresses that do not resolve through DNS by using ARIN's whois service
  - Customizable Scheduled Reports

- **Servcheck**
   Internet services (http, imap, ldap, ...)  monitoring plugin. This plugin allows you to add
   service monitoring to Cacti. You simply add service check, allow service specific test
   (like certificate test) and you can add the expected response. Servcheck periodically runs test
   and notifies if a service check fails. The plugin records statistics about the connection,
   it's response, and can alert when the status changes.
   - tests for scp, tftp, ftp, smb, ..
   - import own certificate for test
   - notify about soon certificate expiration
   - notify when last result is different

- **HMIB**
  The hmib plugin is designed to collect SNMP information from Cacti Devices that support the
  SNMP Host Resources Mib structure. This SNMP information includes performance metrics like
  CPU utilization, running processes and applications, hardware details, ...

- **Weathermap**
  Weathermap is one of many implementations of the same basic idea - take data from
  your network devices and use it to provide a single-page overview of the current
  state of network, like the one to the right.

- **Syslog**
  It provides a simple Syslog event search an Alert generation and notification
  interface that can generate both HTML and SMS messages for operations personnel
  who wish to receive notifications inside of a data or network operations center.
  When combined by the Linux SNMPTT package, it can be converted into an SNMP Trap
  and Inform receiver and notification engine as the SNMPTT tool will receive SNMP
  Traps and Informs and convert them into Syslog messages on your log server.
  These syslog messages can then be consumed by the syslog plugin. So, this tool is quite handy
  - Message filtering
  - Message searching
  - Message Alerting
  - Alert Methods of Individual and Threshold Based
  - Remote Log Server connection capabilities
  - Ability to Generate Tickets to Ticketing Systems through Script Execution
  - Ability to run alert specific commands at Alert and Re-alert times

- **Slowlog**
  The plugin will allow a Cacti Administrator to import their slow
  Query log and perform analysis of that slow log.

- **APCUPSD**
  This plugin is to be used to track UPS status from the apcupsd daemon
  as well as SNMP enabled UPS.  The apcupsd daemon is able to provide information
  on APC and other types of UPS' over various network typologies such as USB,
  Modbus, Ethernet, etc. We have added basic SNMP support in order to provide
  direct access to certain models over the SNMP protocol thus removing the need
  for an apcupsd host to provide the monitoring details as well.
  - Track UPS status
  - Log information to Cacti database

- **WMI**
  The WMI Plugin provides data collection services for devices that support the
  WMI protocol. It operates asyncrhonously to the Cacti data collection and
  stores the resulting information into cache tables. These cache tables can
  then be used to generate graphs, thresholds and alerts. It relies on the 'wmic'
  command in Linux, and WMI services via Microsofts COM protocol from Windows Cacti servers.

