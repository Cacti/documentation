# Automation Device Rules

This section will describe **Device Rules** in Cacti.

Cacti Automation relies on create device Rules these rules helps the automation process figure out what type of device is being scanned. Based on the device rule REGEX the automation engine can apply the appropriate template to the device i.e if there is a REGEX for ios the automation engine may pick the Cisco router template for the device

![Automation Device Rules](images/automation-device-templates.png)
Below you will be able to choose a REGEX that will help identify the device the REGEX can be in any perl supported format. You can select either to match by system description i.e the device hostname or the system name i.e Cisco 

![Automation Device Rules Edit](images/automation-device-templates-edit1.png)

An example regex for Cisco

---
Copyright (c) 2004-2020 The Cacti Group
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY2ODkxODY3OV19
-->