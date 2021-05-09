# PHP Script Server

The **PHP Script Server** is a memory resident PHP interpreter that is launched
by each Cacti **Data Collector** or poller each polling cycle.  If using
`cmd.php`, there will be at most one **PHP Script Server** launched per poller
process.  If using `spine` poller, then up to 10 **PHP Script Servers** will be
launched in a pool for the various `spine` threads to consume.

If you have a number of devices that must gather their data via a script, it's
very important to utilize the **PHP Script Server**. This feature allows for the
rapid execution of PHP based **Scripts** and **Data Queries** in Cacti thus
reducing **Data Collector** polling times.

The reason that the **PHP Script Server** is so fast is that the PHP interpreter
is started in memory one time, and for every **Data Source** polled, it's
controlling function is interpreted only once. The resulting much faster script
execution and reduced load average during the **Data Collectors** life cycle.
Using the **PHP Script Server** process over the traditional exec() process nets
roughly a 20+ fold speed improvement in Cacti's **Data Collection** process.

Since PHP is such a powerful language, this Cacti feature enables rapid
collection of virtually any **Data Source** metric.  It's an excellent choice
for both SNMP and non-SNMP based data.

## Using the Script Server

Cacti contains two sample **PHP Script Server** scripts for reference. They are
for the collection of HostMib CPU and Disk Partition information. These two
examples are based off the traditional POPEN version of the HostMib functions
found in earlier versions of Cacti.  Upgrading from these very old **Data Input
Methods** to the **PHP Script Server** is not longer supported.

## Migration of Existing Scripts and Data Queries to PHP Script Server

If you have **Scripts** or **Data Queries** that you wish to migrate, you must
follow the steps below to migrate those scripts to the **PHP Script Server**
format.

### Script File Changes

First, if your script is written in another languages, say Perl, or Python, you
need to convert it to PHP.  Then, each PHP Script file must be changed to the
new Script Server format. The changes are not dramatic, but required for the
proper operation of the **PHP Script Server**. Note that you should use PHP
internal functions for calling services rather than forking binaries within the
PHP script as this will defeat the purpose of the **PHP Script Server**.  Follow
the steps below to complete the migration.

1. Copy your existing script to a new name. The name must begin `ss_` followed
   by your script name. The `ss_` identifies the script as being a script server
   variety of the a PHP script and is named that way to easily identify them in
   your install. For example, if you previously had a script called
   `get_mysql_stats.php`, it's new name would be `ss_get_mysql_stats.php`.

2. Edit the new PHP script and add the following required lines to the file,
   where `ss_myfunction` is the same as your filename.

   ```php
   <?php
   $no_http_headers = true;

   /* display No errors */
   error_reporting(E_ERROR);

   if (!isset($called_by_script_server)) {
       array_shift($_SERVER["argv"]);
       print call_user_func_array("ss_myfunction", $_SERVER["argv"]);
   }
   ?>
   ```

3. What was originally just mainline code, must be replaced with a function
   name. For example, if your program previously contained the following three
   lines of code:

   ```php
   <?php
   $a = 100;
   $b = $a / 10;
   print $b;
   ?>
   ```

   Would become:

   ```php
   function ss_myfunction() {
       $a = 100;
       $b = $a / 10;
       print $b;
   }
   ```

4. If you have any additional functions declared within your script file, you
   must prefix them to make them unique among all functions. Our recommendation
   would be to prefix all functions with the name of the main function. For
   example if you have a function called "meme" you would rename it to
   `ss_myfunction_meme`. This guarantee's correct **PHP Script Server**
   functionality.

5. The last step is to change the function call that could have traditionally
   returned the value to the Cacti poller using the `print` function. You must
   change that line or lines in your code to utilize the `return` function
   instead. However, this does not apply to `print` statements that are not
   called from the Poller. For a simple script, this results in

   ```php
   function ss_myfunction() {
       $a = 100;
       $b = $a / 10;
       return $b;
   }
   ```

   Be careful, when writing Script Server Data Queries. Use the `return`
   function for returning results of the GET operation. But use `print` for
   `index` and `query` operations, e.g.

   ```php
   if (($cmd == "index")) {
       ...
       print $some_index_data . PHP_EOL;
   } elseif ($cmd == "query") {
       ...
       print $some_query_data . PHP_EOL;
   } elseif ($cmd == "get") {
       ...
       return $some_get_data;
   }
   ```

### XML File Changes

If your **Data Sources** are based upon a **Data Query**, then you must also
change your XML file contents and location. Please reference the XML files in
the `<path_cacti>/resource/script_server` directory for the specifics related to
your required modifications. However, you may also follow the instructions
below:

1. Modify the `<script_path>` tag. Change it from:

   ```xml
   <script_path>|path_php_binary| -q |path_cacti|/scripts/myfucntion.php</script_path>
   ```

   to simply the following:

   ```xml
   <script_path>|path_cacti|/scripts/ss_myfunction.php</script_path>
   ```

2. Add the following two XML tags below the `<script_path>` tag. Replace
   `ss_myfunction` with your function name:

    ```xml
    <script_function>ss_myfunction</script_function>
    <script_server>php</script_server>
    ```

3. Save the XML file.

### Data Query & Data Template Changes

Your **Data Queries** and **Data Templates** must be also modified. Although
somewhat self explanatory by now, you must make the following changes:

1. If the **Data Template** is based upon a **Script** and not a **Data Query**,
   change it's **Data Input Method** to `Script Server`.

2. If the **Data Template** is based upon a **Data Query**, edit the **Data
   Query** and change it's **Data Input Method** to `Get Script Server Data
   (Indexed)` and change the XML file path to point to the new XML file in the
   `<path_cacti>/resources/script_server/` directory.

3. Your final step is to go to the **Console > System Utilities > Rebuild Poller
   Cache** to apply the new settings.

If your **PHP Script Server** script is operating correctly, you should now be
migrated to the **PHP Script Server**.

## Testing Your Script in the Script Server

To test your script in the script server, simply follow the instructions below.
When you have finished you testing, simply type "quit" + `<CR>` at the **PHP
Script Server** command line to exit the script server.

1. Start the script server - You can do this by typing the following command:

   ```console
   shell> php <path_cacti>/script_server.php
   ```

   > **NOTE**: Due to a bug in Windows implementation of PHP, you must type the
   > full path name to the `script_server.php` file.

2. Type in your command - Using the example from above, you would type in the
   following:

   ```sh
   script server> /path_cacti/scripts/ss_myserver_file.php my_function argument1 argument2 ...
   ```

   In the Windows environment, your example could be the following:

   ```sh
   script server> c:\www\root\cacti\script\ss_myserver_file.php ss_myfunction argument1 argument2 ...
   ```

3. If your script and function is operating properly, you should get a result.

   ```sh
   script server> c:\www\root\cacti\script\ss_myserver_file.php ss_myfunction argument1 argument2 ...
   nameA:valueA nameB:valueB ...
   ```

4. To quit the script server, simply type `quit <CR>` at the command line.

   > **Note**: If there are errors in your script, you must restart the script
   > server before your retest your code.

---
<copy>Copyright (c) 2004-2021 The Cacti Group</copy>
