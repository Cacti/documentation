# How To How to Graph a Custom Collection Script

This HOWTO walks you through the simplest steps of graphing the output of a
single value from a script. As a new user of cacti, I had a difficult time
understanding how to graph anything that wasn't canned with the original load.
After a lot of playing around, I came up with these procedures which can be
built upon for more sophisticated collections and graphs.

I do not use templates in this HOWTO. Templates provide a significant advantage
if you are graphing the output for multiple instances or creating graphs for
multiple hosts. They help to maintain consistency and simplify setup.

The example here is not realistic, but can be used and expanded upon as a model
for creating your own graphs.

I've not put a lot of explanations in the procedures. Refer to the Cacti manual
for more details.

Have a tested script ready to go. I used the following script located in
`/home/cactiuser/bin` called `random2.pl`:

```perl
#!/usr/bin/perl -w

print int(rand(10));
```

This script simply prints out a random integer between 0 and 9 every time it's
called.

### Minimal steps to create a graph from a script

1. Create a **Data Input Method** to tell Cacti how to call the script and what to
   expect from it.

2. Create a **Data Source** to tell Cacti how and where the data will be stored.

3. Create a **Graph** to tell Cacti how the data will be presented in graph form.

4. Add **Graph** to **Graph Tree** so you can view the graph.

5. View the **Graph**.

### Detailed Instructions

1. Create **Data Input Method**

   - Click the **Console** tab at the top

   - Click **Data Input Methods** under **Management**

   - Click **Add**

   - Name: `Random 2 Input`

   - Input Type: ___Script/Command___

   - Input String: `/home/cactiuser/bin/random2.pl`

   - Click **Create**

   - Should see ***Save Successful*** at the top of the page.

   - Click **Add** by **Output Fields** (there are no input fields for this example)

   - Field [Output]: `random_number`

   - Friendly Name: `Random Number`

   - Update RRD file: ___Checked___

   - Click **Create**

   - Should see ***Save Successful*** and `random_number` listed under **Output Fields**.

   - Click **Save**

   - Should see ***Save Successful*** and `Random Input` listed in **Data Input Methods**.

2. Create a **Data Source**

   - Click **Data Sources** under **Management**

   - Click **Add** in the top right

   - The **Data Template Section** should be None and None, we're not using
     templates for this example.

   - Click **Create**

   - Name: `random2ds`

   - Data Source Path: ***empty*** (Cacti will fill this in)

   - Data Input Source: ___Random 2 Input___ (this is the data input method you
     created in step 1)

   - Highlight each of the **Associated RRA's** using control-click

   - Step: `300` (300 seconds = 5 minutes)

   - Data Source Active: ___Checked___

   - Describe the **Data Source Item** inside the **RRA** by...

   - Internal Data Source Name: `random_number`

   - Minimum Value: `0`

   - Maximum Value: `0`

   - Data Source Type: ___GAUGE___

   - Heartbeat: `600`

   - Click **Create**

   - Should see ***Save Successful*** at the top and the **Data Source Path**
     should now have a value (my example `<path_rra>/random_number_286.rrd`)

   - Click **Turn On Data Source Debugging Mode** to see the results of this
     step.

   - Click **Save**

   - Should see ***Save Successful*** and your new **Data Source** listed.

3. Create **Graph**

   - Select **Graph Management** under **Management**

   - Click **Add**

   - Selected Graph Template: ___None___

   - Host: ___None___

   - Click **Create**

   - Title: `RANDOM NUMBERS`

   - Image Format: ___PNG___

   - Height: `120`

   - Width: `500`

   - Auto Scale: ___Checked___

   - Auto Scale Options: ___Use --alt-autoscale-max___

   - Logarithmic Scaling: ___Unchecked___

   - Rigid Boundaries: ___Unchecked___

   - Auto Padding: ___Checked___

   - Allow Graph Export: ___Checked___

   - Upper Limit: `100`

   - Lower Limit: `0`

   - Base Value: `1000`

   - Unit Value: ***Empty***

   - Unit Exponent Value: `0`

   - Vertical Label: `Random Number`

   - Click **Create**

   - Should see ***Save Successful***

   - If you click **Turn On Graph Debug Mode*** now you will see: `Error:
     can't make a graph without contents`. We need to add **Graph Items**:

   - Click **Add** by **Graph Items**

   - Data Source: ___No Host - random2ds (random_number)___

   - Color: ___0000FF (Blue)___

   - Graph Item Type: ___LINE2___

   - Consolidation Function: ___AVERAGE___

   - CDEF Function: ___None___

   - Value: **Empty**

   - GPRINT Type: ___Normal___

   - Text Format: **Empty**

   - Insert Hard Return: ___Unchecked___

   - Click **Create**

   - Should see ***Save Successful***, **Item #1** listed and a graph under debug
     (probably with nothing in it yet)

   - To add a legend, click **Add** by **Graph Items** again

   - Data Source: ___No Host - random2ds (random_number)___

   - Color: ___None___

   - Graph Item Type: ___GPRINT___

   - Consolidation Function: ___LAST___

   - CDEF Function: ___None___

   - Value: **Empty**

   - GPRINT Type: ___Normal___

   - Text Format: `Cur:`

   - Insert Hard Return: ___Unchecked___

   - Click **Create**

   - Should see ***Save Successful*** and the graph will have a legend showing
     the current value. ***Note:*** your integer random number has been averaged
     over the past 5 minutes. At the bottom of the page, click **Save**.

   - At the bottom of the page, click **Save**.

   - Should see ***Save Successful*** and your graph listed.

4. Add **Graph** to the **Graph Tree**

   - Click **Graph Trees** under **Management**

   - We'll create a tree called `Scripts` to place our graph

   - Click **Add**

   - Name: `Scripts`

   - Should see ***Save Successful***

   - Click **Add** beside **Tree Items** (to add our graph to this tree)

   - Under **Tree Items [graph]**...

   - Graph: ___RANDOM NUMBERS___ (we named this in step 3)

   - Round Robin Archive: ___Daily (5 Minute Average)___

   - Click **Create**

   - Should see ***Save Successful*** and **RANDOM NUMBERS** listed under
     **Tree Items**

   - Click **Save**

   - Should see ***Save Successful*** and **Scripts** listed under **Graph Trees**

5. View Graph

   - Select **Graphs** tab

   - Select **Tree View** (Tree beside settings tab)

   - Select **Scripts** tree on left

   - You may see **Random Graph** but no graph. It takes two or three polls
     (10 - 15 minutes) to see a graph. I believe poll 1 to create the rrd,
     poll 2 to get the first data point and poll 3 to have graph-able data.

   - Now be patient. Hit your refresh button every few minutes. After the
     first poll I got a few empty graphs. A few minutes later data started
     showing up.

---
Originally written by Kevin der Kinderen, <http://kdeuja.com/~kevin/>
---
Copyright (c) 2004-2020 The Cacti Group
