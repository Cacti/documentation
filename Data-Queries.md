# Data Queries

Data queries are not a replacement for data input methods in Cacti. Instead
they provide an easy way to query, or list data based upon an index, making the
data easier to graph. The most common use of a data query within Cacti is to
retrieve a list of network interfaces via SNMP. If you want to graph the
traffic of a network interface, first Cacti must retrieve a list of interfaces
on the host. Second, Cacti can use that information to create the necessary
graphs and data sources. Data queries are only concerned with the first step of
the process, that is obtaining a list of network interfaces and not creating
the graphs/data sources for them. While listing network interfaces is a common
use for data queries, they also have other uses such as listing partitions,
processors, or even cards in a router.

One requirement for any data query in Cacti, is that it has some unique value
that defines each row in the list. This concept follows that of a 'primary key'
in SQL, and makes sure that each row in the list can be uniquely referenced.
Examples of these index values are 'ifIndex' for SNMP network interfaces or the
device name for partitions.

There are two types of data queries that you will see referred to throughout
Cacti. They are script queries and SNMP queries. Script and SNMP queries are
virtually identical in their functionality and only differ in how they obtain
their information. A script query will call an external command or script and
an SNMP query will make an SNMP call to retrieve a list of data.

All data queries have two parts, the XML file and the definition within Cacti.
An XML file must be created for each query, that defines where each piece of
information is and how to retrieve it. This could be thought of as the actual
query. The second part is a definition within Cacti, which tells Cacti where to
find the XML file and associates the data query with one or more graph
templates.

## Creating a Data Query

Once you have created the XML file that defines your data query, you must add
the data query within Cacti. To do this you must click on Data Queries under
the Data Gathering heading, and select Add. You will be prompted for some basic
information about the data query, described in more detail below.

When you are finished filling in all necessary fields, click the Create button
to continue. You will be redirected back to the same page, but this time with
some additional information to fill in. If you receive a red warning that says
'XML File Does Not Exist', correct the value specified in the 'XML Path' field.

### Associated Graph Templates

Every data query must have at least one graph template associated with it, and
possibly more depending on the number of output fields specified in the XML
file. This is where you get to choose what kind of graphs to generate from this
query. For instance, the interface data query has multiple graph template
associations, used to graph traffic, errors, or packets. To add a new graph
template association, simply click Add at the right of the Associated Graph
Templates box. You will be presented with a few fields to fill in:

When you are finished filling in these fields, click the Create button. You
will be redirected back to the same page with some additional information to
fill in. Cacti will make a list of each data template referenced to in your
selected graph template and display them under the Associated Data Templates
box. For each data source item listed, you must selected the data query output
field that corresponds with it. *Do not forget to check the checkbox to the
right of each selection, or your settings will not be saved.*

The Suggested Values box gives you a way to control field values of data
sources and graphs created using this data query. If you specify multiple
suggested values for the same field, Cacti will evaluate them in order which
you can control using the up or down arrow icons. For more information about
valid field names and variables, read the section on suggested values.

When you are finished filling in all necessary fields on this form, click the
Save button to return to the data queries edit screen. Repeat the steps under
this heading as many times as necessary to represent all data in your XML file.
When you are finished with this, you should be ready to start adding your data
query to hosts.

### SNMP Query XML Syntax

~~~xml
<query>
   <name>Get SNMP Interfaces</name>
   <description>Queries a host for a list of monitorable interfaces</description>
   <oid_uptime>.1.3.x.x.x</oid_uptime>
   <oid_index>.1.3.6.1.2.1.2.2.1.1</oid_index>
   <oid_index_parse>OID/REGEXP:.*.([0-9]{1,3}.[0-9]{1,3})$</oid_index_parse>
   <oid_num_indexes>.1.3.6.1.2.1.2.1.0</oid_num_indexes>
   <index_order>ifDescr:ifName:ifIndex</index_order>
   <index_order_type>numeric</index_order_type>
   <index_title_format>|chosen_order_field|</index_title_format>

   <fields>
      <ifIndex>
         <name>Index</name>
         <method>walk</method>
         <source>value</source>
         <direction>input</direction>
         <oid>.1.3.6.1.2.1.2.2.1.1</oid>
      </ifIndex>
   </fields>
</query>
~~~

## Script Query XML Syntax

~~~xml
<query>
   <name>Get Unix Mounted Partitions</name>
   <description>Queries a list of mounted partitions on a unix-based host  with the 'df' command.</description>
   <script_path>perl |path_cacti|/scripts/query_unix_partitions.pl</script_path>
   <arg_index>index</arg_index>
   <arg_query>query</arg_query>
   <arg_get>get</arg_get>
   <arg_num_indexes>num_indexes</arg_num_indexes>
   <output_delimeter>:</output_delimeter>
   <index_order>dskDevice:dskMount</index_order>
   <index_order_type>alphabetic</index_order_type>
   <index_title_format>|chosen_order_field|</index_title_format>

   <fields>
      <dskDevice>
         <name>Device Name</name>
         <direction>input</direction>
         <query_name>device</query_name>
      </dskDevice>
   </fields>
</query>
~~~
