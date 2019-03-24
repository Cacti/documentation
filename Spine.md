# Spine

Spine is the fast replacement for `cmd.php`. It is written in C to ensure
ultimate performance for device polling. Expect a decrease in polling time of
an order of magnitude. Polling times far less than 60 seconds for about 20,000
data sources are achievable e.g. on a dual XEON system supplied with 4 GB RAM
and standard local disks.

When using Spine, don't change crontab settings! Always use poller.php with
crontab! To activate Spine instead of cmd.php, please visit Settings and select
the Poller tab. Select Spine and save. Now, poller.php will use Spine on all
subsequent polling cycles.

While Spine is really fast, choosing the correct setup will ensure, that all
processor resources are used. Required settings for Maximum Concurrent Poller
Processes are 1-2 times the number of CPU cores available for Spine.

###### Table 15-1. Spine Specific Execution Parameters

Name | Description
--- | ---
Maximum Threads per Process | The maximum threads allowed per process. Using a higher number when using Spine will improve performance. Required settings are 10-15. Values above 50 are most often insane and may degrade performance
Number of PHP Script Servers | The number of concurrent script server processes to run per Spine process. Settings between 1 and 10 are accepted. Script Servers will pre-load a PHP environment. Then, the Script Server Scripts are included into that environment to save the overhead of reloading PHP each and every time.
Script and Script Server Timeout Value | The maximum time that Spine will wait on a script to complete, in units of seconds. If a Script Server Script is terminated due to timeout conditions, the value entered into the RRD file will be NaN
The Maximum SNMP OID's Per SNMP Get Request | The maximum number of SNMP get OID's to issue per SNMP request. Increasing this value speeds poller performance over slow links. The maximum value is 60 OID's. Please bear in mind, that some type of devices do not accept huge OID numbers and may fail if set above 1. That's why cacti 0.8.7 allows to define this value at device level

---
Copyright (c) 2004-2019 The Cacti Group
