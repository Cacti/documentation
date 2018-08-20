# PHP Script Server

The PHP Script Server is a new feature in Cacti 0.8.6. This new feature allows
for the rapid execution of PHP based Data Queries in Cacti. The Script Server
process is launched by the poller during every polling cycle. It listens for
commands from the poller, executes them, and then waits for an quit signal.

The reason that it is so fast is that PHP is started in memory only one time,
and for every Data Query called, it's code is interpreted only once. The
resulting Data Query binaries are therefore very efficient. Using the Script
Server process over the traditional POPEN process nets a 20+ fold speed
improvement in Cacti.

Since PHP scripts are so powerful, this new feature in Cacti, makes it an
excellent choice for collecting non-SNMP and SNMP based data.

## Using the Script Server

Cacti 0.8.6 contains two sample script server routines. They are for the
collection of HostMib CPU and Disk Partition information. These two examples
are based off the traditional POPEN version of the HostMib functions found in
earlier versions of Cacti.

For new installs, the HostMib functions are defaulted to using the PHP Script
Server, therefore, you don't need to do anything to use it.

For upgrades, you must make several changes to start using the PHP Script
Server for the HostMib CPU and HostMib Partitions Data Queries. To migrate you
must follow the step below.

## Upgrade Steps for the Example HostMib Data Queries

If you are using the two built in script queries, "SNMP - Get Mounted
Partitions" and "SNMP - Get Processor Information", you can migrate to the PHP
Script Server using the steps below:

1. Verify the existence of New Data Input Method - Go to Data Input Methods,
   verify that you see the "Get Script Server Data (Indexed)" Data Input Method
   exists and that it is using the "Script Query - Script Server" method.

2. Disable the Poller - Goto Settings -> Poller and uncheck the Poller Enabled
   checkbox. Press Save.

3. Update Your Data Queries - Go to Data Queries and Edit the two Data Queries
   below. Change both their Data Input Method to `Get Script Server Data
   (Indexed)` and in the XML path replace `script_query` with `script_server` as
   shown below:

   - `SNMP - Get Mounted Partitions`

      `<path_cacti>/resource/script_server/host_disk.xml`

   - `SNMP - Get Processor Information`

     `<path_cacti>/resource/script_server/host_cpu.xml`

4. Update Your Data Templates - Goto Data Templates, locate the following two
   data templates and change their data input method to `Get Script Server Data
   (Indexed)`.

   - `Host MIB - Hard Drive Space`

   - `Host MIB - CPU Utilization`

5. Re-enable the Poller - Go to Settings -> Poller and check the Poller Enabled
   checkbox. Click the `Save` button.

Following those steps should complete your migration to the new PHP Script
Server for the two example HostMIB Data Queries.

## Migration of Existing PHP Scripts to Script Server

If you have other PHP scripts that you wish to migrate, you must follow the
steps below to migrate your scripts to the PHP Script Server required format.

### Script File Changes

Each PHP Script file must be changed to the new Script Server format. The
changes are not dramatic, but required for the proper operation of the PHP
Script Server. Follow the steps below to complete.

1. Copy you existing script to a new name. The name must begin `ss_` followed
   by your script name. The `ss_` identifies the script as being a script
   server variety of the a PHP script. For example, if you previously had a
   script called `get_mysql_stats.php`, it's new name would be
   `ss_get_mysql_stats.php`.

2. Edit the new PHP script and add the following required lines to the file,
   where `ss_myfunction` is the same as your filename.

~~~php
<?php
$no_http_headers = true;

/* display No errors */
error_reporting(E_ERROR);

include_once(dirname(__FILE__) . "/../include/config.php");
include_once(dirname(__FILE__) . "/../lib/snmp.php");

if (!isset($called_by_script_server)) {
    array_shift($_SERVER["argv"]);
    print call_user_func_array("ss_myfunction", $_SERVER["argv"]);
}
~~~

3. What was originally just mainline code, must be replaced with a function
   name. For example, if your program previously contained the following three
   lines of code:

~~~php
<?php
$a = 100;
$b = $a / 10;
print $b;
?>
~~~

   Would become:

~~~php
function ss_myfunction() {
    $a = 100;
    $b = $a / 10;
    Print $b;
}
~~~

4. If you have any additional functions declared within your script file, you
   must prefix them to make them unique amongst all functions. Our
   recommendation would be to prefix all functions with the name of the main
   function. For example if you have a function called "meme" you would rename
   it to `ss_myfunction_meme`. This guarantee's correct Script Server
   functionality.

5. The last step is to change the function call that could have traditionally
   returned the value to the Cacti poller using the `print` function. You must
   change that line or lines in your code to utilize the `return` function
   instead. However, this does not apply to `print` statements that are not
   called from the Poller. For a simple script, this results in

~~~php
function ss_myfunction() {
    $a = 100;
    $b = $a / 10;
    Return $b;
}
~~~

   Be careful, when writing Script Server Data Queries. Use the `return`
   function for returning results of the GET operation. But use `print` for
   `index` and `query` operations, e.g.

~~~php
if (($cmd == "index")) {
    ...
    print $some_index_data . "n";
} elseif ($cmd == "query") {
    ...
    print $some_query_data . "n";
} elseif ($cmd == "get") {
    ...
    result $some_get_data;
}
~~~

### XML File Changes

If you are using a `Script Query` type function, then you must also change your
XML file. Please reference the XML files in the
`<path_cacti>/resource/script_server` directory for the specifics related to
your required modifications. However, you may also follow the instructions
below:

1. Modify the `<script_path>` tag. Change it from:

   `<script_path>|path_php_binary| -q |path_cacti|/scripts/myfucntion.php</script_path>`

   to simply the following:

   `<script_path>|path_cacti|/scripts/ss_myfunction.php</script_path>`

2. Add the following two XML tags below the `<script_path>` tag. Replace
   `ss_myfunction` with your function name:

    ~~~xml
    <script_function>ss_myfunction</script_function>
    <script_server>php</script_server>
    ~~~

3. Save the XML file.

### Data Query & Data Template Changes

Your Data Queries and Data Templates must be also changed. Although somewhat
self explanatory by now, you must make the following changes:

1. Change it's Input Method to "Get Script Server Data" or "Get Script Server
   Data (Index)" depending on it's type.

2. Change the XML file path to point to the new XML file in the
   `<path_cacti>/resources/script_server/*.xml` path.

3. For all data templates that use the data query you must change their "Data
   Input Method" accordingly.

Your final step is to go to the System Utilities and Clear Poller Cache to
apply the new settings. If you script is operating correctly, you should now be
migrated to the script server.

## Testing Your Script in the Script Server

To test your script in the script server, simply follow the instructions below.
When you have finished you testing, simply type "quit" + `<CR>` at the Script
Server command line to exit the script server.

1. Start the script server - You can do this by typing the following command:

   `shell> php <path_cacti>/script_server.php`

   > **NOTE**: Due to a bug in Windows implementation of PHP, you must type
   > the full path name to the `script_server.php` file.

2. Type in your command - Using the example from above, you would type in the
   following:

   ~~~sh
   script server> <path_myfunction> my_function argument1 argument2 ...
   ~~~

   In the Windows environment, your example could be the following:

   ~~~sh
   script server> c:\www\root\cacti\script\ss_myfunction.php ss_myfunction localhost public 1 get duddle
   ~~~

3. If your function is operating properly, you should get a result.

4. To quit the script server, simply type "quit" `<CR>` at the command line.

> **Note**: If there are errors in your script, you must restart the script
> server before your retest your code.
