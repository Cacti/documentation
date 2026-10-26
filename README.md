# Cacti (tm) Documentation

![Cacti](images/logo.svg)

Cacti collects measurements from network devices, servers, and applications
and uses RRDtool to store time-series data and display graphs. Use this manual
to install Cacti, configure monitoring, and keep your installation running.

**Version:** This manual follows **develop**, the unreleased Cacti 1.3 series.
For released Cacti 1.2 installations, use the [1.2.x manual][manual-1.2] and
the requirements supplied with your installed version.

## What Do You Want to Do

<a id="cacti-installation"></a>

- **[Install or upgrade Cacti](Manual-Index.md#install-or-upgrade-cacti)**:
  Check requirements, choose your platform, install, upgrade, and secure Cacti.

<a id="cacti-overview"></a>

- **[Create your first graphs](Manual-Index.md#create-your-first-graphs)**:
  Add a device, configure SNMP, create graphs, and verify data collection.
- **[Manage your installation](Manual-Index.md#manage-your-installation)**:
  Organize devices and graphs, automate discovery, manage access, and report.

<a id="advanced-operations"></a>

- **[Configure data collection](Manual-Index.md#configure-data-collection)**:
  Set up collectors, Spine, remote polling, scheduling, and performance.
- **[Create and reuse templates](Manual-Index.md#create-and-reuse-templates)**:
  Work with templates, data queries, and package import and export.
- **[Troubleshoot a problem](#troubleshoot-a-problem)**:
  Investigate missing data, failed SNMP queries, and polling errors.

## Getting Started

Follow this sequence for a new installation:

1. [Check requirements](Requirements.md).
2. [Install Cacti](General-Installing-Instructions.md) for your platform.
3. [Add a device and create its graphs](How-to-Graph-Your-Network.md).
4. [Verify data collection](Data-Debug.md) and check the
   [Cacti log](Cacti-Log.md).
5. [Secure the installation](Hardening-Cacti-Installation.md) before making
   it available to other users.

For the concepts behind these steps, read
[Principles of Operation](Principles-of-Operation.md). To find your way around
Cacti, use [Navigating the User Interface](Navigating-The-User-Interface.md).

## Troubleshoot a Problem

- **[Graphs have no data](Data-Debug.md)**: Check polling and RRD updates.
- **[Find errors in the log](Cacti-Log.md)**: Inspect collection and system
  logs.
- **[Investigate SNMP and graph failures](Debugging.md)**: Follow the debugging
  guide for polling and rendering problems.
- **[Common questions and polling problems](Frequently-Asked-Questions.md)**:
  Find answers about SNMP, scheduling, password recovery, and graph errors.

<a id="known-issues"></a>

- **[Known issues](Known-Issues.md)**: Check documented limitations and where
  to report a problem.

## Manual and Reference

<a id="table-of-contents"></a>
<a id="how-tos"></a>
<a id="template-specific-documentation"></a>
<a id="device-template-specific-documentation"></a>

Browse the **[complete manual index](Manual-Index.md)** for every guide,
including procedures grouped with their related subjects.

For offline reading and runnable query examples, see
[PDF manuals and example downloads](Downloads.md).

Use the [settings reference](Manual-Index.md#settings-reference),
[command-line scripts](Command-Line-Scripts.md), and
[graph and data reference](Manual-Index.md#graph-and-data-reference) when you
need a particular option, command, variable, or graph expression. Check
[release notes](Version-Specific-Release-Notes.md) for version-specific changes.

## Extend and Contribute

<a id="plugins"></a>
<a id="plugin-development"></a>

- **[Use and develop plugins](Manual-Index.md#plugins)**: Install extensions or
  find plugin guidelines, hooks, and references.

<a id="contributing"></a>

- **[Contribute to Cacti](Contributing.md)**: Report bugs, improve code or
  documentation, and [help translate Cacti](Contributing-Translations.md).

<a id="development-standards"></a>

- **[Development standards](Manual-Index.md#development-standards)**: Follow
  the documentation, PHP, SQL, and security conventions for your target branch.

<a id="architecture-decisions"></a>

- **[Architecture decisions](Architecture-Decisions.md)**: Read proposals and
  accepted decisions guiding development.

<a id="video-tutorials"></a>

- **[Video tutorials][videos]**: Watch tutorials on the official Cacti channel.
  Check the demonstrated version against your installation.

## Project Information

<a id="core-developers---both-active-and-emeritus"></a>
<a id="active-developers"></a>
<a id="contributors"></a>
<a id="emeritus-members"></a>
<a id="thanks"></a>

See [project credits, acknowledgments, and licensing](Project-Information.md).
For downloads and news, visit the [Cacti website](https://www.cacti.net/).
For community support, use the [Cacti Forums](https://forums.cacti.net/).

[manual-1.2]: https://github.com/Cacti/documentation/tree/1.2.x
[videos]: https://www.youtube.com/channel/UC6ROmUGuuLa9BdHWzvGSY1w

---

Copyright (c) 2004-2026 The Cacti Group
