# Data Input Methods

Data Input Methods allow Cacti to retrieve data to insert into RRDfiles based
upon a mapping controlled by **Data Templates** and their corresponding **Data
Sources**.  These resulting **Data Templates** and **Data Sources** can then be
used to create **Graph Templates** and **Graphs**.

Cacti includes a number of build in **Data Input Methods** for **SNMP** data and
for **Script**, **Script Server** and **SNMP Data Queries**.

Outside of the built in **Data Input Methods**, the Cacti Administrator can
create virtually any **Data Input Method** based upon a **Script**, or a PHP
**Script Server** script.  The **Script** based **Data Input Method** allows
Cacti to virtually collect data from anywhere, though the built in **SNMP** and
**Script Server** methods provide the greatest scalability in Cacti.  Both
**Data Queries**, and PHP **Script Server** topics will be covered in later
sections of the documentation.

## Creating a Data Input Method

To create a new **Data Input Method**, from the Cacti Console, select **Data
Collection > Data Input Methods**. Once on that screen, click the plus (+) glyph
on the right which will allow you to add a new **Data Input Method**. You will
be presented with a few fields to populate on the following screen.

###### Table 11-1. Field Description: Data Input Methods

Name | Description
--- | ---
Name | Give the data query a name that you will use to identify it
Input Type | Select the type of **Data Input Method** you are trying to create
Input String | This field is only used when the Input Type is set to **Script/Command**

The `Name` specified will be used throughout Cacti to identify the human
readable name given to the **Data Input Method**.  Careful consideration should
be made to help uniquely identify the **Data Source**.  Having very similar
names can lead to confusion when utilizing them as your Cacti system grows.

Valid options for `Input Type` are **Script/Command**, and **Script Server**.
As mentioned previously, Cacti provides built in **Data Input Methods** for SNMP
data gathering and for SNMP, **Script**, and **Script Server** based **Data
Queries**.  Though present in the Cacti database, they are hidden from user
view.

When the type is set to `Script/Command`, the `Input String` specifies the full
path to the script including any per **Data Source** input variables.  **Data
Source** input variables must be enclosed in greater than and less than
characters. For instance, if you are passing an IP address to a script, your
input string might look something like: `/path/to/script.pl <ip>` When the user
creates a **Data Source** based on this **Data Input Method**, they will be
prompted for an IP address to pass onto the script.

When you are finished filling in all necessary fields, click the Create button
to continue. Upon saving the new **Data Input Method**, you will be presented
with two new sections to complete.  Those sections will instruct Cacti what to
pass to the Script, known as `Input Fields` otherwise known as `Input
Parameters` and how to handle the output data, which we refer to as `Output
Fields`.

The `Input Fields` box is used to define any fields that require information
from the user or from various data within the Cacti Database such as the
hostname, ip address, host id, etc. Any input fields referenced to in the input
string must be defined here.

The `Output Fields` box is used to define each field that you expect back from
the script and will be eventually stored in both the database and RRDfiles.

*All **Data Input Methods** must have at least one output field defined*, but
may have more than one depending on the type.

### Data Input Fields

To define a new field, click the plus sign (+) next to the input or output field
boxes. You will be presented with some or all of the fields below depending on
whether you are adding an input or output field.

###### Table 11-2. Field Description: Data Input Fields

Name | Description
--- | ---
Field/Field Name | You will be presented a drop down list of the unused braced input fields from the command
Friendly Name | Enter a more descriptive name for this field
Regular Expression Match (Input Only) | Enter a valid regular expression as to how to modify the output
Allow Empty Input (Input Only) | Can the input value of this field blank or not
Special Type Code (Input Only) | Pull the input data from the Cacti database and don't prompt the user for this input value
Update RRDfile (Output Only) | Checked if you intend this output data to be stored in an RRDfile

The `Field Name` must contain no spaces or other non-alphanumeric characters
(except '-' or '_').

If you want to enforce a certain regular expression pattern when the user enters
a value into `Regular Expression Match (Input Only)` for this Data Input Field,
it must follow POSIX syntax as it will be passed to PHP's preg() functions.

If the Data Input Field needs to reference another field internally, you can
enter this into the `Special Type Code`. For instance, if your field requires an
IP address from the user, you can enter 'management_ip' here and Cacti will fill
this field in with the current IP address of the selected host.

###### Table 11-3. Special Type Codes

Field Name | Description
--- | ---
hostname | The hostname
management_ip | The ip
snmp_community | The SNMP community
snmp_username | The SNMP username
snmp_password | The SNMP version

If you enable the `Update RRDfile`, Cacti will insert the return value from this
field into the RRDfile. This box needs to be checked for at least one output
field per data input source, but can be left blank to have Cacti store the value
only in the database instead.

When you are finished filling in all necessary fields, click the Create button
to continue. You will be redirected back to the **Data Input Method** edit page.
From here you can continue to add additional fields, or click Save on this
screen when finished.

## Making Your Scripts Work With Cacti

The simplest way to extend Cacti's data gathering functionality is through
external scripts. Cacti comes with a number of scripts out of the box which are
located in the `scripts/` directory. These scripts are used by the **Data Input
Methods** that are present in a new installation of Cacti.

To have Cacti call an external script to gather data you must create a new
**Data Input Method**, making sure to specify Script/Command for the Input Type
field. See the previous section, [Creating a Data Input
Method](data_input_methods.html) for more information about how to create a
**Data Input Method**. To gather data using your **Data Input Method**, Cacti
simply executes the shell command specified in the Input String field. Because
of this, you can have Cacti run any shell command or call any script which can
be written in almost any language.

What Cacti is concerned with is the output of the script. When you define your
**Data Input Method**, you are required to define one or more output fields. The
number of output fields that you define here is important to your script's
output. For a **Data Input Method** with only one output field, your script
should output its value in the following format:

```console
<numeric value>
```

So if I wrote a script that outputs the number of running processes, its output
might look like the following:

```console
67
```

Data Input Methods with more than one output field are handled a bit differently
when writing scripts. Scripts that output more than one value should be
formatted like the following:

```console
<fieldname_1>:<value_1> <fieldname_2>:<value_2> ... <fieldname_n>:<value_n>
```

If you wrote a script that outputs the 1, 5, and 10 minute load average of a
Unix machine and in Cacti named the output fields '1min', '5min', and '10min',
the output of the script should look like the following:

`1min:0.40 5min:0.32 10min:0.01`

One last thing to keep in mind when writing scripts for Cacti is that they will
be executed as the user the data gatherer runs as. Sometimes a script may work
correctly when executed as root, but fails due to permissions problems when
executed as a less privileged user.

## Walkthough

You can find a detailed example of how to create a complete Graph from
simple command output in the following example
[How To Create a Data Input Method](How-To-Create-Data-Input-Method.md).

---
Copyright (c) 2004-2021 The Cacti Group
