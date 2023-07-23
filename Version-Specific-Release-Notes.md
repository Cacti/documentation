# Version Specific Release Notes

## Summary

Below you will find the release note for all versions of Cacti 1.0.0 and above.
Release notes for earlier Cacti versions have been excluded due to the large
list of changes that have occurred over the years, and since Cacti 0.8.x is no
longer supported, it's a good time to for the purposes of this document, move
them aside.

Before that list, let's talks about Cacti 1.0.0 first.

## Cacti 1.0.0

This was the initial release of Cacti 1.x. With the release of Cacti 1.0.0 many
improvements and enhancements have been made. As part of ongoing efforts to
improve Cacti almost 20 plugins were merged into the core of Cacti eliminating
the need for the plugins. A major refresh of the interface has been started and
will continue to occur as development on Cacti continues.

### Plugins integrated into Cacti Core

The following plugins have been merged into the core Cacti code as of version
1.0.0:

| Plugin     | Description                                              |
| ---------- | -------------------------------------------------------- |
| snmpagent  | An SNMP Agent extension, trap and notification generator |
| clog       | Log viewers for administrators                           |
| settings   | Core plugin providing email and DNS services             |
| boost      | Large system performance boost plugin                    |
| dsstats    | Cacti data source statistics                             |
| watermark  | Watermark graphs                                         |
| ssl        | Force https connection                                   |
| ugroup     | User groups support                                      |
| domains    | Multiple authentication domains                          |
| jqueryskin | User interface skinning                                  |
| secpass    | C3 level password and site security                      |
| logrotate  | Log management                                           |
| realtime   | Realtime graphing                                        |
| rrdclean   | RRDfile maintenance                                      |
| nectar     | Email based graph reporting                              |
| aggregate  | Templating, creation and management of aggregate graphs  |
| autom8     | Graph and Tree creation automation                       |
| discovery  | Network Discovery and Device automation                  |
| spikekill  | Removes spikes from Graphs                               |
| superlinks | Allows administrators to links to additional sites       |

## ChangeLog for All Cacti 1.x Releases

The following shows the naming convention used for issues and features listed in the CHANGELOG for both cacti and it's plugins

| Category         | Description                                                                   |
| ---------------- | ----------------------------------------------------------------------------- |
| issue[issue#]    | Normal issues either experienced by a Developer or logged in GitHub and fixed |
| feature[issue#]  | Features either implemented or logged in GitHub and addressed                 |
| security[issue#] | Security vulnerability either fixed or logged in GitHub and addressed         |
| bug[bug#]        | Feature of Bug reported in the old Cacti Mantis system that was addressed.    |

Below are a few examples of the version, type and description that can be found in the CHANGELOG
| Version | Feature/Bug   | Description                                                                                                                      |
| ------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 1.2.17  | issue#3981    | PHP ERROR: Call to undefined function api_data_source_cache_crc_update()                                                         |
| 1.2.17  | feature#4013  | Remote Poller - reset avg/max polling time                                                                                       |
| 1.2.16  | issue#3704    | When generating a report, the Cascade to Branches function does not as expected                                                  |
| 1.2.16  | issue#3859    | When viewing graphs, automatic refresh so not always work as expected                                                            |
| 1.2.16  | feature       | Update Chart.js to version 2.9.4                                                                                                 |
| 1.2.16  | feature#3923  | Add ability to hide the Graph Drilldown icons by datatecuk                                                                       |
| 1.2.16  | feature#3943  | Add hooks for plugins to show custom Graph Source and custom Template URL (List View)                                            |
| 1.2.13  | security#3628 | Lack of escaping on template import can lead to XSS exposure                                                                     |
| 1.2.13  | issue#3517    | When generating reports, function looping can occur resulting in 100% cpu usage                                                  |

---

Copyright (c) 2004-2023 The Cacti Group
