# Data Source Profiles

**Data Source Profiles** define sampling intervals, heartbeats, consolidation
functions and archive retention for data sources. A profile describes how
RRDfiles should be created; selecting another profile does not automatically
convert existing RRDfiles.

![Data Source Profiles](images/data-source-profiles.png)

![Data Source Profiles Edit](images/data-source-profiles-edit1.png)

The following are illustrative archive sizes per data source. Actual RRDfile
size depends on its data sources, rows, archives and consolidation functions;
these values are not fixed requirements for every profile.

| polling time | type    | size per ds | polling time | type   | size per ds |
| -----------: | ------- | ----------: | -----------: | ------ | ----------: |
|    30 second | Daily   |        48kb |    30 second | Weekly |        43kb |
|    30 second | Monthly |        46kb |    30 second | Yearly |       140kb |
|     1 minute | Daily   |        93kb |     1 minute | Weekly |        45kb |
|     1 minute | Monthly |        47kb |     1 minute | Yearly |       140kb |
|     5 minute | Daily   |        19kb |     5 minute | Weekly |        22kb |
|     5 minute | Monthly |        25kb |     5 minute | Yearly |        26kb |

![Data Source Profiles RRA Edit](images/data-source-profiles-edit2.png)

## Changing data profile averages

The Cacti GUI allows you to change the averages on a specific Data source
profile some setups require a higher resolution of data and you may want to
change the averaging to keep the most data this will come with a cost of storage
due to the bigger sized RRDfile

To do this follow these steps

### Method 1 - Profile not used by existing data sources

1. Login to Cacti

2. Click on Presets >> Data Profiles

3. Select the profile you want to edit i.e 1 minute collection

4. Select the period which you want to edit i.e weekly

5. If you wish to change the average select the aggregate level for 1 minute you
   will be able to go as low as 5 Minutes

6. Set the row count for the retention required at that resolution. Each
   archive maintains its own consolidation and retention settings.

7. Save config and generate graphs

### Method 2 - Existing device(s) on system

In Cacti 1.2.31, archive settings are read-only in the profile editor when
local data sources use that profile. Duplicate the profile and edit the copy
for new data sources instead of deleting all graphs to unlock those settings.
Select only the intended data templates when using **Change Profile**; that
bulk action changes template definitions, not existing local data sources.

Existing RRDfiles retain their stored structure until explicitly converted.
Back up matching database, configuration and RRD data before a migration,
and validate conversion on isolated copies. Changing a database setting alone
does not change an existing file's step or archive layout. See
[changing to one-minute collection](How-To-Poller-5-to-1-min.md) for the
distinction between new collection and an existing-history migration.

## Data profile Rows Calculation

Each archive row covers the base sampling step multiplied by the number of
primary data points consolidated into that row. Calculate retention as:

```console
row_seconds = profile_step_seconds * archive_steps
retention_seconds = rows * row_seconds
rows = desired_retention_seconds / row_seconds
```

> **Example**
>
> For one-minute rows retained for three days (72 hours):
>
> 72 * 3600 / 60 = 4,320 rows.

Round up to a whole number of rows when necessary. Retention is calculated
separately for each archive; older data does not move from one archive to
another when a graph changes timespan. For an existing file, inspect its
actual step, `pdp_per_row` and row count with [RRDtool info][rrdinfo].

The [Cacti 1.2.31 profile editor][profile-source] and
[template profile action][template-source] define these editing rules.

[profile-source]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/data_source_profiles.php>
[template-source]:<https://github.com/Cacti/cacti/blob/1e8eaca26b84b128c39ce8cc8ece42d7ff76aac1/data_templates.php>
[rrdinfo]:<https://oss.oetiker.ch/rrdtool/doc/rrdinfo.en.html>

---

Copyright (c) 2004-2026 The Cacti Group
