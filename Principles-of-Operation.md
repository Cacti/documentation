# Principles of Operation

Cacti operation may be divided into three different tasks:

- Data Retrieval
- Data Storage
- Graphing

## Data Retrieval

First task is to retrieve data. Cacti will do so using its Poller. The Poller
is executed from the operating system's scheduler, e.g. crontab or
systemd for Unix flavored OSes.  It collects down to an every
10 cycle frequency to a several hour cycle.

In the image below, you can see the general flow of data from
the device to the Cacti database.

<img src="images/principles_of_operation.png" width="200"/>

In enterprise installations, you're dealing with potentially
thousands of devices of different type, e.g. servers, network
equipment, appliances and the like. To retrieve data from remote
targets/hosts, cacti will mainly use the Simple Network
Management Protocol SNMP. Thus, all devices capable of using SNMP will be
eligible to be monitored by cacti.

Many customers gather data using an out of band processes like the hmib
plugin, store the data in transient tables, and then do the device
data collection directly from those transient tables.  That design,
since no device can be nearer in latency than the database, can
scale to 30, 40, even 50 thousand devices with relative ease in
Cacti depending on the size of your database and data collector
server (sockets, cores, threads).  When using this N-Tiered
methology, most customers will use Cacti's script server which
is a memory resident PHP interpretor that preloads all scripts
used to gather data, therefore, it's super fast, and parallel
in nature.  However, most customers will use SNMP, or SSH to
gather metrics from their Devices.

Once the data has been gathered, Cacti then uses eithe an 
out-of-band or in-band process to store the data into Round
Robin Archive files, which represent a flat very well performing
Time Series Databases called RRDfiles.  See below for details
on that storage mechanism.

## Data Storage

In the industry, storage of the resulting data can take meny forms.
In Cacti, the RRDfile has been the tool of choice for many years.
There are only so many ways to make a hammer, and RRDtool's a great
hammer.  Other approaches in the industry use SQL database,
others flat files or document stores like Elastic Search, Splunk,
Mongo DB, InfluxDB.  There are a number of options out there.
You can get more information about RRDfile from the 
[RRDtool Website](http://www.RRDtool.org/).

`RRD` is an acronym for **Round Robin Database**. RRD is a system to store and
display time-series data (i.e. network bandwidth, machine-room temperature,
server load average). It stores the data in a very compact way that will not
expand over time, and it can create beautiful graphs.  Data that ages
beyond a certain point is consolidated and very old data just rolls off
the end of the RRDfile.  It ages out.  This keeps storage requirements at bay.

As mentioned, performs consolidation to combine raw data (a `primary data point` 
in RRDtool lingo) to consolidated data (a `consolidated data point`). 
This way, historical data is compressed to save space. RRDtool knows
different consolidation functions: AVERAGE, MAXIMUM, MINIMUM and LAST.

## Data Presentation

One of the most appreciated features of [RRDtool](http://www.RRDtool.org/) is
the built-in graphing function. This comes in useful when combining this with
some commonly used webserver. Such, it is possible to access the graphs from
merely any browser on any platform.

The Graphing engine is quite flexible. It is possible, to graph one or
many items in one graph. Autoscaling is supported and logarithmic y-axis,
left and right axes, and much much more. You may stack items onto another
and print pretty legends denoting characteristics such as minimum, 
average, maximum and lots more.

## Extending Built-in capabilities

As mentioned, scripts and Queries extend Cacti's capabilities beyond
just SNMP. They allow for data retrieval using custom-made code.
This is not even restricted to certain programming languages; 
you will find php, perl, shell/batch and more. These
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

## Beyond Graphs

Cacti is not just a Graphing platform, it's also a Network Operations
Framework.  Thought the dozens of plugins and user contributed
Graph Templates, the sky is the limit as to what can be done using the
Cacti Framework.  It's stood the test of time now in it's 19th year
of existance in the Open Source world.

---
Copyright (c) 2004-2021 The Cacti Group
