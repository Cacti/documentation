# Spine

Use only the [supported operating systems][supported-os] and maintained
dependencies compatible with this Cacti branch.

Spine is a multithreaded replacement for `cmd.php`, written in C. Polling
performance depends on the devices, network latency, scripts, database and
collector configuration. Measure complete poll-cycle duration on your own
workload before choosing thread and process counts; this page does not provide
a reproducible benchmark or guarantee a particular speedup.

For Cacti 1.2.31, start with the corresponding
[Spine 1.2.31 source][spine-release] and its build instructions. Check the
installed binary's version and configuration before switching pollers. This
does not establish compatibility for arbitrary mixed Cacti and Spine versions.

When using Spine, don't change crontab or systemd settings! Always use
poller.php with crontab or cactid.php for systemd!

To activate Spine instead of cmd.php, please visit
`Console > Configuration > Settings > Poller` and select spine and save as the
`Poller Type`. If it's not showing as an available `Poller Type` this means
either it has not been installed, or it's path has not been defined on the
`Paths` tab within Settings.

Once saved, poller.php will use Spine on all subsequent polling cycles. Before
making this change, ensure that Spine runs properly from the command line using
the following test:

```console
cd /usr/local/spine/bin
./spine -R -V 3 -S
```

You should receive quite a bit of output depending on the size of your system.
To increase the number of Threads and concurrent processes, you must modify the
setting when editing your Data Collector under
`Console > Data Collection > Data Collectors`.

Choose Maximum Concurrent Poller Processes together with thread counts and
database connection capacity. CPU count alone does not determine the
appropriate settings.

When using spine, you must be senstivive to the number of connections that are
available for MySQL or MariaDB. Under
`Console > Utilities > System Utilities > General` Cacti will provide a
recommended `max_connection` for MySQL/MariaDB.

###### Table 15-1. Spine Parameters maintained at the System Level

| Name                                   | Description                                                                                                                                                                                           |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Script and Script Server Timeout Value | The maximum time that Spine will wait on a script to complete, in units of seconds. If a Script Server Script is terminated due to timeout conditions, the value entered into the RRDfile will be NaN |

###### Table 15-2. Spine Parameters maintained at the Data Collector Level

| Name                         | Description                                                                                                                                                                                                                                                                                                               |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Maximum Threads per Process | The maximum threads allowed per process. More threads may reduce time spent waiting for devices, but also increase database connections and concurrent work. Measure poll-cycle duration and resource use before increasing the value; there is no universal requirement to use 10-15 threads. |
| Number of PHP Script Servers | The number of concurrent script server processes to run per Spine process. Settings between 1 and 10 are accepted. Script Servers will pre-load a PHP environment. Then, the Script Server Scripts are included into that environment to save the overhead of reloading PHP and re-interpreting the binary for each call. |

###### Table 15-3. Spine Parameters maintained at the Device Level

| Name                                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The Maximum SNMP OIDs Per SNMP Get Request | The maximum number of SNMP get OIDs to issue per SNMP request. Increasing this value increases poller performance over slow links. The maximum value is 60 OIDs, but that value is highly dependent on the MTU for your links to the remote devices. In some cases, using a **Remote Data Collector** is much more effective for polling remote **Davices**. Additionally, some **Device Types** do not handle large SNMP OID get requests. It's best to experiment until you find the correct setting. |
| Device Threads                             | The maximum number spine threads used to gather information from a **Device**. When using this setting at the **Device** level, you have to ensure that you have enough threads allocated to a process so as to not block other **Devices** being polled from the same spine binary.                                                                                                                                                                                                                    |

### Installing Spine

Use a Spine release compatible with the installed Cacti release. For Cacti
1.2.31, obtain [Spine 1.2.31][spine-release] or a compatible maintained
package.
Follow that release's build instructions rather than using an older archive.

On supported Ubuntu Server or Debian installations:

```console
apt-get update
apt-get install -y build-essential autoconf automake libtool dos2unix \
  help2man libssl-dev default-libmysqlclient-dev libsnmp-dev
```

On supported RHEL, Rocky Linux, or AlmaLinux installations, first enable the
vendor's development-header repository if needed. Repository names differ
between RHEL and its derivatives. Install the required build tools:

```console
dnf install -y gcc autoconf automake libtool dos2unix help2man \
  openssl-devel mariadb-devel net-snmp-devel
```

Build and install from the extracted release directory:

```console
./bootstrap
./configure
make
make install
```

Copy the installed `spine.conf.dist` to `spine.conf`. Set `DB_Host`,
`DB_Database`, `DB_User`, `DB_Pass`, and `DB_Port` to the actual Cacti database
connection. Restrict access to the configuration to administrators and the
poller account. Configure the installed Spine binary and configuration paths
in Cacti, then test execution under the actual poller account.

Grant raw-socket privileges only if the selected availability checks need
them, using the package's documented mechanism. Do not grant blanket root
execution privileges merely to resolve a failed configuration check.

### Testing/Debugging spine via command line

spine offer a a few different ways at the command line to test its
functionality. Here are a few examples of some tests you can run by executing
spine.

#### Test Spine without writing results to database

This test allows you to run spine and display the results to the console. This
will not commit any of the data to the database by specifying the -R option.

```shell
/usr/local/spine/bin# ./spine -R -V 5
SPINE: Using spine config file [../etc/spine.conf]
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The path_php_server variable is /var/www/html/cacti/script_server.php
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The path_cactilog variable is /var/www/html/cacti/log/cacti.log
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The log_destination variable is 1 (FILE)
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The path_php variable is /usr/bin/php
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The availability_method variable is 2
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The ping_recovery_count variable is 3
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The ping_failure_count variable is 2
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The ping_method variable is 2
2021-01-08 14:26:25 - SPINE: Poller[1] PID[13482] DEBUG: The ping_retries variable is 1
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] POLLER: Active Threads is 1, Pending is 1
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] DEBUG: Entering ICMP Ping
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] DEBUG: Attempting to ping 192.168.1.5, seq 9 (Retry 0 of 1)
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] DEBUG: Attempting to ping 192.168.1.5, seq 9 (Retry 0 of 1)
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] DEBUG: ICMP Device Alive, Try Count:1, Time:0.4990 ms
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] PING: Result ICMP: Device is Alive
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] HT[1] Device has no information for recache.
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] HT[1] NOTE: There are '1' Polling Items for this Device
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] DEBUG: The NIFTY POPEN returned the following File Descriptor 5
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] HT[1] DS[64] TT[9.95] SCRIPT: perl /var/www/html/cacti/scripts/ping.pl '192.168.1.5', output: 0.047
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] HT[1] Total Time: 0.018 Seconds
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] Device[38] HT[1] DEBUG: HOST COMPLETE: About to Exit Device Polling Thread Function
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] DEBUG: The Value of Active Threads is 0 for Device ID 38
2021-01-08 14:31:40 - SPINE: Poller[1] PID[13804] POLLER: Active Threads is 0, Pending is 0
```

#### Running spine for a specific host

If you want to run spine for a specific host you are able to do that with the
following command:

```shell
/usr/local/spine/bin# ./spine -R -f 42 -l 42 -V 5
SPINE: Using spine config file [../etc/spine.conf]
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: The path_php_server variable is /var/www/html/cacti/script_server.php
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: The path_cactilog variable is /var/www/html/cacti/log/cacti.log
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: The log_destination variable is 1 (FILE)
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: The path_php variable is /usr/bin/php
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: The Value of Active Threads is 1 for Device ID 0
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] POLLER: Active Threads is 1, Pending is 0
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] SPINE: Active Threads is 1, Pending is 1
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] DEBUG: In Poller, About to Start Polling of Device for Device ID 42
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] IPv4 address 1.1.1.30 (1.1.1.30)
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] DEBUG: Entering ICMP Ping
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] DEBUG: Attempting to ping 1.1.1.30, seq 0 (Retry 0 of 1)
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] DEBUG: ICMP Device Alive, Try Count:1, Time:26.5849 ms
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] PING: Result ICMP: Device is Alive
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] HT[1] Device has no information for recache.
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] HT[1] NOTE: There are '1' Polling Items for this Device
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] DEBUG: The NIFTY POPEN returned the following File Descriptor 7
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] HT[1] DS[68] TT[42.86] SCRIPT: perl /var/www/html/cacti/scripts/ping.pl '1.1.1.30', output: 26.9
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] HT[1] Total Time: 0.077 Seconds
2021-01-08 14:34:14 - SPINE: Poller[1] PID[14296] Device[42] HT[1] DEBUG: HOST COMPLETE: About to Exit Device Polling Thread Function
```

#### Spine debug via GUI

You are also able to view spine debug information via the log file also spine
allows you to raise the level of detail it provides in the log if you want to
debug a specific device and see the spine output click enable device debug.

Below is an example output of Spine debug info via the log file

![spine](images/spine-debug-gui.png)

To enable more detailed spine logging go to
`Console > Configuration > Settings > Poller`

You can choose from Detailed,Summary or No logging for Invalid data

Detailed Logging will be similar to cmd.php in that you will get a report for
each data source that is having an issue

Summary provides a count of how many data sources are having an issue per
device

![spine](images/spine-parameters.png)

### Common Spine related errors

```shell
2021/01/08 14:38:44 - SPINE: Poller[1] PID[14838] FATAL: Unable to read configuration file! (Spine init)
```

Ensure that you have spine.conf in /usr/local/spine/etc on first install
`spine.conf` may be `spine.conf.dist`.

```shell
DEBUG Falling back to UDP Ping Due to SetUID Issues
```

This is a permissions issue with spine ensure you have give spine the proper
permissions

```shell
chmod u+s /usr/local/spine/bin/spine
```

[spine-release]:<https://github.com/Cacti/spine/tree/release/1.2.31>

[supported-os]: Requirements.md#supported-operating-systems

---

Copyright (c) 2004-2026 The Cacti Group
