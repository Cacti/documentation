# Complete Manual Index

[Return to the documentation front page](README.md).

This index follows **develop**, the unreleased Cacti 1.3 series. For released
Cacti 1.2 installations, use the [1.2.x manual][manual-1.2]. Menu visibility
also depends on permissions, enabled features, and plugins. Screenshots can
show an earlier release or a different theme.

## Install or Upgrade Cacti

Choose the guide for your operating system and installation method.

- [Requirements](Requirements.md)
- [General Installing Instructions](General-Installing-Instructions.md)
- [Enterprise Linux with Apache (LAMP)](Install-Under-Enterprise-Linux-LAMP.md)
- [Enterprise Linux with Nginx (LEMP)](Install-Under-Enterprise-Linux-LEMP.md)
- [Ubuntu/Debian with Apache (LAMP)](Installing-Under-Ubuntu-Debian.md)
- [Installing Under Windows](Installing-Under-Windows.md)
- [Upgrading Cacti Under UNIX Compatible Operating Systems](Upgrading-Cacti.md)
- [Upgrading Cacti Under Windows](Upgrading-Cacti-Under-Windows.md)
- [Upgrading Cacti Under FreeBSD](Upgrading-Cacti-Under-FreeBSD.md)
- [Convert a Debian/Ubuntu package install to source][guide-1]
- [Hardening a Cacti Installation](Hardening-Cacti-Installation.md)
- [Configuring SSL for Cacti](Cacti-SSL-Configuration.md)
- [Version Specific Release Notes](Version-Specific-Release-Notes.md)

## Create Your First Graphs

Start with the interface and concepts, then add a device and its graphs.

- [Navigating the Cacti User Interface](Navigating-The-User-Interface.md)
- [Principles of Operation](Principles-of-Operation.md)
- [How to Graph Your Network](How-to-Graph-Your-Network.md)
- [Device Management](Devices.md)
- [Graph Overview](Graph-Overview.md)
- [Graph Management](Graphs.md)
- [Viewing Graphs](Viewing-Graphs.md)
- [Creating a Graph for a Single SNMP OID](Graph-a-Single-SNMP-OID.md)

## Manage Your Installation

Organize monitoring, automate discovery, manage access, and create reports.

- [Site Management](Sites.md)
- [Cacti Trees](Trees.md)
- [Data Source Management](Data-Sources.md)
- [Aggregate Graphs](Aggregates.md)
- [Automation Networks](Automation-Networks.md)
- [Automation Discovered Devices](Discovered-Devices.md)
- [Automation Device Rules](Device-Rules.md)
- [Automation Graph Rules](Graph-Rules.md)
- [Automation Tree Rules](Tree-Rules.md)
- [Automation SNMP Options](SNMP-Options.md)
- [User Management](User-Management.md)
- [User Group Management](User-Group-Management.md)
- [Login Providers](Login-Providers.md)
- [User Domains (1.2)](User-Domains.md)
- [Reports Administration](Reports-Admin.md)
- [Reports User](Reports-User.md)
- [Report Items](Reports-Items.md)
- [Report Preview](Reports-Preview.md)
- [Report Events](Reports-Events.md)
- [Other Report Management Options](Reports-Other-Options.md)
- [System Utilities](System-Utilities.md)

## Configure Data Collection

Configure local and remote collection and diagnose performance constraints.

- [Data Collectors](Data-Collectors.md)
- [Spine](Spine.md)
- [Poller Settings](Settings-Poller.md)
- [PHP Script Server](PHP-Script-Server.md)
- [Performance Boosting Settings](Boost.md)
- [rrdproxy](RRDproxy.md)
- [Remote Poller Setup](How-To-Setup-Remote-Pollers.md)
- [Change the polling interval](How-To-Poller-5-to-1-min.md)
- [SSH tunnels for remote Unix monitoring](How-To-SSH-Tunnels.md)
- [How To Extend snmpd with custom script/data](How-To-SNMP-Custom-Script.md)

## Create and Reuse Templates

Find template concepts, query procedures, packaging, and device-specific guides.

- [Templates](Templates.md)
- [How To Work with Templates](How-To-Work-With-Templates.md)
- [Device Templates](Device-Templates.md)
- [Graph Templates](Graph-Templates.md)
- [Data Source Templates](Data-Source-Templates.md)
- [Aggregate Templates](Aggregate-Templates.md)
- [Color Templates](Color-Templates.md)
- [Data Input Methods](Data-Input-Methods.md)
- [Create a data input method](How-To-Create-Data-Input-Method.md)
- [Data Queries](Data-Queries.md)
- [How To Work with Data Queries](How-To-Data-Queries.md)
- [SNMP Data Queries](How-To-Existing-SNMP-Data-Queries.md)
- [SNMP Data Query Walkthrough](How-To-New-SNMP-Data-Queries.md)
- [Script Data Query Walkthrough](How-To-Script-Data-Queries.md)
- [Determine a template version](How-To-Determine-Template-Version.md)
- [Import Packages](Import-Packages.md)
- [Template Import](Import-Template.md)
- [Template Exporting](Export-Template.md)
- [Create Packages](Create-Packages.md)
- [Package Repositories](Package-Repositories.md)
- [Package Public Keys](Public-Keys.md)
- [Apache Template Config](template_apache_config.md)
- [ESXi/VMware Template](template_esxi_config.md)
- [Proxmox - external storage usage](device-template-specific-proxmox.md)

## Troubleshoot a Problem

Start with the symptom, polling output, and log messages.

- [Data Source Debugging](Data-Debug.md)
- [The Cacti Log Interface](Cacti-Log.md)
- [Debugging](Debugging.md)
- [Frequently Asked Questions](Frequently-Asked-Questions.md)
- [Known Issues](Known-Issues.md)
- [Spikekill](Spikekill.md)

## Settings Reference

Use the settings for your branch. Development and 1.2 authentication differ.

- [Settings](Settings.md)
- [General Settings](Settings-General.md)
- [Path Settings](Settings-Paths.md)
- [Device Default Settings](Settings-Device-Defaults.md)
- [Data Settings](Settings-Data.md)
- [Visual Settings](Settings-Visual.md)
- [Performance Settings (Boost)](Settings-Performance.md)
- [Spike Kill](Settings-Spikes.md)
- [Mail/Reporting/DNS Settings/Proxy](Settings-Mail-Reporting-DNS.md)
- [Authentication](Settings-Auth.md)
- [Local Authentication](Settings-Auth-Local.md)
- [LDAP Authentication](Settings-Auth-LDAP.md)
- [Basic Authentication](Settings-Auth-Basic.md)
- [Multiple LDAP/AD Domains (1.2)](Settings-Domains.md)
- [Users, groups, and login providers](Settings-Users-Groups-Domains.md)

## Graph and Data Reference

Look up data profiles, expressions, formatting, and command-line tools.

- [Data Source Profiles](Data-Profiles.md)
- [CDEFs](CDEFs.md)
- [VDEFs](VDEFs.md)
- [Colors](Colors.md)
- [GPRINT Presets](GPRINTs.md)
- [Variables](Variables.md)
- [RRDtool Specific Features](RRDtool-Specific-Features.md)
- [Command Line Scripts (CLI)](Command-Line-Scripts.md)

## Plugins

Install and use plugins, or develop an extension.

- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)
- [syslog](Plugin-Syslog.md)
- [MacTrack](Plugin-Mactrack.md)
- [Plugin Development](Plugin-Development.md)
- [Plugin Guidelines](Plugin-Guidelines.md)
- [Creating a plugin](Plugin-Creating-Plugins.md)
- [Reference Plugins](Plugin-Reference.md)
- [Plugin Hook API Reference](Plugin-Hook-API-Ref.md)
- [ReportIt 3.0 development manual (PDF)](resource/pdf/manual_reportit_3.0.pdf)
- [ReportIt plugin manual (historical PDF)](resource/pdf/manual_reportit.pdf)

## Contributing

Contribute code, documentation, translations, and support.

- [Contributing](Contributing.md)
- [Creating Translations](Contributing-Translations.md)

## Development Standards

Follow the target branch's contributor instructions and checks.

- [Documentation Standards](Standards-Documentation.md)
- [Formatting Guidelines](Standards-Code-Formatting.md)
- [PHP Specific Constructs](Standards-PHP-Spec-Constructs.md)
- [File System Layout](Standards-FileSystem-Layout.md)
- [Patch Creation](Standards-Patch-Creation.md)
- [SQL Standards](Standards-SQL.md)
- [Security](Standards-Security.md)

## Architecture Decisions

Read the decision index for the status of each proposal.

- [Architecture Decision Records](Architecture-Decisions.md)
- [ADR-0001: Bounded contexts](Architecture/0001-bounded-contexts.md)
- [ADR-0002: Durable install runs](Architecture/0002-durable-install-runs.md)
- [ADR-0003: Plugin extension boundary][guide-2]
- [ADR-0004: Workflow storage and observability][guide-3]

## Project and Community

Find project credits, licensing, support, and additional resources.

- [Manual and Example Downloads](Downloads.md)
- [Project Credits and Licensing](Project-Information.md)
- [External Links](External-Links.md)
- [Official video tutorials][videos]
- [Cacti Forums](https://forums.cacti.net/)

[guide-1]: convert-from-package-to-source-debian-ubuntu.md
[guide-2]: Architecture/0003-plugin-extension-boundary.md
[guide-3]: Architecture/0004-workflow-storage-and-observability.md
[manual-1.2]: https://github.com/Cacti/documentation/tree/1.2.x
[videos]: https://www.youtube.com/channel/UC6ROmUGuuLa9BdHWzvGSY1w

---

Copyright (c) 2004-2026 The Cacti Group
