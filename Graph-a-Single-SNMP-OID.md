# Graph a Single SNMP OID

When dealing with SNMP-enabled devices, there are often times when you want to
graph the value of a single OID. This tutorial explains how to do this in
Cacti. It also assumes that you have the "SNMP - Generic OID Template" graph
template, which is now included in Cacti as of version 0.8.5. If you do not see
this template listed under Graph Templates, download the template from the
Cacti website in XML form and import it using the Import Templates menu item.

To start the process of creating a new graph for your OID, click the New Graphs
menu item and select the host that contains the target OID from the dropdown.
Under the Graph Templates box, you will see a dropdown on the last line that
reads (Select a graph type to create). From this dropdown, choose "SNMP -
Generic OID Template" and click the Create button at the bottom of the page.

###### Table 10-1. Field Description: SNMP - Generic OID Template

Name | Description
--- | ---
(Graph) Title | The title that is to be used for the new graph. It is generally a good idea to keep `|host_description|` in the title, as to make the graph easier to identify later.
(Graph) Vertical Label | The text that will be printed along the y-axis of the graph. It is generally used to describe units, such as 'bytes' or 'percent'.
(Graph Items) Legend Color | The color that will be used to represent the data on the graph.
(Graph Items) Opacity/Alpha Channel | This optionally provides an opacity (not available with rrdtool-1.0.x) for a colored item.
(Graph Items) Legend Text | The text that will be used to describe the data on the graph legend.
(Data Source) Name | The title that is to be used for the new data source. It is generally a good idea to keep |host_description| in the title, as to make the data source easier to identify later.
(Data Source) Maximum Value [snmp_oid] | The maximum value that will be accepted from the OID. Make sure you choose a value that is reasonable for the data you are trying to graph because anything larger than the maximum will be ignored. If you are graphing a percentage, you should use '100' as the value should never exceed this.
(Data Source) Data Source Type [snmp_oid] | How the data from the OID should be stored by RRDTool and interpreted on the graph. If the value of the OID represents the actual data, you should use GAUGE for this field. If the OID value is a constantly incremented number, you should use COUNTER for this field. The two remaining field values, DERIVE and ABSOLUTE can be ignored in most situations.
(Custom Data) OID | The actual SNMP OID to graph. It is typically a good idea to enter the number OID here as opposed to using MIB names. For instance, to get the number of open files on a Netware server, you would use ".1.3.6.1.4.1.23.2.28.2.7.0" as the OID.

You will be presented with several fields that will require input before the
new graph can be created. They are described in more detail below.

When finished filling in values for these fields, click the Create button. Your
new graph can now be accessed through the Graph Management page or the Graphs
tab inside of Cacti.

---
Copyright (c) 2004-2019 The Cacti Group
