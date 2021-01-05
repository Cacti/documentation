# Data Source Templates

This section will describe **Data Source Templates** in Cacti.

Data sources serve an important role in Cacti data sources are data points
collected from the devices you monitor in Cacti.

These data sources can be for example incoming traffic on a interface.
Cacti allows you to create data source templates to asociate to data queries
the template allows you to describe what type of data Cacti should expect.

To create a Data source you will need to select the proper data input
there are several options but the most popular ones would be
get SNMP data or get snmpdata indexed.

You would use Get SNMP data (indexed) for interfaces for example as Cacti
would need to query the device to find the interface index.

You would use Get SNMP data and put in a single OID for a OID that wont change
for example CPU usage generally does not have a index and the OID wont change



![Data-Source-Templates](images/datasource-template.PNG)

![Data-Source-Templates](images/datasource-template2.PNG)

---
Copyright (c) 2004-2021 The Cacti Group
