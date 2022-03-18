# Command Line Scripts (CLI)

Cacti supports a number of command line scripts. You will find them in the
`./cli` directory.  The CLI scripts fall into multiple categories, they include:

- **Automation** - Utilities to help automate adding objects to Cacti
- **Maintenance** - Utilities to help keep Cacti healthy
- **Repair** - Utilities to help with repairing Cacti database components
- **Repair/Migration** - Utilities to help with repairing or migrating Cacti components
- **Install/Upgrade** - Utilities to help with installing and upgrading Cacti

In the table below, each of the CLI scripts are categories and explained
briefly.

## Automation Scripts

Script | Category | Description
--- | --- | ---
add_device.php | Automation | Allows adding a Device to Cacti.  Most device options are included.  Some plugin options may not.
add_data_query.php | Automation | Allows adding a Data Query to Cacti.
add_graph_template.php | Automation | Allows adding a Graph Template to Cacti.
add_graphs.php | Automation | Allows adding a Graph to Cacti.
add_perms.php | Automation | Allows adding permissions to Cacti.
add_tree.php | Automation | Allows adding tree's tree branches and objects to Cacti Trees.
copy_user.php | Maintenance | Allows creating new users from Templates

## Maintenance Scripts

Script | Category | Description
--- | --- | ---
input_whitelist.php | Maintenance | To to onboard new Data Input Methods when using Cacti in a high security environment where new Data Input Methods must always be vetted before enabling for general use.
poller_graphs_reapply_names.php | Maintenance | Allows selecting re-running of Cacti's suggested values engine for Graphs
poller_reindex_hosts.php | Maintenance | Batch method to re-index Cacti Devices
analyze_database.php | Maintenance | Analyzes all Cacti tables rebuilding their index cardinality.  Important to run after having added large numbers of Devices and Graphs to Cacti.

## Repair Scripts

Script | Category | Description
--- | --- | ---
poller_output_empty.php | Repair | Removes bad entries from Cacti's poller output table.
rebuild_poller_cache.php | Repair | Batch process to re-populate Cacti's poller cache.  NOTE: This script can run for a very long time on large systems.
repair_database.php | Repair | Utility to look for common problems with old Cacti databases where objects were removed while still in use.  Also rapairs all tables after a system crash.
repair_graphs.php | Repair | Utility to repair Cacti Graphs whose structure is damaged due to legacy Cacti behavior.
repair_templates.php | Repair | Utility to repair Cacti Templates whose structure was damaged due to legacy Cacti behavior.

## Repair/Migration Scripts

Script | Category | Description
--- | --- | ---
audit_database.php | Repair/Migration | Script to audit your Cacti schema, and repair any tables that don't match the stock Cacti schema.  It will also upgrade the Cacti schema and run plugin upgrade functions.  This is a good migration tool to move database from old versions of Cacti.
convert_tables.php | Repair/Migration | Convert all tables from their current form to the Cacti preferred table type, collation and charset
splice_rra.php | Migration | Utility that allows two RRDfiles to be merged, and also assists with resampling an old RRDfile to a new RRA configuration, for example moving a Cacti system from 5 minute polling to 1 minute polling.

## Install/Upgrade Scripts

Script | Category | Description
--- | --- | ---
import_package.php | Install/Upgrade | Import a Cacti package from a tgz file.
install_cacti.php | Install/Upgrade | Script to install Cacti from a raw schema.  Used primarily by distribution maintainers.
md5sum.php | Install/Upgrade | Utility to verify the MD5SUM of a file.
sqltable_to_php.php | Install/Upgrade | Utility for Plugin Developers to create an object for creating tables in plugins.
structure_rra_paths.php | Install/Upgrade | Utility to convert a system from a flat directory path to a heirarchial one.  Important for certain file systems that don't perform well when there are tens or hundreds of thousands of files in a single directory.
upgrade_database.php | Install/Upgrade | Utility to upgrade a Cacti database from a point in time to the current release.  Or even rerun the database upgrade from a point in the past to catch up with changes.  This script should be used in conjunction with the `audit_database.php --repair --upgrade` option.

> **NOTE**: Package maintainers may wish to utilize the CLI methods of install_cacti.php and
> upgrade_database.php to perform in place installations and upgrades.

> **Caution**: In the following examples, several numbers are shown as output from various
> scripts. They will vary between different installations. So don't bother, if
> your numbers will vary.

In the sub-sections below, we will demonstrate the use of a few of these CLI scripts.

## Rebuild Poller Cache

The poller cache holds all commands that cacti will issue during the polling
process in an internal format. It is possible, to review the current contents
of the poller cache by visiting `System Utilities`, `View Poller Cache`. It is
possible to apply filters to this view; it will show up like

```console
Localhost - Hard Drive Space    Script Server: /var/www/html/cacti/scripts/ss_host_disk.php ss_host_disk 127.0.0.1 1 1:161:500:somesecret:::::: get total 6
                                RRD: /var/www/html/cacti/rra/localhost_hdd_total_61.rrd
Localhost - Load Average        Script: /usr/bin/perl /var/www/html/cacti/scripts/loadavg_multi.pl
                                RRD: /var/www/html/cacti/rra/localhost_load_1min_5.rrd
Localhost - Logged in Users     Script: /usr/bin/perl /var/www/html/cacti/scripts/unix_users.pl
                                RRD: /var/www/html/cacti/rra/localhost_users_6.rrd
Localhost - Memory - Free       Script: /usr/bin/perl /var/www/html/cacti/scripts/linux_memory.pl MemFree:
                                RRD: /var/www/html/cacti/rra/localhost_mem_buffers_3.rrd
Localhost - Memory - Free Swap  Script: /usr/bin/perl /var/www/html/cacti/scripts/linux_memory.pl SwapFree:
                                RRD: /var/www/html/cacti/rra/localhost_mem_swap_4.rrd
Localhost - mtaReceivedMessages SNMP Version: 1, Community: somesecret, OID: .1.3.6.1.2.1.28.1.1.1.1
                                RRD: /var/www/html/cacti/rra/localhost_mtareceivedmessages_47.rrd
Localhost - mtaReceivedVolume   SNMP Version: 1, Community: somesecret, OID: .1.3.6.1.2.1.28.1.1.4.1
                                RRD: /var/www/html/cacti/rra/localhost_mtareceivedvolume_49.rrd
```

There are several circumstances, that may result in the poller cache being out
of sync. An example would be a change of the name of a script used in a `Data
Input Method`. This change is *not* automatically propagated to the poller
cache. It is required, to run `php -q rebuild poller_cache.php` manually.

Calling the script with the parameter `--help` yields

```console
shell>php -q rebuild_poller_cache.php --help
Cacti Rebuild Poller Cache Script 1.0, Copyright 2004-2018 - The Cacti Group

usage: rebuild_poller_cache.php [-d] [-h] [--help] [-v] [--version]

-d            - Display verbose output during execution
-v --version  - Display this help message
-h --help     - Display this help message
```

Debug mode lists the data sources items that are worked upon.

```console
shell>php -q rebuild_poller_cache.php -d
WARNING: Do not interrupt this script.  Rebuilding the Poller Cache can take quite some time
DEBUG: There are '38' data source elements to update.
DEBUG: Data Source Item '1' of '38' updated
DEBUG: Data Source Item '2' of '38' updated
DEBUG: Data Source Item '3' of '38' updated
DEBUG: Data Source Item '4' of '38' updated
....
```

Without any parameter, some dots are shown as progress indicators.

```console
shell>php -q rebuild_poller_cache.php
WARNING: Do not interrupt this script.  Rebuilding the Poller Cache can take quite some time
......................................
shell>
```

> **Caution**
>
> Rebuilding the poller cache interferes with the poller operation. Make sure
> that the poller is not running and will not start during a rebuild operation

## Re-Index Hosts

Re-Indexing is required only for SNMP/Script Data Queries. Remember, that when
applying a Data Query to a Host, a `Re-Index Method` has to be chosen. This
reindex method governs the automatic re-indexing based on specific events.

###### Table 20-1. Re-Index Methods

Re-Index Method | Description
--- | ---
Uptime Goes Backwards | Refers to a system reboot
Index Count Changed | Refers to a change of the number of indexed items
Verify All Fields | All index fields of the according XML file are checked for changes

If the method is set to `Uptime Goes Backwards`, Cacti will detect if the
target has been rebooted by querying sysUptime (.1.3.6.1.2.1.1.3.0). If
the current value for the uptime is lower than the previous one (uptime
goes backwards), a reboot is assumed and a re-index is performed

If the method is set to `Index Count Change`, e.g. the number of interfaces,
without checking sysUptime. It is of particular interest in cases, where
indexed entries may change without the need of a reboot. As modern operating
systems seldom require reboots for system configuration changes, you may want
to consider this setting for many cases (e.g. creating of a new filesystem
without a reboot). The index to be considered is defined by the according
XML file.

If the method is set to `Verify All Fields`, all indexes of the data source
are checked for changes.  This is of particular interest e.g. in cases,
where the index is non-numeric (e.g. a MAC address).  It should be noted that
in the 1.0 and 1.1 releases, this method was found to be broken and has been
corrected since 1.2.

If you feel the need for manual re-indexing, you may run it from CLI. Calling
the script with the parameter `--help` yields

```console
shell>php -q poller_reindex_hosts.php --help
Cacti Reindex Host Script 1.2, Copyright 2004-2018 - The Cacti Group

usage: poller_reindex_hosts.php --id=[host_id|All] [--qid=[ID|All]] [--host-descr=[description]]
                           [-d] [-h] [--help] [-v] [--version]

--id=host_id             - The host_id to have data queries reindexed or 'All' to reindex all hosts
--qid=query_id           - Only index on a specific data query id; defaults to 'All'
--host-descr=description - The host description to filter by (SQL filters acknowledged)
--debug                  - Display verbose output during execution
-v --version             - Display this help message
-h --help                - Display this help message
```

Running it in debug mode for the host with `id=2` may yield

```console
shell>php -q poller_reindex_hosts.php -id=2 -d
WARNING: Do not interrupt this script.  Reindexing can take quite some time
DEBUG: There are '1' data queries to run
DEBUG: Data query number '1' host: '2' SNMP Query Id: '1' starting
DEBUG: Data query number '1' host: '2' SNMP Query Id: '1' ending
```

A silent run for all devices is issued by

```console
shell>php -q poller_reindex_hosts.php -id=All
WARNING: Do not interrupt this script.  Reindexing can take quite some time
.....shell>
```

You may run this script against a specific data query id using
`--qid=[data query id]` like

```console
shell>php -q poller_reindex_hosts.php --id=All --qid=1 -d
WARNING: Do not interrupt this script.  Reindexing can take quite some time
DEBUG: There are '3' data queries to run
DEBUG: Data query number '1' host: '1' SNMP Query Id: '1' starting
DEBUG: Data query number '1' host: '1' SNMP Query Id: '1' ending
DEBUG: Data query number '2' host: '2' SNMP Query Id: '1' starting
DEBUG: Data query number '2' host: '2' SNMP Query Id: '1' ending
DEBUG: Data query number '3' host: '15' SNMP Query Id: '1' starting
DEBUG: Data query number '3' host: '15' SNMP Query Id: '1' ending
```

It is possible, to select a host based on its host description using
`--host-descr=[host description]`. It is allowed to apply an SQL filter
expression for the description like `--qid=some%descr`. Use this parameter in
conjunction with either `--id=[host id]` or `--qid=[data query id]` or both:

```console
shell>php -q poller_reindex_hosts.php --id=All --qid=1 --host-descr=ga%f -d
WARNING: Do not interrupt this script.  Reindexing can take quite some time
DEBUG: There are '1' data queries to run
DEBUG: Data query number '1' host: '2' SNMP Query Id: '1' starting
DEBUG: Data query number '1' host: '2' SNMP Query Id: '1' ending
```

> **Caution**
>
> Re-Indexing interferes with the poller operation. Make sure that the
> poller is not running and will not start during a reindex operation

## Empty Poller Output Table

During normal poller operation, all retrieved results are intermediately
stored in the table named poller_output After execution of cmd.php or
Spine, this table holds all results. The poller.php finally issues all
rrdtool update operations. Thus, after polling has completed, the table
should be empty.

Conditions may arise, where the table is not (completely) emptied. The most
often known issue is lack of php memory. In those cases, the table is bigger
than the php memory size, thus not all items are handled correctly. If that
issue occurs, you may save all pending updates *after increasing PHP memory
appropriately* by running this very script. Calling the script with the
parameter `--help` yields

```console
shell>php -q poller_output_empty.php --help
Cacti Empty Poller Output Table Script 1.0, Copyright 2004-2018 - The Cacti Group

usage: poller_output_empty.php [-h] [--help] [-v] [--version]

-v --version  - Display this help message
-h --help     - Display this help message
```

You see, no parameter is required for operating successfully. Under normal
circumstances, running this script should yield

```console
shell>php -q poller_output_empty.php
There were 0, RRD updates made this pass
shell>
```

In case, you hit the poller process or if the table was really not fully
processed, you may find

```console
shell>php -q poller_output_empty.php
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.04
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.00 r:0.05
OK u:0.00 s:0.01 r:0.06
There were 21, RRD updates made this pass
shell>
```

If logging level verbosity was switched to `DEBUG` you may find
additional debug messages that usually show up in `cacti.log`

## Reapply Suggested Names to Graphs

For a general understanding of suggested names used with data queries,
please see ?. Be aware, that changes to the `Suggested Names` section of
a data query will not automatically be propagated to all existing graphs.
This is, where poller_graphs_reapply_names.php drops in. Calling the
script with the parameter `--help` yields

```console
shell>php -q poller_graphs_reapply_names.php --help
Cacti Reapply Graph Names Script 1.0, Copyright 2004-2018 - The Cacti Group

usage: poller_graphs_reapply_names.php -id=[host_id|All][host_id1|host_id2|...] [-s=[search_string] [-d] [-h] [--help] [-v] [--version]

-id=host_id   - The host_id or 'All' or a pipe delimited list of host_id's
-s=search_str - A graph template name or graph title to search for
-d            - Display verbose output during execution
-v --version  - Display this help message
-h --help     - Display this help message
```

Assume a situation, where the suggested names where changed for the standard
data query named `SNMP - Get Mounted Partitions`. In this case, you will want to
rework all graphs for this data query only. A verbose run will yield

```console
shell>php -q poller_graphs_reapply_names.php -id=All -d -s="Used space"
WARNING: Do not interrupt this script.  Interrupting during rename can cause issues
DEBUG: There are '6' Graphs to rename
DEBUG: Graph Name 'Localhost - Used Space - Memory Buffers' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - Memory Buffers'
DEBUG: Graph Name 'Localhost - Used Space - Real Memory' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - Real Memory'
DEBUG: Graph Name 'Localhost - Used Space - Swap Space' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - Swap Space'
DEBUG: Graph Name 'Localhost - Used Space - /' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - /'
DEBUG: Graph Name 'Localhost - Used Space - /sys' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - /sys'
DEBUG: Graph Name 'Localhost - Used Space - /boot' starting
DEBUG: Graph Rename Done for Graph 'Localhost - Used Space - /boot'
```

Notice the miss-spelling of the word “Space”. The `-s=` option is not case
sensitive.

## Copy Local Cacti Users

For use and understanding the limitation of this script, it is of importance to
read [User Management](User-Management.md)

Calling the script with the parameter `--help` yields

```console
shell>php -q copy_user.php --help
Cacti Copy User Utility, Version 1.2.0, Copyright (C) 2004-2018 The Cacti Group
usage: copy_cacti_user.php <template user> <new user>

A utility to copy on local Cacti user and their settings to a new one.

NOTE: It is highly recommended that you use the web interface to copy users as
this script will only copy Local Cacti users.
```

Now let's create a new user Harry Potter as follows

```console
shell>php -q copy_user.php guest "Harry Potter"
Template User: guest
New User:      Harry Potter

Copying User...
User copied...
```

Find the results of this program call at User Management

User Name\*\* | Full Name | Enabled | Realm | Default Graph Policy | Last Login
--- | --- | --- | --- | --- | ---
admin | Administrator | Yes | Local | ALLOW | Sunday, October 07, 2007 14:59:32
guest | Guest Account | Yes | Local | ALLOW | N/A
Harry Potter | Guest Account | Yes | Local | ALLOW | N/A

## Add a New Device

While it is an easy task to add a new device from the panels, this would be a
tedious task for creating dozens of hundreds of devices in one turn. This is,
where the script `add_device.php` comes in. First, let's have a look at the
whole list of features it provides. Calling the script with the parameter
`--help` yields

```console
shell>php -q add_device.php --help
Add Device Script 1.0, Copyright 2004-2018 - The Cacti Group

A simple command line utility to add a device in Cacti

usage: add_device.php --description=[description] --ip=[IP] --template=[ID] [--notes="[]"] [--disable]
        [--avail=[ping]] --ping_method=[icmp] --ping_port=[N/A, 1-65534] --ping_retries=[2]
        [--version=[1|2|3]] [--community=] [--port=161] [--timeout=500]
        [--username= --password=] [--authproto=] [--privpass= --privproto=] [--context=]
        [--quiet]

    Required:
        --description  the name that will be displayed by Cacti in the graphs
        --ip           self explanatory (can also be a FQDN)
    Optional:
        --template     0, is a number (read below to get a list of templates)
        --notes        '', General information about this host.  Must be enclosed using double quotes.
        --disable      0, 1 to add this host but to disable checks and 0 to enable it
        --avail        pingsnmp, [ping][none, snmp, pingsnmp]
        --ping_method  tcp, icmp|tcp|udp
        --ping_port    '', 1-65534
        --ping_retries 2, the number of time to attempt to communicate with a host
        --version      1, 1|2|3, snmp version
        --community    '', snmp community string for snmpv1 and snmpv2.  Leave blank for no community
        --port         161
        --timeout      500
        --username     '', snmp username for snmpv3
        --password     '', snmp password for snmpv3
        --authproto    '', snmp authentication protocol for snmpv3
        --privpass     '', snmp privacy passphrase for snmpv3
        --privproto    '', snmp privacy protocol for snmpv3
        --context      '', snmp context for snmpv3

    List Options:
        --list-host-templates
        --list-communities
        --quiet - batch mode value return
```

Wow, that's quite a lot of options. To better understand it's use, let's first
stick to the listing options

### List all Host Templates

```console
shell>php -q add_device.php --list-host-templates

Valid Host Templates: (id, name)
1       Generic SNMP-enabled Host
3       ucd/net SNMP Host
4       Karlnet Wireless Bridge
5       Cisco Router
6       Netware 4/5 Server
7       Windows 2000/XP Host
8       Local Linux Machine
```

Why are those `Host Templates` of such importance for this script? Well, when
using this script to add a new device, there are 3 required parameters. The
`description` and the `device ip address` are of course left to you. But for
assigning the correct `Host Template Id`, you should first know the correct id
of that very parameter. For the purpose of this chapter we assume to add a
device that will be associated to a `ucd/net SNMP Host`, so the id of `3` is
required.

If you do not want to associate the host to any `Host Template Id`, known as
host template None, either provide the parameter `--template=0` or omit this
parameter.

### List all Community Strings

```console
shell>php -q add_device.php --list-communities

Known communities are: (community)
    public
    snmp-get
```

Of course, your list will vary

### Create a New Device

Now, let's set up the most basic command to add a new device. The description
shall be `"Device Add Test"`, the ip will be given as a FQDN,
`router.mydomain.com`. As a SNMP enabled device, surely a community string has
to be provided; in this case given as `public`. In total, this makes the
following command

```console
shell>php -q add_device.php --description="Device Add Test" --ip="router.mydomain.com" --template=3 --community="public"

Adding Device Add Test (router.mydomain.com) as "ucd/net SNMP Host" using SNMP v1 with community "public"
Success - new device-id: (11)
```

Go to Devices to see the result:

Description** | Graphs | Data Sources | Status | Hostname | Current (ms) | Average (ms) | Availability
--- | ---| --- | --- | --- | --- | --- | ---
Device Add Test | 0 | 0 | Unknown | router.mydomain.com | 0 | 0 | 100

Use any other combination of parameters in the same way as via the web browser
console. You may want to remember the new device id, `11` in this case, for the
next steps.

## Associate a Data Query to an existing Host

It is recommended to maintain data query associations by maintaining host
templates. Each time, a data query is added to a host template, it will
automatically associated with all hosts related to that very host
template. The data query will be executed as well; this way the snmp
cache will be filled with all values related to that query.

Nevertheless, it is sometimes suitable to manually associate a certain
data query with a single host only without changing any host template.
This is, where the script `add_data_query.php` comes in. First, let's
have a look at the whole list of features it provides. Calling the script
with the parameter `--help` yields

```console
shell>php -q add_data_query.php --help

Add Data Query Script 1.0, Copyright 2004-2018 - The Cacti Group

A simple command line utility to add a data query to an existing device in Cacti

usage: add_data_query.php --host-id=[ID] --data-query-id=[dq_id] --reindex-method=[method] [--quiet]

Required:
        --host-id         the numerical ID of the host
        --data-query-id   the numerical ID of the data_query to be added
        --reindex-method  the reindex method to be used for that data query
                          0|None   = no reindexing
                          1|Uptime = Uptime goes Backwards
                          2|Index  = Index Count Changed
                          3|Fields = Verify all Fields
List Options:
        --list-hosts
        --list-data-queries
        --quiet - batch mode value return

If the data query was already associated, it will be reindexed.
```

Let's first stick to the listing options

### List all Hosts

```console
shell>php -q add_data_query.php --list-hosts

Known Hosts: (id, hostname, template, description)
1       127.0.0.1       8       Localhost
11      router          3       router.mydomain.com
```

### List all Data Queries

```console
shell>php -q add_data_query.php --list-data-queries

Known SNMP Queries:(id, name)
1       SNMP - Interface Statistics
2       ucd/net -  Get Monitored Partitions
3       Karlnet - Wireless Bridge Statistics
4       Netware - Get Available Volumes
6       Unix - Get Mounted Partitions
7       Netware - Get Processor Information
8       SNMP - Get Mounted Partitions
9       SNMP - Get Processor Information
```

### Add a Data Query

```console
shell>php -q add_data_query.php --host-id=11 --data-query-id=1 --reindex-method=fields
Success - Host (11: router.mydomain.com) data query (1: SNMP - Interface Statistics) reindex method (3: Verify All Fields)
```

This example shows the use of a string `"fields"` for specifying the reindex
method. As given by the help text, the use of the numeric value of `"3"` would
have given the exact same result. When visiting the device edit panel, you will
find non-zero values for the data query status column, e.g. *Success [41 Items,
5 Rows]*.

## Associate a Graph Template to an existing Host

It is recommended to maintain graph template associations by maintaining host
templates. Each time, a graph template is added to a host template, it will
automatically associated with all hosts related to that very host template.

Nevertheless, it is sometimes suitable to manually associate a certain graph
template with a single host only without changing any host template. This is,
where the script `add_graph_template.php` comes in. First, let's have a look at
the whole list of features it provides. Calling the script with the parameter
`--help` yields

```console
shell>php -q add_graph_template.php --help

Add Graph Template Script 1.0, Copyright 2004-2018 - The Cacti Group

A simple command line utility to associate a graph template with a host in Cacti

usage: add_graph_template.php --host-id=[ID] --graph-template-id=[ID]
        [--quiet]

Required:
        --host-id             the numerical ID of the host
        --graph_template-id   the numerical ID of the graph template to be added

List Options:
        --list-hosts
        --list-graph-templates
        --quiet - batch mode value return
```

Let's first stick to the listing options

### List all Hosts for a graph template

```console
shell>php -q add_graph_template.php --list-hosts

Known Hosts: (id, hostname, template, description)
1       127.0.0.1       8       Localhost
11      router          3       router.mydomain.com
```

### List all Graph Template

```console
shell>php -q add_graph_template.php --list-graph-templates

Known Graph Templates:(id, name)
2       Interface - Traffic (bits/sec)
3       ucd/net - Available Disk Space
4       ucd/net - CPU Usage
5       Karlnet - Wireless Levels
6       Karlnet - Wireless Transmissions
7       Unix - Ping Latency
8       Unix - Processes
9       Unix - Load Average
10      Unix - Logged in Users
11      ucd/net - Load Average
...
```

### Add a Graph Template

```console
shell>php -q add_graph_template.php --host-id=11 --graph-template-id=7

Success: Graph Template associated for host: (11: router) - graph-template: (7: Unix - Ping Latency)
```

## Add a New Graph

You won't stop now as you've just created a device from cli. Surely, the
task of setting up graphs is the next step. This is done using
`add_graphs.php`. Calling the script with the parameter `--help` yields

```console
shell>php -q add_graphs.php
Add Graphs Script 1.2, Copyright 2008 - The Cacti Group

A simple command line utility to add graphs in Cacti

usage: add_graphs.php --graph-type=[cg|ds] --graph-template-id=[ID]
        --host-id=[ID] [--graph-title=title] [graph options] [--force] [--quiet]

For cg graphs:
        [--input-fields="[data-template-id:]field-name=value ..."] [--force]

        --input-fields  If your data template allows for custom input data, you may specify that
                        here.  The data template id is optional and applies where two input fields
                        have the same name.
        --force         If you set this flag, then new cg graphs will be created, even though they
                        may already exist

For ds graphs:
        --snmp-query-id=[ID] --snmp-query-type-id=[ID] --snmp-field=[SNMP Field] --snmp-value=[SNMP Value]

        [--graph-title=]       Defaults to what ever is in the graph template/data-source template.

        [--reindex-method=]    the reindex method to be used for that data query
                               if data query already exists, the reindex method will not be changed
                        0|None   = no reindexing
                        1|Uptime = Uptime goes Backwards (Default)
                        2|Index  = Index Count Changed
                        3|Fields = Verify all Fields
List Options:
        --list-hosts
        --list-graph-templates [--host_template=[ID]]
        --list-input-fields --graph-template-id=[ID]
        --list-snmp-queries
        --list-query-types  --snmp-query-id [ID]
        --list-snmp-fields  --host-id=[ID] [--snmp-query-id=[ID]]
        --list-snmp-values  --host-id=[ID] [--snmp-query-id=[ID]] --snmp-field=[Field]

    'cg' graphs are for things like CPU temp/fan speed, while
    'ds' graphs are for data-source based graphs (interface stats etc.)
```

Like the graph creation from the console, this task is split into two different
ones:

- **Associated Graph Templates:**
  These are named `cg` graph_type for this script.

- **Associated Data Queries:**
  These are named `ds` graph_type for this script. Additional SNMP parameters
are required to define those graphs.

> **Caution**
>
> When running this cli script, caution must be taken to avoid typos.
> Sometimes, list options take an ending “s”, where the option for graph
> creation comes without “s”. Error messages are not issued to indicate
> this typo; instead you will see the general help screen.

### List Options for Associated Graph Templates

The first list option, `--list-hosts`, is required only if you do not know the
`id` of the device you want to add graphs for. It will produce output as follows

```console
shell>php -q add_graphs.php --list-hosts

Known Hosts: (id, hostname, template, description)
...
11      router.mydomain.com 3       Device Add Test
```

You surely recognize the device we've just added?

The next list option, `--list-graph-templates`, is required to identify the
number of an `Associated Graph Templates`.

```console
shell>php -q add_graphs.php --list-graph-templates

Known Graph Templates:(id, name)
2       Interface - Traffic (bits/sec)
3       ucd/net - Available Disk Space
4       ucd/net - CPU Usage
5       Karlnet - Wireless Levels
6       Karlnet - Wireless Transmissions
7       Unix - Ping Latency
8       Unix - Processes
9       Unix - Load Average
...
```

We will need the graph template id of the `ucd/net - CPU Usage` template later.
So note the number `4` for it.

It is possible to reduce the listing to the graph templates associated with a
specific host template by using `--list-graph-templates
--host-template-id=[id]`. For a "ucd/net SNMP Host" this yields

```console
shell>php -q add_graphs.php --list-graph-templates --host-template-id=3

Known Graph Templates:(id, name)
4   ucd/net - CPU Usage
11  ucd/net - Load Average
13  ucd/net - Memory Usage...
```

### List Options for Associated Data Queries

First task is to find all id's for available data queries.

```console
shell>php -q add_graphs.php --host-id=2 --list-snmp-queries

Known SNMP Queries:(id, name)
1       SNMP - Interface Statistics
2       ucd/net -  Get Monitored Partitions
3       Karlnet - Wireless Bridge Statistics
4       Netware - Get Available Volumes
6       Unix - Get Mounted Partitions
7       Netware - Get Processor Information
8       SNMP - Get Mounted Partitions
9       SNMP - Get Processor Information
```

For standard interface statistics, we note the id of `1`

Next task is to find the query_type as done by issuing

```console
shell>php -q add_graphs.php --snmp-query-id=1 --list-query-types

Known SNMP Query Types: (id, name)
2       In/Out Errors/Discarded Packets
3       In/Out Non-Unicast Packets
4       In/Out Unicast Packets
9       In/Out Bytes (64-bit Counters)
13      In/Out Bits
14      In/Out Bits (64-bit Counters)
16      In/Out Bytes
20      In/Out Bits with 95th Percentile
21      In/Out Bits with Total Bandwidth
22      In/Out Bytes with Total Bandwidth
23      In/Out Bits 1 min
24      In/Out Bits 1 min (64-bit Counters)
```

For a standard `In/Out Bits` type, we note the id of `13`

Next issue is to select the `SNMP Field` that shall be used for a new graph.

```console
shell>php -q add_graphs.php --host-id=11 --list-snmp-fields

Known SNMP Fields for host-id 11: (name)
ifAlias
ifDescr
ifHwAddr
ifIndex
ifIP
ifName
ifOperStatus
ifSpeed
ifType
```

For our graph, we will use the field `ifOperStatus` to select the correct
interfaces.

In general, you will next determine the values available for the `SNMP Field`,
in our case `ifOperStatus`. This is done by

```console
shell>php -q add_graphs.php --host-id=11 --snmp-field=ifOperStatus --list-snmp-values

Known values for ifOperStatus for host 11: (name)
Down
Up
```

This is no surprise, of course. Now, all parameters required for creating a new
graph are determined.

### Add Non-Indexed Graphs

We will create a graph for `ucd/net - CPU Usage`. Above, we've identified the
graph template it to be `4`. In total, that makes up for the following command

```console
shell>php -q add_graphs.php --host-id=11 --graph-type=cg --graph-template-id=4

Graph Added - graph-id: (39) - data-source-id: (63)
```

Find the result when visiting Graph Management

Graph Title** | Template Name | Size
--- | --- | ---
Device Add Test - CPU Usage | ucd/net - CPU Usage | 120x500

If the graph template was not associated with that host before, it is now added
to the list of Associated Graph Templates.

### Add Indexed Graphs

First, let's sum up the id's of all resources required for this task:

###### Table 20-2. Parameters required for an Interface Traffic Graph

Object | Value | Description
--- | --- | ---
Graph Template Id | 2 | Interface - Traffic (bits/sec)
SNMP Query Id | 1 | SNMP - Interface Statistics
SNMP Query Type Id | 13 | In/Out Bits
SNMP Field | ifOperStatus | Field name
SNMP Value | Up | Field value

This will make up for the following command

```console
shell>php -q add_graphs.php --host-id=11 --graph-type=ds --graph-template-id=2 --snmp-query-id=1 --snmp-query-type-id=13 --snmp-field=ifOperStatus --snmp-value=Up

Graph Added - graph-id: (40) - data-source-id: (65)
```

Find the result when visiting Graph Management

Graph Title** | Template Name | Size
--- | --- | ---
Device Add Test - CPU Usage | ucd/net - CPU Usage | 120x500
Device Add Test - Traffic - lo | Interface - Traffic (bits/sec) | 120x500

If the data query was not associated with that host before, it is now added to
the list of Associated Graph Templates. In this case, the Re-Index Method of
`Uptime Goes Backwards` is defaulted if not given otherwise. You may provide a
different Re-Index Method by entering the optional parameter `--reindex-method`.

## Add Items to a Tree

Now, that we've created some nice graphs, they should be put the graph trees.
This is done using `add_tree.php`. As you will notice soon, it is possible to
even add header items, hosts and graphs to a tree as well as adding a new tree
itself. But let us first see the help output. Calling the script with the
parameter `--help` yields

```console
shell>php -q add_tree.php --help

Add Tree Script 1.0, Copyright 2004-2018 - The Cacti Group

A simple command line utility to add objects to a tree in Cacti

usage: add_tree.php  --type=[tree|node] [type-options] [--quiet]

Tree options:
        --name=[Tree Name]
        --sort-method=[manual|alpha|natural|numeric]

Node options:
        --node-type=[header|host|graph]
        --tree-id=[ID]
        [--parent-node=[ID] [Node Type Options]]

Header node options:
        --name=[Name]

Host node options:
        --host-id=[ID]
        [--host-group-style=[1|2]]
        (host group styles:
         1 = Graph Template,
         2 = Data Query Index)

Graph node options:
        --graph-id=[ID]
        [--rra-id=[ID]]

List Options:
        --list-hosts
        --list-trees
        --list-nodes --tree-id=[ID]
        --list-rras
        --list-graphs --host-id=[ID]
```

### List Hosts

The first try is dedicated to the list option `--list-hosts`. It goes like

```console
shell>php -q add_tree.php --list-hosts

Known Hosts: (id, hostname, template, description)
1       127.0.0.1           8       Localhost
2       gandalf         3       gandalf
...
11      router.mydomain.com 3       Device Add Test
```

### List Trees

Now, let us `--list-trees`. It goes like

```console
shell>php -q add_tree.php --list-trees

Known Trees:
id      sort method                     name
1       Manual Ordering (No Sorting)    Default Tree
```

### List Nodes

Listing all existend node of a given tree is done by

```console
shell>php -q add_tree.php --list-nodes --tree-id=1

Known Tree Nodes:
type    id      text
Host    7       127.0.0.1       Graph Template
Host    9       gandalf     Graph Template
Host    12      gandalf     Graph Template
```

### List RRAs

For special tree add options, you will require the id of the RRA definition to
completely specify the add request. That's why the corresponding `--list-rras`
option is implemented. It goes this way

```console
shell>php -q add_tree.php --list-rras

Known RRAs:
id      steps   rows    timespan        name
1       1       600     86400           Daily (5 Minute Average)
2       6       700     604800          Weekly (30 Minute Average)
3       24      775     2678400         Monthly (2 Hour Average)
4       288     797     33053184        Yearly (1 Day Average)
```

### List Graphs for given Hosts

To be able to add a Graph, the id of that very graph is required. Thus, a
`--list-graphs --host-id=[id]` option was implemented

```console
shell>php -q add_tree.php --list-graphs --host-id=1

Known Host Graphs: (id, name, template)
1       Localhost - Memory Usage            Linux - Memory Usage
2       Localhost - Load Average            Unix - Load Average
3       Localhost - Logged in Users         Unix - Logged in Users
4       Localhost - Processes           Unix - Processes
5       Localhost - Traffic - eth0          Interface - Traffic (bits/sec, 95th Percentile)
33      Localhost - Used Space - Memory Buffers Host MIB - Available Disk Space
34      Localhost - Used Space - Real Memory    Host MIB - Available Disk Space
35      Localhost - Used Space - Swap Space     Host MIB - Available Disk Space
36      Localhost - Used Space - /          Host MIB - Available Disk Space
37      Localhost - Used Space - /sys       Host MIB - Available Disk Space
38      Localhost - Used Space - /boot      Host MIB - Available Disk Space
```

### Add a new Tree

Cacti comes with a single tree, named Default Tree. Console entry Graph
Trees is used to add more trees. With `add_tree.php`, you may now do so
from command line as well:

```console
shell>php -q add_tree.php --type=tree --name="Test Tree Add" --sort-method=manual

Tree Created - tree-id: (6)
```

Verify this from console, Graph Trees to find

```console
Default Tree
Test Tree Add
```

as expected.

### Add a new Header Node to a Tree

Now, that a new tree has been created, you may want to add a new header to that
very tree. Use

```console
shell>php -q add_tree.php --type=node --node-type=header --tree-id=6 --name="Header Test"

Added Node node-id: (21)
```

You will want to save the id returned if willing to add further nodes to
exactly this new Header Node

Please note that it is currently not possible to add another header with
the same options even if this is possible from console

But it is possible to add a subheader to an already defined header. Even
in this case, the `name` has to be unique

```console
shell>php -q add_tree.php --type=node --node-type=header --tree-id=6 --parent-node=21  --name="SubHeader Test"

Added Node node-id: (22)
```

### Add a new Host Node to a Tree

We will distinguish several options adding a host to a tree. First, let's
add a Host directly to a tree. For this example, we use the tree id
returned from adding our own `Test Tree Add` known with `id=6`

```console
shell>php -q add_tree.php --type=node --node-type=host --tree-id=6 --host-id=1

Added Node node-id: (23)
```

As no `--parent-node` was given, this host is directly added to the tree
itself. If you wish to add a host to a (sub)header specify as follows

```console
shell>php -q add_tree.php --type=node --node-type=host --tree-id=6 --parent-node=21 --host-id=1

Added Node node-id: (24)
```

Both example come without a `--host-group-style` option. For those cases,
`Graph Template` host group style is default. Here's an example for
providing a host group option of `Data Query Index` instead

```console
shell>php -q add_tree.php --type=node --node-type=host --tree-id=6 --parent-node=22 --host-id=1 --host-group-style=2

Added Node node-id: (25)
```

### Add a new Graph Node to a Tree

Like above, instead of hosts it is possible to add a single graph to a
tree or a (sub)header of any tree. Of course, you again will require the
`id` of the tree and optionally of the `header`. This results in

```console
shell>php -q add_tree.php --type=node --node-type=graph --tree-id=6 --graph-id=5

Added Node node-id: (26)
```

Like above, this graph now was added directly to the tree itself. To add
a graph to a header, proceed as follows

```console
shell>php -q add_tree.php --type=node --node-type=graph --tree-id=6 --parent-node=21 --graph-id=5

Added Node node-id: (27)
```

In both cases, no explicit `--rra-id` was given. This will default to the
Daily (5 Minute Average). Specify any other `--rra-id` as given

```console
shell>php -q add_tree.php --type=node --node-type=graph --tree-id=6 --parent-node=21 --graph-id=1 --rra-id=4

Added Node node-id: (28)
```

to provide the `--rra-id` for a rra of Yearly (1 Day Average).

## Add Graph Permissions

This script is used to specify special graph permissions to users. The
list of parameters is displayed as usual when calling the script with the
parameter `--help`

```console
shell>php -q add_perms.php --help

Add Permissions Script 1.0, Copyright 2004-2018 - The Cacti Group

A simple command line utility to add permissions to tree items in Cacti

usage: add_perms.php [ --user-id=[ID] ]
        --item-type=[graph|tree|host|graph_template]
        --item-id [--quiet]

Where item-id is the id of the object of type item-type
List Options:
        --list-users
        --list-trees
        --list-graph-templates
        --list-graphs --host-id=[ID]
```

### List Users

The list of users is retrieved by calling the script with the parameter
`--list-users`. It goes like

```console
shell>php -q add_perms.php --list-users

Known Users:
id      username        full_name
1       admin   Administrator
3       guest   Guest Account
```

### List Trees who accept permissions

The list of trees is retrieved by calling the script with the parameter
`--list-trees`. It goes like

```console
shell>php -q add_perms.php --list-trees

Known Trees:
id      sort method                     name
1       Manual Ordering (No Sorting)    Default Tree
```

### List Graph Templates

The list of available graph templates is retrieved by calling the script with
the parameter `--list-graph-templates`. It goes like

```console
shell>php -q add_perms.php --list-graph-templates

Known Graph Templates:(id, name)
2       Interface - Traffic (bits/sec)
3       ucd/net - Available Disk Space
4       ucd/net - CPU Usage
5       Karlnet - Wireless Levels
6       Karlnet - Wireless Transmissions
7       Unix - Ping Latency
8       Unix - Processes
9       Unix - Load Average
...
```

### List Graphs for given Hosts where permissions can be set

To be able to add a permissions to a specific Graph, the id of that very graph
is required. Thus, a `--list-graphs --host-id=[id]` option was implemented

```console
shell>php -q add_perms.php --list-graphs --host-id=1

Known Host Graphs: (id, name, template)
1       Localhost - Memory Usage            Linux - Memory Usage
2       Localhost - Load Average            Unix - Load Average
3       Localhost - Logged in Users         Unix - Logged in Users
4       Localhost - Processes           Unix - Processes
5       Localhost - Traffic - eth0          Interface - Traffic (bits/sec, 95th Percentile)
33      Localhost - Used Space - Memory Buffers Host MIB - Available Disk Space
34      Localhost - Used Space - Real Memory    Host MIB - Available Disk Space
35      Localhost - Used Space - Swap Space     Host MIB - Available Disk Space
36      Localhost - Used Space - /          Host MIB - Available Disk Space
37      Localhost - Used Space - /sys       Host MIB - Available Disk Space
38      Localhost - Used Space - /boot      Host MIB - Available Disk Space
```

### Add Graph Permissions to specific Users

There are various ways to define graph permissions to specific users.
First, we will add graph permissions for a given host. This is done using
the parameter `--item-type=host` as follows

```console
shell>php -q add_perms.php --user-id=4 --item-type=host --item-id=1
```

`--user-id=4` must specify an existing users. Else, an error message will
be printed. As `--item-type=host` is given, `--item-id=1` must specify a
valid host. Again, if no host with this specific id exists, an error
message will be printed. No output is produced on successful operations.

Next, we will add graph permissions for a given tree. This is done using
the parameter `--item-type=tree` as follows

```console
shell>php -q add_perms.php --user-id=4 --item-type=tree --item-id=1
```

`--user-id=4` must specify an existing users. Else, an error message will
be printed. As `--item-type=tree` is given, `--item-id=1` must specify a
valid tree (the Default Tree in this case). Again, if no tree with this
specific id exists, an error message will be printed. No output is
produced on successful operations.

Adding graph permissions for a given graph template is done using the
parameter `--item-type=graph_template` as follows

```console
shell>php -q add_perms.php --user-id=4 --item-type=graph_template --item-id=25
```

`--user-id=4` must specify an existing users. Else, an error message will
be printed. As `--item-type=graph_template` is given, `--item-id=1` must
specify a valid graph_template (the Interface - Traffic (bytes/sec) in
this case). Again, if no graph template with this specific id exists, an
error message will be printed. No output is produced on successful
operations.

Last but not least we add graph permissions for a given graph by using
the parameter `--item-type=graph` as follows

```console
shell>php -q add_perms.php --user-id=4 --item-type=graph --item-id=8
```

`--user-id=4` must specify an existing users. Else, an error message will
be printed. As `--item-type=graph` is given, `--item-id=1` must specify a
valid graph. Again, if no graph template with this specific id exists, an
error message will be printed. No output is produced on successful
operations.

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
