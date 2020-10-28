# Cacti (tm) Documentation

![Cacti](images/logo.png)

Cacti is designed to be a complete graphing solution based on the RRDTool's
framework. Its goal is to make a network administrator's job easier by taking
care of all the necessary details necessary to create meaningful graphs.

Please see the official Cacti website for information, support, and updates.

## Developers

- Ian Berry (raX)

- Larry Adams (TheWitness)

- Tony Roman (rony)

- J.P. Pasnak, CD (Linegod)

- Jimmy Conner (cigamit)

- Reinhard Scheck (gandalf)

- Andreas Braun (browniebraun)

- Mark Brugnoli-Vinten (netniV)

## Thanks

A very special thanks to Tobi Oetiker, the creator of RRDTool and the very
popular MRTG. The users of Cacti - especially anyone who has taken the time to
create a bug report, or otherwise help fix a Cacti related problem. Also
to anyone who has contributed to supporting Cacti.

Cacti is licensed under the GNU GPL:

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

## Table of Contents

1. [Cacti Installation](README.md#cacti-installation)

   This section contains information on how to install and/or upgrade the
   Cacti system.  It covers requirements, different platforms and the steps
   needed to get your system working under normal circumstances.

2. [Cacti Overview](README.md#cacti-overview)

   This section describes Cacti components and their purpose as well as
   providing examples including on how to create **Templates** in Cacti.

3. [Advanced Operations](README.md#advanced-operations)

   This section covers more advanced material such as using a advanced data
   collection and replacement variables that can be used within **Templates**,
   etc.

4. [Plugin Development](README.md#plugin-development)

   This section contains all Plugin development related information.
   Guidelines, hooks, references, etc.  More information can be found on
   the [Cacti Forums](https://forums.cacti.net/viewforum.php?f=6).

5. [How To's](README.md#how-tos)

   This section contains how to's for several topics.

6. [Contributing](README.md#contributing)

   This section contains information on how to contribute to Cacti.

7. [Development Standards](README.md#development-standards)

   This section contains the relevant information on how to ensure that any
   contribution is kept to the same standards that are applied for the Cacti
   Group. It should be noted that non-compliance does not mean automatically
   exclusion of proposed changes.

### Known Issues

[List of Known issues](known-issues.md)

### Cacti Installation

1. [Requirements](Requirements.md)

2. [General Installing Instructions](General-Installing-Instructions.md)

3. Installing Cacti on Linux

   3.1. [Installation Under CentOS 7 - LAMP Stack](Install-Under-CentOS_LAMP.md)

   3.2. [Installation Under CentOS 7 - LEMP Stack](Install-Under-CentOS_LEMP.md)

   3.3. [Installation Under Ubuntu/Debian - LAMP Stack](Installing-Under-Ubuntu-Debian.md)

4. [Installing Under Windows](Installing-Under-Windows.md)

5. [Upgrading Cacti Under Linux/UNIX](Upgrading-Cacti.md)

6. [Upgrading Cacti Under Windows](Upgrading-Cacti-Under-Windows.md)

7. [Upgrading Cacti Under FreeBSD](Upgrading-Cacti-Under-FreeBSD.md)

### Cacti Overview

1. Overview

   1.1. [Navigating the User Interface](Navigating-The-User-Interface.md)

   1.2. [Principles of Operation](Principles-of-Operation.md)

   1.3. [Graph Overview](Graph-Overview.md)

   1.4. [How to Graph Your Network](How-to-Graph-Your-Network.md)

   1.5. [Viewing Graphs](Viewing-Graphs.md)

   1.6. [Graph a Single SNMP OID](Graph-a-Single-SNMP-OID.md)

2. Management

   2.1. [Devices](Devices.md)

   2.2. [Sites](Sites.md)

   2.3. [Trees](Trees.md)

   2.4. [Graphs](Graphs.md)

   2.5. [Data Sources](Data-Sources.md)

   2.6. [Aggregates](Aggregates.md)

3. Data Collection

   3.1. [Data Collectors](Data-Collectors.md)

   3.2. [Data Input Methods](Data-Input-Methods.md)

   3.3. [Data Queries](Data-Queries.md)

      3.3.1. [SNMP Data Queries Walkthrough](SNMP-Data-Queries-Walkthrough.md)

      3.3.2. [SNMP New Data Query Walkthrough](SNMP-New-Data-Query-Walkthrough.md)

      3.3.3. [Script Data Query Walkthrough](Script-Data-Query-Walkthrough.md)

4. [Templates](Templates.md)

   4.1. [Device](Device-Templates.md)

   4.2. [Graph](Graph-Templates.md)

   4.3. [Data Source](Data-Source-Templates.md)

   4.4. [Aggregate](Aggregate-Templates.md)

   4.5. [Color](Color-Templates.md)

5. [Automation](Automation.md)

   5.1. [Networks](Automation-Networks.md)

   5.2. [Discovered Devices](Discovered-Devices.md)

   5.3. [Device Rules](Device-Rules.md)

   5.4. [Graph Rules](Graph-Rules.md)

   5.5. [Tree Rules](Tree-Rules.md)

   5.6. [SNMP Options](SNMP-Options.md)

6. Presets

   6.1. [Data Profiles](Data-Profiles.md)

   6.2. [CDEFS](CDEFs.md)

   6.3. [VDEFS](VDEFs.md)

   6.4. [Colors](Colors.md)

   6.5. [GPRINTs](GPRINTs.md)

7. Import/Export

   7.1. [Import Templates](Import-Template.md)

   7.2. [Export Templates](Export-Template.md)

8. Configuration

   8.1. [Settings](Settings.md)

      8.1.1 [Authentication](Settings-Auth.md)

         8.1.1.1 [LDAP](Settings-Auth-LDAP.md)

   8.2. [Users](User-Management.md)

   8.3. [User Groups](User-Group-Management.md)

   8.4. [User Domains](User-Domains.md)

   8.5. [Plugins](Plugins.md)

9. Utilities

   9.1. [System Utilities](System-Utilities.md)

   9.2. [Data Debug](Data-Debug.md)

   9.3. [External Links](External-Links.md)

### Advanced Operations

1. Data Collection

   1.1. [How to Graph a Custom Collection Script](How-to-Graph-a-Custom-Collection-Script.md)

   1.2. [PHP Script Server](PHP-Script-Server.md)

   1.3. [Spine Data Collection](Spine.md)

   1.4. [Command Line Scripts](Command-Line-Scripts.md)

2. [Frequently Asked Questions](Frequently-Asked-Questions.md)

3. [Replacement Variables](Variables.md)

4. [RRDTool Specific Features](RRDTool-Specific-Features.md)

5. [RRDProxy Specific Features](RRDproxy.md)

6. [Spikekill](Spikekill.md)

7. [Debugging](Debugging.md)

8. [Version Specific Release Notes](Version-Specific-Release-Notes.md)

### Plugin Development

1. [Plugin Overview](Plugin-Development.md)

2. [Plugin Guidelines](Plugin-Guidelines.md)

3. [Creating Plugins](Plugin-Creating-Plugins.md)

4. [References](Plugin-Reference.md)

5. [Hook API Reference](Plugin-Hook-API-Ref.md)

### How Tos

1. [Determine template version](How-To-Determine-Template-Version.md)

2. [Using SSH Tunnels](How-To-SSH-Tunnels.md)

3. [Data Query Templates](How-To-Data-Query-Templates.md)

4. [How To Setup Remote Pollers](How-To-Setup-Remote-Pollers.md)

### Contributing

1. [Contributing](Contributing.md)

2. [Translations](Contributing-Translations.md)

### Development Standards

1. [Documentation](Standards-Documentation.md)

2. [Code Formatting](Standards-Code-Formatting.md)

3. [PHP Specific Constructs](Standards-PHP-Spec-Constructs.md)

4. [File System Layout](Standards-FileSystem-Layout.md)

5. [Patch Creation](Standards-Patch-Creation.md)

6. [SQL Standards](Standards-SQL.md)

7. [Security](Standards-Security.md)

---
Copyright (c) 2004-2020 The Cacti Group
