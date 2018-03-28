Frequently Asked Questions
==========================

Using Cacti
-----------

**Q:** How do I create traffic graphs?

**A:** Before you can create traffic graphs, Cacti must have working SNMP support. One way to do this is to compile PHP with SNMP support built in, many times you can install the 'php-snmp' package to do this. The second option is to have Cacti call the snmpget and snmpwalk binaries from your ucd-snmp or net-snmp installation. You can use the about page to determine whether to are using "built-in" or "external" SNMP support.

Now that you have working SNMP support, follow these steps.

1.  Click Devices on Cacti's menu.

2.  Click Add to add a new device.

3.  Type a description, hostname, management IP, and SNMP community. Make sure to select "Generic SNMP-enabled Host" under Host Template and click Create.

4.  Click Create Graphs for this Host at the top of the page.

5.  You should see one or more interfaces listed under the Data Query [SNMP - Interface Statistics] box. Place a check next to each interface that you want to graph. Below the box, select type of graph that you want to create (bits, bytes, summation, etc).

6.  Click Create, and Create again on the following screen to create your graphs.

General
-------

**Q:** I get a "Undefined variable: _SERVER" error message from Cacti.

**A:** Cacti 0.8.6 and above requires that you have at least PHP 4.1 or greater installed.

**Q:** I get a "Call to undefined function: mysql_connect()" error message from Cacti.

**A:** Your installation of PHP does not have MySQL installed or enabled. On binary-based distributions, make sure you have the 'php-mysql' package installed. Also make sure that 'extension=mysql.so' is uncommented in your php.ini file.

**Q:** I have forgotten my 'admin' password to Cacti, how do I reset it?

**A:** To reset the admin account password back to the default of 'admin', connect to your Cacti database at the command line.

    shell> mysql -u root -p cacti

Now execute the following SQL:

    mysql> update user_auth set password=md5('admin') where username='admin';

Monitoring
----------

**Q:** I am polling thousands of items and poller.php takes more than 5 minutes to run.

**A:** Give Spine, the fast replacement for poller.php a try. Unlike poller.php, Spine is written in c and makes use of pthreads. On a typical installation, it is not uncommon for Spine to poll about 500 items in less then 10 seconds.

**Q:** I changed x, and now some of my graphs are not updating.

**A:** The best thing to do here is to force Cacti to rebuild its poller cache. To do this click Utilities on the Cacti menu, and select Clear Poller Cache.

**Q:** I am using Redhat 8.0 and SNMP is not working.

**A:** Redhat 8.0 comes with a broken php-snmp package. Updating your 'php-snmp' and 'net-snmp' packages to their latest versions should fix this problem.

**Q:** How do I configure net-snmp so it will work with Cacti?

**A:** Run `snmpconf -g basic_setup` and follow the prompts. Also check that the file being used by snmpd is the correct config file. For Redhat Linux, snmpconf creates the `/etc/snmpd.conf`, but snmpd uses `/etc/snmpd/snmpd.conf`.

If this doesn't work a very simple config file is:

    # contact
    syslocation Something
    syscontact "root@someone.com"

    # auth
    rocommunity public

    # disk monitoring
    disk /

Graphs
------

**Q:** I just installed Cacti and all of my graphs appear as broken images.

**A:** For you to actually get graph images, poller.php must run at least once so it can create .rrd files in Cacti's 'rra/' directory. Double check that you configured your `/etc/crontab` file to execute poller.php every five minutes. Also make sure that the user poller.php runs as has permission to create new files in Cacti's 'rra/' directory.

If all of your settings appear correct, try running poller.php manually by cd'ing to Cacti's directory and typing:

    shell> php poller.php

If you have files in your 'rra/' directory, but your graphs still appear as broken images, you should enable graph debug mode see exactly why the graphs are not rendering. To do this go into Cacti, select Graph Management from the menu, select any graph listed, and select Turn On Graph Debug Mode.

**Q:** My graphs render, but they do not contain any data.

**A:** More often than not, this problem's cause is permissions. For instance if you run poller.php manually as root for testing, any .rrd files that it creates will be owned by root. Now when poller.php runs from cron, it will not be able to update these .rrd files because they are owned by root. You can double check the owner of your .rrd files by running the following command in your Cacti directory:

    shell> ls -al rra/

If only some of your graphs are not updating correctly, double check the Maximum Value field for all data sources used by these graphs. If the value being fed to the .rrd file exceeds its Maximum Value, RRDTool will insert an Unknown and you will see no data on the graph.

**Q:** A lot of my graphs contain long ifAlias names, but they are being truncated to 15 characters.

**A:** Cacti does this by default to better control graph title formatting. You can change this limit, by going to Cacti Settings on the Cacti menu, selecting the Visual tab, and changing the value for Data Queries - Maximum Field Length.

**Q:** One of my devices rebooted and now I have a huge spike on my graph!

**A:** This occurs because the reboot causes SNMP's counters to reset, which can cause a rather large spike on the graph when RRDTool tries to determine the change between the new small counter value and the large previous value. One way to combat this issue is to specify realistic maximum values for your data sources. RRDTool will ignore any value that is larger than the maximum value.

If you already have a spike on one or more of your graphs, there is a really [useful Perl script](http://cricket.sourceforge.net/contrib/files/killspike2) that will remove them for you.

**Q:** RRDTool Says: ERROR: unknown option '--slope-mode' or RRDTool Says: ERROR: Garbage ':39:24 To 2005/10/22 16:39:24\c' after command: COMMENT:From 2005/10/21 16:39:24 To 2005/10/22 16:39:24\c

**A:** This occurs because the version of RRDTool that you are running does not match the RRDTool version Cacti is configured to use. Double check your Cacti Settings and make sure that the RRDTool version matches what version of RRDTool you are running.

Windows Related
---------------

**Q:** I get a "Fatal error: Cannot redeclare title_trim()" error message from Cacti.

**A:** Contrary to previous versions of Cacti, you must not put Cacti in your PHP include path. Check your `php.ini` file to make sure there is not something like `include_path = C:/Apache2/htdocs/cacti`.

