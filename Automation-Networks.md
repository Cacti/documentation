# Automation Networks

This section will describe **Automation Networks** in Cacti.

Adding a network to scan in the automation plugin is easy  on the main console click Automation
once on the below page click the + on the top right of the page 

![Automation Networks](images/automation-network-main.png)

<br>
<br>
<br>

you will now see the below page for example if you want to scan 192.168.1.0/24 you would enter that in the subnet range textbox/n
you will need to note the subnet in CIDR format<br>

Other important options are 
<br>
Schedule type - How often you want to scan this subnet for devices<br>
Discovery threads - How many proccessess to spawn during the scan <br>
Max Runtime - to prevent the scan from running indefinetly <br>
Automatically add to cacti - If a device is SNMP reachable and matches a rule from this subnet the device will be added<br>
Netbios - Attempt to resolve the hostname by netbios



![Automation Networks Edit General](images/automation-networks-edit1.png)



<br>
<br>


![Automation Networks Edit Notification/Reachability](images/automation-networks-edit2.png)







---
Copyright (c) 2004-2019 The Cacti Group
