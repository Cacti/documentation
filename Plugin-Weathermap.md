# Weathermap

The Weathermap plugin builds network maps in which nodes and links display
monitored values, for example link utilization colored from blue to red. Maps
are described in text configuration files, edited in a browser editor, drawn by
the Cacti poller into image files, and shown on a **Weathermap** tab. It is
based on the PHP Network Weathermap by Howard Jones and is maintained by the
Cacti Group. Network operators use it to give a single picture of traffic and
status across a site, a WAN or a data center.

This page follows the plugin's development branch (`develop`), which is
unreleased and can change. That branch declares version 2.1 and Cacti
compatibility 1.2.29 in its `INFO` file.

## Requirements

- Plugin version 2.1 and Cacti compatibility 1.2.29, as declared in `INFO`.
- No other plugins are required. The `cactithold` data source reads threshold
  state, so it is only useful when the thold plugin is installed.
- The PHP GD extension. The plugin's checker (see
  [Command-Line Tools](#command-line-tools)) treats `imagepng`,
  `imagecreatetruecolor`, `imagealphablending`, `imagesavealpha`,
  `imagecreatefrompng` and `preg_match` as required. JPEG and GIF input and
  output, `imagecopyresampled` (thumbnails) and `imagettfbbox` (TrueType fonts)
  are optional.
- The RRDtool binary configured in Cacti (**RRDtool Binary Path**). The plugin
  reads RRD files through it for `.rrd` targets.
- A sufficient PHP `memory_limit` for the poller. The map generator warns in
  the log when a map run does not finish and names memory as a possible cause.
- Directories under `plugins/weathermap` that the web server user can read, and
  that can be written where you create or edit maps: `configs` for map
  configuration files and `output` for generated images and HTML.

## Installation

Follow [Plugin Management](Plugins.md) for the generic steps. In addition:

1. Copy the plugin into `plugins/weathermap`. The directory must be named
   `weathermap`.
2. Make `plugins/weathermap/configs` writable by the web server user if you
   want to create or edit maps from inside Cacti. If it is not writable, the
   management page raises a permission error and logs `FATAL: The map config
   directory ... is not writable by the web server user`.
3. Install and enable the plugin, then grant the realms in the next section.
4. Optionally run `check.php` from the command line and from a web page to
   test the PHP environment.

The plugin creates the tables `weathermap_auth`, `weathermap_data`,
`weathermap_maps`, `weathermap_groups` and `weathermap_settings`. Uninstalling
drops them. Back up the plugin and your map configuration files before an
upgrade.

Background images and node icons use the separate directories
`images/backgrounds` and `images/objects`. When upgrading from older versions,
the upgrade code tries to move images and update configuration paths, so check
customized image locations afterward.

## Permissions

| Realm | Pages |
| --- | --- |
| **View Weathermaps** | `weathermap-cacti-plugin.php` |
| **Manage Weathermap** | `weathermap-cacti-plugin-mgmt.php`, `weathermap-cacti-plugin-mgmt-groups.php`, `check.php` |
| **Edit Weathermaps** | `weathermap-cacti-plugin-editor.php` |

When Cacti provides role augmentation, **General Administration** receives
**Manage Weathermap** and **Edit Weathermaps**, and **Normal User** receives
**View Weathermaps**.

Realms control which pages a user can open. Access to an individual map is a
separate per-map permission (see below).

## Settings

Global settings are on the **Weathermap** tab of **Console > Configuration >
Settings**, under the heading **Network Weathermap**.

| Setting | Default | Purpose |
| --- | --- | --- |
| Debug Mode | off | Writes detailed status about map generation to the Cacti log. |
| Info URL Style | Time Graph View | Click-through used by the Info URL when graphs are added to a node or link: **Standard Graph View** (several graphs allowed) or **Time Graph View** (one graph). |
| Page style | none set | How multiple maps are shown: **Thumbnail Overview**, **Full Images** or **Show Only First**. |
| Thumbnail Maximum Size | 1000 | Maximum width or height of thumbnails in pixels. Takes effect after the next poller run. |
| Hover Graph Default Width | 400 | Default width of the RRDtool graphs shown when hovering over a link. |
| Hover Graph Default Height | 125 | Default height of those graphs. |
| Hover Graph Style | none set | **Thumbnail Graphs** or **Full Graphs** when hovering over links or nodes. |
| Map Processing Timeout | 5 Minutes | Time allowed before the periodic map generation is treated as timed out: 5, 10, 15 or 20 minutes. |
| Refresh Time | none set | How often the page refreshes in Cycle mode: **Automatic** (fits all maps into 5 minutes), 5, 15 or 30 seconds, or 1, 2 or 3 minutes. |
| Output Format | none set | Image format of generated maps and thumbnails: **PNG (default)**, **JPEG** or **GIF**. |
| Map Rendering Interval | Every Poller Cycle (default) | How often maps are recalculated: **Never (manual updates)**, every poller cycle, or every 2, 3, 4, 5, 10, 12, 24, 36, 48, 72 or 288 poller cycles. The description advises leaving it alone unless you have a non-standard polling setup. |
| Show Weathermap Help Links | off | Adds a link to documentation on all Weathermap pages. |
| Show 'All' Tab | No (default) | When using groups, adds an **All Maps** tab to the tab bar. |
| Show Map Selector | Yes (default) | Shows a map selector box on the full-screen map view. |
| Quiet Logging | Chatty (default) | **Quiet** logs only errors at low log levels. |

Where the table says none set, the source defines no default and the interface
shows the first choice.

The management page also provides **Settings** pages that hold per-map and
per-group values, described below.

## Using Weathermap

### Viewing maps

Open the **Weathermap** tab. Depending on **Page style**, you see thumbnails
of the maps you may view, full images, or the first map only. If maps are
organized into groups, each group is a tab, and **All Maps** appears when
enabled. A map can be opened in a live view or full screen view, and **Cycle**
mode steps through the available maps automatically, with stop, previous,
pause and next controls. The page footer links to the management page and to
the local documentation for users who hold the right realms.

The screenshot shows a map in the viewer. It has six nodes and five links
colored by load, with a legend at the upper left. The example uses synthetic
data.

![Example WAN map with colored links in the viewer][img-1]

Maps can also be added to a Cacti graph tree as a **Weathermap** item, and the
plugin offers an RSS style feed of the maps through the viewer page.

### Managing maps

Open **Console > Management > Weathermaps**. The page is titled **Weather
Maps** and shows run details of the last map generation (time, number of maps,
warnings). The buttons next to the filter are **Group Settings**, **Map
Settings**, **Settings**, **Rebuild All** and **Docs**. The list has the
columns **Title**, **Config File**, **ID**, **Group**, **Enabled**,
**Settings**, **Sort Order**, **Order**, **Accessible By**, **Last Duration**
and **Last Runtime**.

The screenshot shows the management list with one synthetic example map.

![Weather Maps list with one example map][img-2]

Use the plus icon to add a map. The **Add Map** picker lists configuration
files in `configs` with their title, create date, last modified date and size,
and has a **Create Options** box to start a **New Map** (enter a name ending in
`.conf`) from an empty file or from a **Source Map**. Select maps and choose an
action from the list: **Delete**, **Duplicate**, **Disable**, **Enable** or
**Rebuild Now**.

If you use Boost to update RRD files, the page explains that Boost delays data
being written and offers a link to enable Weathermap's `poller_output` support
globally.

If the last run did not complete, the page names the map it failed on and
suggests disabling that map or investigating, with memory limits as a likely
cause.

### Permissions, groups and settings

- **Accessible By** shows who can see each map ("No Users", "All Users", or a
  count of users and groups). Selecting it opens **Edit Permissions**, where
  users and user groups are granted or denied access with the actions **Grant
  Access** and **Revoke Access**.
- **Group Settings** opens the **Edit Map Groups** page, where groups of maps
  are created, renamed, deleted and ordered.
- **Settings** in the map row and the **Map Settings** button open pages of
  map settings. These are `SET` variable name and value pairs that apply to all
  maps, to a group, or to one map. A group overrides the global settings and a
  map overrides the group, and both override `SET` commands inside the map
  configuration file.
- **Sort Order** arrows move a map up or down.

### Editing a map

Select **Edit Map** for a map to open the editor (realm **Edit Weathermaps**).
The editor adds and moves nodes, adds links, edits node, link and map
properties and styles, manages node icon and background images (including
uploads and deletions), manages color presets, and shows the generated
configuration. It records edits so that undo and redo are available. Node
icons come from `images/objects` and backgrounds from `images/backgrounds`.

To create a first map:

1. Open **Console > Management > Weathermaps** and select the plus icon.
2. Enter a name ending in `.conf` under **New Map** and select **Create**, or
   choose a **Source Map** to copy. The bundled `configs/simple.conf` is a
   sample.
3. Add the map to the list from the picker if it is not already registered.
4. Edit the map, add nodes and links, and assign data sources to links.
5. Select **Rebuild All** to draw it without waiting for the poller, then open
   the **Weathermap** tab.

### Data sources

A link or node gets its values from a `TARGET` in the map configuration. The
bundled data source plug-ins in `lib/datasources` recognize these target forms:

| Target form | Source |
| --- | --- |
| `cacti:<id>` | A Cacti data source. |
| `cactihost:<id>` | Cacti host status. |
| `cactithold:<id>`, `cactithold:<id>:<id>` or `cactimonitor:<id>` | Threshold or monitor state. |
| `dsstats:<id>:<name>:<name>` | Data Source Statistics values. |
| `<path>.rrd:<ds>:<ds>` or `<path>.rrd` | An RRD file read through RRDtool. |
| `snmp:...` (also SNMP v2c and v3 plug-ins) | A live SNMP query. |
| `mrtg` log files, `tabfile`, `static`, `time`, `wmdata`, `fping` | Other sources. |

The full list of configuration keywords and target formats is in the bundled
manual under `docs/`.

## Background Processing

The plugin registers the `poller_top`, `poller_output` and `poller_bottom`
hooks.

- `poller_top` records the poller start time, rounded to the minute, for
  schedule checks.
- `poller_output` captures the values the poller writes to RRD files so that
  maps can use them directly when `rrd_use_poller_output` is enabled. This is
  what the Boost note on the management page refers to.
- `poller_bottom` regenerates the maps according to **Map Rendering
  Interval**. If the interval is **Never (manual updates)**, it only logs and
  returns. Otherwise it registers a process with the **Map Processing
  Timeout**, runs all enabled maps and writes images, thumbnails and HTML to
  the `output` directory, then removes permissions of users that no longer
  exist.

If a previous run is still registered, the next one logs `WARNING: Weathermap
map generation process timed out.  Consider increasing the timeout in Console >
Configuration > Settings > Weathermap` and exits. A summary line starting with
`WEATHERMAP STATS` is written to the Cacti log, and per map `MAPSTATS` lines
when the log level is medium. Enable **Debug Mode** for more detail.

## Command-Line Tools

Run the scripts from the plugin directory with PHP. Run `check.php` both from
the command line and from a web page, because the two environments can
differ. It reports the PHP version, `memory_limit`, loaded ini files, and
which required and optional functions are available, with a verdict at the end.

`weathermap` renders a single map file without Cacti:

```console
php weathermap --config=configs/simple.conf --output=output/simple.png
```

Its options, from its help text:

```console
Usage: php weathermap [options]

 --config {filename}      -  filename to read from. Default weathermap.conf
 --output {filename}      -  filename to write image. Default weathermap.png
 --htmloutput {filename}  -  filename to write HTML. Default weathermap.html
 --image-uri {uri}        -  URI to prefix <img> tags in HTML.
 --bulge                  -  Enable link-bulging mode. See manual.
 --define name=value      -  Define internal variables
 --no-data                -  skip the data-reading process (just a 'grey' map)
 --randomdata             -  as above, but use random data
 --debug                  -  produce (LOTS) of debugging information during run
 --no-warn={errorcode}[,{errorcode}] - suppress warnings with listed errorcodes
 --dump-after             -  dump all internal PHP structures (HUGE)
 --dumpconfig {filename}  -  filename to write a new config to (for testing)
 --help                   -  show this help
 --version                -  show version number
```

The `cli` directory has helpers for map configuration files:

| Script | Options |
| --- | --- |
| `cacti-integrate.php` | `--input`, `--output`, `--target-rrdtool` (default), `--target-dsstats`, `--debug`. Fills in targets and related lines from Cacti data. |
| `convert-to-dsstats.php` | `--input`, `--output`, `--reverse` (DSStats back to RRDtool), `--debug`. |
| `map-tidyup.php` | `--input`, `--output`, `--debug`, `--help`. |
| `upgrade_configs.php` | `--debug`. Repairs map metadata. |

The scripts `cacti-mapper.php`, `bristle.php` and `auto-overlib.pl` are
described in `cli/README`.

## Troubleshooting

- The management page shows a permission error: the web server user cannot
  write `plugins/weathermap/configs`. Fix the ownership and retry.
- A map says it has not been created yet, or its thumbnail is missing: no
  poller cycle has drawn it. Select **Rebuild All** or wait for the poller.
- Maps never update: check **Map Rendering Interval**. **Never (manual
  updates)** disables automatic runs.
- Maps lag behind with Boost enabled: enable `poller_output` support from the
  link on the management page.
- Log message `Weathermap map generation process timed out`: raise **Map
  Processing Timeout**.
- The management page reports that the last run did not complete: disable the
  named map or investigate. Memory limits are a possible cause; use **Debug
  Mode** and the log.
- Environment problems such as a missing GD function: run `check.php` as
  described above.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_weathermap)
- [README](https://github.com/Cacti/plugin_weathermap/blob/develop/README.md)
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-1]: images/plugin-weathermap-map.png
[img-2]: images/plugin-management-overview-2.0.png

---

Copyright (c) 2004-2026 The Cacti Group
