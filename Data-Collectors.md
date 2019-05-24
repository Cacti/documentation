# Data Collectors

This section will describe **Data Collectors** in Cacti.

As of Cacti 1.x remote polling is now supported remote polling allows for devices to be monitored by differnt servers 
either geographically closer to the node being monitored or by a redudant server for load balancing.

The below page shows the current online collecter aka pollers these are used to reach out to the device either by SNMP or Ping
all traffic would originiate from the poller asigned to the device.

![Data Collectors](images/data-collectors.png)

The Main poller resides on the local server that you are logged into this also serves as the master poller for a distributed system using remote pollers.

![Data Collectors Edit Main](images/data-collectors-edit-main.png)

![Data Collectors Edit Remote](images/data-collectors-edit-remote1.png)

The below page allows you to modify remote poller specific details such as username and password

![Data Collectors Edit Remote Connection Test](images/data-collectors-edit-remote2.png)

---
Copyright (c) 2004-2019 The Cacti Group
