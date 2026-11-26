# QuickTree

QuickTree is a basket for graphs. While investigating a problem you click a
plus icon next to any graph, and the graph is added to your personal QuickTree
page. You can then save the collection as a normal Cacti graph tree or as a
branch of an existing tree. It suits users who switch between graphs from
different devices, such as a server load graph and a switch port graph.

This page follows the plugin's `main` branch, which is unreleased and can
change. The branch declares version 2.0 and Cacti compatibility 1.2.29 in its
`INFO` file. It is not presented here as a released version.

## Requirements

- Cacti 1.2.29 or later, as declared in `INFO` (version 2.0).
- No other plugins, PHP extensions, or external programs are required.
- Saving a collection as a tree requires permission to edit that tree.

## Installation

Copy the plugin into `plugins/quicktree` in the Cacti directory (the folder
must be named `quicktree`), then install and enable it as described in
[Plugin Management](Plugins.md). Installing creates the `quicktree_graphs`
table and sets the page style to **Tab**. Uninstalling leaves the table in
place.

If you run a Cacti version older than 1.2.31, the plugin README describes a
JavaScript function to add to `include/layout.js` so that **Cancel** buttons
on forms work.

## Permissions

| Realm | Pages |
| --- | --- |
| **QuickTree Management** | `quicktree.php` |

Grant the realm to each user who should have a QuickTree. The tab, the console
menu entry, and the plus icon next to graphs appear only for users with the
realm. Each user has a separate list.

## Settings

The plugin adds one setting to the **Misc** tab of **Console > Configuration >
Settings**, under the **Quicktree** heading.

| Setting | Default | Purpose |
| --- | --- | --- |
| **Page Style** | Tab | Where the QuickTree page is displayed: **Tab**, **Console Menu**, or **Both Tab and Console Menu**. |

The default is stored at install time; the setting itself has no `default`
entry in the settings array.

## Using QuickTree

Depending on **Page Style**, open the **QuickTree** tab in the Cacti header or
**Console > Management > QuickTree Trees**.

To collect graphs, click the plus icon (**Add to Quicktree**) next to a graph
on the graph view pages. A graph already in your list is not added twice.

The page opens with an **Information/Directions** box, an **Actions** drop-down,
and then each queued graph with its title and a remove icon. The example uses
synthetic data and shows the top of the page; queued graphs appear below it.

![QuickTree page with directions and Actions][qt-img]

To save the collection as a tree:

1. Open the QuickTree page.
2. In **Actions**, choose **Save To New Tree** or **Save To Branch**, and click
   **Go**.
3. For a new tree, enter a **Tree Name** and a **Branch Name**. For an existing
   tree, choose the **Tree Name** and enter a **Branch Name**. Only trees you
   may edit are offered.
4. Click **Continue**.

Cacti creates the tree or branch, adds the graphs, and opens it in the graph
view. Cacti caches graph trees, so you may need to switch to another tree before
a newly created tree appears in the list.

To remove one graph, click the remove icon beside its title. To empty the list,
choose **Clear All Graphs** in **Actions**. Adding, removing, and clearing do
not change anything else in Cacti. Only saving creates a tree.

## Command-Line Tools

The plugin provides none.

## Troubleshooting

- **No Graphs Added Yet** is shown when your list is empty.
- **QuickTree has no Graphs Queued** is shown when you try to save an empty
  list.
- **Graph ... was NOT added to QuickTree** means the graph is already in your
  list.
- If the plus icon does not appear, check that the user has the **QuickTree
  Management** realm.

## More Information

- [Plugin repository](https://github.com/Cacti/plugin_quicktree)
- [Plugin README](https://github.com/Cacti/plugin_quicktree/blob/main/README.md)
- [Plugin Management](Plugins.md)
- [Supported plugins](supported-plugins.md)

[qt-img]: images/plugin-quicktree-page.png

---

Copyright (c) 2004-2026 The Cacti Group
