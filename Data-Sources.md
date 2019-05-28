# Data Source Management

This section will describe **Data Source** management in Cacti.

Data sources in cacti are the points of data that cacti will collect from a device here are some examples

You have a ping monitor going to a device that ping monitor will count as 1 data source.

If you have a 24 port switch and you poll the device via snmp and graph all of the ports then there will be 24 data sources

However if you add more graphs that base their data on the original data source that would not count as another data source

Example you have a 24 port switch that you graph all of the in/out bits on each interface if you then add the in/out bits with 95th percential that would still be 24 data sources.

Keeping on top of the amount of data sources you have is important as the larger the amount of data sources you have the more resources you will need to allocate to your server.

You can see how many data sources are associated with a single device by going to managment then click on devices.

![device datasources](cacti_device_datasource.JPG)

You can also see the total amount of data sources by checking the poller stats on the system
Click the log tab and filter by stats and lookout for the below messege

```console
2019/05/24 17:21:11 - SYSTEM STATS: Time:9.5913 Method:spine Processes:2 Threads:2 Hosts:14 HostsPerProcess:7 DataSources:162 RRDsProcessed:117
```

This output tells us we have 162 data sources on the system.

### Storage considerations and datasources

The amount of data sources on your system has an impact on the amount of storage you will need on your server you will also need to consider and what rate you are polling your devices i.e 1 minute or 5 Minute polls

Here is the amount of storage you can expect to consume per data source

30 second polling
Daily 48kb  / Datasource
Weekly 43kb / Datasource
Monthly 46kb / Datasource
Yearly 140kb / Datasource

1 minute polling
Daily 93kb / Datasource
Weekly 45kb / Datasource
Monthly 47kb / Datasource

Yearly 140KB/data source
5 minute polling
Daily 19kb  / Datasource
Weekly 22kb / Datasource
Monthly 25kb / Datasource
Yearly 26kb  / Datasource

---
Copyright (c) 2004-2019 The Cacti Group
