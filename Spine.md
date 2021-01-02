# Spine

Spine is the fast replacement for `cmd.php`. It is written in C to ensure
ultimate performance for device polling and is multi-threaded. Expect a 
decrease in polling time of an order of magnitude. Polling times far 
less than 60 seconds for about 20,000 data sources are achievable e.g. 
on a dual XEON system supplied with 4 GB RAM and standard local disks.

When using Spine, don't change crontab or systemd settings! Always use 
poller.php with crontab or cactid.php for systemd!

To activate Spine instead of cmd.php, please visit 
`Console > Configuration > Settings > Poller` and select spine and save
as the `Poller Type`. If it's not showing as an available `Poller Type`
this means either it has not been installed, or it's path has not
been defined on the `Paths` tab within Settings.

Once saved, poller.php will use Spine on all subsequent polling cycles.
Before making this change, ensure that Spine runs properly from the
command line using the following test:

```console
cd /usr/local/spine/bin
./spine -R -V 3 -S
```

You should receive quite a bit of output depending on the size of your
system.  To increase the number of Threads and concurrent processes,
you must modify the setting when editing your Data Collector under
`Console > Data Collection > Data Collectors`.

While Spine is really fast, choosing the correct setup will ensure that all
processor resources are used. Required settings for Maximum Concurrent Poller
Processes are 1-2 times the number of CPU cores available for Spine.

When using spine, you must be senstivive to the numer of connections that
are available for MySQL or MariaDB.  Under 
`Console > Utilities > System Utilities > General` Cacti will provide a
recommended `max_connection` for MySQL/MariaDB.


###### Table 15-1. Spine Specific Execution Parameters maintained at the System Level

Name | Description
--- | ---
Script and Script Server Timeout Value | The maximum time that Spine will wait on a script to complete, in units of seconds. If a Script Server Script is terminated due to timeout conditions, the value entered into the RRD file will be NaN

###### Table 15-2. Spine Specific Execution Parameters maintained at the Data Collector Level

Name | Description
--- | ---
Maximum Threads per Process | The maximum threads allowed per process. Using a higher number when using Spine will improve performance. Required settings are 10-15. Values above 50 are most often insane and may degrade performance vs. improve it.
Number of PHP Script Servers | The number of concurrent script server processes to run per Spine process. Settings between 1 and 10 are accepted. Script Servers will pre-load a PHP environment. Then, the Script Server Scripts are included into that environment to save the overhead of reloading PHP and re-interpreting the binary for each call.

###### Table 15-3. Spine Specific Execution Parameters maintained at the Device Level

Name | Description
--- | ---
The Maximum SNMP OIDs Per SNMP Get Request | The maximum number of SNMP get OIDs to issue per SNMP request. Increasing this value increases poller performance over slow links. The maximum value is 60 OIDs, but that value is highly dependent on the MTU for your links to the remote devices.  In some cases, using a **Remote Data Collector** is much more effective for polling remote **Davices**. Additionally, some **Device Types** do not handle large SNMP OID get requests.  It's best to experiment until you find the correct setting.
Device Threads | The maximum number spine threads used to gather information from a **Device**.  When using this setting at the **Device** level, you have to ensure that you have enough threads allocated to a process so as to not block other **Devices** being polled from the same spine binary.


### Installing Spine

As Spine is written in C is must be compiled on the local system that it is to
be installed on  below is an example of compiling on centos and Ubuntu

### Ubuntu

Install the required system packages

```console
apt-get install -y build-essential dos2unix dh-autoreconf libtool help2man libssl-dev libmysql++-dev librrds-perl libsnmp-dev
```

Next, download the version of spine you are looking for Typically this should
match the version of Cacti you are using. In this case we will download Version
1.2.3 of Spine

```console
wget <https://github.com/Cacti/spine/archive/release/1.2.3.zip>
unzip 1.2.3
cd spine-release-1.2.3
```

Once you are in the spine directory its time to compile the poller by issuing
the following commands:

```console
./bootstrap
./configure
make
make install
chown root:root /usr/local/spine/bin/spine
chmod u+s /usr/local/spine/bin/spine
```

Once that has completed, you will need to configure spine's config file

```console
vi /usr/local/spine/etc/spine.conf
```

Below is an example of a configuration however yours should match your cacti
database username and password

```console
DB_Host       localhost
DB_Database   cacti
DB_User       spine
DB_Pass       spine
DB_Port       3306
#DB_UseSSL    0
#RDB_SSL_Key
#RDB_SSL_Cert
#RDB_SSL_CA
```

### CentOS

Install required system packages

```console
yum install -y gcc mysql-devel net-snmp-devel autoconf automake libtool dos2unix help2man
```

Then compile using the folowing commands

```console
./bootstrap
./configure
make
make install
chown root:root /usr/local/spine/bin/spine
chmod u+s /usr/local/spine/bin/spine
```

---
Copyright (c) 2004-2021 The Cacti Group
