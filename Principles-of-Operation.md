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

Later on, we demonstrate how to extend cacti's capabilities of retrieving data
to scripts, script queries and more.

## Data Storage

There are lots of different approaches for this task. Some may use an (SQL)
database, others flat files. Cacti uses [RRDTool](http://www.rrdtool.org/) to
store data.

RRD is the acronym for Round Robin Database. RRD is a system to store and
display time-series data (i.e. network bandwidth, machine-room temperature,
server load average). It stores the data in a very compact way that will not
expand over time, and it can create beautiful graphs. This keeps storage
requirements at bay.

Likewise, rrdtool will perform some specific tasks. It performs consolidation
to combine raw data (a primary data point in rrdtool lingo) to consolidated
data (a consolidated data point). This way, historical data is compressed to
save space. rrdtool knows different consolidation functions: AVERAGE, MAXIMUM,
MINIMUM and LAST.

## Data Presentation

One of the most appreciated features of [RRDTool](http://www.rrdtool.org/) is
the built-in graphing function. This comes in useful when combining this with
some commonly used webserver. Such, it is possible to access the graphs from
merely any browser on any plattform.

Graphing can be done in very different ways. It is possible, to graph one or
many items in one graph. Autoscaling is supported and logarithmic y-axis as
well. You may stack items onto another and print pretty legends denoting
characteristics such as minimum, average, maximum and lots more.

Copyright (c) 2018 Cacti Group
