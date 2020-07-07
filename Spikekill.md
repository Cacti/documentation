# Spikekill

## Warning

Spikekill is designed to overwrite specific data points in one or more RRD files. You should use great caution when running Spikekill, and you should always ensure you have proper backups from which to restore your RRD files if Spikekill behaves in a way you did not expect.

## Overview

Spikekill is a tool used to remove spikes in a graph.  Spikes can appear in a graph after a device reboots, or when you switch from 32-bit to 64-bit interface counters on a device.  Spikekill works by statistically analyzing the data contained inside an RRD file, and overwriting specific data points.  It offers 4 methods by which to analyze the data and selectively overwrite data points:
1. Standard Deviation - Calulate the [standard deviation](https://en.wikipedia.org/wiki/Standard_deviation) of the data, and overwrite data points that are _N_ times higher than the standard deviation
1. Variance Average - Calculate the average value of the data, and overwrite data points that are _N_ percent higher than the average
1. GapFill - Find gaps in the data (missing data points) and fill them in with the average value
1. Float - Calculate the average value of the data, and then overwrite all data points that are within a specified time range

## How to use
Spikekill is easily run on a graph with a couple mouse clicks:
1. On Cacti's main `Graph` tab, click the Spikekill icon next to a graph.
1. In the drop-down menu that appears, review your current settings by hovering on `Settings` and reviewing each item, making changes if desired.
1. Run Spikekill by choosing one of the four methods available in the drop-down menu. Spikekill runs immediately, and the graph may be modified, depending on your settings.  The graph is refreshed when Spikekill is finished.

## Settings
Spikekill requires certain values to successfully calculate which data points to overwrite.  The following settings are customizable:
1. Replacement Method - When Spikekill identifies data points to overwrite, the value of _Replacement Method_ represents the data that will be written in place of each data point
1. Standard Deviations - When using the Standard Deviation method, the value of _Standard Deviations_ is the coefficient which determines how many times above the standard deviation the data must be to be considered a spike
1. Variance Percentage - When using the Variance Average method, the value of _Variance Percentage_ is the coefficient which determines how much higher than the average the data must be to be considered a spike
1. Variance Outliers - When using the Variance Average method, the highest _N_ values and the lowest _N_ values are considered _outliers_.  These outliers are ignored when calculating the average of the data
1. Kills Per RRA - Spikekill will limit the number of data points that it overwrites to the value of _Kills Per RRA_.  For reference, a single RRD file can contain multiple _data sources_ and multiple _archives_.  Therefore, the total number of data points that could be overwritten in a single RRD file will be determined by the equation: ```[number_of_RRAs] * [number_of_data_sources] * [Kills_Per_RRA]```

The above settings are maintatined individually for each Cacti user.  The default values can be changed globally in the Cacti settings, found at Configuration > Settings > Spikes.  A user can change his or her individual settings by selecting different choices in the Spikekill menu which appears next to a graph.
