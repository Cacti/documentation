# Frequently Asked Questions

## Using Cacti

**Q:** How do I create traffic graphs?

**A:** Before you can create traffic graphs, Cacti must have working SNMP
support. One way to do this is to compile PHP with SNMP support built in, many
times you can install the 'php-snmp' package to do this. The second option is
to have Cacti call the snmpget and snmpwalk binaries from your ucd-snmp or
net-snmp installation. You can use the about page to determine whether to are
using "built-in" or "external" SNMP support.

Now that you have working SNMP support, follow these steps.

1. Click Devices on Cacti's menu.

2. Click Add to add a new device.

3. Type a description, hostname, management IP, and SNMP community. Make sure
   to select "Generic SNMP-enabled Host" under Host Template and click Create.

4. Click Create Graphs for this Host at the top of the page.

5. You should see one or more interfaces listed under the Data Query [SNMP -
   Interface Statistics] box. Place a check next to each interface that you want
   to graph. Below the box, select type of graph that you want to create (bits,
   bytes, summation, etc).

6. Click Create, and Create again on the following screen to create your
   graphs.

## General

**Q:** When I visit the Cacti Monitoring Website, I see garbage instead of a
login prompt.

**A:** Starting iwth Cacti 1.2.x, the first thing you should always see is a
login prompt asking for your admin credentials before the installation wizard
will be displayed.  However, if you fail to see the login prompt, you may be
presented with text that looks like:

```php
<?php
/*
 +-------------------------------------------------------------------------+
 | Copyright (C) 2004-2021 The Cacti Group                                 |
 |                                                                         |
 | This program is free software; you can redistribute it and/or           |
 | modify it under the terms of the GNU General Public License             |
 | as published by the Free Software Foundation; either version 2          |
 | of the License, or (at your option) any later version.                  |
```

If this happens, it usually means that you have not enabled the PHP module to
work with your web server software.  This can be as simple as running `a2enmod`
on Ubuntu, or having to manually create a configuration for nginx under another
flavour of Linux.  For specific help on enabling PHP, search the internet using
your favourite search engine with keywords such as:

> How do I enable PHP under ...

Replacing the three dots with your operating system and web server software
should reveal many results on how to do this.  The specific steps are outside of
the scope of Cacti's FAQ documentation, though there are several How To
installation documents included that may also help.

**Q:** I get a "Undefined variable: _SERVER" error message from Cacti.

**A:** Cacti 0.8.6 and above requires that you have at least PHP 4.1 or greater
installed.

**Q:** I get a "Call to undefined function: mysql_connect()" error message from
Cacti.

**A:** Your installation of PHP does not have MySQL installed or enabled. On
binary-based distributions, make sure you have the 'php-mysql' package
installed. Also make sure that 'extension=mysql.so' is uncommented in your
php.ini file.

**Q:** I have forgotten my 'admin' password to Cacti, how do I reset it?

**A:** To reset the admin account password back to the default of 'admin',
connect to your Cacti database at the command line.

```sql
shell> mysql -u root -p cacti
```

Now execute the following SQL:

```sql
MySQL> update user_auth set password=md5('admin') where username='admin';
```

## Monitoring

**Q:** I am polling thousands of items and poller.php takes more than 5 minutes
to run.

**A:** Give Spine, the fast replacement for poller.php a try. Unlike
poller.php, Spine is written in c and makes use of threads. On a typical
installation, it is not uncommon for Spine to poll about 500 items in less then
10 seconds.

**Q:** I changed x, and now some of my graphs are not updating.

**A:** The best thing to do here is to force Cacti to rebuild its poller cache.
To do this click Utilities on the Cacti menu, and select Clear Poller Cache.

**Q:** I am using Redhat 8.0 and SNMP is not working.

**A:** Redhat 8.0 comes with a broken php-snmp package. Updating your
'php-snmp' and 'net-snmp' packages to their latest versions should fix this
problem.

**Q:** How do I configure net-snmp so it will work with Cacti?

**A:** Run `snmpconf -g basic_setup` and follow the prompts. Also check that
the file being used by snmpd is the correct config file. For Redhat Linux,
snmpconf creates the `/etc/snmpd.conf`, but snmpd uses `/etc/snmpd/snmpd.conf`.

If this doesn't work a very simple config file is:

    # contact
    syslocation Something
    syscontact "root@someone.com"

    # auth
    rocommunity public

    # disk monitoring
    disk /

## Graphs

**Q:** I just installed Cacti and all of my graphs appear as broken images.

**A:** For you to actually get graph images, poller.php must run at least once
so it can create .rrd files in Cacti's 'rra/' directory. Double check that you
configured your `/etc/crontab` file to execute poller.php every five minutes.
Also make sure that the user poller.php runs as has permission to create new
files in Cacti's 'rra/' directory.

If all of your settings appear correct, try running poller.php manually by
cd'ing to Cacti's directory and typing:

```sh
shell> php poller.php
```

If you have files in your 'rra/' directory, but your graphs still appear as
broken images, you should enable graph debug mode see exactly why the graphs
are not rendering. To do this go into Cacti, select Graph Management from the
menu, select any graph listed, and select Turn On Graph Debug Mode.

**Q:** My graphs render, but they do not contain any data.

**A:** More often than not, this problem's cause is permissions. For instance
if you run poller.php manually as root for testing, any .rrd files that it
creates will be owned by root. Now when poller.php runs from cron, it will not
be able to update these .rrd files because they are owned by root. You can
double check the owner of your .rrd files by running the following command in
your Cacti directory:

```sh
shell> ls -al rra/
```

If only some of your graphs are not updating correctly, double check the
Maximum Value field for all data sources used by these graphs. If the value
being fed to the .rrd file exceeds its Maximum Value, RRDtool will insert an
Unknown and you will see no data on the graph.

**Q:** A lot of my graphs contain long ifAlias names, but they are being
truncated to 15 characters.

**A:** Cacti does this by default to better control graph title formatting. You
can change this limit, by going to Cacti Settings on the Cacti menu, selecting
the Visual tab, and changing the value for Data Queries - Maximum Field Length.

**Q:** One of my devices rebooted and now I have a huge spike on my graph!

**A:** This occurs because the reboot causes SNMP counters to reset, which
can cause a rather large spike on the graph when RRDtool tries to determine the
change between the new small counter value and the large previous value. One
way to combat this issue is to specify realistic maximum values for your data
sources. RRDtool will ignore any value that is larger than the maximum value.

If you already have a spike on one or more of your graphs, there is a really
[useful Perl script](http://cricket.sourceforge.net/contrib/files/killspike2)
that will remove them for you.

**Q:** RRDtool Says: ERROR: unknown option '--slope-mode' or RRDtool Says:
ERROR: Garbage ':39:24 To 2005/10/22 16:39:24\c' after command: COMMENT:From
2005/10/21 16:39:24 To 2005/10/22 16:39:24\c

**A:** This occurs because the version of RRDtool that you are running does not
match the RRDtool version Cacti is configured to use. Double check your Cacti
Settings and make sure that the RRDtool version matches what version of RRDtool
you are running.

## Windows Related

**Q:** I get a "Fatal error: Cannot redeclare title_trim()" error message from
Cacti.

**A:** Contrary to previous versions of Cacti, you must not put Cacti in your
PHP include path. Check your `php.ini` file to make sure there is not something
like `include_path = C:/Apache2/htdocs/cacti`.

## Common Problems

### Cron is out of sync with the Poller Interval

```shell
WARNING: Cron is out of sync with the Poller Interval! The Poller Interval is
'15' seconds, with a maximum of a '60' second Cron, but 300.9 seconds have
passed since the last poll!
```

This warning message may be recorded in the Cacti logs if you have a mismatch
between the cron file that runs the poller.php and the settings within Cacti
itself.  Browse to **Console -> Configuration -> Settings -> Poller** *(tab)*
and check that the Cron Interval is defined as either 1 minute or 5 minutes.

If the cron inteval is 5 minutes, then the schedule within the cron
configuration file (normally /etc/cron.d/cacti) should be set to:

```console
*/5 * * * *
```

For 1 minute intervals, this should be:

```console
* * * * *
```

### Poller Runtime exceeded

```shell
POLLER: Poller[0] Maximum runtime of xxx seconds exceeded.
```

This error indicates that Cacti was unable to finish the polling cycle in time.
This can be for a few reasons.

* You are using spine and have not entered the correct mysql credentials in spine.conf
* You do not have an adaquete proccess setting for cmd.php or thread/process
  count for spine
* Network related issue either an network outage or a network slowdown
* System related trouble cpu/memory exhaustion
* Insufficient MySQL connections resulting in spine failing

### RRDtool reports Unknown Error

Sometimes, RRDtool can be rather unhelpful and display the simple error within
the graph image of "Unknown Error".  When this occurs, the best course of action
would be to grab the command that Cacti uses and see if any more information is
given at the command line level.

To do this, edit a graph that has the issue, select **Turn On Graph Debug** and
a new section should appear beneath the graph.  This should show both the
command and what output we received from the tool.

```console
RRDtool Command:
  /usr/bin/rrdtool graph - \
  --imgformat=PNG \
  --start='-86400' \
  --end='-60' \
  --pango-markup  \
  --title='localhost - CPU Usage' \
  --vertical-label='percent' \
  --slope-mode \
  --base=1000 \
  --height=200 \
  --width=700 \
  --tabwidth '40' \
  --rigid \
  --alt-autoscale-max \
  --lower-limit='0' \
  COMMENT:"From 2019/10/19 12\:37\:00 To 2019/10/20 12\:36\:00\c" \
  COMMENT:"  \n" \
  --color BACK#F3F3F3 \
  --color CANVAS#FDFDFD \
  --color SHADEA#CBCBCB \
  --color SHADEB#999999 \
  --color FONT#000000 \
  --color AXIS#2C4D43 \
  --color ARROW#2C4D43 \
  --color FRAME#2C4D43 \
  --border 1 --font TITLE:11:'Arial' \
  --font AXIS:8:'Arial' \
  --font LEGEND:8:'Courier' \
  --font UNIT:8:'Arial' \
  --font WATERMARK:6:'Arial' \
  --slope-mode \
  --watermark 'Generated by Cacti' \
  DEF:a='/usr/share/cacti/site/rra/127_0_0_1_5min_cpu_40.rrd':'5min_cpu':MAX \
  AREA:a#FF0000FF:'CPU Usage'  \
  GPRINT:a:LAST:'Current\:%8.0lf'  \
  GPRINT:a:AVERAGE:'Average\:%8.0lf'  \
  GPRINT:a:MAX:'Maximum\:%8.0lf\n'

RRDtool Says:
  OK
```

If the output above isn't helpful, simply copy the command section and then
run it as the user which the website runs as.  For Linux, you can do this by
either `su - <user>` and then running the command, or `sudo -u <user> <command>`
to stay as your current user but run the command as the website user.

For Windows, the following command will allow you to spawn a command prompt as
the website user, from which you can then run the above command to see the
output.

```console
runas /user:<machine or domain>\<user> cmd.exe
```

The newly created command prompt should show the user name if you have entered
the correct password.

---
Copyright (c) 2004-2021 The Cacti Group
