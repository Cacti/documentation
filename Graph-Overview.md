# Graph Overview

Almost everything in Cacti is somehow related to a graph. At any time, you can
list all available graphs by clicking on the Graph Management menu item. While
it is possible to manually create graphs through this screen, new users should
follow the instructions provided in the next chapter for creating new graphs in
Cacti.

For users that are familiar with [RRDTool](http://www.rrdtool.org/), you will
immediately recognize that a graph in Cacti is closely modeled after RRDTool's
graphs. This makes sense since Cacti provides a user friendly interface to
RRDTool without requiring users to understand how RRDTool works. With this in
mind, every graph in Cacti has certain settings and at least one graph item
associated with it. While graph settings define the overall properties of a
graph, the graph items define the data that is to be represented on the graph.
So the graph items define which data to display and how it should displayed,
and also define what should be displayed on the legend.

Each graph and graph item has a set of parameters which control various aspects
of the graph. Fortunately through the use of graph templates, it is not
necessary to understand the function of each field to create graphs for your
network. When you are ready to take on the task of creating your own graph
templates, extensive field descriptions for both graphs and graph items are
provided in that section of the manual.
