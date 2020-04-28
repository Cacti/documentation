# Data Source Profiles

This section will describe **Data Source Profiles** in Cacti.

![Data Source Profiles](images/data-source-profiles.png)

![Data Source Profiles Edit](images/data-source-profiles-edit1.png)

The following values are for the disk usage per Data source for the respective
data profile

### 30 second polling

Daily 48kb

Weekly 43kb

Monthly 46kb

Yearly 140kb

### 1 minute polling

Daily 93kb / data source

Weekly 45kb / data source

Monthly 47kb /datasource

Yearly 140KB/data source

### 5 minute polling

Daily 19kb / data source

Weekly 22kb / data source

Monthly 25kb / data source

Yearly 26kb / data source

![Data Source Profiles RRA Edit](images/data-source-profiles-edit2.png)

### Changing data profile averages 

The Cacti gui allows you to change the averages on a specifc Data source profile
some setups require a higher resolution of data and you may want to change the averaging to
keep the most data this will come with a cost of storage due to the bigger sized RRD file

To do this follow these steps

Method 1: New system without any hosts

1.) Login to cacti

2.) Click on Presets >> Data Profiles

3.) Select the profile you want to edit i.e 1 minute collection

4.) Select the period which you want to edit i.e weekly 

5.) if you wish to change the average select the aggregate level for 1 minute you will be able to go as low as 5 Minutes

6.) you will need to edit the Rows amount to match the data retention you want to set after this period the data will be 
averaged out to the monthly graph

7.) save config and generate graphs

---
Copyright (c) 2004-2020 The Cacti Group
