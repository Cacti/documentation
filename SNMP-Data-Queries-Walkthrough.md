# SNMP Data Queries

## Walkthrough: A New SNMP Data Query

For SNMP Queries, you won't need to create a data retrieval script. Cacti will
use SNMP to retrieve information. But cacti will need additional information on
how the indexed data is structured. Think about a table (a MIB table in this
case); you'll have to tell cacti about the table structure. This is done by
defining an XML file. Basically, you have to define the index to tell cacti
about the number of rows and about their unique index. This index is later used
to access each rows data. Furthermore, you may define columns, that serve as
**descriptive fields** to be shown in the selection table. The XML file knows
them as

`<direction>input</direction>`

At last, you will have to define those fields, that will be queried for the
readings, e.g. ifInOctets, ifOutOctets, ifInErrors, …The XML file knows them as

`<direction>output</direction>`

Lets have an example: standard Interface MIB with the corresponding part of the
`<path_cacti>/resources/snmp_queries/interfaces.xml` file are displayed using
the following table:

![SNMP Table 1](images/snmp_dqw_table1.png)

![SNMP Table 2](images/snmp_dqw_table2.png)

![SNMP Table 3](images/snmp_dqw_table3.png)

and see the corresponding table structure when defining **New Graphs** for that
device (my laptop):

![Creating graph for Data Query](images/r-dq-1.png)

Now you can map

- Index: IF-MIB::ifIndex
- Status: IF-MIB::ifOperStatus
- Description: IF-MIB::ifDescr
- Type: IF-MIB::ifType
- Speed: IF-MIB::ifSpeed

All those are `<direction>input</direction>` Parameters. They serve as
descriptive information to each row to help you identify the proper interface
to use. Those parameters of `<direction>output</direction>` can be compared to
output parameters of a script (see ping.pl script above). These are the
readings from the device. By selecting the appropriate row (the one greyed out
had been selected by me), you tell cacti to retrieve data from the interface
defined by this index. But how does cacti know, what output parameters it shall
retrieve? See the Select a Graph type DropDown. It specifies a **Graph
Template** defined for this Data Query. The Graph Template in turn references a
**Data Template** which incorporates the needed output parameters as Data
Sources. This works quite the same way as defined for a Data Input Method.

To sum up: the SNMP XML file is somehow a **replacement** for the Data Input
Method described above to be used on indexed values. It tells cacti, what data
it should retrieve (direction: output). To help you identifying the relevant
indexes, the XML defines descriptive parameters (direction: input) to be
displayed in the selection table.

A walkthrough for this is given now. It is based on the already supplied
interfaces.xml XML file.

## Create a Data Query to tell cacti how to retrieve data

Go to **Data Queries** and click **Add** to see:

![Add new Data Query](images/r-dq1_0.png)

Here, we are using the already existing interface.xml file. Select **Get SNMP
Data (Indexed)** as **Data Input Method**. **Create** to see:

![Fill Data for Data Query](images/r-dq2.png)

See, that cacti found the XML file. Don't bother with the Associated Graph
Templates at the moment. The success message does not include checking of the
XML file's content. Not lets proceed to the next definitions.

## Create a Data Template to tell cacti how to store data

This is the exact copy of the definitions made above. So I do not repeat
everything here. **Data Input Method** must be selected as **Get SNMP Data
(Indexed)**. As this data source is a COUNTER type, select this as the **Data
Source Type**. But after saving the new Data Source definition, you may want to
define a second Data Source to the same **Data Template**. To do so, select New
from the **Data Source Item** heading to see:

![Enter new Data Source Item](images/r-dq-dt1.png)

The name of the Data Source (ifOutOctets) is not replaced in the Tab until you
save your work. By default, **Maximum Value** is set to 100. This is way too
low for an interface. All readings above this value will be stored as NaN by
rrdtool. To avoid this, set to 0 (no clipping) or to a reasonable value (e.g.
interface speed). Don't forget to specify COUNTER! You will have noticed, that
the name of the data source does not match the Name in the interface.xml. Don't
worry, the solution to this is given later on. Before leaving, pay attention to
the bottom of the page:

![Check indices for Data Query Data Template](images/r-dq-dt2.png)

This is specific to indexed SNMP Queries. You will have to check the last three
items to make indexing work. All other items should be left alone, there values
will be taken from the appropriate device definitions. Now **Save** and you're
done with this step.

## Create a Graph Template to tell cacti how to present the data

Now you want to tell cacti, how to present the data retrieved from SNMP Query.
Again, this is done by merely copying the procedure described above. When
selecting the **Data Source**, pay attention to select from the just defined
data sources. The next step is new and applies only to Data Queries:

### Add Graph Template to the Data Query

Now it's time to re-visit our Data Query. Remember the **Associated Graph
Template** we've left alone in the very first step? Now it will get a meaning.
Go to Data Queries and select our new one. Then Add a new Associated Graph
Template:

![Add new associated Graph Template](images/r-dq3.png)

Give it a **Name** and select the generated Graph Template. **Create**.

![Creating new associated Graph Template](images/r-dq4.png)

Select the correct **Data Source**, pay attention to checking the checkboxes of
each row. Apply a name to the Data Template and a **title** to the Graph
Template. Use cacti variables as defined in Variables. You may use all XML
fields defined as `<direction>input</direction>`; in this example the fields
`<ifName>` and `<ifDescr>` of the interface.xml were used. **Add** those
**Suggested Values**. They will be used to distinguish Data Sources and Graphs
for the same device; without this they all would carry the same name. At last:
**Save**:

![Save Associated Graph Template](images/r-dq6.png)

## Apply the Data Query to your Device

Now go to your **Device** to add the **Associated Data Query**:

![Apply Data Query to your Device](images/r-dq-dev1_0.png)

Click **Add** and then **Create Graphs for this Host** to see:

![Create Graphs for Data Query](images/r-dq-dev2.png)

Now select the wanted interface and **Create** to generate the Traffic Graph.
As long as there's only one **Associated Graph Template** for that Data Query,
here will be now Select a Graph Type `DropDown`.

---
Copyright (c) 2018 Cacti Group
