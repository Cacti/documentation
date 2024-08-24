# Cacti (tm) Documentation

![Cacti](images/logo.svg)

Cacti is designed to be a complete graphing solution based on the RRDtool's
framework. Its goal is to make a network administrator's job easier by taking
care of all the necessary details necessary to create meaningful graphs.

Please see the official Cacti website for information, support, and updates.

## Core Developers - Both active and emeritus

- Larry Adams (TheWitness, Active)
- Mark Brugnoli-Vinten (netniV, Active)
- Jimmy Conner (cigamit, Active)
- Andreas Braun (browniebraun, Active)
- J.P. Pasnak, CD (Linegod, Active)

- Tony Roman (rony, Emeritus)
- Reinhard Scheck (gandalf, Emeritus)
- Ian Berry (raX, Founder, Emeritus)

## Thanks

A very special thanks to Tobi Oetiker, the creator of RRDtool and the very
popular MRTG. The users of Cacti - especially anyone who has taken the time to
create a bug report, or otherwise help fix a Cacti related problem. Also to
anyone who has contributed to supporting Cacti.

Cacti is licensed under the GNU GPL:

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

## Table of Contents

1. [Cacti Installation](README.md#cacti-installation)

   This section contains information on how to install and/or upgrade the Cacti
   system. It covers requirements, different platforms and the steps needed to
   get your system working under normal circumstances.

2. [Cacti Overview](README.md#cacti-overview)

   This section describes Cacti components and their purpose as well as
   providing examples including on how to create **Templates** in Cacti.

3. [Advanced Operations](README.md#advanced-operations)

   This section covers more advanced material such as using a advanced data
   collection and replacement variables that can be used within **Templates**,
   etc.

4. [Plugin Development](README.md#plugin-development)

   This section contains all Plugin development related information. Guidelines,
   hooks, references, etc. More information can be found on the
   [Cacti Forums](https://forums.cacti.net/viewforum.php?f=6).

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

[List of Known issues](Known-Issues.md)

### Cacti Installation

1. [Requirements](Requirements.md)

2. [General Installing Instructions](General-Installing-Instructions.md)

3. Installing Cacti on Linux

   3.1. [Installation Under CentOS 7 - LAMP Stack](Install-Under-CentOS_LAMP.md)

   3.2. [Installation Under CentOS 7 - LEMP Stack](Install-Under-CentOS_LEMP.md)

   3.3.
   [Installation Under Ubuntu/Debian - LAMP Stack](Installing-Under-Ubuntu-Debian.md)

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

2. Management

   2.1. [Devices](Devices.md)

   2.2. [Sites](Sites.md)

   2.3. [Trees](Trees.md)

   2.4. [Graphs](Graphs.md)

   2.5. [Data Sources](Data-Sources.md)

   2.6. [Aggregates](Aggregates.md)

3. Data Collection

   3.1. [Data Collectors](Data-Collectors.md)

   3.2. [Spine Data Collection](Spine.md)

   3.3. [Data Input Methods](Data-Input-Methods.md)

   3.4. [Data Queries](Data-Queries.md)

4. [Templates](Templates.md)

   4.1. [Device](Device-Templates.md)

   4.2. [Graph](Graph-Templates.md)

   4.3. [Data Source](Data-Source-Templates.md)

   4.4. [Aggregate](Aggregate-Templates.md)

   4.5. [Color](Color-Templates.md)

5. Automation

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

8. [Settings (w/o Auth)](Settings.md)

   8.1. [General](Settings-General.md)

   8.2. [Paths](Settings-Paths.md)

   8.3. [Device Defaults](Settings-Device-Defaults.md)

   8.4. [Poller](Settings-Poller.md)

   8.5. [Data](Settings-Data.md)

   8.6. [Visual](Settings-Visual.md)

   8.7. [Performance](Settings-Performance.md)

   8.8. [Spikes](Settings-Spikes.md)

   8.9. [Mail/Reporting/DNS](Settings-Mail-Reporting-DNS.md)

9. [Settings - Auth](Settings-Auth.md)

   9.1. [Local Auth](Settings-Auth-Local.md)

   9.2. [LDAP Auth](Settings-Auth-LDAP.md)

   9.3. [Basic Auth](Settings-Auth-Basic.md)

   9.4. [Domains Auth](Settings-Domains.md)

10. [Configuration - Users, Groups and Domains](Settings-Users-Groups-Domains.md)

    10.1. [Users](User-Management.md)

    10.2. [User Groups](User-Group-Management.md)

    10.3. [User Domains](User-Domains.md)

11. [Configuration - Plugins](Plugins.md)

12. Utilities

    12.1. [System Utilities](System-Utilities.md)

    12.2. [Data Debug](Data-Debug.md)

    12.3. [External Links](External-Links.md)

13. Reporting

    13.1. [Reports Admistrative Interface](Reports-Admin.md)

    13.2. [Reports User Interface](Reports-User.md)

    13.3. [Report Items Page](Reports-Items.md)

    13.4. [Report Preview Page](Reports-Preview.md)

    13.5. [Report Events Page](Reports-Events.md)

    13.6. [Other Options for Adding Report Items](Reports-Other-Options.md)

14. [The Cacti Log](Cacti-Log.md)

### Advanced Operations

1. Data Collection

   1.1. [Command Line Scripts](Command-Line-Scripts.md)

   1.2. [PHP Script Server](PHP-Script-Server.md)

   1.3. [Spine Data Collection](Spine.md)

   1.4. [Performance Setting (Boost)](Boost.md)

2. [Frequently Asked Questions](Frequently-Asked-Questions.md)

3. [Replacement Variables](Variables.md)

4. [RRDtool Specific Features](RRDtool-Specific-Features.md)

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

### Plugin Documentation

1.[Syslog Plugin](syslog-plugin.md)

### How Tos

1. [How To Work with Templates](How-To-Work-With-Templates.md)

2. [How To Create a Data Input Method](How-To-Create-Data-Input-Method.md)

3. [How To Work with Data Queries](How-To-Data-Queries.md)

4. [How To Work with Existing SNMP Data Queries](How-To-Existing-SNMP-Data-Queries.md)

5. [How To Work with New SNMP Data Queries](How-To-New-SNMP-Data-Queries.md)

6. [How To Work with Script Data Queries](How-To-Script-Data-Queries.md)

7. [How To Setup Remote Pollers](How-To-Setup-Remote-Pollers.md)

8. [How To Determine Template Version](How-To-Determine-Template-Version.md)

9. [How To Setup SSH Tunnels](How-To-SSH-Tunnels.md)

10.[Enable SSL for Cacti](Cacti-SSL-Configuration.md)

11.[Graph a Single SNMP OID](Graph-a-Single-SNMP-OID.md)

12.[Change poller interval from 5 minutes to 1 minute ](How-To-Poller-5-to-1-min.md)

13.[Convert from Package based install to source on Ubuntu/Debian](convert-from-package-to-source-debian-ubuntu.md)

### Video Tutorials

Watch Howto's and Tutorials on the Cacti Official YouTube page if you prefer. If you would have any ideas for videos or would like to contribute let us know !

[Cacti Official Youtube Channel](https://www.youtube.com/channel/UC6ROmUGuuLa9BdHWzvGSY1w)

### Contributing

1. [Open Source Code](Contributing.md)

2. [Language Translations](Contributing-Translations.md)

### Development Standards

1. [Documentation](Standards-Documentation.md)

2. [Code Formatting](Standards-Code-Formatting.md)

3. [PHP Specific Constructs](Standards-PHP-Spec-Constructs.md)

4. [File System Layout](Standards-FileSystem-Layout.md)

5. [Patch Creation](Standards-Patch-Creation.md)

6. [SQL Standards](Standards-SQL.md)

7. [Security](Standards-Security.md)

### Template Specific Documentation

This section will be for template specific configuration requriments

1. [Apache Server Template](apache_template_config.md)

---

Copyright (c) 2004-2024 The Cacti Group
