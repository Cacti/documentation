Data Input Methods
==================

Data input methods allow Cacti to retrieve data to insert into data sources and ultimately put on a graph. There are different ways for Cacti to retrieve data, the most popular being through an external script or from SNMP.

Creating a Data Input Method
----------------------------

To create a new data input method, select the Data Input Methods option under the Management heading. Once on that screen, click Add on the right. You will be presented with a few fields to populate on the following screen.

||

When you are finished filling in all necessary fields, click the Create button to continue. You will be redirected back to the same page, but this time with two new boxes, Input Fields and Output Fields. The Input Fields box is used to define any fields that require information from the user. Any input fields referenced to in the input string must be defined here. The Output Fields box is used to define each field that you expect back from the script. *All data input methods must have at least one output field defined*, but may have more for a script.

### Data Input Fields

To define a new field, click Add next to the input or output field boxes. You will be presented with some or all of the fields below depending on whether you are adding an input or output field.

||

When you are finished filling in all necessary fields, click the Create button to continue. You will be redirected back to the data input method edit page. From here you can continue to add additional fields, or click Save on this screen when finished.

Making Your Scripts Work With Cacti
-----------------------------------

The simplest way to extend Cacti's data gathering functionality is through external scripts. Cacti comes with a number of scripts out of the box which are located in the `scripts/` directory. These scripts are used by the data input methods that are present in a new installation of Cacti.

To have Cacti call an external script to gather data you must create a new data input method, making sure to specify Script/Command for the Input Type field. See the previous section, [Creating a Data Input Method](data_input_methods.html) for more information about how to create a data input method. To gather data using your data input method, Cacti simply executes the shell command specified in the Input String field. Because of this, you can have Cacti run any shell command or call any script which can be written in almost any language.

What Cacti is concerned with is the output of the script. When you define your data input method, you are required to define one or more output fields. The number of output fields that you define here is important to your script's output. For a data input method with only one output field, your script should output its value in the following format:

    <value_1>

So if I wrote a script that outputs the number of running processes, its output might look like the following:

`67`

Data input methods with more than one output field are handled a bit differently when writing scripts. Scripts that output more than one value should be formatted like the following:

    <fieldname_1>:<value_1> <fieldname_2>:<value_2> ... <fieldname_n>:<value_n>

Lets say that I write a script that outputs the 1, 5, and 10 minute load average of a Unix machine. In Cacti, I name the output fields '1min', '5min', and '10min', respectively. Based on these two things, the output of the script should look like the following:

`1min:0.40 5min:0.32 10min:0.01`

One last thing to keep in mind when writing scripts for Cacti is that they will be executed as the user the data gatherer runs as. Sometimes a script may work correctly when executed as root, but fails due to permissions problems when executed as a less privileged user.

