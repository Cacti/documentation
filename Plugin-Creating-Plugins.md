# Creating a plugin

Your plugin will require a few things to be properly detected by Cacti.

## Directory Structure

Your plugin will reside in its own directory in Cacti's plugin directory.  You
will need to create a new directory, with a unique name.  It is recommended
that you use all lowercase alpha letters, and try to keep it short (you will be
typing it a lot). All plugin names must contain only upper or lowercase letters
a-z and digits 0-9.

So to begin, create your directory in the plugins directory like this.

```console
/plugins/PLUGINNAME/
```

## Setup File

Cacti detects plugins by looking for a 'setup.php' file located inside your
plugin's directory.  It must be all lowercase.  Inside this file should only be
functions, no code that runs automatically.

## INFO File

Every Cacti plugin must have an INFO file.  Any legacy plugins that do not
have an INFO file will not work with Cacti 1.x.  This was done intentionally
so that plugin users could know ahead of time that their plugin was not
designed for Cacti 1.x.  The info file includes several line including:

* name - The short name for the plugin.  Must be alpha with no spaces and
match the directory name.
* version - The version of the plugin.  Use two to three decimal places.
* longname - A user readable short description for the plugin.
* author - The author of the plugin.
* email - The authors email address for obtaining support.
* homepage - If the author maintains a homepage, the address for that page.
* compat - A sminimum version of Cacti that is required to use this plugin.
* depends - A space delimited list of plugins:version that are required
to use this plugin.
* capabilities - A comma delimited list of capabilities for define what 
capabilities the plugin has primarily remotely.
* nosync - A comma delimited list of relative paths that should not be
syncronized with the remote data collectors, for example transient folders
that may contain quite a bit of data that changes often.

## Functions

Inside the setup file, there are several functions that are mandatory in order
for your plugin to properly be detected, and to properly function.

### plugin_PLUGINNAME_install

This first function is the installation function that is ran when a request is
received to install your plugin.  There are no arguments passed to this
function.

You will need to replace PLUGINNAME with the exact folder name (including case
sensitivity).  Below is an example of this function.  We will discuss the
register_hook function later in this document.

```php
function plugin_PLUGINNAME_install () {
     api_plugin_register_hook('PLUGINNAME', 'top_header_tabs', 'PLUGINNAME_show_tab', 'setup.php');
}
```

### plugin_PLUGINNAME_uninstall

The next function is the uninstall function.  This is a function that is called
when someone requests to uninstall your plugin.  You can use this to clean up
any extra data that is left by your plugin.  If you used the API function to
install any tables, they will be cleaned up automatically.

### plugin_PLUGINNAME_version

The next function is used for checking the version of your plugin, plus
providing a little bit more information.

Below is an example of this function.  The few extra things to return are the
longname (aka Pretty Name that will be displayed), the author, website, etc...
the `url` is a special url used to check for updates of your plugin to be
compatible with the 'update' plugin.

```php
function plugin_PLUGINNAME_version () {
     global $config;
     $info = parse_ini_file($config['base_path'] . '/plugins/PLUGINNAME/INFO', true);
     
     return $info['info'];
}
```

### plugin_PLUGINNAME_check_config

The last mandatory function is used for determining whether your plugin is
ready to be enabled after being installed.

When a plugin is installed, it starts in a disabled state.  Only a few of the
necessary hooks for the plugin are enabled.  These are the config_settings and
config_arrays hook.  Anything that uses those hooks will still be available
while the plugin is disabled.  This allows a user to modify any necessary
settings for the plugin before the plugin is actually enabled and goes live.
You can then use this check_config function to determine whether everything is
correctly setup, before you allow the plugin to be enabled.  From this
function, you will simply need to return TRUE if everything checks out, or
return FALSE if something else needs to be setup.

```php
function plugin_PLUGINNAME_check_config () {
     if (read_config_option('PLUGINNAME_SETTING') != '') {
          return true;
     }
     
     return false;
}
```

#### Registering Hooks

The way that your plugin is able to interact within Cacti is via the many hooks
that are placed into the interface.  As cacti processes the various visual
pages and backend functions, it will call specific hook functions which passes
control over to any plugins that might want to interact with that aspect of
cacti.  In order to utilize these hooks, your plugin must register for each
hook that you require inside our installation function.  This is done via a
simple API function.

```php
api_plugin_register_hook('PLUGINNAME', 'HOOKNAME', 'CALLBACKFUNCTION', 'FILENAME');
```

Name | Description
--- | ---
PLUGINNAME | The name of your plugin
HOOKNAME | The name of the hook you want to register
CALLBACKFUNCTION | The name of your function to call when the hook is triggered.
FILENAME | The name of the file which contains the above function (path relative to your plugin directory)

Taking our above example, if you wanted to display a new tab at the top of
Cacti's Console, your setup.php file may look like this.

```php
function plugin_PLUGINNAME_install () {
     api_plugin_register_hook('PLUGINNAME', 'top_header_tabs', 'PLUGINNAME_show_tab', 'setup.php');
}

function PLUGINNAME_show_tab () {
     global $config;
     print '<a href="' . $config['url_path'] . 'plugins/PLUGINNAME/PLUGINNAME.php"><img src="' . $config['url_path'] . 'plugins/PLUGINNAME/images/tab.gif" align="absmiddle" border="0"></a>';
}
```

Here you can find a full listing of the available hooks

[Hook Api Reference](Plugin-Hook-API-Ref.md)

#### Registering Realms

Cacti allows you to restrict access to various portions of Cacti by utilizing
Realm Permissions.  Creating a new realm will add a checkbox to the User
Permissions form for the page you desire to restrict access to.  You can create
1 realm that permits access to multiple pages, or use multiple realms for
different functional duties (ex: separating out the viewing and the
configuration sections of your plugin).

We need to call this hook in the same function as we registered for hooks.
Either of the api calls can come first (there is no order necessary)

```php
api_plugin_register_realm('PLUGINNAME', 'FILENAMETORESTRICT', 'DISPLAYTEXT', 1);
```

Name | Description
--- | ---
PLUGINNAME | Your plugins name
FILENAMETORESTRICT | the filename (relative to your plugin directory) to restrict access to, you can separate multiple with a comma
DISPLAYTEXT | This is the text that will display on the User Permissions form for this Realm
1 or 0 (true or false) | This tells it whether to automatically grant permission to the 'admin' user account (true)

So to follow our example, your install function would look like this

```php
function plugin_PLUGINNAME_install () {
     api_plugin_register_hook('PLUGINNAME', 'top_header_tabs', 'PLUGINNAME_show_tab', 'setup.php');
     api_plugin_register_realm('PLUGINNAME', 'PLUGINNAME.php,', 'View PLUGINNAME', 1);
}
```

---
Copyright (c) 2004-2020 The Cacti Group
