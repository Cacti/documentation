# Change poller interval from 5 minutes to 1 minute

Cacti 1.2.31 separates the scheduler interval, the poller interval and each
Data Source Profile's sampling and retention settings. Changing the scheduler
alone does not convert existing five-minute RRDfiles to one-minute archives.

## Plan the change

Identify the data sources that need one-minute collection. Keep unrelated
profiles, custom heartbeats and externally updated data sources unchanged.
Record the affected data source IDs, profile IDs, actual RRD paths and archive
settings. Do not assume profile IDs are the same on every installation.

Back up the database, configuration and RRDfiles together before changing
existing data sources. Pause cron, Task Scheduler or cactid as appropriate,
wait for active polling and RRD-writing processes to finish, and account for
pending Boost or rrdcached updates before copying or replacing files. Keep
these backups until collection and historical graphs have been verified.

## Configure collection for new data sources

1. Open **Console > Presets > Data Profiles**. Review the one-minute
   profile's step, heartbeat, consolidation functions and retention. Duplicate
   a profile if you need different settings without changing other users of it.

2. In **Console > Templates > Data Source**, select only the templates that
   should use one-minute collection and choose **Change Profile**. In 1.2.31,
   this bulk action changes template definitions, not existing local data
   sources or their RRDfiles. Setting a default profile also does not migrate
   existing files.

3. In **Console > Configuration > Settings > Poller**, set **Poller Interval**
   to one minute for one-minute collection. Set **Cron/Daemon Interval** to
   match the actual scheduler; using one minute for both is a simple setup.
   Run only one scheduler per collector.

4. Rebuild the poller cache after changing **Poller Interval**, using
   **Console > Utilities > System Utilities > Rebuild Poller Cache**.
   Check the scheduled command and PHP path on every affected collector.

5. Resume the scheduler and create a test graph using the selected profile.
   Verify the file's step and archives, fresh samples and poller completion
   time before adding more one-minute data sources.

For example, an `/etc/cron.d/` entry for an installation at
`/usr/local/share/cacti` might be:

```sh
* * * * * cacti /usr/local/bin/php /usr/local/share/cacti/poller.php > /dev/null 2>&1
```

Replace the account and paths with the installed values. A user's own crontab
omits the username field. Do not add cron when cactid already launches polling.

## Existing data sources and history

Changing a template or a database row does not by itself rewrite an existing
RRDfile. Do not use unqualified `UPDATE data_template_data` or
`UPDATE data_template_rrd` statements to convert the entire installation.
They also affect unrelated profiles and custom settings. Do not move the
whole live RRD directory away to force recreation.

To retain history, rehearse conversion on an isolated copy of the installation.
The database settings and the replacement RRD's step, data source definitions,
heartbeats and archives must agree for each selected data source. There is no
single bulk SQL recipe here for all existing configurations.

Cacti includes `cli/splice_rrd.php` on the main collector to merge an old RRD
with a new RRD that already has the desired structure. It does not choose a
profile or create that new structure for you. Use disposable writable copies
of both inputs, an unused output path and the installed utility's `--help`.
A single-file example, after preparing those copies, is:

```sh
/usr/local/bin/php /usr/local/share/cacti/cli/splice_rrd.php \
  --oldrrd=/srv/cacti-conversion/old/example.rrd \
  --newrrd=/srv/cacti-conversion/new/example.rrd \
  --finrrd=/srv/cacti-conversion/result/example.rrd
```

This is an offline utility example, not a complete migration procedure.
Validate the output before replacing a production file: compare data source
names and types, step, heartbeat, archive retention, timestamps and historical
values. Account for structured paths and custom RRD locations. Preserve the
original file, ownership and access controls when deploying a replacement.
Previously collected five-minute data cannot recover measurements that were
never sampled at one-minute intervals.

After deployment, rebuild the poller cache for the matching configuration,
resume one scheduler per collector and verify fresh updates and old graphs.
If validation fails, pause writers again and restore the matching database,
configuration and RRD backup together. Restoring only one of them can leave
polling metadata inconsistent with the files.

See [Data Source Profiles](Data-Profiles.md),
[Poller Settings](Settings-Poller.md), the
[released template profile action][template-source] and
[released splicer implementation][splice-source]. Use the installed RRDtool's
[info command][rrdinfo] to inspect a file's actual structure.

[template-source]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/data_templates.php>
[splice-source]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/cli/splice_rrd.php>
[rrdinfo]:<https://oss.oetiker.ch/rrdtool/doc/rrdinfo.en.html>

---

Copyright (c) 2004-2026 The Cacti Group
