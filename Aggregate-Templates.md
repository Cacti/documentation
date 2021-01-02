# Aggregate Templates

This section will describe **Aggregate Templates** in Cacti.  **Aggregate Templates**
allow you to easily create hundreds of **Aggregate Graphs** in just minutes by
allowing common Aggregate Types to be created enmass and managed by the 
parent **Aggregate Template** in a less error prone way.

You first create the **Aggregate Template**, and then from the Cacti **Graphs** page,
you can select the **Graphs** that you want used as part of the **Aggregate**,
and then select `Create Aggregate from Template` from the Cacti Actions dropdown.
Once you have created your **Aggregate Graphs**, they behave like any other 
Cacti Graph, they can be a part of a Tree, zoomed, etc.

If you wish to change settings for **Graphs** managed by the **Aggregate Template**, 
simply make the changes there, and they will cascade to all templaged 
**Aggregate Graphs**.

The image below shows an Aggregate Template for Traffic.

![Aggregate Templates](images/aggregate-templates.png)

When you edit that Template, you are presented with an interface that allows
you to define the Graph Canvas as well as it's formatting.  You should experiment
until you find the mechanism that works best to suite your needs.

![Aggregate Templates Edit General Options](images/aggregate-templates-edit1.png)

![Aggregate Templates Edit Canvas Options](images/aggregate-templates-edit2.png)

![Aggregate Templates Edit Common Options](images/aggregate-templates-edit3.png)

![Aggregate Templates Edit Scaling Options](images/aggregate-templates-edit4.png)

![Aggregate Templates Edit Grid Options](images/aggregate-templates-edit5.png)

![Aggregate Templates Edit Axis Options](images/aggregate-templates-edit6.png)

![Aggregate Templates Edit Legend Options](images/aggregate-templates-edit7.png)

---
Copyright (c) 2004-2021 The Cacti Group
