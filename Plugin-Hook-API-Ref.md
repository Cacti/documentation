# Plugin Hook API Reference

The following table shows all known Cacti plugin hooks and a brief description
of their function.

hook | hook | hook
--- | --- | ---
[add\_graph\_template\_to\_host](Plugin-Hook-API-Ref.md#add_graph_template_to_host) | [api\_device\_new](Plugin-Hook-API-Ref.md#api_device_new) | [api\_device\_save](Plugin-Hook-API-Ref.md#api_device_save)
[auth\_alternate\_realms](Plugin-Hook-API-Ref.md#auth_alternate_realms) | [auth\_profile\_reset](Plugin-Hook-API-Ref.md#auth_profile_reset) | [auth\_profile\_reset\_value](Plugin-Hook-API-Ref.md#auth_profile_reset_value)
[auth\_profile\_run\_action](Plugin-Hook-API-Ref.md#auth_profile_run_action) | [auth\_profile\_save](Plugin-Hook-API-Ref.md#auth_profile_save) | [auth\_profile\_tabs](Plugin-Hook-API-Ref.md#auth_profile_tabs)
[auth\_profile\_update\_data](Plugin-Hook-API-Ref.md#auth_profile_update_data) | [boost\_poller\_bottom](Plugin-Hook-API-Ref.md#boost_poller_bottom) | [bottom\_footer](Plugin-Hook-API-Ref.md#bottom_footer)
[cacti\_stats\_update](Plugin-Hook-API-Ref.md#cacti_stats_update) | [change\_password\_title](Plugin-Hook-API-Ref.md#change_password_title) | [clog\_regex\_array](Plugin-Hook-API-Ref.md#clog_regex_array)
[config\_arrays](Plugin-Hook-API-Ref.md#config_arrays) | [config\_form](Plugin-Hook-API-Ref.md#config_form) | [config\_insert](Plugin-Hook-API-Ref.md#config_insert)
[config\_settings](Plugin-Hook-API-Ref.md#config_settings) | [console\_after](Plugin-Hook-API-Ref.md#console_after) | [console\_before](Plugin-Hook-API-Ref.md#console_before)
[copy\_user](Plugin-Hook-API-Ref.md#copy_user) | [create\_complete\_graph\_from\_template](Plugin-Hook-API-Ref.md#create_complete_graph_from_template) | [custom\_denied](Plugin-Hook-API-Ref.md#custom_denied)
[custom\_login](Plugin-Hook-API-Ref.md#custom_login) | [custom\_logout\_message](Plugin-Hook-API-Ref.md#custom_logout_message) | [custom\_password](Plugin-Hook-API-Ref.md#custom_password)
[custom\_version\_info](Plugin-Hook-API-Ref.md#custom_version_info) | [data\_input\_sql\_where](Plugin-Hook-API-Ref.md#data_input_sql_where) | [data\_source\_action\_array](Plugin-Hook-API-Ref.md#data_source_action_array)
[data\_source\_action\_bottom](Plugin-Hook-API-Ref.md#data_source_action_bottom) | [data\_source\_action\_execute](Plugin-Hook-API-Ref.md#data_source_action_execute) | [data\_source\_action\_prepare](Plugin-Hook-API-Ref.md#data_source_action_prepare)
[data\_source\_edit\_bottom](Plugin-Hook-API-Ref.md#data_source_edit_bottom) | [data\_source\_edit\_top](Plugin-Hook-API-Ref.md#data_source_edit_top) | [data\_source\_remove](Plugin-Hook-API-Ref.md#data_source_remove)
[data\_source\_to\_poller\_items](Plugin-Hook-API-Ref.md#data_source_to_poller_items) | [data\_sources\_table](Plugin-Hook-API-Ref.md#data_sources_table) | [device\_action\_array](Plugin-Hook-API-Ref.md#device_action_array)
[device\_action\_bottom](Plugin-Hook-API-Ref.md#device_action_bottom) | [device\_action\_execute](Plugin-Hook-API-Ref.md#device_action_execute) | [device\_action\_prepare](Plugin-Hook-API-Ref.md#device_action_prepare)
[device\_display\_text](Plugin-Hook-API-Ref.md#device_display_text) | [device\_edit\_pre\_bottom](Plugin-Hook-API-Ref.md#device_edit_pre_bottom) | [device\_edit\_top\_links](Plugin-Hook-API-Ref.md#device_edit_top_links)
[device\_filter\_end](Plugin-Hook-API-Ref.md#device_filter_end) | [device\_filter\_start](Plugin-Hook-API-Ref.md#device_filter_start) | [device\_filters](Plugin-Hook-API-Ref.md#device_filters)
[device\_remove](Plugin-Hook-API-Ref.md#device_remove) | [device\_sql\_where](Plugin-Hook-API-Ref.md#device_sql_where) | [device\_table\_bottom](Plugin-Hook-API-Ref.md#device_table_bottom)
[device\_table\_replace](Plugin-Hook-API-Ref.md#device_table_replace) | [device\_template\_edit](Plugin-Hook-API-Ref.md#device_template_edit) | [device\_template\_top](Plugin-Hook-API-Ref.md#device_template_top)
[draw\_navigation\_text](Plugin-Hook-API-Ref.md#draw_navigation_text) | [export\_action](Plugin-Hook-API-Ref.md#export_action) | [fgc\_contextoption](Plugin-Hook-API-Ref.md#fgc_contextoption)
[get\_friendly\_name](Plugin-Hook-API-Ref.md#get_friendly_name) | [global\_settings\_update](Plugin-Hook-API-Ref.md#global_settings_update) | [graph](Plugin-Hook-API-Ref.md#graph)
[graph\_buttons](Plugin-Hook-API-Ref.md#graph_buttons) | [graph\_edit\_after](Plugin-Hook-API-Ref.md#graph_edit_after) | [graph\_image](Plugin-Hook-API-Ref.md#graph_image)
[graph\_items\_remove](Plugin-Hook-API-Ref.md#graph_items_remove) | [graph\_tree\_page\_buttons](Plugin-Hook-API-Ref.md#graph_tree_page_buttons) | [graphs\_action\_array](Plugin-Hook-API-Ref.md#graphs_action_array)
[graphs\_action\_bottom](Plugin-Hook-API-Ref.md#graphs_action_bottom) | [graphs\_action\_execute](Plugin-Hook-API-Ref.md#graphs_action_execute) | [graphs\_action\_prepare](Plugin-Hook-API-Ref.md#graphs_action_prepare)
[graphs\_item\_array](Plugin-Hook-API-Ref.md#graphs_item_array) | [graphs\_new\_top\_links](Plugin-Hook-API-Ref.md#graphs_new_top_links) | [graphs\_remove](Plugin-Hook-API-Ref.md#graphs_remove)
[graphs\_sql\_where](Plugin-Hook-API-Ref.md#graphs_sql_where) | [hmib\_get\_cpu](Plugin-Hook-API-Ref.md#hmib_get_cpu) | [hmib\_get\_cpu\_indexes](Plugin-Hook-API-Ref.md#hmib_get_cpu_indexes)
[hmib\_get\_disk](Plugin-Hook-API-Ref.md#hmib_get_disk) | [host\_edit\_bottom](Plugin-Hook-API-Ref.md#host_edit_bottom) | [host\_edit\_top](Plugin-Hook-API-Ref.md#host_edit_top)
[host\_save](Plugin-Hook-API-Ref.md#host_save) | [import\_action](Plugin-Hook-API-Ref.md#import_action) | [is\_console\_page](Plugin-Hook-API-Ref.md#is_console_page)
[login\_after](Plugin-Hook-API-Ref.md#login_after) | [login\_before](Plugin-Hook-API-Ref.md#login_before) | [login\_options\_navigate](Plugin-Hook-API-Ref.md#login_options_navigate)
[login\_process](Plugin-Hook-API-Ref.md#login_process) | [login\_realms](Plugin-Hook-API-Ref.md#login_realms) | [login\_title](Plugin-Hook-API-Ref.md#login_title)
[logout\_post\_session\_destroy](Plugin-Hook-API-Ref.md#logout_post_session_destroy) | [logout\_pre\_session\_destroy](Plugin-Hook-API-Ref.md#logout_pre_session_destroy) | [nav\_login\_after](Plugin-Hook-API-Ref.md#nav_login_after)
[nav\_login\_before](Plugin-Hook-API-Ref.md#nav_login_before) | [page\_bottom](Plugin-Hook-API-Ref.md#page_bottom) | [page\_buttons](Plugin-Hook-API-Ref.md#page_buttons)
[page\_head](Plugin-Hook-API-Ref.md#page_head) | [page\_title](Plugin-Hook-API-Ref.md#page_title) | [poller\_bottom](Plugin-Hook-API-Ref.md#poller_bottom)
[poller\_command\_args](Plugin-Hook-API-Ref.md#poller_command_args) | [poller\_exiting](Plugin-Hook-API-Ref.md#poller_exiting) | [poller\_finishing](Plugin-Hook-API-Ref.md#poller_finishing)
[poller\_output](Plugin-Hook-API-Ref.md#poller_output) | [poller\_top](Plugin-Hook-API-Ref.md#poller_top) | [remote\_agent](Plugin-Hook-API-Ref.md#remote_agent)
[replicate\_in](Plugin-Hook-API-Ref.md#replicate_in) | [replicate\_out](Plugin-Hook-API-Ref.md#replicate_out) | [report\_filters](Plugin-Hook-API-Ref.md#report_filters)
[resolve\_dependencies](Plugin-Hook-API-Ref.md#resolve_dependencies) | [rrd\_graph\_graph\_options](Plugin-Hook-API-Ref.md#rrd_graph_graph_options) | [run\_data\_query](Plugin-Hook-API-Ref.md#run_data_query)
[snmpagent\_cache\_install](Plugin-Hook-API-Ref.md#snmpagent_cache_install) | [substitute\_host\_data](Plugin-Hook-API-Ref.md#substitute_host_data) | [top\_graph\_header](Plugin-Hook-API-Ref.md#top_graph_header)
[top\_graph\_header\_tabs](Plugin-Hook-API-Ref.md#top_graph_header_tabs) | [top\_graph\_jquery\_function](Plugin-Hook-API-Ref.md#top_graph_jquery_function) | [top\_graph\_refresh](Plugin-Hook-API-Ref.md#top_graph_refresh)
[top\_header](Plugin-Hook-API-Ref.md#top_header) | [tree\_after](Plugin-Hook-API-Ref.md#tree_after) | [tree\_view\_page\_end](Plugin-Hook-API-Ref.md#tree_view_page_end)
[ugroup\_tabs](Plugin-Hook-API-Ref.md#ugroup_tabs) | [update\_data\_source\_title\_cache](Plugin-Hook-API-Ref.md#update_data_source_title_cache) | [user\_admin\_action](Plugin-Hook-API-Ref.md#user_admin_action)
[user\_admin\_edit](Plugin-Hook-API-Ref.md#user_admin_edit) | [user\_admin\_run\_action](Plugin-Hook-API-Ref.md#user_admin_run_action) | [user\_admin\_setup\_sql\_save](Plugin-Hook-API-Ref.md#user_admin_setup_sql_save)
[user\_admin\_tab](Plugin-Hook-API-Ref.md#user_admin_tab) | [user\_admin\_user\_save](Plugin-Hook-API-Ref.md#user_admin_user_save) | [user\_group\_admin\_action](Plugin-Hook-API-Ref.md#user_group_admin_action)
[user\_group\_admin\_edit](Plugin-Hook-API-Ref.md#user_group_admin_edit) | [user\_group\_admin\_save](Plugin-Hook-API-Ref.md#user_group_admin_save) | [user\_group\_admin\_setup\_sql\_save](Plugin-Hook-API-Ref.md#user_group_admin_setup_sql_save)
[user\_remove](Plugin-Hook-API-Ref.md#user_remove) | [utilities\_action](Plugin-Hook-API-Ref.md#utilities_action) | [utilities\_array](Plugin-Hook-API-Ref.md#utilities_array)
[utilities\_list](Plugin-Hook-API-Ref.md#utilities_list) | [utilities\_tab](Plugin-Hook-API-Ref.md#utilities_tab) | [valid\_host\_fields](Plugin-Hook-API-Ref.md#valid_host_fields)

## add\_graph\_template\_to\_host

Allows you to perform additional operations when adding a graph template to
host. The parameters passed are `host_id` and `graph_template_id`.

file | introduced | retired
--- | :--- | :---
cli/add_graph_template.php |  1.0.0  |
cli/host_update_template.php |  1.0.0  |
host.php |  1.0.0  |
lib/api_device.php |  1.0.0  |

## api\_device\_new

This hooks allows you to perform additional operation at the end of
api_device_save function. Unlike the api_device_save hook, the device ID is
already defined here.

file | introduced | retired
--- | :--- | :---
lib/api_device.php |  1.0.0  |

## api\_device\_save

This hook allows you to perform additional operation at the end of
api_device_save function. Unlike the api_device_new hook, the device ID is might
not be defined here.

This hook allows you to alter the contents to the device table with custom
fields. When used properly, it allows you to extend the host table with your
plugins custom fields.

file | introduced | retired
--- | :--- | :---
lib/api_device.php |  1.0.0  |

## auth\_alternate\_realms

This hook allows you to handle user login check alternate plugin defined
authentication realms.

file | introduced | retired
--- | :--- | :---
include/auth.php |  1.0.0  |

## auth\_profile\_reset

Allows you to reset plugins all user settings

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.0-beta3  |

## auth\_profile\_reset\_value

Allows you to reset plugins single user settings

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.0-beta3  |

## auth\_profile\_run\_action

Allows you to draw plugins user settings form

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.0-beta3  |

## auth\_profile\_save

Allows you to save plugins all user settings

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.0-beta3  |

## auth\_profile\_tabs

Allows you to draw plugins user setting tabs

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.0-beta3  |

## auth\_profile\_update\_data

Allows you to update plugins single user setting

file | introduced | retired
--- | :--- | :---
auth_profile.php |  1.2.4  |

## boost\_poller\_bottom

file | introduced | retired
--- | :--- | :---
poller_boost.php |  1.0.0  |

## bottom\_footer

Allows you to override the rendering of the bottom_footer html snippet.

file | introduced | retired
--- | :--- | :---
include/bottom_footer.php |  0.8.7i |  1.1.38

## cacti\_stats\_update

file | introduced | retired
--- | :--- | :---
poller.php |  1.0.0  |

## change\_password\_title

file | introduced | retired
--- | :--- | :---
auth_changepassword.php |  1.2.0-beta1  |

## clog\_regex\_array

Allows you to enhance the Logs display with additional information or links.

file | introduced | retired
--- | :--- | :---
lib/clog_webapi.php |  1.1.34  |

## config\_arrays

Allows your plug-in to define custom array elements to be used throughout cacti.
Things like dropdown arrays and the like.

file | introduced | retired
--- | :--- | :---
include/global_arrays.php |  1.0.0  |

## config\_form

Allows you to define form object to represent data to be stored in your tables.
In the case of MacTrack, there is a table called `mac_track_sites` and in order
to drive the UI and allow for the user to provide input and save a site, you
must provide the Cacti form engine a form array to allow for the form to be
presented and contents to be saved.

file | introduced | retired
--- | :--- | :---
include/global_form.php |  1.0.0  |

## config\_insert

This is a general purpose hook used for connecting to other database, or
sourcing common includes that would otherwise not be sourced.

file | introduced | retired
--- | :--- | :---
include/global.php |  1.0.0  |

## config\_settings

Allows you to extend the Cacti settings page to allow for custom tabs and global
settings within them.

file | introduced | retired
--- | :--- | :---
include/global_settings.php |  1.0.0  |

## console\_after

Allows you to add text after the default message on the console page

file | introduced | retired
--- | :--- | :---
index.php |  1.0.0  |

## console\_before

Allows you to add text before the default message on the console page. For
instance, the Update plug-in will display a message here if there are new
versions of plugins.

file | introduced | retired
--- | :--- | :---
index.php |  1.0.0  |

## copy\_user

Allows a plugin to take part in the Copy User actions.  This is important a
plugin maintains user settings.

file | introduced | retired
--- | :--- | :---
lib/auth.php |  1.0.0  |

## create\_complete\_graph\_from\_template

Allows you to perform additional operations when adding new graph to device from
graph template.

file | introduced | retired
--- | :--- | :---
lib/template.php |  1.0.0  |

## custom\_denied

Allows you to override the rendering of the permission denied interface.

file | introduced | retired
--- | :--- | :---
permission_denied.php |  1.2.2  |
auth_login.php |  1.2.12  |

## custom\_login

Allows you to override the rendering of the auth_login.php page.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## custom\_logout\_message

Allows you to override the rendering of the logout.php page.

file | introduced | retired
--- | :--- | :---
logout.php |  1.0.0  |

## custom\_password

Allows you to override the rendering of the auth_changepassword.php page.

file | introduced | retired
--- | :--- | :---
auth_changepassword.php |  1.0.0  |

## custom\_version\_info

Allows your plugin to display additional information on the cacti tech support
page.

file | introduced | retired
--- | :--- | :---
utilities.php |  1.0.0  |

## data\_input\_sql\_where

file | introduced | retired
--- | :--- | :---
data_input.php |  1.0.0  |

## data\_source\_action\_array

Allows you to define custom dropdown actions from within the data sources page.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_action\_bottom

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_action\_execute

Allows you to define custom actions to be taken upon you dropdown selection.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_action\_prepare

This is the final component to creating a custom action within the data sources.
In Cacti's form engine, you must provide the dropdown action and then two
follow-up actions to complete the cycle. This is were you actually save the
data.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_edit\_bottom

Allows you to make minor change to the Data Sources page, like add a tabbed
interface.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_edit\_top

Allows you to make minor changes to the Data Sources page, like add a tabbed
interface.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## data\_source\_remove

This hook is called when the data sources used by a graph are removed. The
parameters are the graphs data sources.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |  1.1.38
graphs.php |  1.0.0  |  1.1.38
host.php |  1.0.0  |  1.1.38
lib/api_data_source.php |  1.2.0-beta1  |

## data\_source\_to\_poller\_items

file | introduced | retired
--- | :--- | :---
lib/utility.php |  1.0.0  |

## data\_sources\_table

Allows you to change the data displayed on the Data Sources table. THold uses
this to create a link to that datasources threshold

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## device\_action\_array

Allows you to define custom dropdown actions from within the device/host page.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_action\_bottom

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_action\_execute

Allows you to define custom actions to be taken upon you dropdown selection.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_action\_prepare

This is the final component to creating a custom action within the devices. In
Cacti's form engine, you must provide the dropdown action and then two follow-up
actions to complete the cycle. This is were you actually save the data.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_display\_text

This hook allows you to add custom columns header to the host list page

file | introduced | retired
--- | :--- | :---
host.php |  1.3.0 - Dev  |

## device\_edit\_pre\_bottom

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_edit\_top\_links

This hook allows you to add custom actions to the host edit page, below the
"Create graphs for this Host".

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_filter\_end

This hook allows you to add custom filter fields before Cacti buildin filter to
the host list page

file | introduced | retired
--- | :--- | :---
host.php |  1.3.0 - Dev  |

## device\_filter\_start

This hook allows you to add custom filter fields after Cacti buildin filter to
the host list page

file | introduced | retired
--- | :--- | :---
host.php |  1.3.0 - Dev  |

## device\_filters

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_remove

This hook allows you to perform additional actions on devices that have been
selected for deletion. The parameter is an array of deleted device IDs. Note
that at this point, the devices are already deleted from the host table.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |  1.1.38
lib/api_device.php |  1.2.0-beta1  |

## device\_sql\_where

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_table\_bottom

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## device\_table\_replace

Allows you to override the rendering of the host list page

file | introduced | retired
--- | :--- | :---
host.php |  1.3.0 - Dev |

## device\_template\_edit

file | introduced | retired
--- | :--- | :---
host_templates.php |  1.0.0  |

## device\_template\_top

file | introduced | retired
--- | :--- | :---
host_templates.php |  1.0.0  |

## draw\_navigation\_text

Just below the Cacti "Console", and "Graphs" tabs, cacti provides a Navigation
bar that allows you to move backward in a selection tree. Although it is not
foolproof, this hook allows you to populate and navigate that tree.

file | introduced | retired
--- | :--- | :---
lib/functions.php |  1.0.0  |

## export\_action

file | introduced | retired
--- | :--- | :---
lib/export.php |  1.2.0-beta1  |

## fgc\_contextoption

file | introduced | retired
--- | :--- | :---
lib/functions.php |  1.1.28  |

## get\_friendly\_name

file | introduced | retired
--- | :--- | :---
lib/import.php |  1.2.0-beta1  |

## global\_settings\_update

file | introduced | retired
--- | :--- | :---
settings.php |  1.0.0  |

## graph

This hook is called at the top of graph.php page

file | introduced | retired
--- | :--- | :---
graph.php |  1.0.0  |

## graph\_buttons

You know about the zoom button right? Well this allows you to add any additional
custom button to the right of a graph.

file | introduced | retired
--- | :--- | :---
graph.php |  1.0.0  |

## graph\_edit\_after

file | introduced | retired
--- | :--- | :---
graphs.php |  1.2.0-beta1  |

## graph\_image

This hooks allows displaying of alternative graphics in place of a graph image.
This hook can no output text, only modify the image, as it is only called when a
graph is required to be outputted.

file | introduced | retired
--- | :--- | :---
graph_image.php |  1.0.0  |
graph_json.php |  1.0.0  |

## graph\_items\_remove

This hook is called when when the data source is deleted, and the option to
remove all graph items tied to the data source is selected.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |

## graph\_tree\_page\_buttons

Allows you to add custom HTML to the graph tree view page, under the timespan
presets and the graph search box.

file | introduced | retired
--- | :--- | :---
lib/html_tree.php |  0.8.7i  |

## graphs\_action\_array

Similar to the host actions and host, prepare and execute hooks. It allows you
to have custom dropdown actions within the graph management interface.

file | introduced | retired
--- | :--- | :---
graphs.php |  1.0.0  |

## graphs\_action\_bottom

file | introduced | retired
--- | :--- | :---
graphs.php |  1.0.0  |

## graphs\_action\_execute

file | introduced | retired
--- | :--- | :---
graphs.php |  1.0.0  |

## graphs\_action\_prepare

file | introduced | retired
--- | :--- | :---
graphs.php |  1.0.0  |

## graphs\_item\_array

file | introduced | retired
--- | :--- | :---
graphs.php |  1.2.0-beta1  |

## graphs\_new\_top\_links

Add a link at the top of the "Create New Graphs" page.

file | introduced | retired
--- | :--- | :---
graphs_new.php |  1.0.0  |

## graphs\_remove

This hook is called after one or more graphs are removed. The parameters are the
removed graph IDs.

file | introduced | retired
--- | :--- | :---
data_sources.php |  1.0.0  |  1.1.38
graphs.php |  1.0.0  |  1.1.38
host.php |  1.0.0  |  1.1.38
lib/api_graph.php |  1.2.0-beta1  |

## graphs\_sql\_where

This hooks allows you to add additional where clauses to the select statement
used to display graphs on the graphs.php page.

file | introduced | retired
--- | :--- | :---
graphs.php |  1.0.0  |

## hmib\_get\_cpu

file | introduced | retired
--- | :--- | :---
scripts/ss_host_cpu.php |  1.0.0  |

## hmib\_get\_cpu\_indexes

file | introduced | retired
--- | :--- | :---
scripts/ss_host_cpu.php |  1.0.0  |

## hmib\_get\_disk

file | introduced | retired
--- | :--- | :---
scripts/ss_host_disk.php |  1.0.0  |

## host\_edit\_bottom

Allows you to make minor changes to the Devices page, like add a tabbed
interface.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## host\_edit\_top

Allows you to make minor changes to the Devices page, like add a tabbed
interface.

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## host\_save

file | introduced | retired
--- | :--- | :---
host.php |  1.0.0  |

## import\_action

file | introduced | retired
--- | :--- | :---
lib/import.php |  1.2.0-beta1  |

## is\_console\_page

file | introduced | retired
--- | :--- | :---
lib/html.php |  1.0.0  |

## login\_after

This allows you to display text or html after the login form.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## login\_before

This allows you to display text or html before the login form. Combined with the
above hook, you could draw a box, etc around the form, change its background
color, etc to slightly customize the login page.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## login\_options\_navigate

Used to support alternate login realm types.

file | introduced | retired
--- | :--- | :---
auth_changepassword.php |  1.0.0  |
auth_login.php |  1.0.0  |

## login\_process

Used to authenticate the user logging in to a custom plugin defined realm.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## login\_realms

Used to defined additional custom plugin defined authentication realms. The
parameter passed is an array of existing authentication realms.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## login\_title

Allows the plugin to set/modify that page title.

file | introduced | retired
--- | :--- | :---
auth_login.php |  1.0.0  |

## logout\_post\_session\_destroy

This pair of hooks (`logout_pre_session_destroy` and
`logout_post_session_destroy`) allows you to preserve some session variables
that would otherwise get unset, when `session_destroy()` is called.

file | introduced | retired
--- | :--- | :---
logout.php |  1.0.0  |

## logout\_pre\_session\_destroy

This pair of hooks (`logout_pre_session_destroy` and
`logout_post_session_destroy`) allows you to preserve some session variables
that would otherwise get unset, when `session_destroy()` is called.

file | introduced | retired
--- | :--- | :---
logout.php |  1.0.0  |

## nav\_login\_after

This pair of hooks (`nav_login_before` and `nav_login_after`) allows you to add
custom HTML to the navigation bar, before and after the "Logged in as " text.

file | introduced | retired
--- | :--- | :---
lib/functions.php |  1.0.0  |

## nav\_login\_before

This pair of hooks (`nav_login_before` and `nav_login_after`) allows you to add
custom HTML to the navigation bar, before and after the "Logged in as " text.

file | introduced | retired
--- | :--- | :---
lib/functions.php |  1.0.0  |

## page\_bottom

This hook allows you to add custom HTML to the bottom of the page, after the
main layout table.

file | introduced | retired
--- | :--- | :---
include/bottom_footer.php |  1.0.0  |

## page\_buttons

Allows you to add custom buttons and HTML to the top of the graph.php page,
above the "Viewing graph" row.

file | introduced | retired
--- | :--- | :---
graph.php |  1.0.0  |

## page\_head

This hook allows you to add custom HTML tags to the page <head> tag.

file | introduced | retired
--- | :--- | :---
graph_realtime.php |  1.0.0  |  1.1.33
include/top_general_header.php |  1.0.0  |  1.1.33
include/top_graph_header.php |  1.0.0  |  1.1.33
include/top_header.php |  1.0.0  |  1.1.33
lib/html.php |  1.1.34  |

## page\_title

Allows the plugin to set/modify the page title

file | introduced | retired
--- | :--- | :---
include/top_general_header.php |  1.0.0  |
include/top_graph_header.php |  1.0.0  |
include/top_header.php |  1.0.0  |

## poller\_bottom

This hook allows you to launch other polling activities once Cacti has complete
it's polling activities. Things like MacTrack, Boost, THold, and others use this
hook to launch their respective poller.

file | introduced | retired
--- | :--- | :---
poller.php |  1.0.0  |

## poller\_command\_args

Using this hook, your plugin can pass additional command line arguments to the
poller.

file | introduced | retired
--- | :--- | :---
poller.php |  0.8.7i  | 1.2.8

## poller\_exiting

file | introduced | retired
--- | :--- | :---
poller.php |  1.0.0  |

## poller\_finishing

file | introduced | retired
--- | :--- | :---
poller.php |  1.0.0  |

## poller\_output

This hook was designed specifically for the boost plug-in. However, it has found
new life in many plugins making them much faster now. What this hook allows you
to do is intercept the contents of the `poller_output` table before the data is
deleted. This allows for things like threshold checking and other interesting
actions such as checking for up/down events and the like. Previously, plugins
were reliant on using things like `rrdtool fetch` to perform these actions. Now
they can leverage the pollers output directly.

file | introduced | retired
--- | :--- | :---
lib/poller.php |  1.0.0  |

## poller\_top

This hook allows you to launch processes concurrently with the Cacti poller for
things like THolds fast poller for example.

file | introduced | retired
--- | :--- | :---
poller.php |  1.0.0  |

## remote\_agent

file | introduced | retired
--- | :--- | :---
remote_agent.php |  1.0.0  |

## replicate\_in

file | introduced | retired
--- | :--- | :---
lib/poller.php |  1.0.0  |

## replicate\_out

file | introduced | retired
--- | :--- | :---
lib/api_device.php |    |
lib/poller.php |  1.0.0  |

## resolve\_dependencies

file | introduced | retired
--- | :--- | :---
lib/export.php |  1.2.0-beta1  |

## rrd\_graph\_graph\_options

This hook allows you to specify additional options or change parameters
regarding graph image rendering. Some of the parameters will be passed to
RRDtool.

file | introduced | retired
--- | :--- | :---
lib/rrd.php |  1.0.0  |

## run\_data\_query

This hook allows your plugin to perform additional operations after a data query
update was triggered.

file | introduced | retired
--- | :--- | :---
lib/data_query.php |  1.0.0  |

## snmpagent\_cache\_install

file | introduced | retired
--- | :--- | :---
lib/snmpagent.php |  1.0.0  |

## substitute\_host\_data

This allows you to add to the substitution variables that cacti can parse.

file | introduced | retired
--- | :--- | :---
lib/variables.php |  1.0.0  |  1.1.5

## top\_graph\_header

Allows you to override the rendering of the top_graph_header.php include.

file | introduced | retired
--- | :--- | :---
include/top_graph_header.php |  0.8.7i  |  1.1.38

## top\_graph\_header\_tabs

This hook is used to add tab's to Cacti's user interface.

file | introduced | retired
--- | :--- | :---
lib/html.php |  1.0.0  |

## top\_graph\_jquery\_function

file | introduced | retired
--- | :--- | :---
lib/html_tree.php |  1.0.0  |

## top\_graph\_refresh

This allows you to change the refresh on the graph (and any plug-in page that
calls the graph header)

file | introduced | retired
--- | :--- | :---
include/global_session.php |  1.0.0  |
include/themes/sunrise/global_session.php |  1.1.11  |  1.1.38

## top\_header

This hooks enables you to output custom HTML on top the the graph view page, if
navigation tabs are not rendered. Allows you to override the rendering of the
top_header.php include.

file | introduced | retired
--- | :--- | :---
include/top_general_header.php |  1.0.0  |  1.1.38
include/top_header.php |  0.8.7i  |  1.1.38

## tree\_after

This hook allows you to add additional HTML at the bottom of the graph tree view
page. The HTML is rendered only if a valid graph tree leaf is selected.

file | introduced | retired
--- | :--- | :---
lib/html_tree.php |  1.0.0  |

## tree\_view\_page\_end

This hook allows you to add additional HTML at the bottom of the graph tree view
page, irrespective of the leaf selection.

file | introduced | retired
--- | :--- | :---
graph.php |  1.0.0  |
lib/html_tree.php |  1.0.0  |

## ugroup\_tabs

file | introduced | retired
--- | :--- | :---
user_group_admin.php |  1.0.0  |

## update\_data\_source\_title\_cache

This hook is called after the data source title cache is updated.

file | introduced | retired
--- | :--- | :---
lib/variables.php |  1.0.0  |

## user\_admin\_action

This hook is part of a series of hooks that allow you to add custom user
settings. Consider a plug-in called "abc". In that plug-in, you want to save
custom settings on a per user basis. Therefore, following our unpublished ?
table naming standards, you would create a table called "abc_settings". When you
tab over to the "abc" plug-in, you are provided an "abc settings" on the right
similar to "Graphs". The next series of hooks allow you to present those
settings to the user, enable or disable the users access to that specific "abc
settings" tab and allow an administrator to define customer values for that
plug-in on a per user basis.

file | introduced | retired
--- | :--- | :---
user_admin.php |  1.0.0  |

## user\_admin\_edit

See the explanation on `user_admin_action`

file | introduced | retired
--- | :--- | :---
user_admin.php |  1.0.0  |

## user\_admin\_run\_action

See the explanation on `user_admin_action`

file | introduced | retired
--- | :--- | :---
user_admin.php |  1.0.0  |

## user\_admin\_setup\_sql\_save

See the explanation on `user_admin_action`

file | introduced | retired
--- | :--- | :---
user_admin.php |  1.0.0  |

## user\_admin\_tab

See the explanation on `user_admin_action`

file | introduced | retired
--- | :--- | :---
user_admin.php |  0.8.7i  |
utilities.php |  1.0.0  | 1.2.0-beta3

## user\_admin\_user\_save

See the explanation on `user_admin_action`

file | introduced | retired
--- | :--- | :---
user_admin.php |  1.0.0  |

## user\_group\_admin\_action

file | introduced | retired
--- | :--- | :---
user_group_admin.php |  1.0.0  |

## user\_group\_admin\_edit

file | introduced | retired
--- | :--- | :---
user_group_admin.php |  1.0.0  |

## user\_group\_admin\_save

file | introduced | retired
--- | :--- | :---
user_group_admin.php |  1.0.0  |

## user\_group\_admin\_setup\_sql\_save

file | introduced | retired
--- | :--- | :---
user_group_admin.php |  1.0.0  |

## user\_remove

Allows the plugin to take part in the user removal process.  Important when the
plugin maintains user settings.

file | introduced | retired
--- | :--- | :---
lib/auth.php |  1.0.0  |
user_admin.php |  1.0.0  |

## utilities\_action

This hook set's up the function to be executed from within Cacti's utilities
section.

file | introduced | retired
--- | :--- | :---
utilities.php |  1.0.0  |

## utilities\_array

file | introduced | retired
--- | :--- | :---
utilities.php |  1.0.4  |

## utilities\_list

This hook allows you to add a custom utilities pick under Cacti's "Utilities"
page.

file | introduced | retired
--- | :--- | :---
utilities.php |  1.0.0  |

## utilities\_tab

This hook allows you to add a custom utilities tab under Cacti's "Utilities"
page.

file | introduced | retired
--- | :--- | :---
utilities.php |  1.2.0-beta3  |

## valid\_host\_fields

Allows your plugin to define additional variables that will be used in
substitute_host_data.

Pretty sure that this hook allows you to define custom replacement values in
graphs.

file | introduced | retired
--- | :--- | :---
include/global_form.php |  1.0.0  |

---
Copyright (c) 2004-2021 The Cacti Group
