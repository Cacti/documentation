# How To

## Simplest Method of Going from Script to Graph (Walkthrough)

Written by Kevin der Kinderen, <http://kdeuja.com/~kevin/>

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

~~~perl
#!/usr/bin/perl -w

print int(rand(10));
~~~

This script simply prints out a random integer between 0 and 9 every time it's
called.

1. Create a Data Input Method to tell Cacti how to call the script and what to
   expect from it.

2. Create a Data Source to tell cacti how and where the data will be stored.

3. Create a Graph to tell cacti how the data will be presented in graph form.

4. Add Graph to Graph View so you can view the graph.

5. View the Graph

<!-- -->

1. Create Data Input Method

   - Click the Console tab at the top

   - Click Data Input Methods under Management

   - Click Add

   - Name: Random 2 Input

   - Input Type: Script/Command

   - Input String: /home/cactiuser/bin/random2.pl

   - Click Create

   - Should see "Save Successful." at the top of the page.

   - Click Add by Output Fields (there are no input fields for this example)

   - Field [Output]: random_number

   - Friendly Name: Random Number

   - Update RRD File: checked

   - Click Create

   - Should see "Save Successful." and random_number listed under Output Fields.

   - Click Save

   - Should see "Save Successful." and Random Input listed in Data Input Methods.

2. Create a Data Source

   - Click Data Sources under Management

   - Click Add in the top right

   - The Data Template Section should be None and None, we're not using
     templates for this example.

   - Click Create.

   - Name: random2ds

   - Data Source Path: blank (Cacti will fill this in)

   - Data Input Source: Random 2 Input (this is the data input method you
     created in step 1)

   - Highlight each of the Associated RRA's using control-click

   - Step: 300 (300 seconds = 5 minutes)

   - Data Source Active: checked

   - Describe the Data Source Item inside the RRA by...

   - Internal Data Source Name: random_number

   - Minimum Value: 0

   - Maximum Value: 0

   - Data Source Type: GAUGE

   - Heartbeat: 600

   - Click Create

   - Should see "Save Successful." at the top and the Data Source Path
     should now have a value (my example `<path_rra>/random_number_286.rrd`)

   - Click Turn On Data Source Debugging Mode to see the results of this
     step.

   - Click Save

   - Should see "Save Successful" and your new Data Source listed.

3. Create Graph

   - Select Graph Management under Management

   - Click Add

   - Selected Graph Template: None

   - Host: None

   - Click Create

   - Title: RANDOM NUMBERS

   - Image Format: PNG

   - Height: 120

   - Width: 500

   - Auto Scale: checked

   - Auto Scale Options: Use --alt-autoscale-max

   - Logarithmic Scaling: unchecked

   - Rigid Boundaries: unchecked

   - Auto Padding: checked

   - Allow Graph Export: checked

   - Upper Limit: 100

   - Lower Limit: 0

   - Base Value: 1000

   - Unit Value: blank

   - Unit Exponent Value: 0

   - Vertical Label: Random Number

   - Click Create

   - Should see "Save Successful."

   - If you click "Turn On Graph Debug Mode." now you will see: "Error:
     can't make a graph without contents." We need to add Graph Items:

   - Click Add by Graph Items

   - Data Source: (from list) No Host - random2ds (random_number)

   - Color: 0000FF (Blue)

   - Graph Item Type: LINE2

   - Consolidation Function: AVERAGE

   - CDEF Function: None

   - Value: blank

   - GPRINT Type: Normal

   - Text Format: blank

   - Insert Hard Return: unchecked

   - Click Create

   - Should see "Save Successful.", Item #1 listed and a graph under debug
     (probably with nothing in it yet)

   - To add a legend, click Add by Graph Items again

   - Data Source: No Host - random2ds (random_number)

   - Color: None

   - Graph Item Type: GPRINT

   - Consolidation Function: LAST

   - CDEF Function: None

   - Value: blank

   - GPRINT Type: Normal

   - Text Format: Cur:

   - Insert Hard Return: unchecked

   - Click Create

   - Should see "Save Successful." and the graph will have a legend showing
     the current value. Note: your integer random number has been averaged
     over the past 5 minutes. At the bottom of the page, click save.

   - At the bottom of the page, click Save.

   - Should see "Save Successful." and your graph listed.

4. Add graph to the graph view

   - Click Graph Trees under Management

   - We'll create a tree called "test" to place our graph

   - Click Add

   - Name: test

   - Should see "Save Successful"

   - Click Add beside Tree Items (to add our graph to this tree)

   - Under Tree Items [graph]...

   - Graph: RANDOM NUMBERS (we named this in step 3)

   - Round Robin Archive: Daily (5 Minute Average)

   - Click Create

   - Should see "Save Successful." and RANDOM NUMBERS listed under Tree Items

   - Click Save

   - Should see "Save Successful." and test listed under Graph Trees

5. View Graph

   - Select Graphs tab

   - Select tree view (Tree beside settings tab)

   - Select test tree on left

   - You may see "Random Graph" but no graph. It takes two or three polls
     (10 - 15 minutes) to see a graph. I believe poll 1 to create the rrd,
     poll 2 to get the first data point and poll 3 to have graphable points.

   - While waiting, you can click the RANDOM NUMBERS graph. You'll see place
     holders for 4 graphs. Select [source] under Daily (5 Minute Average).
     You'll see the source for the call to rrdtool graph. Give it a sanity check.

   - Now be patient. Hit your refresh button every few minutes. After the
     first poll I got a few empty graphs. A few minutes later data started
     showing up.
