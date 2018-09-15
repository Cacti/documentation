# Data Input Methods

Data input methods allow Cacti to retrieve data to insert into data sources and
ultimately put on a graph. There are different ways for Cacti to retrieve data,
the most popular being through an external script or from SNMP.

## Creating a Data Input Method

To create a new data input method, select the Data Input Methods option under
the Management heading. Once on that screen, click Add on the right. You will
be presented with a few fields to populate on the following screen.

###### Table 11-1. Field Description: Data Input Methods

Name | Description
--- | ---
Name | Give the data query a name that you will use to identify it. This name will be used throughout Cacti to identify the data input method.
Input Type | Select the type of data input method you are trying to create. Valid options here are 'Script/Command', 'SNMP', 'SNMP Query', and 'Script Query'.
Input String | This field is only used when the Input Type is set to 'Script/Command'. It specifies the full path to the script including any per data source variables inside <>'s from the user. For instance, if you are passing an IP address to a script, your input string might look something like: `/path/to/script.pl <ip>` When the user creates a data source based on this data input method, they will be prompted for an IP address to pass onto the script.
Output String | This field is only here for legacy purposes and will probably go away in a future version of Cacti.

When you are finished filling in all necessary fields, click the Create button
to continue. You will be redirected back to the same page, but this time with
two new boxes, Input Fields and Output Fields. The Input Fields box is used to
define any fields that require information from the user. Any input fields
referenced to in the input string must be defined here. The Output Fields box
is used to define each field that you expect back from the script. *All data
input methods must have at least one output field defined*, but may have more
for a script.

### Data Input Fields

To define a new field, click Add next to the input or output field boxes. You
will be presented with some or all of the fields below depending on whether you
are adding an input or output field.

###### Table 11-2. Field Description: Data Input Fields

Name | Description
--- | ---
Field/Field Name | Either select or type in the name of the field you want to define. No spaces or other non-alphanumeric characters (except '-' or '_') should be used in this field.
Friendly Name | Enter a more descriptive name for this field which will be used for identification throughout Cacti.
Regular Expression Match (Input Only) | If you want to enforce a certain regular expression pattern when the user enters a value for this field, enter it here. The regular expression must follow POSIX syntax as it will be passed to PHP's ereg() function.
Allow Empty Input (Input Only) | Select whether you want to allow the user to leave the value of this field blank or not.
Special Type Code (Input Only) | Sometimes Cacti needs to reference a field internally, but needs to rely on more than just the field name. For instance, if your field requires an IP address from the user, you can enter 'management_ip' here and Cacti will fill this field in with the current IP address of the selected host. Valid values for this field are: 'hostname', 'management_ip', 'snmp_community', 'snmp_username', 'snmp_password', and 'snmp_version'.
Update RRD File (Output Only) | Check this box if you want Cacti to insert the return value from this field into the RRD file. Obviously, this box needs to be checked for at least one output field per data input source, but can be left blank to have Cacti store the value in the database instead.

When you are finished filling in all necessary fields, click the Create button
to continue. You will be redirected back to the data input method edit page.
From here you can continue to add additional fields, or click Save on this
screen when finished.

## Making Your Scripts Work With Cacti

The simplest way to extend Cacti's data gathering functionality is through
external scripts. Cacti comes with a number of scripts out of the box which are
located in the `scripts/` directory. These scripts are used by the data input
methods that are present in a new installation of Cacti.

To have Cacti call an external script to gather data you must create a new data
input method, making sure to specify Script/Command for the Input Type field.
See the previous section, [Creating a Data Input Method](data_input_methods.html)
for more information about how to create a data input method. To gather data
using your data input method, Cacti simply executes the shell command specified
in the Input String field. Because of this, you can have Cacti run any shell
command or call any script which can be written in almost any language.

What Cacti is concerned with is the output of the script. When you define your
data input method, you are required to define one or more output fields. The
number of output fields that you define here is important to your script's
output. For a data input method with only one output field, your script should
output its value in the following format:

```xml
<value_1>
```

So if I wrote a script that outputs the number of running processes, its output
might look like the following:

`67`

Data input methods with more than one output field are handled a bit
differently when writing scripts. Scripts that output more than one value
should be formatted like the following:

```xml
<fieldname_1>:<value_1> <fieldname_2>:<value_2> ... <fieldname_n>:<value_n>
```

Lets say that I write a script that outputs the 1, 5, and 10 minute load
average of a Unix machine. In Cacti, I name the output fields '1min', '5min',
and '10min', respectively. Based on these two things, the output of the script
should look like the following:

`1min:0.40 5min:0.32 10min:0.01`

One last thing to keep in mind when writing scripts for Cacti is that they will
be executed as the user the data gatherer runs as. Sometimes a script may work
correctly when executed as root, but fails due to permissions problems when
executed as a less privileged user.

---
Copyright (c) 2018 Cacti Group
