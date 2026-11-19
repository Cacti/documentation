# Supported plugins

Plugins extend Cacti with monitoring, reporting, inventory, and notification
features. The catalog below links to public plugin repositories in the Cacti
organization. Read each plugin's README, `INFO`, and release notes before
choosing a version; requirements and release schedules differ between plugins.

The default branch can contain unreleased changes. Use its documentation for
development checkouts, and use the documentation at the matching release tag
for an installed package. An `INFO` version on a development branch does not
by itself mean that version has been released.

For installation, updates, permissions, and removal, see
[Plugin Management](Plugins.md). Install a repository named `plugin_NAME`
under `plugins/NAME`, using the directory name declared by that plugin.

| Plugin and documentation | Purpose | Install directory |
| --- | --- | --- |
| [Alarm Manager](https://github.com/Cacti/plugin_alarmmanager) | Route alarms to email, HTTP services, and scripts; track delivery and recovery. | `plugins/alarmmanager` |
| [APC UPS](https://github.com/Cacti/plugin_apcupsd) | Monitor UPS devices through apcupsd, SNMP, or Network UPS Tools. | `plugins/apcupsd` |
| [Audit](https://github.com/Cacti/plugin_audit) | Record Cacti activity and forward audit events to remote Syslog. | `plugins/audit` |
| [Credentials](https://github.com/Cacti/plugin_credentials) | Manage reusable encrypted credentials and external secret providers. | `plugins/credentials` |
| [Cycle](https://github.com/Cacti/plugin_cycle) | Rotate through selected graphs for an operations display. | `plugins/cycle` |
| [Evidence](https://github.com/Cacti/plugin_evidence) | Inventory SNMP Entity MIB hardware, serial numbers, and firmware changes. | `plugins/evidence` |
| [FlowView](https://github.com/Cacti/plugin_flowview) | Collect and report on network flow data, with scheduled reports. | `plugins/flowview` |
| [Graph Export](https://github.com/Cacti/plugin_gexport) | Export Cacti graphs to files for use outside the Cacti interface. | `plugins/gexport` |
| [GPSMap](https://github.com/Cacti/plugin_gpsmap) | Plot device locations, status, and coverage areas on Google Maps. | `plugins/gpsmap` |
| [Host MIB](https://github.com/Cacti/plugin_hmib) | Collect Host Resources MIB performance, process, and hardware information. | `plugins/hmib` |
| [Intropage](https://github.com/Cacti/plugin_intropage) | Build personal or shared dashboards from Cacti graphs and plugin panels. | `plugins/intropage` |
| [MacTrack](https://github.com/Cacti/plugin_mactrack) | Track MAC and IP addresses, switch ports, VLANs, and device history. | `plugins/mactrack` |
| [Maintenance](https://github.com/Cacti/plugin_maint) | Schedule maintenance periods for integrations that suppress alerts. | `plugins/maint` |
| [MikroTik](https://github.com/Cacti/plugin_mikrotik) | Collect RouterOS device, wireless, user, interface, and health information. | `plugins/mikrotik` |
| [Monitor](https://github.com/Cacti/plugin_monitor) | Display device availability and provide audible and visual status alerts. | `plugins/monitor` |
| [Nagios Plugin for Cacti](https://github.com/Cacti/plugin_npc) | View Nagios status and history stored through NDOUtils. | `plugins/npc` |
| [QuickTree](https://github.com/Cacti/plugin_quicktree) | Collect graphs into a personal playlist and save them as a graph tree. | `plugins/quicktree` |
| [ReportIt](https://github.com/Cacti/plugin_reportit) | Generate and schedule tabular reports from RRD data. | `plugins/reportit` |
| [Router Configs](https://github.com/Cacti/plugin_routerconfigs) | Back up network device configurations and compare revisions. | `plugins/routerconfigs` |
| [Service Check](https://github.com/Cacti/plugin_servcheck) | Check network services, responses, and certificate expiry. | `plugins/servcheck` |
| [Slowlog](https://github.com/Cacti/plugin_slowlog) | Import and analyze MySQL or MariaDB slow query logs. | `plugins/slowlog` |
| [Syslog](https://github.com/Cacti/plugin_syslog) | Search log messages, manage alert and removal rules, and build dashboards. | `plugins/syslog` |
| [Tags](https://github.com/Cacti/plugin_tags) | Annotate graphs with manual or automatic tags for devices, sites, and events. | `plugins/tags` |
| [Thold](https://github.com/Cacti/plugin_thold) | Evaluate thresholds, track device events, and send notifications. | `plugins/thold` |
| [TopX](https://github.com/Cacti/plugin_topx) | Display ranked graph and data-source views; check repository compatibility before use. | `plugins/topx` |
| [Weathermap](https://github.com/Cacti/plugin_weathermap) | Build network maps whose links and nodes display monitored values. | `plugins/weathermap` |
| [Webseer](https://github.com/Cacti/plugin_webseer) | Monitor website availability and response timing. | `plugins/webseer` |
| [WMI](https://github.com/Cacti/plugin_wmi) | Collect Windows performance and inventory data through WMI transports. | `plugins/wmi` |

## Detailed manual pages

- [MacTrack setup and troubleshooting](Plugin-Mactrack.md).
- [Syslog collection, alerts, and remote pollers](Plugin-Syslog.md).

The linked repositories contain the plugin-specific configuration and
upgrade instructions. Check dependencies in `INFO` rather than assuming that
plugins with related features require one another. For example, Monitor
declares a Thold dependency; a Syslog installation can send direct email
without installing Thold.

---

Copyright (c) 2004-2026 The Cacti Group
