# Plugin Development

## Overview

Cacti Plugins allow users of Cacti to extend it's functionality into areas
that the core Cacti developers have not.  They were written based off of
the work of Jimmy Conner from the Squirrel Mail project years ago.  They
allow developers to augment the Cacti Website, and it's polling processes
to extend Cacti's reach.

There are a number of popular plugins including:

- **Thold** - A graph based service checking framework that leverages the
  data on Cacti graphs for performing service checks
- **Syslog** - A plugin that allows you to view log data from hundreds or
  thousands of hosts and generate faults based upon pattern matching of
  that log data.
- **Monitor** - A plugin that provides a Device Dashboard highlighting
  Cacti Devices that are experiencing faults.
- **Intropage** - A plugin that provides a replacement to the Cacti console
  showing key performance metrics accross all of Cacti from a single page.
- **Weathermap** - A plugin that allows you to create architectural 
  diagrams of your network and to animate them with status data.

In theory, these plugins can be integrated into Cacti very simply, and removed
without breaking Cacti.  However, it must be noted to always review the
plugins documentation before you start to use it.

## Legacy Plugins Notice

Plugins written for Cacti 0.8.x require modifications in order to be compatible 
with Cacti 1.x.  There are several changes that all plugin developers need to 
be aware of. Any of the Cacti Group maintained plugin can be
used as reference plugins for driving your plugin migration to the 1.x
framework and are available on [Github](https://github.com/Cacti/).

## Plugin Migration

In order to migrate your legacy Cacti plugins, there are several steps that
need to be taken.  This guide will provide a brief synopsis of changes that are
required to make your plugins compatible with Cacti 1.0.

## Migration Steps

Each of the following steps should be followed to migrate your plugins.  Some
of these changes are optional, and some are mandatory.  We will start with the
list of steps that must be required.  Then, in future sections, we will provide
details on performing each step.

### Required Steps

- Creation of Information (INFO) file (mandatory)

- Applying correct classes to Anchor tags to trigger callbacks (mandatory)

- Remove instances of including top_header.php, top_graph_header.php,
  top_general_header.php and replacing with function calls top_header(),
  bottom_footer(), top_graph_header(), and top_general_header(). (mandatory)

- Adding '&header=false' to most header() function calls to drive Ajax
  rendering. (mandatory)

- Movement of form elements to be W3C compliant as HTML5 requires it (mandatory)

- Moving the $nav variable within the page to ensure tables are formatted
  correctly.  This includes the $nav before the table and the $nav afterwards.
  (mandatory)

- Remove all instances of $_GET, $_REQUEST, and $_POST and replacing the
  wrappers get_request_var(), get_filter_request_var(), set_request_var(),
  isset_request_var(), isempty_request_var() (mandatory)

- Utilize the 'validate_store_request_vars()' function to greatly simplify
  request validation on your pages. (mandatory)

- Migration of the Plugin to the PIA 2.x+ install and setup process.  Cacti PIA
  1.x plugins are not supported in Cacti 1.0 and beyond. (mandatory)

- Removal of hooks that inject jQuery, jQueryUI into Cacti's header (mandatory)

### Optional Steps

- Remove inline styles, and use Cacti's classes instead (highly recommended)

- Migration of filters to Ajax callbacks (highly recommended)

- Removing references to the $colors array (optional)

- Using new functions for alternate colored rows, sorted, checkbox and other
  headers (optional)

- Using new options for headers to support tool tips, alignment etc (optional)

- Migration to new pagination functions, which simplify page navigation

### INFO File structure

The INFO file follows the INI file specification.  An example INFO file
includes the following sections:

- **name** - The name of the plugin directory

- **version** - The version number of the plugin

- **longname** - A description for the plugin

- **author** - The plugins author

- **email** - An email contact in order to reach the author

- **homepage** - A link to the plugin authors homepage

- **compat** - The minimum supported Cacti version

- **capabilities** - a comma delimited string of capabilities defining how the
  plugin works with remote data collectors

- **nosync** - a comma delimited string of directories or file extensions to
  skip during the remote data collector synchronization.  File extensions must be
  formatted as `*.extension` and only are relevant in the base directory of the
  plugin.  The following extensions are automatically excluded regardless of
  directory: 'tar', 'gz', 'zip', 'tgz', 'ttf', 'z', 'exe', 'pack', 'swp', 'swo'.

As mentioned, there are some very good examples of how to create or migrate
plugins in the various Cacti plugins included on The Cacti Groups GitHub site.
Also, for a very simple Cacti page, you can look at vdef.php as an example.
You can use this as a template to manage a table using the Cacti framework.
For a simple plugin example, please review the gexport plugin.

## Charting Functionality

Several JavaScript based HTML5 Charting packages have been included in Cacti in
an effort to assist plugin developers who wish to use graphing API's in their
plugins other than RRDtool.

- [Billboard.js](https://naver.github.io/billboard.js/)
- [D3](https://d3js.org/)
- [Chart.js](http://www.chartjs.org/)
- [DyGraphs](http://dygraphs.com/)
- [jQuery Sparklines](http://omnipotent.net/jquery.sparkline/)

## Logging

For developers using the Cacti framework, it is important to note that
additional controls on logging have been added.  Debug logging can now be
controlled at not only a global level, but now per plugin, per device and even
per file.

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
