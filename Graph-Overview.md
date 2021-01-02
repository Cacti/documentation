# Graph Overview

Almost everything in Cacti is somehow related to a **Graph**. At any time, you can
list all available **Graphs** by clicking on the `Console > Management > Graphs`
menu pick. While it is possible to manually create **Graphs** through this interface,
new users should follow the instructions provided in the next chapter for
creating **Graph** in Cacti.

For users that are familiar with [RRDTool](http://www.RRDTool.org/), you will
immediately recognize that a **Graph** in Cacti is closely modeled after RRDTool's
**Graphs**, in fact they are one and the same. This makes sense since Cacti
provides a user friendly interface to RRDTool without requiring users to
understand how RRDTool works. With this in mind, every **Graph** in Cacti has
certain settings and at least one graph item associated with it. While
graph settings define the overall properties of a **Graph**, the **Graph Items**
define the data that is to be represented on the **Graph**. So the **Graph Items**
define which data to display and how it should displayed, and also define 
what should be displayed on the legend.

Each **Graph** and **Graph Item** has a set of parameters which control various
aspects of the graph. Fortunately through the use of graph templates, it is not
necessary to understand the function of each field to create **Graphs** for your
network. When you are ready to take on the task of creating your own **Graph
Templates**, extensive field descriptions for both **Graphs** and **Graph Items** are
provided in that section of the manual.

---
Copyright (c) 2004-2021 The Cacti Group
