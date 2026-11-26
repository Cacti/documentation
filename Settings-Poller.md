# Poller Settings

The Poller sub-tab of the Cacti settings is where you go to control
many aspects of **Data Collection** in Cacti. You control various base
collection frequencies, communication timeouts, and other settings that
impact how Cacti's **Data Collection** works.

## General Settings

The **General Settings** are a broad collection of settings into
multiple categories.  The image below shows Cacti's **General Settings**
sub-section.

![Settings Poller General](images/settings-poller-general.png)

Those settings include:

- **Data Collection Enabled** - This is a setting that essentially will
  override and disable all Cacti **Data Collection** from all of Cacti's
  **Data Collectors**.  It's really intended to allow you to put Cacti
  in maintenance mode with a single click.

- **Poller Type** - This is where you define either Cacti's built in poller
  `cmd.php`, or use the more robust poller `spine`.  You will not see the
  `spine` drop-down option unless it has first been installed, and the
  `spine` binary path defined from
  `Console > Configuration > Settings > Paths` settings sub-tab.

- **Poller Sync Interval** - When creating a Cacti **Data Collector**
  this is the default `Full Sync` interval it will use.  In the current
  Cacti design, a `Full Sync` should only be required when attempting
  to replicate local authentication or authorization data to
  **Remote Data Collectors**, or if you have made changes that would
  otherwise impact the behavior of a **Remote Data Collector** when it
  was offline.

- **Poller Interval** - This setting must align with the highest frequency
  **Data Source Profile** polling interval.

> **Note**: This only applies to the **Data Source Profiles** that are in
> use.  If you only plan on polling every minute and therefore only using
> the `1 Minute` **Data Source Profile**, then your **Poller Interval**
> should be `1 Minute` as well.

- **Cron/Daemon Interval** - This is the frequency at which either the Cacti
  daemon (cactid.php), or the system's crontab/task-manager should relaunch
  every **Data Collector's** Poller process.

- **Balance Process Load** - This setting will sort the devices such that
  each concurrent Cacti process is polling the same number of **Data Sources**.
  Otherwise, Cacti will simply order the hosts by their `device ids`.

- **Debug Output Width** - This is a diagnostic setting that you would only
  enable from time to time if you wish to check if the output from your
  **Data Collector** scripts exceeded the output width in the various
  Poller tables.  Since checking this has a very negative impact on
  polling performance, it's disabled by default.

- **Remote Agent Timeout** - When Cacti either needs information from
  a **Data Collector**, like `ping` latency from the collector to one
  of the **Devices** it's monitoring, or when a **Remote Data Collector**
  needs information from the main Cacti server, this is the timeout
  for receiving a handshake from that server.  It's used to keep the
  Website from locking up in the case a **Data Collector** is not
  responding due to being down.

- **Refresh Poller Table Per Cycle** - For single **Data Collector** systems
  only.  Rebuilds the poller output table on each polling cycle to prevent the
  memory table from swapping on very large systems with large databases.

- **Disable Resource Cache Replication** - By default Cacti will
  continually replicate its Website content with its
  **Remote Data Collectors**.  So, essentially, they are self
  upgradable.  However there are some cases where customers wish
  to upgrade the Central system before allowing the remotes
  to self upgrade.  In those cases, you would enable this feature.

- **Disable Automatic Full Sync on Upgrade** - By default, upgrading the
  main Cacti system performs a `Full Sync` to all **Data Collectors**, which
  can be time consuming.  If you disable it, the Cacti administrator must force
  the `Full Sync` from the **Data Collectors** interface after the upgrade.

> **Note**: The SNMP Agent Support, `Max OID Limit`, `Bulkwalk Fetch Size` and
> `Disable increasing OID Check` settings are on the
> [Device Defaults](Settings-Device-Defaults.md) sub-tab.

## Scheduler Settings

Limits for Cacti's background processes are set on the **Scheduler** sub-tab,
not on the Poller sub-tab.  They limit how long Cacti background processes will
be allowed to run before timing out and being killed, and how many scheduled
tasks may run at once.  These limits are required to keep Cacti performing at
peak by not allowing certain tasks to re-spawn while they are still running,
causing system overload.

Those settings include:

- **Max Running Tasks** - The maximum number of scheduled tasks allowed to run
  concurrently.  The default is 2.

- **Default Maximum Task Runtime** - The maximum amount of time a scheduled
  task can run without generating a timeout error and being killed.  The
  default is 5 minutes.

The following settings cover tasks that are not managed by the Cacti scheduler:

- **Data Source Statistics Timeout** - The maximum time Cacti's
  **Data Source Statistics** script can run before it is killed.  The default is
  5 minutes.

- **RRDChecker Timeout** - The maximum time Cacti's RRDfile check script can
  run before it is killed.  The default is 1 hour.

- **Poller Commands Timeout** - The maximum time Cacti's background commands
  script can run before it is killed.  This script performs tasks such as
  re-indexing **Devices** and pruning **Devices** from
  **Remote Data Collectors**.  The default is 5 minutes.

- **Poller Command Concurrent Processes** - The number of concurrent Poller
  Command processes.  There is at most one concurrent command per **Device**
  within the pool.  The default is 1.

- **Maintenance Background Generation Timeout** - The maximum time Cacti's
  maintenance script can run before it is killed.  The default is 5 minutes.

- **Spikekill Background Generation Timeout** - The maximum time Cacti's
  Spikekill script can run before it is killed.  The default is 1 hour.

## Data Collector Processes and Threads

The `Processes` and `Threads` settings are not global settings.  They are
maintained on each **Data Collector**, since not all
**Data Collectors** are created equally.  You may have one **Data Collector**
that's collecting data from 1,000 hosts, and another that is collecting from 10.
The thread setting only applies if you are using the `spine` poller.

## Additional Data Collector Settings

These settings are Global Spine poller settings.  They apply to all
**Data Collectors**.  An image of these settings can be seen below:

![Additional Data Collector Settings](images/settings-poller-spine.png)

Those settings include:

- **Invalid Data Logging** - By default spine will only log the number
  of errors it experienced for a **Device**.  If you wish more
  granularity you can change this setting to either `Summary`
  or `Detailed` logging.

- **Number of PHP Script Servers** - Another level of Spine parallelism
  is its ability to create a pool of memory resident PHP
  interpreters for running PHP scripts, making spine very powerful.
  Every concurrent process will have this many memory resident
  PHP interpreters pooled for running scripts.

- **Script and Script Server Timeout Value** - This is the timeout
  to stop run-on scripts from blocking poller performance.  If a script
  exceeds this timeout, it will generate a log message.

- **Poller Output Not Empty Debouncing** - If some **Data Sources** cause your
  Email to be flooded with `Poller Output Not Empty` warnings, you can debounce
  the warning based upon this interval.

---
Copyright (c) 2004-2026 The Cacti Group
