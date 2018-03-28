Graph a Single SNMP OID
=======================

When dealing with SNMP-enabled devices, there are often times when you want to graph the value of a single OID. This tutorial explains how to do this in Cacti. It also assumes that you have the "SNMP - Generic OID Template" graph template, which is now included in Cacti as of version 0.8.5. If you do not see this template listed under Graph Templates, download the template from the Cacti website in XML form and import it using the Import Templates menu item.

To start the process of creating a new graph for your OID, click the New Graphs menu item and select the host that contains the target OID from the dropdown. Under the Graph Templates box, you will see a dropdown on the last line that reads (Select a graph type to create). From this dropdown, choose "SNMP - Generic OID Template" and click the Create button at the bottom of the page.

You will be presented with several fields that will require input before the new graph can be created. They are described in more detail below.

||

When finished filling in values for these fields, click the Create button. Your new graph can now be accessed through the Graph Management page or the Graphs tab inside of Cacti.

