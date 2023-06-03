# Spikekill

## Warning

Spikekill is designed to overwrite specific data points in one or more RRD
files. You should use great caution when running Spikekill, and you should
always ensure you have proper backups from which to restore your RRDfiles if
Spikekill performs a modification that you did not expect.

## Overview

Spikekill is a tool used to remove spikes in a graph.  Spikes can appear in a
graph after a device reboots, or when you switch from 32-bit to 64-bit interface
counters on a device.  Spikekill works by statistically analyzing the data
contained inside an RRDfile, and overwriting specific data points.  It offers
4 methods by which to analyze the data and selectively overwrite data points:

1. _Standard Deviation_

   Calulates the [standard
   deviation](https://en.wikipedia.org/wiki/Standard_deviation) of the data, and
   overwrites data points that are _N_ times higher than the standard deviation.

2. _Variance Average_

   Calculates the average value of the data, and overwrites data points that are
   _N_ percent higher than the average.

3. _GapFill_

   Finds gaps in the data (missing data points) and also finds data points that
   are _N_ percent higher than the average, and overwrites them, but only does
   so inside the specified time range.

4. _Float_

   Overwrites all data points that are within a specified time range.

## How to use

### GUI

Spikekill is easily run on a graph with a couple mouse clicks in the Cacti GUI:

1. On Cacti's main `Graph` tab, click the Spikekill icon
   ![Spikekill-icon](images/spikekill.gif) next to a graph.

2. In the drop-down menu that appears, review your current settings by hovering
   on `Settings` and reviewing each item, making changes if desired.

3. Run Spikekill by choosing one of the four methods available in the drop-down
   menu. Spikekill runs immediately, and the graph may be modified, depending on
   your settings.  The graph is refreshed when Spikekill is finished.

### CLI

Spikekill also has a flexible command line interface.  The following example
will help you get started.

```console
shell>php cli/removespikes.php --help
```

## Settings

Spikekill requires certain values to successfully calculate which data points to
overwrite.  The following settings are customizable:

1. _Replacement Method_

   When Spikekill identifies data points to overwrite, the
   value of _Replacement Method_ represents the data that will be written in
   place of each data point.

   When _Replacement Method_ is set to `NaN`, running Spikekill using `GapFill`
   or `Float` methods will perform no modifications. Please be aware of [Issue
   #3673](https://github.com/Cacti/cacti/issues/3673), where 'Last Known Good'
   is always used, regardless of setting.

2. _Standard Deviations_

   When using the Standard Deviation method, the value of _Standard Deviations_
   is the coefficient which determines how many times above the standard
   deviation the data must be to be considered a spike.

3. _Variance Percentage_

   When using the Variance Average method, the value of _Variance Percentage_ is
   the coefficient which determines how much higher than the average the data
   must be to be considered a spike.

4. _Variance Outliers_

   When using the Variance Average method, the highest _N_ values and the lowest
   _N_ values are considered _outliers_.  These outliers are ignored when
   calculating the average of the data.

5. _Kills Per RRA_

   Spikekill will limit the number of data points that it
   overwrites to the value of _Kills Per RRA_.  For reference, a single RRDfile
   can contain multiple _data sources_ and multiple _archives_.  Therefore, the
   total number of data points that could be overwritten in a single RRDfile
   will be determined by the formula:

   ```console
   (number_of_RRAs) x (number_of_data_sources) x (Kills_Per_RRA)
   ```

   This only applies when using the `Standard Deviation` or `Variance Average`
   methods, and does not apply when using the `GapFill` or `Float` methods.

The above settings are maintatined individually for each Cacti user.  The
default values can be changed globally in the Cacti settings, found at
Configuration > Settings > Spikes.  A user can change her or his individual
settings by selecting different choices in the Spikekill menu which appears
next to a graph.

## Detailed Operation

### Independence between each RRA:DS pair

When Spikekill runs, it analyzes each data source (DS) of each round-robin
archive (RRA) independently.  During analysis, it calculates values for
`average` and `standard deviation` for each RRA:DS pair.

To understand this better, consider the following example.

- You have a round-robin database (RRD) file that stores traffic levels on a
  router interface.

- You have two DSes, which are `traffic_in` and `traffic_out`.

- You also have selected three profiles, which are 1 minute for 7 days, 15
  minutes for 5 weeks, and 1 hour for 3 years.

- Lastly, you have three consolidation functions (CF), which are `average`,
  `min`, and `max`.

In this example, you have 9 RRAs (3 profiles multiplied by 3 CFs).  Therefore,
Spikekill will calculate 18 averages and 18 standard deviation values (9 RRAs
multiplied by 2 DSes).  Data points for each RRA:DS pair will be compared
against their respective `average` and `standard deviation` values.

### Search order

Spikekill searches for spikes in the same order as `rrddump` exports data,
which is sequentially by RRA, from oldest to newest data points within each
RRA.  Data points are overwritten if they exceed the maximum allowed threshold
or if they do not reach the minimum required threshold.

Spikekill will cease overwriting data points for any individual RRA when it has
reached the value of _Kills Per RRA_, counting all DSes of that RRA together.
It will then begin the process again on the next RRA.

This means that for any given RRA, older spikes will always be overwritten
before newer spikes.  However, newer spikes in one RRA can still be overwritten
before older spikes in a different RRA, since the thresholds are different per
RRA:DS pair.

---
<copy>Copyright (c) 2004-2023 The Cacti Group</copy>
