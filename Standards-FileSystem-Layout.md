# File System Layout

It is important that files are well placed and named within Cacti's directory
structure. The naming structure may contain a **category token** and/or an
**action**.

## Token

Under each category directory, functions should be broken out into multiple
files where applicable. All files must begin with the name of category (ie. its
parent directory name). Valid token names are

* auth
* automation
* color_template
* data_input
* data_query
* data_source
* data_source_profile
* data_template
* device (rename from host)
* device_template
* event (if we have event management in core)
* graph
* graph_template
* graph_tree
* package
* plugin
* poller
* preset (colors, cdefs, vdefs, gprints, etc)
* site
* user

## Actions

This part should reflect what type of actions the file contains. Specific
examples are listed below.

* info - reads information
* update - writes (or changes) information
* form - draws form-related information
* execute - performs some action that does not modify or return information
* utility - contains miscellaneous functions

## Function Verbs

Functions in those PHP modules shall name their token and shall contain a verb
to explain the purpose. Specific examples are listed below.

* list
* get
* save
* copy
* clear
* remove
* update

## Directory Structure

### cli/

`[token]_[action].php`

### images/

* icons/        # 16x16, 32x32 icons
* buttons/      # button images (save, cancel, etc)
* tabs/         # tab images

### include/

Code that must be accessed globally but is not contained inside of a function
should be stored in the `include/` directory. The most common examples are to
store globally accessible constants and arrays.

Directly under the `include/` directory, the files beginning with `global` are
used to store information that is accessible everywhere in the code. Only store
information in these files that are meaningful to the entire program. Also
under the `include/` directory is a directory for each category (graph, device,
etc), where information specific to that category is to be stored.

Constants that are made available everyone in the program

```console
include/global_constants.php
```

Arrays that are only used with graphs

```console
include/graph_arrays.php
```

```console
  content/
  fa/                                   # FontAwesome files
  js/                                   # javascript files
  themes/[theme]/                       # Visual theme files
  vendor/
    csrf/                               # CSRF Magic
    flag-icon-css/                      # Flag Icons
    phpgettext/                         # PHP GetText Library
    phpmailer/                          # PHP Mailer Library
    phpseclib/                          # PHP Security Library
    phpsnmp/                            # PHP Snmp Library
```

```console
  auth.php                              # Ensures user authenticate and
                                        # includes global.php
  cacti_version
  cli_check.php                         # Default Command Line Include also
                                        # includes global.php
  global_arrays.php
  global_constants.php                  # Constants only
  global_form.php                       # Form field definitions
  global_languages.php                  # Language selector
  global.php
  global_session.php                    # Session variable management
  global_settings.php                   # Setting definitions
  session.php                           # Session management

  plugins.php                           # Global plugin variables

  bottom_footer.php                     # Standard Footer
  top_general_header.php
  top_graph_header.php
  top_header.php

  layout.js                             # Main layout javascript
  realtime.js                           # Realtime javascript functions
```

### lib/

Functions that must be accessed globally should be stored in the ''lib/''
directory. This is where most of the heavy lifting in Cacti occurs.

Directly under the `lib/` directory, the files beginning with the `api`
prefix are core Cacti API's that are only to be used by third party
developers and should NEVER include a call to a
`$_REQUEST`, `$_POST`, or `$_GET` variable.

Files that have the `html` prefix, generally invole the rendering of page
content, for example the `html_form.php` library draws forms and
`html_validate.php` includes functions to validate page variables there
are other various files in the current cacti `lib/` directory that will
over time be changing with the migration to the next major version of
Cacti.  So, these rules may change over time.

Here is the core API for the Cacti `graphs.php` page, and that deals with
the manipulation of **Graphs**.

```console
lib/api_graph.php
```

### locales/

Language-related files are stored here to handle the multi-lingual natural of
Cacti. These can be updated by running the `update-pot.sh` script.  It is
advised to do this whenever you are submitting a change to the Cacti via Pull
Request.  Otherwise, language translations can be missed.

### plugins/

Directly under the `plugins/` directory are sub directories that contain
plugins for Cacti.  Since Cacti 1.0.0, all plugins must have an accompanying
INFO file that details the plugin.

## Including and Requiring Files

To reduce bloat, each file and/or function should include any and all files
which it relies on.

The following function directly relies the libraries related to sequences and
reading graph information. The `require_once` directive is used instead of
`require` to prevent PHP re-declaration errors.

```php
function api_graph_item_save($graph_item_id, &$_fields_graph_item) {
    require_once(CACTI_BASE_PATH . '/lib/sys/sequence.php');
    require_once(CACTI_BASE_PATH . '/lib/graph/graph_info.php');
```

---
<copy>Copyright (c) 2004-2022 The Cacti Group</copy>
