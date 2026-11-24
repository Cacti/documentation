# Visual Settings

## Overview

Cacti's Visual settings page is where you can go to globally control the
behavior of Cacti's GUI. Settings like the default Theme, the maximum allowed
size of a Graph Title, auto-complete settings, as well as a myriad of other
settings can be found here.

The Visual page is broken down into several sub-sections. We will cover them and
the meaning of the various settings here.

> **NOTE**: This is a popular page for Plugin developers to augment. Therefore,
> if you have installed Plugins, your Settings page may look different than the
> default page.

## Theme, Table, Tree, and Filter Settings

The image below shows the default layout for these sub-sections.

![Settings Visual Theme, Table, Tree and Filter](images/settings-visual-1.png)

Those settings include:

- **Theme** - The default theme that users logging into Cacti receive

- **Rows Per Page** - For all standard Cacti tables, the number of rows to show
  per page.

- **Select Search Minimum Rows** - The minimum number of options a drop-down
  must have before Cacti shows a search box inside it. Choose `Always` to show
  the search box regardless of the number of options. The default is 10.

- **Autocomplete Rows** - The number of rows to return from an autocomplete
  based select pattern match. Many drop-downs do not scale well with thousands
  of items, so Cacti uses an autocomplete drop-down for them. This is limited by
  the PHP `max_input_vars` setting.

- **Autocomplete Delay** - The number of milliseconds to wait before initiating
  a call to the server for autocomplete. Any value less than 500 assumes
  500ms.

- **Minimum Tree Width** - The minimum width of the Tree panel in Cacti

- **Maximum Tree Width** - The maximum width of the Tree panel in Cacti. Above
  this width, tree items will scroll into the panel.

- **Strip Domains from Device Drop-downs** - Strip domain names from Device
  drop-downs to save horizontal filter space.

## Graph, Data Source, Data Query, Log Settings

The image below shows the default layout for these sub-sections.

![Graph, Data Source, Data Query, Log Settings](images/settings-visual-2.png)

Those settings include:

- **Maximum Title Length** - The maximum length of a Graph or Data Source title.
  Titles above this length will be clipped.

- **Data Source Field Length** - When applying |query\_\*| replacement values,
  the maximum supported length of those variables. Variables longer than this
  will be clipped.

- **Default Graph Type** - When on the **New Graphs** page, which **Graph Type**
  filter should be the default. With **Device Templates** with many **Data
  Queries** or **Graph Templates**, this page can become very long. Allowing you
  to select your preferred **Graph Type** makes navigating the page easier.

- **Default Log Tail Lines** - When viewing the Cacti Log, how many lines should
  appear per page.

- **Maximum number of rows per page** - The number of lines the Cacti Log
  viewer tails when a user selects **All Lines**. The default is 1000.

- **Log Tail Refresh** - The frequency that the log pages should auto-refresh.

- **Exclusion Reg-ex** - This setting allows you to exclude certain log messages
  by regular expression from normal users. Expressions that include login log
  entries are common here to mask the login accounts of users.

## Realtime and RRDtool Graph Options

The image below shows the default layout for these sub-sections.

![Realtime and RRDtool Graph Options](images/settings-visual-3.png)

Those settings include:

- **Enable Real-time Graphing** - Allow Realtime graphs to be used in Cacti.
  Checked by default.

- **Graph Timespan** - The default system level `Graph Timespan` to use when a
  user opens a Realtime **Graph** for the first time.  The default is 1 Minute.

- **Minimum Refresh Interval** - The minimal supported time between Realtime
  **Graph** updates.  The default is 10 Seconds.  A **Device** that caches its
  data and does not provide realtime updates can need a higher value to avoid
  gaps.

- **Cache Directory** - Where should Cacti cache Realtime PNGs and RRDfiles.
  The default is the `realtime` directory under the Cacti cache path.  The
  path must be absolute and writable.

See [Realtime Graphs](Viewing-Graphs.md#realtime-graphs) for how these settings
are used.

- **Custom Watermark** - A watermark that will appear on every Cacti **Graph**

- **Disable RRDtool Watermark** - Every RRDtool Graph includes a vertical
  watermark. This option allows you to disable that.

- **Font Selection Method** - This allows the system administrator to control,
  at a global level, how various text elements on RRDtool **Graphs** appear. The
  settings include: Theme, or System. When choosing `System`, your settings page
  will expand where you will then have additional control.

> **NOTE**: The RRDtool Watermark control is supported by RRDtool 1.5, the
> minimum release Cacti supports, and later. If you attempt to use this setting
> and your **Graphs** break, then upgrade RRDtool.

## Font Selection Options

The image below shows the available Font Selection options when you override the
Theme settings.

![Font Selection Options](images/settings-visual-4.png)

The sizes are in pixels, and the Font Settings can either be a True Type Font
file path, or a valid Pango font-config value. For more information on Pango
font-config values, see your operating system's documentation. However, you can
normally see all the fonts installed on your Linux system by issuing the
following command `fc-list`.

---

Copyright (c) 2004-2026 The Cacti Group
