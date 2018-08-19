# Variables

## Graph Variables

The following variables can be used in the Text Format and Value graph item
fields. Below is a description of each of these variables.

## Date/Time

`|date_time|`

This variable will place the date and time of the last poller run on the graph.
It can be used to replicate MRTG's "graph last updated" feature.

## Data Source Title

`|data_source_title|`

This variable, `|data_source_title|`, gets replaced with the name of the data
source associated with a particular graph item in a graph template. This change
allows the creation of generic graph templates (2-variable line graph,
3-variable stack, etc.) which can be reused with large numbers of data sources.
See attached examples to understand usage.

![Example of a Graph Template using |data_source_title|](images/data_source_title_template.png)

![Example 1 of a Graph making use of |data_source_title|](images/data_source_title_example1.png)

![Example 2 of a Graph making use of |data_source_title|](images/data_source_title_example2.png)

## Data Query Fields

`|query_field_name|`

You can place the value of any data query field on the by including this
variable. Make sure to substitute "field_name" with the actual data query field
name.

`|query_ifIP|`

`|query_dskPath|`

## Nth Percentile

`|[0-9]:(bits|bytes):[0-9]:(current|total|max|total_peak|all_max_current|all_max_
peak|aggregate_max|aggregate_sum|aggregate_current|aggregate):[0-9]|`

Nth percentile is often used by hosting providers to bill customers based on
their peak traffic usage while ignoring their top (100 - Nth) percent. This way
if a customer has a fairly consistent traffic pattern and decides to download a
huge file one day, the large spike will be ignored. Common Nth percentile is
95, which would cut off the top 5% of the traffic.

In Cacti, Nth percentile works just like any other graph variable. To use this
variable you must give it five arguments:

> **Note**
>
> All data sources used in a graph MUST have the same rra definitions. If the
> number of rows do not match when calculations are attempted, the results may
> produce errors and invalid results. Please also be aware the aggregate
> functions take more memory and processor power when used. Recommended minimum
> of 64 megs memory limit for php when querying large ranges or graphs with a
> large ammount of aggregated data sources.

`|95:bits:6:max:2|`

## Bandwidth Summation

`|sum:([0-9]|auto):(current|total):([0-9]):([0-9]+|auto)|`

Bandwidth summation is useful for summing up all values in an RRD file for a
given time range. This is typically useful on traffic graphs where you can see
a total of all traffic that has gone through an interface in a given time
period.

In Cacti, bandwidth summation works just like any other graph variable. To use
this variable you must give it three arguments:

`|sum:auto:current:2:auto|`

## Host Variables

Host variables represent host data and can be placed in graph or data source
titles. The following table describes which host variables can be used and
which host fields the correspond to.
