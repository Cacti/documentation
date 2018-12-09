# Reference Plugins

FIXME The reference plugin is under development.  Nothing to see here yet.

The Reference Plugin(s) are generic plugins that implement key pieces of the
Plugin Architecture.

They are broken down into several separate plugins, each covering different
portions of the [Hook API Reference](Plugin-Hook-API-Ref.md)

## Standard Files

The following files should be included in every plugin

* README
* docs/CHANGELOG
* LICENSE
* setup.php
* index.php

```php
<?php

/*

 +-------------------------------------------------------------------------+

 | Copyright (C) 2004-2018 The Cacti Group                                 |
 |                                                                         |
 | This program is free software; you can redistribute it and/or           |
 | modify it under the terms of the GNU General Public License             |
 | as published by the Free Software Foundation; either version 2          |
 | of the License, or (at your option) any later version.                  |
 |                                                                         |
 | This program is distributed in the hope that it will be useful,         |
 | but WITHOUT ANY WARRANTY; without even the implied warranty of          |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |
 | GNU General Public License for more details.                            |
 +-------------------------------------------------------------------------+
 | Cacti: The Complete RRDTool-based Graphing Solution                     |
 +-------------------------------------------------------------------------+
 | This code is designed, written, and maintained by the Cacti Group. See  |
 | about.php and/or the AUTHORS file for specific developer information.   |
 +-------------------------------------------------------------------------+
 | https://www.cacti.net/                                                   |
 +-------------------------------------------------------------------------+
*/

header("Location:../index.php");

?>
```

## File Structure

All plugin files should reside under thier own respective plugin directory.  The example below is for a plugin called 'myplugin'.

```console
myplugin/
    images/
        myimage.png
        index.php
    lib/
        index.php
        functions.php
    include/
        index.php
        settings.php
    LICENSE
    INFO
    README.md
    index.php
    setup.php
```

## Contents of Files

The three core sub-directories included in your plugin should be images, lib, and included.  Each of these directories should include an index.php that points to it's parent directories index.php.  This way we prevent people from randomly browsing the contents of our web site.

The two main files required for every plugin are the INFO and the setup.php file.  Without these two files, the plugin directory will not be recognized as a valid plugin and will be skipped.

The INFO file is formatted as Microsoft standard INI file.  It constains information about the plugin including its version, author, dependencies, functions, and minimum version of Cacti and other plugins required.

The setup file includes key plugin functions that allow the plugin to be installed, uninstalled, upgraded, etc.  We will document those various functions in the REFERENCE HERE section of the documentation.  There are several functions that every setup.php must include for the plugin to function correctly.

Any core functions should always be placed in the lib/functions.php file, and settings should go into the include/settings.php file.  The plugin architecture allows hooks to be defined that reach into the include/settings.php file.  Having those hooks point to the include version of the file will keep Cacti page loads fast.  Including too much in the setup.php slows Cacti and should be avoided.

---
Copyright (c) 2018 Cacti Group
