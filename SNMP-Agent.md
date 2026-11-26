# SNMP Agent and Notification Receivers

The SNMP Agent support in Cacti keeps a cache of Cacti device, poller and
system information as SNMP objects, and sends SNMP notifications about Cacti
events to the receivers you register.  This page follows **develop**, the
unreleased Cacti 1.3 series; labels and defaults are those of the development
source.

## Enable SNMP Agent Support

Under **Console > Configuration > Settings**, on the
[Device Defaults](Settings-Device-Defaults.md) tab, the **SNMP Behavior**
section has the setting **SNMP Agent Support Enabled**.  It is checked by
default.  When checked, Cacti populates the SNMP Agent tables with Cacti device
and system information.  It does not enable an SNMP Agent service itself.
When the setting is unchecked, the cache tables are emptied at the end of the
next polling cycle.

Notifications are sent with the Net-SNMP `snmptrap` program.  Set its location
in **snmptrap Binary Path** on the [Paths](Settings-Paths.md) tab.

## The SNMP Agent Cache

The cache is built from the three MIB files in the `mibs` directory of the
Cacti installation:

| MIB file            | Content                                                   |
| ------------------- | --------------------------------------------------------- |
| CACTI-MIB           | Cacti settings, device, poller and plugin tables, statistics, and the event notifications |
| CACTI-SNMPAGENT-MIB | The `snmpagentNotificationTest` notification, which can be used to verify the configuration of SNMP managers |
| CACTI-BOOST-MIB     | Boost settings and statistics                             |

The Cacti objects are registered below the enterprise OID
`.1.3.6.1.4.1.23925`.  Plugins can add their own MIBs to the cache.

The main **Data Collector** refreshes the cached values at the end of each
polling cycle.  Under **Console > Utilities > System Utilities**, the
**SNMP Agent Utilities** section, shown only while SNMP Agent support is
enabled, provides:

- **View SNMP Agent Cache** - Lists the cached objects with their **OID**,
  **Name**, **MIB**, **Type**, **Max-Access** and **Value**.  The list can be
  filtered by MIB.
- **Rebuild SNMP Agent Cache** - Empties the cache tables and loads the MIB
  files again.  It takes another polling cycle to restore the values
  completely.
- **View SNMP Agent Notification Log** - Lists the notifications sent to all
  receivers with their **Time**, **Receiver**, **Notification** and
  **Varbinds**, and can purge that log.

## Serve the Cache to SNMP Managers

The Cacti web interface and poller do not answer SNMP requests.  The cache is
exposed by the persistent script `snmpagent_persist.php` in the Cacti base
directory.  Its help text describes it as the daemon for the Cacti SNMP Agent,
to be launched with `systemctl` and defined as a persistent service.  The
script reads requests from standard input and answers on standard output:

| Request   | Reply                                                          |
| --------- | -------------------------------------------------------------- |
| `PING`    | `PONG`                                                         |
| `get`     | The OID, type and value of the OID on the next line, or `NONE` |
| `getnext` | The OID, type and value of the next accessible OID, or `NONE`  |

When it starts, the script launches `snmpagent_mibcache.php` if it is not
already running.  That process starts `snmpagent_mibcachechild.php` every 30
seconds, which writes the cache table to the file `mibcache/mibcache.tmp` under
the Cacti cache path whenever the table has changed.  The persistent script
answers from that file.

The development source does not include a service unit or an SNMP daemon
configuration example for this script, so this page does not give one.

## Notification Receivers

A notification receiver is an SNMP manager that Cacti sends notifications to.
Open **Console > Utilities > SNMP Managers**; the page is titled
**SNMP Notification Receivers** and requires the **Settings/Utilities**
permission.  The list shows each receiver's **Description**, **Id**,
**Status**, **Hostname**, and its number of **Notifications** and **Logs**.
The action drop-down offers **Delete**, **Disable** and **Enable**.

Add a receiver from the list, or select one to edit it.  A receiver has three
tabs: **General**, **Notifications** and **Logs**.  The last two are available
after the receiver has been saved.

### General

| Field                              | Purpose                                 | Default       |
| ---------------------------------- | --------------------------------------- | ------------- |
| Description                        | A meaningful description of this SNMP entity | Empty    |
| Hostname                           | Fully qualified hostname or IP address of the receiver | Empty |
| Disable SNMP Notification Receiver | Check to temporarily stop sending notifications to this host | Unchecked |
| Maximum Log Size                   | The number of days, 1 to 31, of notification log entries to keep for this receiver | 31 |
| SNMP Message Type                  | `NOTIFICATIONS` or `INFORMS`            | NOTIFICATIONS |
| Notes                              | Free text notes for this host           | Empty         |

The **SNMP Options** section holds the same SNMP fields as a **Device**, such
as **SNMP Version**, **SNMP Community String**, **SNMP Port** and the SNMPv3
credentials.  Their defaults come from the
[Device Defaults](Settings-Device-Defaults.md).  For SNMPv3, the
**SNMP Engine ID (v3)** is required.

SNMP traps are always unacknowledged.  To send acknowledged notifications,
called INFORMS, the receiver must use SNMP version 2 or 3.

### Notifications

The **Notifications** tab lists the notification objects in the cache, with
their **Name**, **OID**, **MIB**, **Kind**, **Max-Access** and whether they are
**Monitored**.  Select the notifications that this receiver should get and
choose **Enable** from the action drop-down; **Disable** stops forwarding them.
A receiver gets no notifications until at least one is enabled here.

Cacti itself raises these notifications from `CACTI-MIB`:

| Notification                      | Sent when                                    |
| --------------------------------- | -------------------------------------------- |
| cactiNotifyDeviceDown             | A monitored **Device** went down             |
| cactiNotifyDeviceRecovering       | A monitored **Device** became reachable again |
| cactiNotifyDeviceFailedPoll       | Cacti was unable to poll a **Device**        |
| cactiNotifyPollerRuntimeExceeding | A Cacti poller has breached its maximum runtime |

The three device notifications are evaluated at the end of each polling cycle,
and are not sent for a **Device** that a plugin reports as being in
maintenance.  `cactiNotify` is a generic notification that carries only a
description and can be used by plugins.

### Logs

The **Logs** tab lists the notifications sent to this receiver, with their
**Time**, **Notification** and **Varbinds**, colored by severity (low, medium,
high or critical).  It can be filtered by **Severity**, and **Purge** empties
the log of this receiver.  Entries older than the receiver's
**Maximum Log Size** are removed at the end of each polling cycle.

## Limits

- If an event has no enabled receiver, Cacti writes a notice to the Cacti log
  instead of sending anything.  For events below high severity, the notice is
  written once per process.
- A notification is not sent when the event is not present in the cache, or
  when the caller does not supply all the varbinds that the MIB defines for
  it.  Both cases are logged as errors.
- Messages from the SNMP Agent code are written to the Cacti log with the
  `SNMPAGENT` facility.  The `snmptrap` command line is logged at the MEDIUM
  log level, with passwords masked.

---

Copyright (c) 2004-2026 The Cacti Group
