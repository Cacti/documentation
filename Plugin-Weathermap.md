# Weathermap

The Weathermap plugin draws network maps in which nodes are devices and links
are colored and labeled by the traffic or other values that Cacti collects.
Maps are edited in a browser editor, stored as configuration files, rendered
by the Cacti poller, and shown to users on the **Weathermap** tab. Operators
who want a single-page view of the current state of a network use this plugin.
It is based on PHP Network Weathermap by Howard Jones.

## Requirements

- This page documents Weathermap 2.1 (release tag `v2.1`). The README and
  bundled manual in this release still carry the 2.0 title.

- Cacti 1.2.29 or later.

- No other plugin is required. Data sources for Thold and for Cacti device
  status are included for maps that use them.

- PHP with GD support for the image formats you use. The bundled manual
  states that FreeType is needed for TrueType labels and curved comments, and
  that the PHP `intl` extension is used for locale-aware timestamps.

- A working Cacti poller and RRDtool for maps that read RRD files.

- The legacy command-line wrapper `weathermap` loads the PEAR
  `Console/Getopt.php` class. The Cacti integration does not use it.

## Installation

Install the plugin with the generic procedure in
[Plugin Management](Plugins.md). Place the release in
`<cacti_root>/plugins/weathermap/`; if the archive has a versioned top-level
directory, rename it to `weathermap` so that `INFO` and `setup.php` sit
directly inside it. The plugin creates and upgrades its own database tables.

The bundled manual lists the file system access each account needs:

- `configs/`: the web server account needs read and write access, and must
  be able to create files in the directory. The poller needs read access.

- `output/`: the poller needs write access for rendered maps and thumbnails,
  and the web server must be able to serve them.

- `images/objects/` and `images/backgrounds/`: the web server account needs
  write access to upload and delete images. The renderer needs read access.

When upgrading, back up the whole plugin directory, including `configs/`,
`output/`, uploaded images and custom fonts, and back up the Cacti database.
On a version change the plugin repairs map metadata and removes files that
the release manifest lists as obsolete. Older background and icon images are
moved into `images/backgrounds/` and `images/objects/`, and the map
configurations are updated to match.

## Permissions

###### Table 1. Weathermap realms

| Realm                 | Pages                                                                                  |
| --------------------- | -------------------------------------------------------------------------------------- |
| **View Weathermaps**  | `weathermap-cacti-plugin.php`                                                          |
| **Manage Weathermap** | `weathermap-cacti-plugin-mgmt.php`, `weathermap-cacti-plugin-mgmt-groups.php`, `check.php` |
| **Edit Weathermaps**  | `weathermap-cacti-plugin-editor.php`                                                   |

On Cacti versions that support role augmentation, the plugin adds **Manage
Weathermap** and **Edit Weathermaps** to the **General Administration** role
and **View Weathermaps** to the **Normal User** role.

These realms control access to the plugin pages. Each map also has its own
list of users and user groups who may view it, set on the map's permissions
page.

## Settings

Global settings are on **Console > Configuration > Settings > Weathermap**,
in the **Network Weathermap** section. The **Settings** button on the
management page opens the same tab.

###### Table 2. Weathermap settings

| Label | Default | Purpose |
| ----- | ------- | ------- |
| **Debug Mode** | Unchecked | Writes detailed map generation messages to the Cacti log. |
| **Info URL Style** | **Time Graph View** | Click-through target when graphs are added to a node or link: **Standard Graph View** (several graphs allowed) or **Time Graph View** (one graph). |
| **Page style** | Not set; behaves as **Thumbnail Overview** | How several maps are shown: **Thumbnail Overview**, **Full Images** or **Show Only First**. |
| **Thumbnail Maximum Size** | 1000 | Largest thumbnail width or height in pixels. Takes effect after the next poller run. |
| **Hover Graph Default Width** | 400 | Width of the graphs shown when hovering over a link. |
| **Hover Graph Default Height** | 125 | Height of those graphs. |
| **Hover Graph Style** | Not set | **Thumbnail Graphs** or **Full Graphs**. |
| **Map Processing Timeout** | 5 Minutes | Time allowed for the periodic map generation, from 5 to 20 minutes. |
| **Refresh Time** | Not set | Page refresh in cycle mode. **Automatic** fits all maps into 5 minutes. |
| **Output Format** | **PNG (default)** | Image format for maps and thumbnails: PNG, JPEG or GIF. |
| **Map Rendering Interval** | **Every Poller Cycle (default)** | How often maps are recalculated: every poller cycle, every 2 to 288 cycles, or **Never (manual updates)**. |
| **Show Weathermap Help Links** | Unchecked | Adds a documentation link to all Weathermap pages. |
| **Show 'All' Tab** | **No (default)** | Adds an **All Maps** tab when groups are used. |
| **Show Map Selector** | **Yes (default)** | Shows a map selector on the full-screen map view. |
| **Quiet Logging** | **Chatty (default)** | **Quiet** logs only errors at the LOW log level. |

The management page also has **Map Settings** and **Group Settings**
buttons. These hold named map settings that correspond to `SET` lines in a
map file, at three levels. A per-map setting overrides the group setting,
which overrides the global setting; all three override a `SET` line in the
map configuration file.

## Using Weathermap

### Viewing maps

Users with **View Weathermaps** see a **Weathermap** tab at the top of
Cacti. With several maps, the page shows thumbnails or full images according
to **Page style**; **Automatically Cycle** in the page title rotates through
the maps the user may view. Hovering over a link shows its graphs.

The following screenshot shows the viewer with a three-node example map. The
green heading holds the **Manage Weathermaps**, **Map Settings**, **Map
Permissions** and **Edit Map** shortcuts, and **Map to View** selects another
map.

![Weathermap viewer showing an example map of a core router, access switch
and server joined by links colored by utilization, with a traffic
legend](images/plugin-weathermap-viewer-overview-2.0.png)

### Managing maps

Open **Console > Management > Weathermaps**. The **Weather Maps** list shows
each map's **Title**, **Config File**, **Group**, **Enabled** state,
**Settings**, **Sort Order**, **Accessible By**, **Last Duration** and
**Last Runtime**. The buttons beside the filter open **Group Settings**, **Map
Settings** and **Settings**, start **Rebuild All**, and open the bundled
**Docs**. The actions menu offers **Delete**, **Duplicate**, **Disable**,
**Enable** and **Rebuild Now**.

The following screenshot shows the management list filtered to one example
map.

![Weathermap management list with one example map, showing its config file,
group, enabled state, settings, sort order, access and last run
time](images/plugin-weathermap-management-overview-2.0.png)

A map configuration file is not drawn until it is registered on this page.
To create and register a map:

1. On **Console > Management > Weathermaps**, click the add icon on the
   **Weather Maps** heading. This opens the configuration file list.

2. Under **Create Options**, enter a new file name ending in `.conf` and an
   optional map title. Choose **Empty File** for a blank map, or an existing
   map to copy, and create the file.

3. In **Existing Configuration Files**, find the new file and click the add
   icon beside it to register it.

4. Back on the management page, check the map's group and permissions, then
   click its title to open the editor.

To change who can see a map, click the entry in **Accessible By**. The
permissions page lists users and user groups; select rows and choose **Grant
Access** or **Revoke Access**.

Map groups organize the viewer and can carry shared map settings. Open
**Group Settings** to add, rename, order and delete groups, and click a map's
group on the management list to move it. Deleting a group moves its maps to
another group.

### Editing maps

Users with **Edit Weathermaps** open the editor from **Edit Map** in the
viewer or by clicking a map title on the management page. The toolbar has
**Add Node**, **Add Link**, **Add Note**, **Position Legend**, **Position
Timestamp**, **Map Properties**, **Map Style**, **Manage Colors**, **Manage
Images**, **Editor Settings**, and **Undo** and **Redo**. Clicking a node or
link opens its properties; for a traffic link, choose the interface and set
its capacity there.

The following screenshot shows the editor toolbar above an example map.

![Weathermap editor toolbar above an example map with curved links between a
core router, an access switch and an application
server](images/plugin-weathermap-editor-overview-2.0.png)

The release includes the full plugin manual under `docs/` in the plugin
directory. It covers the editor, map configuration keywords, data source
targets and error codes.

## How It Collects Data

Weathermap registers three poller hooks:

- `poller_top` records the start time of the poller cycle.

- `poller_output` reads values for the data sources that maps use from the
  poller output before they are written to RRD files, converts counter and
  derive values to rates, and stores them in the `weathermap_data` table.
  When Cacti's Boost RRD update is enabled, the plugin turns on its own
  `rrd_use_poller_output` global setting so maps use these values.

- `poller_bottom` renders all enabled maps according to **Map Rendering
  Interval**. Rendering is registered as a Cacti process with the **Map
  Processing Timeout** as its limit, and an error in one map is logged
  without stopping the Cacti poller. The same hook removes map permissions
  for deleted Cacti users.

Rendered images, thumbnails and HTML are written to `output/`. The plugin
does not keep history tables; `weathermap_data` holds the latest value for
each data source in use.

## Command-Line Tools

`weathermap-cacti-rebuild.php` renders all maps once, for installations
that use **Never (manual updates)** or need an immediate rebuild. Run it from
the plugin directory as the poller user:

```console
cd /path/to/cacti/plugins/weathermap
php weathermap-cacti-rebuild.php
```

`cli/upgrade_configs.php` repairs map configurations after an upgrade:

```console
php cli/upgrade_configs.php [--debug]
```

The legacy `weathermap` wrapper renders a single configuration file outside
Cacti. Its help text lists these options:

```console
php weathermap --config {filename} --output {filename} --htmloutput {filename}
```

- `--config` is the file to read. The default is `weathermap.conf`.

- `--output` and `--htmloutput` are the image and HTML files to write.

- `--image-uri` sets the URI prefix for `img` tags in the HTML.

- `--bulge` enables link-bulging mode.

- `--define name=value` sets an internal variable, like a global `SET`.

- `--no-data` skips data reading; `--randomdata` uses random data.

- `--debug` produces debugging output; `--no-warn` suppresses warnings with
  the listed error codes.

- `--dumpconfig {filename}` writes a new configuration file for testing.

- `--help` and `--version` show usage and the version.

The wrapper uses `/usr/bin/rrdtool` unless the `$rrdtool` line at the top of
the script is changed.

## Troubleshooting

- `WARNING: Weathermap map generation process timed out.` in the Cacti log
  means map generation exceeded **Map Processing Timeout**. Increase it on
  **Console > Configuration > Settings > Weathermap**.

- `ERROR: Weathermap map generation failed:` is followed by the error from
  the map that failed.

- The editor reports **Editor directory permissions are not correct!** when
  the web server account cannot write to the `configs/` directory.

- A configuration file that is not registered on the management page, or is
  disabled there, is not rendered by the poller.

- Turn on **Debug Mode** to log detailed generation messages, and set
  **Quiet Logging** to **Chatty (default)** to see routine activity.

- A map that links to a graph does not grant permission to that graph, so a
  hover preview can be missing for a user who may see the map but not the
  graph.

- With **Map Rendering Interval** set to **Never (manual updates)**, the
  poller logs `Manual Updates Only` and maps change only when rebuilt.

## More Information

- [Weathermap plugin repository](https://github.com/Cacti/plugin_weathermap)

- [2.1 README](https://github.com/Cacti/plugin_weathermap/blob/v2.1/README.md)

---

Copyright (c) 2004-2026 The Cacti Group
