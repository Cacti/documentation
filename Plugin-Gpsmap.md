# GPSMap

The Maps plugin (directory `gpsmap`) plots Cacti devices on a Google map by
latitude and longitude and colors each marker by device status. It can also
draw coverage areas around access points. It suits networks whose devices are
spread across real geography, such as wireless, campus and metro networks,
where an operator needs to see where a fault is and not only which device is
down.

This page follows the plugin's development branch (`develop`), which is
unreleased and can change. That branch declares version 2.2 and Cacti
compatibility 1.2.29 in its `INFO` file.

## Requirements

- Plugin version 2.2 and Cacti compatibility 1.2.29, as declared in `INFO`.
- No other plugins are required. When the **thold** plugin is enabled, the map
  also uses its threshold state (see [Using GPSMap](#using-gpsmap)).
- A Google Maps API key is recommended. The map page loads the Google Maps
  JavaScript library from `maps.googleapis.com`, so the browser must be able
  to reach it and Cacti's Content Security Policy settings must allow it.
- The poller must be able to write to `plugins/gpsmap/XML`.
- The poller runs the PHP binary configured in Cacti's **PHP Binary Path**
  setting to refresh host name lookups in the background. If it is empty, the
  plugin logs a warning and skips the refresh.

## Installation

Follow [Plugin Management](Plugins.md) for the generic steps. In addition:

1. Copy the plugin into `plugins/gpsmap`.
2. Give the user that runs the poller write access to `plugins/gpsmap/XML`.
   The directory name is uppercase, which matters on case sensitive file
   systems.
3. Install and enable the plugin.
4. Grant the realms in the next section to your users.

Installation adds columns to the Cacti `host` table and creates the
`gpsmap_templates` and `plugin_gpsmap_dns_cache` tables. The columns hold the
coordinates and access point values described below. Uninstalling the plugin
does not remove the tables or columns, so coordinates survive an accidental
removal.

## Permissions

| Realm | Pages |
| --- | --- |
| **Configure Maps** | `gpstemplates.php`, `gpstemplates_add.php` |
| **View Maps** | `gpsmap.php` |

Users need **View Maps** to see the **Maps** tab and open the map. Users who
manage Map Templates need **Configure Maps**.

## Settings

Settings are on the **Maps** tab of **Console > Configuration > Settings**.
The first group, headed **Maps**, locates and centers the map.

| Setting | Default | Purpose |
| --- | --- | --- |
| Google API Key | none | Google Maps API key. The setting is described as not required but highly recommended. |
| Geolocation URL | `http://ipinfo.io/` | URL of an IP to geolocation lookup service. The device IP address is appended to the URL. |
| Initial Latitude | `33.8734` | Centers the map. |
| Initial Longitude | `-115.901` | Centers the map. |
| Initial Elevation | `9` | Starting zoom of the map, from 0 to 12. |

If the initial latitude or longitude is empty, the Maps page shows a message
asking you to configure the plugin under **Settings > Maps** instead of a map.

Section **Display Settings**:

| Setting | Default | Purpose |
| --- | --- | --- |
| Display Disabled Devices | off | Allow disabled devices on the map. |
| Coverage Overlay | off | Draw a transparent circle around an access point with a radius equal to the furthest node in the same group. |
| Map Refresh | `5` | Reload the map after this many minutes. Set it to the poller interval, or 0 to disable. |

Section **Overlay Settings**:

| Setting | Default | Purpose |
| --- | --- | --- |
| Tab Radius (Required) | `.0003` | Radius used to combine nearby points into one marker. |
| Fill Color | `005D57` | Fill color of the overlay circle. |
| Ring Color | `005D57` | Color of the outer rim. |
| Ring Width | `2` | Width of the outer ring. |
| Fill Opacity | `.2` | Fill opacity, between 0 and 1. |
| Ring Opacity | `.8` | Ring opacity, between 0 and 1. |
| Quality | `15` | Number of divisions in a circle. Preferably above 15; larger numbers can slow the browser. |

## Using GPSMap

Three things must be in place before a device appears on the map: a Map
Template for its device template, coordinates on the device, and a completed
poller cycle.

### Map Templates

Open **Console > Templates > Map** to list the Map Templates. The page is
titled **Map Templates** and has the columns **Host Template**, **Up Image**,
**Recovering Image**, **Down Image** and **Is AP**. Use the plus icon to add
one, or select rows and choose **Delete** from the action list.

The screenshot below shows the Map Templates list with four synthetic device
templates and their marker icons.

![Map Templates list with four synthetic templates][img-1]

A Map Template has these fields:

- **Device Template**: the device template that this Map Template applies to.
- **Up Image**, **Recovering Image**, **Down Image**: the marker icon for each
  state.
- **Access Point**: whether the device template represents an access point
  (**Yes** or **No**).

A device whose device template has no Map Template is not drawn. Icon images
are read from `plugins/gpsmap/images/icons`.

### Device coordinates

Edit a device in **Console > Management > Devices**. The plugin adds a
**Map Settings** section after the **Disabled** field:

| Field | Default | Purpose |
| --- | --- | --- |
| Overlay Inclusion | on | Disable to plot the device only, not include it in the coverage overlay. |
| Latitude | empty | Latitude of the device. |
| Longitude | empty | Longitude of the device. |
| Starting Degree | `0` | Start of a directional coverage area, 0 to 360. Shown only for access points. |
| Stopping Degree | `360` | End of the directional area, must be greater than the starting degree. Access points only. |
| Specify Radius | `0` | Manual radius for an access point. 0 derives the radius from grouped devices. Access points only. |
| Group ID | `0` | Group that decides which devices belong to an access point's coverage overlay. 0 disables. |

Starting Degree, Stopping Degree and Specify Radius appear only when the
device's device template is marked as an access point.

### Viewing the map

Open the **Maps** tab. The map shows each device as a marker whose icon depends
on its state: up, recovering, down, disabled or undefined. When the thold
plugin is enabled and an otherwise up device has an enabled threshold in an
alert state, the marker is drawn in the alert state instead. The map page
also lists drill-down links by subnet, each with links to the XML and KML files
of that subnet, and has a **Print** button.

To place a new device on the map:

1. Create a Map Template for its device template under **Console > Templates
   > Map**.
2. Edit the device and enter **Latitude** and **Longitude** under **Map
   Settings**, then save.
3. Wait for the next poller cycle to finish, then open the **Maps** tab.

## Background Processing

The map is generated by the poller, not on each page view. The plugin registers
the `poller_bottom` hook. In each cycle it:

1. Loads every device whose device template has a Map Template and that has
   coordinates. Devices with a literal IP address are used directly. Devices
   with a host name use the address stored in `plugin_gpsmap_dns_cache`.
2. Writes the full map to `plugins/gpsmap/XML` (`all.xml` and
   `all-top.html`), then one set of files for each subnet prefix in use. The
   `.kml` files for the subnet downloads are also produced there.
3. Starts a background PHP process that refreshes host name lookups. A newly
   added host name can therefore appear one poll later. If a lookup fails, the
   last known address is kept.
4. Removes generated files that were not refreshed for three poller intervals,
   but only after all files were published successfully.
5. Writes a summary line to the Cacti log, for example
   `GPSMAP STATS: Mapped:12 Towers:2 Subnets:3 Pruned:0 Time:0.12`.

The Maps page reads the prebuilt files, so nothing appears until a poller cycle
has completed after you configure a device.

## Troubleshooting

Messages are written to the Cacti log with the `GPSMAP` tag.

- Log message `NOTICE: gpsmap has no Devices to map.`: no device qualified.
  Check that its device template is listed under **Templates > Map** and that
  the device has coordinates.
- Log message `Unable to write to: <file>. Please verify that the Data
  Collector has write access to this location.`: fix ownership and permissions
  on `plugins/gpsmap/XML`.
- Log message `gpsmap has N hostname(s) without a cached address`: the
  background lookup has not resolved those names yet. The last known markers
  are kept.
- Log message `gpsmap omitted N hostname(s) after repeated DNS failures`: the
  named devices are left off the map until the lookup succeeds.
- Log message `gpsmap DNS refresh was not scheduled because the PHP binary path
  is not configured`: set the PHP binary path in the Cacti settings.
- The Maps page shows a configuration message instead of a map: set **Initial
  Latitude** and **Initial Longitude** under **Settings > Maps**.
- The page is blank and the browser console reports a blocked script: the
  Google Maps script was not allowed by the Content Security Policy.
- An up device is drawn in the alert state: the thold plugin is enabled and the
  device has an enabled threshold in an alert state.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_gpsmap)
- [README](https://github.com/Cacti/plugin_gpsmap/blob/develop/README.md)
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[img-1]: images/plugin-gpsmap-templates.png

---

Copyright (c) 2004-2026 The Cacti Group
