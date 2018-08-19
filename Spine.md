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
