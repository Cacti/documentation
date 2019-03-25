# Principles of Operation

Cacti operation may be divided into three different tasks:

![Principles of Operation](images/principles_of_operation.png)

## Data Retrieval

First task is to retrieve data. Cacti will do so using its Poller. The Poller
is executed from the operating system's scheduler, e.g. crontab for Unix
flavored OSes.

In current IT installations, you're dealing with lots of devices of different
kind, e.g. servers, network equipment, appliances and the like. To retrieve
data from remote targets/hosts, cacti will mainly use the Simple Network
Management Protocol SNMP. Thus, all devices capable of using SNMP will be
eligible to be monitored by cacti.

Later on, we demonstrate how to extend Cacti's capabilities of retrieving data
to scripts, script queries and more.

## Data Storage

There are lots of different approaches for this task. Some may use an (SQL)
database, others flat files. Cacti uses [RRDTool](http://www.RRDTool.org/) to
store data.

RRD is the acronym for Round Robin Database. RRD is a system to store and
display time-series data (i.e. network bandwidth, machine-room temperature,
server load average). It stores the data in a very compact way that will not
expand over time, and it can create beautiful graphs. This keeps storage
requirements at bay.

Likewise, RRDTool will perform some specific tasks. It performs consolidation
to combine raw data (a primary data point in RRDTool lingo) to consolidated
data (a consolidated data point). This way, historical data is compressed to
save space. RRDTool knows different consolidation functions: AVERAGE, MAXIMUM,
MINIMUM and LAST.

## Data Presentation

One of the most appreciated features of [RRDTool](http://www.RRDTool.org/) is
the built-in graphing function. This comes in useful when combining this with
some commonly used webserver. Such, it is possible to access the graphs from
merely any browser on any platform.

Graphing can be done in very different ways. It is possible, to graph one or
many items in one graph. Autoscaling is supported and logarithmic y-axis as
well. You may stack items onto another and print pretty legends denoting
characteristics such as minimum, average, maximum and lots more.

## Extending Built-in capabilities

Scripts and Queries can extend Cacti's capabilities beyond SNMP. They allow for
data retrieval using custom-made code. This is not even restricted to certain
programming languages; you will find php, perl, shell/batch and more. These
scripts and queries are executed locally by Cacti's poller. But they may
retrieve data from remote hosts by different protocols, e.g.

Protocol | Description
--- | ---
ICMP | ping to measure round trip times and availability
telnet | programming telnet scripts to retrieve data available to sysadmins only
ssh | much like telnet, but more secure (and more complicated)
http(s) | invoke remote cgi scripts to retrieve data via a web server or parse web pages for statistical data (e.g. some network printers)
snmp | use net-snmp's exec/pass functions to call remote scripts and get data
ldap | to retrieve statistical about your ldap server's activities
use your own | invoke nagios agents

and much more...

There a two ways extending Cacti's build-in capabilities:

[Data Input Methods](Data-Input-Methods.md) for querying **single or
multiple**, but **non-indexed** readings

- temperature, humidity, wind, ...
- cpu, memory usage
- number of users logged in
- IP readings like ipInReceives (number of ip packets received per host)
- TCP readings like tcpActiveOpens (number of tcp open sockets)
- UDP readings like udpInDatagrams (number of UDP packets received)

[Data Queries](Data-Queries.md) for **indexed** readings

- network interfaces with e.g. traffic, errors, discards
- other SNMP Tables, e.g. hrStorageTable for disk usage
- you may even create Data Queries as scripts e.g. for querying a
 name server (index = domain) for requests per domain

![Basic Principle of Operation for Data Input Method & Data Query](images/data-input-method-and-query.png)

By using the Exporting and Importing facilities, it is possible to share your
results with others.

---
Copyright (c) 2004-2019 The Cacti Group
