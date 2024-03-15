# Plugin Hook API Reference

The following table shows all known Cacti plugin hooks and a brief description
of their function.

| hook                                                                                      | hook                                                                                              | hook                                                                                    |
| ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| [add_graph_template_to_host](Plugin-Hook-API-Ref.md#add_graph_template_to_host)           | [api_device_new](Plugin-Hook-API-Ref.md#api_device_new)                                           | [api_device_save](Plugin-Hook-API-Ref.md#api_device_save)                               |
| [auth_alternate_realms](Plugin-Hook-API-Ref.md#auth_alternate_realms)                     | [auth_profile_reset](Plugin-Hook-API-Ref.md#auth_profile_reset)                                   | [auth_profile_reset_value](Plugin-Hook-API-Ref.md#auth_profile_reset_value)             |
| [auth_profile_run_action](Plugin-Hook-API-Ref.md#auth_profile_run_action)                 | [auth_profile_save](Plugin-Hook-API-Ref.md#auth_profile_save)                                     | [auth_profile_tabs](Plugin-Hook-API-Ref.md#auth_profile_tabs)                           |
| [auth_profile_update_data](Plugin-Hook-API-Ref.md#auth_profile_update_data)               | [boost_poller_bottom](Plugin-Hook-API-Ref.md#boost_poller_bottom)                                 | [bottom_footer](Plugin-Hook-API-Ref.md#bottom_footer)                                   |
| [cacti_stats_update](Plugin-Hook-API-Ref.md#cacti_stats_update)                           | [change_password_title](Plugin-Hook-API-Ref.md#change_password_title)                             | [clog_regex_array](Plugin-Hook-API-Ref.md#clog_regex_array)                             |
| [config_arrays](Plugin-Hook-API-Ref.md#config_arrays)                                     | [config_form](Plugin-Hook-API-Ref.md#config_form)                                                 | [config_insert](Plugin-Hook-API-Ref.md#config_insert)                                   |
| [config_settings](Plugin-Hook-API-Ref.md#config_settings)                                 | [console_after](Plugin-Hook-API-Ref.md#console_after)                                             | [console_before](Plugin-Hook-API-Ref.md#console_before)                                 |
| [copy_user](Plugin-Hook-API-Ref.md#copy_user)                                             | [create_complete_graph_from_template](Plugin-Hook-API-Ref.md#create_complete_graph_from_template) | [custom_denied](Plugin-Hook-API-Ref.md#custom_denied)                                   |
| [custom_login](Plugin-Hook-API-Ref.md#custom_login)                                       | [custom_logout_message](Plugin-Hook-API-Ref.md#custom_logout_message)                             | [custom_password](Plugin-Hook-API-Ref.md#custom_password)                               |
| [custom_version_info](Plugin-Hook-API-Ref.md#custom_version_info)                         | [data_input_sql_where](Plugin-Hook-API-Ref.md#data_input_sql_where)                               | [data_source_action_array](Plugin-Hook-API-Ref.md#data_source_action_array)             |
| [data_source_action_bottom](Plugin-Hook-API-Ref.md#data_source_action_bottom)             | [data_source_action_execute](Plugin-Hook-API-Ref.md#data_source_action_execute)                   | [data_source_action_prepare](Plugin-Hook-API-Ref.md#data_source_action_prepare)         |
| [data_source_edit_bottom](Plugin-Hook-API-Ref.md#data_source_edit_bottom)                 | [data_source_edit_top](Plugin-Hook-API-Ref.md#data_source_edit_top)                               | [data_source_remove](Plugin-Hook-API-Ref.md#data_source_remove)                         |
| [data_source_to_poller_items](Plugin-Hook-API-Ref.md#data_source_to_poller_items)         | [data_sources_table](Plugin-Hook-API-Ref.md#data_sources_table)                                   | [device_action_array](Plugin-Hook-API-Ref.md#device_action_array)                       |
| [device_action_bottom](Plugin-Hook-API-Ref.md#device_action_bottom)                       | [device_action_execute](Plugin-Hook-API-Ref.md#device_action_execute)                             | [device_action_prepare](Plugin-Hook-API-Ref.md#device_action_prepare)                   |
| [device_display_text](Plugin-Hook-API-Ref.md#device_display_text)                         | [device_edit_pre_bottom](Plugin-Hook-API-Ref.md#device_edit_pre_bottom)                           | [device_edit_top_links](Plugin-Hook-API-Ref.md#device_edit_top_links)                   |
| [device_filter_end](Plugin-Hook-API-Ref.md#device_filter_end)                             | [device_filter_start](Plugin-Hook-API-Ref.md#device_filter_start)                                 | [device_filters](Plugin-Hook-API-Ref.md#device_filters)                                 |
| [device_remove](Plugin-Hook-API-Ref.md#device_remove)                                     | [device_sql_where](Plugin-Hook-API-Ref.md#device_sql_where)                                       | [device_table_bottom](Plugin-Hook-API-Ref.md#device_table_bottom)                       |
| [device_table_replace](Plugin-Hook-API-Ref.md#device_table_replace)                       | [device_template_change](Plugin-Hook-API-Ref.md#device_template_change)                           | [device_template_edit](Plugin-Hook-API-Ref.md#device_template_edit)                     | 
| [device_template_top](Plugin-Hook-API-Ref.md#device_template_top)                         | [draw_navigation_text](Plugin-Hook-API-Ref.md#draw_navigation_text)                               | [export_action](Plugin-Hook-API-Ref.md#export_action)                                   | 
| [fgc_contextoption](Plugin-Hook-API-Ref.md#fgc_contextoption)                             | [get_friendly_name](Plugin-Hook-API-Ref.md#get_friendly_name)                                     | [global_settings_update](Plugin-Hook-API-Ref.md#global_settings_update)                 | 
| [graph](Plugin-Hook-API-Ref.md#graph)                                                     | [graph_buttons](Plugin-Hook-API-Ref.md#graph_buttons)                                             | [graph_edit_after](Plugin-Hook-API-Ref.md#graph_edit_after)                             | 
| [graph_image](Plugin-Hook-API-Ref.md#graph_image)                                         | [graph_items_remove](Plugin-Hook-API-Ref.md#graph_items_remove)                                   | [graph_tree_page_buttons](Plugin-Hook-API-Ref.md#graph_tree_page_buttons)                         |
| [graphs_action_array](Plugin-Hook-API-Ref.md#graphs_action_array)                         | [graphs_action_bottom](Plugin-Hook-API-Ref.md#graphs_action_bottom)                               | [graphs_action_execute](Plugin-Hook-API-Ref.md#graphs_action_execute)                             |
| [graphs_action_prepare](Plugin-Hook-API-Ref.md#graphs_action_prepare)                     | [graphs_item_array](Plugin-Hook-API-Ref.md#graphs_item_array)                                     | [graphs_new_top_links](Plugin-Hook-API-Ref.md#graphs_new_top_links)                               |
| [graphs_remove](Plugin-Hook-API-Ref.md#graphs_remove)                                     | [graphs_sql_where](Plugin-Hook-API-Ref.md#graphs_sql_where)                                       | [hmib_get_cpu](Plugin-Hook-API-Ref.md#hmib_get_cpu)                                               |
| [hmib_get_cpu_indexes](Plugin-Hook-API-Ref.md#hmib_get_cpu_indexes)                       | [hmib_get_disk](Plugin-Hook-API-Ref.md#hmib_get_disk)                                             | [host_edit_bottom](Plugin-Hook-API-Ref.md#host_edit_bottom)                                       |
| [host_edit_top](Plugin-Hook-API-Ref.md#host_edit_top)                                     | [host_save](Plugin-Hook-API-Ref.md#host_save)                                                     | [import_action](Plugin-Hook-API-Ref.md#import_action)                                             |
| [is_console_page](Plugin-Hook-API-Ref.md#is_console_page)                                 | [login_after](Plugin-Hook-API-Ref.md#login_after)                                                 | [login_before](Plugin-Hook-API-Ref.md#login_before)                                               |
| [login_options_navigate](Plugin-Hook-API-Ref.md#login_options_navigate)                   | [login_process](Plugin-Hook-API-Ref.md#login_process)                                             | [login_realms](Plugin-Hook-API-Ref.md#login_realms)                                               |
| [login_title](Plugin-Hook-API-Ref.md#login_title)                                         | [logout_post_session_destroy](Plugin-Hook-API-Ref.md#logout_post_session_destroy)                 | [logout_pre_session_destroy](Plugin-Hook-API-Ref.md#logout_pre_session_destroy)                   |
| [nav_login_after](Plugin-Hook-API-Ref.md#nav_login_after)                                 | [nav_login_before](Plugin-Hook-API-Ref.md#nav_login_before)                                       | [page_bottom](Plugin-Hook-API-Ref.md#page_bottom)                                                 |
| [page_buttons](Plugin-Hook-API-Ref.md#page_buttons)                                       | [page_head](Plugin-Hook-API-Ref.md#page_head)                                                     | [page_title](Plugin-Hook-API-Ref.md#page_title)                                                   |
| [poller_bottom](Plugin-Hook-API-Ref.md#poller_bottom)                                     | [poller_command_args](Plugin-Hook-API-Ref.md#poller_command_args)                                 | [poller_exiting](Plugin-Hook-API-Ref.md#poller_exiting)                                           |
| [poller_finishing](Plugin-Hook-API-Ref.md#poller_finishing)                               | [poller_output](Plugin-Hook-API-Ref.md#poller_output)                                             | [poller_remote_maint](Plugin-Hook-API-Ref.md#poller_remote_maint)                                 |
| [poller_top](Plugin-Hook-API-Ref.md#poller_top)                                           | [remote_agent](Plugin-Hook-API-Ref.md#remote_agent)                                               | [replicate_in](Plugin-Hook-API-Ref.md#replicate_in)                                               |
| [replicate_out](Plugin-Hook-API-Ref.md#replicate_out)                                     | [report_filters](Plugin-Hook-API-Ref.md#report_filters)                                           | [resolve_dependencies](Plugin-Hook-API-Ref.md#resolve_dependencies)                               |
| [rrd_graph_graph_options](Plugin-Hook-API-Ref.md#rrd_graph_graph_options)                 | [run_data_query](Plugin-Hook-API-Ref.md#run_data_query)                                           | [snmpagent_cache_install](Plugin-Hook-API-Ref.md#snmpagent_cache_install)                         |
| [substitute_host_data](Plugin-Hook-API-Ref.md#substitute_host_data)                       | [top_graph_header](Plugin-Hook-API-Ref.md#top_graph_header)                                       | [top_graph_header_tabs](Plugin-Hook-API-Ref.md#top_graph_header_tabs)                             |
| [top_graph_jquery_function](Plugin-Hook-API-Ref.md#top_graph_jquery_function)             | [top_graph_refresh](Plugin-Hook-API-Ref.md#top_graph_refresh)                                     | [top_header](Plugin-Hook-API-Ref.md#top_header)                                                   |
| [tree_after](Plugin-Hook-API-Ref.md#tree_after)                                           | [tree_view_page_end](Plugin-Hook-API-Ref.md#tree_view_page_end)                                   | [ugroup_tabs](Plugin-Hook-API-Ref.md#ugroup_tabs)                                                 |
| [update_data_source_title_cache](Plugin-Hook-API-Ref.md#update_data_source_title_cache)   | [user_admin_action](Plugin-Hook-API-Ref.md#user_admin_action)                                     | [user_admin_edit](Plugin-Hook-API-Ref.md#user_admin_edit)                                         |
| [user_admin_run_action](Plugin-Hook-API-Ref.md#user_admin_run_action)                     | [user_admin_setup_sql_save](Plugin-Hook-API-Ref.md#user_admin_setup_sql_save)                     | [user_admin_tab](Plugin-Hook-API-Ref.md#user_admin_tab)                                           |
| [user_admin_user_save](Plugin-Hook-API-Ref.md#user_admin_user_save)                       | [user_group_admin_action](Plugin-Hook-API-Ref.md#user_group_admin_action)                         | [user_group_admin_edit](Plugin-Hook-API-Ref.md#user_group_admin_edit)                             |
| [user_group_admin_save](Plugin-Hook-API-Ref.md#user_group_admin_save)                     | [user_group_admin_setup_sql_save](Plugin-Hook-API-Ref.md#user_group_admin_setup_sql_save)         | [user_group_admin_run_action] (Plugin-Hook-API-Ref.md#user_group_admin_run_action)                |
| [user_group_admin_tab] (Plugin-Hook-API-Ref.md#user_group_admin_tab)                      | [user_group_remove] (Plugin-Hook-API-Ref.md#user_group_remove)                                    | [user_remove](Plugin-Hook-API-Ref.md#user_remove)                                                 |
| [utilities_action](Plugin-Hook-API-Ref.md#utilities_action)                               | [utilities_array](Plugin-Hook-API-Ref.md#utilities_array)                                         | [utilities_list](Plugin-Hook-API-Ref.md#utilities_list)                                           |
| [valid_host_fields](Plugin-Hook-API-Ref.md#valid_host_fields)                             |

## add_graph_template_to_host

Allows you to perform additional operations when adding a graph template to
host. The parameters passed are `host_id` and `graph_template_id`.

| file                         | introduced | retired |
| ---------------------------- | :--------- | :------ |
| cli/add_graph_template.php   | 1.0.0      |
| cli/host_update_template.php | 1.0.0      |
| host.php                     | 1.0.0      |
| lib/api_device.php           | 1.0.0      |

## api_device_new

This hooks allows you to perform additional operation at the end of
api_device_save function. Unlike the api_device_save hook, the device ID is
already defined here.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| lib/api_device.php | 1.0.0      |

## api_device_save

This hook allows you to perform additional operation at the end of
api_device_save function. Unlike the api_device_new hook, the device ID is might
not be defined here.

This hook allows you to alter the contents to the device table with custom
fields. When used properly, it allows you to extend the host table with your
plugins custom fields.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| lib/api_device.php | 1.0.0      |

## auth_alternate_realms

This hook allows you to handle user login check alternate plugin defined
authentication realms.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| include/auth.php | 1.0.0      |

## auth_profile_reset

Allows you to reset plugins all user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_reset_value

Allows you to reset plugins single user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_run_action

Allows you to draw plugins user settings form

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_save

Allows you to save plugins all user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_tabs

Allows you to draw plugins user setting tabs

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_update_data

Allows you to update plugins single user setting

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| auth_profile.php | 1.2.4      |

## boost_poller_bottom

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| poller_boost.php | 1.0.0      |

## bottom_footer

Allows you to override the rendering of the bottom_footer html snippet.

| file                      | introduced | retired |
| ------------------------- | :--------- | :------ |
| include/bottom_footer.php | 0.8.7i     | 1.1.38  |

## cacti_stats_update

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## change_password_title

| file                    | introduced  | retired |
| ----------------------- | :---------- | :------ |
| auth_changepassword.php | 1.2.0-beta1 |

## clog_regex_array

Allows you to enhance the Logs display with additional information or links.

| file                | introduced | retired |
| ------------------- | :--------- | :------ |
| lib/clog_webapi.php | 1.1.34     |

## config_arrays

Allows your plug-in to define custom array elements to be used throughout cacti.
Things like dropdown arrays and the like.

| file                      | introduced | retired |
| ------------------------- | :--------- | :------ |
| include/global_arrays.php | 1.0.0      |

## config_form

Allows you to define form object to represent data to be stored in your tables.
In the case of MacTrack, there is a table called `mac_track_sites` and in order
to drive the UI and allow for the user to provide input and save a site, you
must provide the Cacti form engine a form array to allow for the form to be
presented and contents to be saved.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| include/global_form.php | 1.0.0      |

## config_insert

This is a general purpose hook used for connecting to other database, or
sourcing common includes that would otherwise not be sourced.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| include/global.php | 1.0.0      |

## config_settings

Allows you to extend the Cacti settings page to allow for custom tabs and global
settings within them.

| file                        | introduced | retired |
| --------------------------- | :--------- | :------ |
| include/global_settings.php | 1.0.0      |

## console_after

Allows you to add text after the default message on the console page

| file      | introduced | retired |
| --------- | :--------- | :------ |
| index.php | 1.0.0      |

## console_before

Allows you to add text before the default message on the console page. For
instance, the Update plug-in will display a message here if there are new
versions of plugins.

| file      | introduced | retired |
| --------- | :--------- | :------ |
| index.php | 1.0.0      |

## copy_user

Allows a plugin to take part in the Copy User actions. This is important a
plugin maintains user settings.

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| lib/auth.php | 1.0.0      |

## create_complete_graph_from_template

Allows you to perform additional operations when adding new graph to device from
graph template.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| lib/template.php | 1.0.0      |

## custom_denied

Allows you to override the rendering of the permission denied interface.

| file                  | introduced | retired |
| --------------------- | :--------- | :------ |
| permission_denied.php | 1.2.2      |
| auth_login.php        | 1.2.12     |

## custom_login

Allows you to override the rendering of the auth_login.php page.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## custom_logout_message

Allows you to override the rendering of the logout.php page.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| logout.php | 1.0.0      |

## custom_password

Allows you to override the rendering of the auth_changepassword.php page.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| auth_changepassword.php | 1.0.0      |

## custom_version_info

Allows your plugin to display additional information on the cacti tech support
page.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| utilities.php | 1.0.0      |

## data_input_sql_where

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| data_input.php | 1.0.0      |

## data_source_action_array

Allows you to define custom dropdown actions from within the data sources page.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_action_bottom

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_action_execute

Allows you to define custom actions to be taken upon you dropdown selection.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_action_prepare

This is the final component to creating a custom action within the data sources.
In Cacti's form engine, you must provide the dropdown action and then two
follow-up actions to complete the cycle. This is were you actually save the
data.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_edit_bottom

Allows you to make minor change to the Data Sources page, like add a tabbed
interface.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_edit_top

Allows you to make minor changes to the Data Sources page, like add a tabbed
interface.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_remove

This hook is called when the data sources used by a graph are removed. The
parameters are the graphs data sources.

| file                    | introduced  | retired |
| ----------------------- | :---------- | :------ |
| data_sources.php        | 1.0.0       | 1.1.38  |
| graphs.php              | 1.0.0       | 1.1.38  |
| host.php                | 1.0.0       | 1.1.38  |
| lib/api_data_source.php | 1.2.0-beta1 |

## data_source_to_poller_items

| file            | introduced | retired |
| --------------- | :--------- | :------ |
| lib/utility.php | 1.0.0      |

## data_sources_table

Allows you to change the data displayed on the Data Sources table. THold uses
this to create a link to that datasources threshold

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## device_action_array

Allows you to define custom dropdown actions from within the device/host page.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_action_bottom

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_action_execute

Allows you to define custom actions to be taken upon you dropdown selection.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_action_prepare

This is the final component to creating a custom action within the devices. In
Cacti's form engine, you must provide the dropdown action and then two follow-up
actions to complete the cycle. This is were you actually save the data.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_display_text

This hook allows you to add custom columns header to the host list page

| file     | introduced  | retired |
| -------- | :---------- | :------ |
| host.php | 1.3.0 - Dev |

## device_edit_pre_bottom

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_edit_top_links

This hook allows you to add custom actions to the host edit page, below the
"Create graphs for this Host".

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_filter_end

This hook allows you to add custom filter fields before Cacti buildin filter to
the host list page

| file     | introduced  | retired |
| -------- | :---------- | :------ |
| host.php | 1.3.0 - Dev |

## device_filter_start

This hook allows you to add custom filter fields after Cacti buildin filter to
the host list page

| file     | introduced  | retired |
| -------- | :---------- | :------ |
| host.php | 1.3.0 - Dev |

## device_filters

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_remove

This hook allows you to perform additional actions on devices that have been
selected for deletion. The parameter is an array of deleted device IDs. Note
that at this point, the devices are already deleted from the host table.

| file               | introduced  | retired |
| ------------------ | :---------- | :------ |
| host.php           | 1.0.0       | 1.1.38  |
| lib/api_device.php | 1.2.0-beta1 |

## device_sql_where

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_table_bottom

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_table_replace

Allows you to override the rendering of the host list page

| file     | introduced  | retired |
| -------- | :---------- | :------ |
| host.php | 1.3.0 - Dev |

## device_template_change

Allows you to add template items such a threshold upon a 
device template change

| file              | introduced  | retired |
| ----------------- | :---------- | :------ |
| lib/ap_device.php | 1.2.25      |

## device_template_edit

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| host_templates.php | 1.0.0      |

## device_template_top

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| host_templates.php | 1.0.0      |

## draw_navigation_text

Just below the Cacti "Console", and "Graphs" tabs, cacti provides a Navigation
bar that allows you to move backward in a selection tree. Although it is not
foolproof, this hook allows you to populate and navigate that tree.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php | 1.0.0      |

## export_action

| file           | introduced  | retired |
| -------------- | :---------- | :------ |
| lib/export.php | 1.2.0-beta1 |

## fgc_contextoption

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php | 1.1.28     |

## get_friendly_name

| file           | introduced  | retired |
| -------------- | :---------- | :------ |
| lib/import.php | 1.2.0-beta1 |

## global_settings_update

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| settings.php | 1.0.0      |

## graph

This hook is called at the top of graph.php page

| file      | introduced | retired |
| --------- | :--------- | :------ |
| graph.php | 1.0.0      |

## graph_buttons

You know about the zoom button right? Well this allows you to add any additional
custom button to the right of a graph.

| file      | introduced | retired |
| --------- | :--------- | :------ |
| graph.php | 1.0.0      |

## graph_edit_after

| file       | introduced  | retired |
| ---------- | :---------- | :------ |
| graphs.php | 1.2.0-beta1 |

## graph_image

This hooks allows displaying of alternative graphics in place of a graph image.
This hook can no output text, only modify the image, as it is only called when a
graph is required to be outputted.

| file            | introduced | retired |
| --------------- | :--------- | :------ |
| graph_image.php | 1.0.0      |
| graph_json.php  | 1.0.0      |

## graph_items_remove

This hook is called when when the data source is deleted, and the option to
remove all graph items tied to the data source is selected.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## graph_tree_page_buttons

Allows you to add custom HTML to the graph tree view page, under the timespan
presets and the graph search box.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/html_tree.php | 0.8.7i     |

## graphs_action_array

Similar to the host actions and host, prepare and execute hooks. It allows you
to have custom dropdown actions within the graph management interface.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## graphs_action_bottom

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## graphs_action_execute

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## graphs_action_prepare

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## graphs_item_array

| file       | introduced  | retired |
| ---------- | :---------- | :------ |
| graphs.php | 1.2.0-beta1 |

## graphs_new_top_links

Add a link at the top of the "Create New Graphs" page.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| graphs_new.php | 1.0.0      |

## graphs_remove

This hook is called after one or more graphs are removed. The parameters are the
removed graph IDs.

| file              | introduced  | retired |
| ----------------- | :---------- | :------ |
| data_sources.php  | 1.0.0       | 1.1.38  |
| graphs.php        | 1.0.0       | 1.1.38  |
| host.php          | 1.0.0       | 1.1.38  |
| lib/api_graph.php | 1.2.0-beta1 |

## graphs_sql_where

This hooks allows you to add additional where clauses to the select statement
used to display graphs on the graphs.php page.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## hmib_get_cpu

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| scripts/ss_host_cpu.php | 1.0.0      |

## hmib_get_cpu_indexes

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| scripts/ss_host_cpu.php | 1.0.0      |

## hmib_get_disk

| file                     | introduced | retired |
| ------------------------ | :--------- | :------ |
| scripts/ss_host_disk.php | 1.0.0      |

## host_edit_bottom

Allows you to make minor changes to the Devices page, like add a tabbed
interface.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## host_edit_top

Allows you to make minor changes to the Devices page, like add a tabbed
interface.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## host_save

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## import_action

| file           | introduced  | retired |
| -------------- | :---------- | :------ |
| lib/import.php | 1.2.0-beta1 |

## is_console_page

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| lib/html.php | 1.0.0      |

## login_after

This allows you to display text or html after the login form.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## login_before

This allows you to display text or html before the login form. Combined with the
above hook, you could draw a box, etc around the form, change its background
color, etc to slightly customize the login page.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## login_options_navigate

Used to support alternate login realm types.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| auth_changepassword.php | 1.0.0      |
| auth_login.php          | 1.0.0      |

## login_process

Used to authenticate the user logging in to a custom plugin defined realm.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## login_realms

Used to defined additional custom plugin defined authentication realms. The
parameter passed is an array of existing authentication realms.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## login_title

Allows the plugin to set/modify that page title.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## logout_post_session_destroy

This pair of hooks (`logout_pre_session_destroy` and
`logout_post_session_destroy`) allows you to preserve some session variables
that would otherwise get unset, when `session_destroy()` is called.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| logout.php | 1.0.0      |

## logout_pre_session_destroy

This pair of hooks (`logout_pre_session_destroy` and
`logout_post_session_destroy`) allows you to preserve some session variables
that would otherwise get unset, when `session_destroy()` is called.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| logout.php | 1.0.0      |

## nav_login_after

This pair of hooks (`nav_login_before` and `nav_login_after`) allows you to add
custom HTML to the navigation bar, before and after the "Logged in as " text.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php | 1.0.0      |

## nav_login_before

This pair of hooks (`nav_login_before` and `nav_login_after`) allows you to add
custom HTML to the navigation bar, before and after the "Logged in as " text.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php | 1.0.0      |

## page_bottom

This hook allows you to add custom HTML to the bottom of the page, after the
main layout table.

| file                      | introduced | retired |
| ------------------------- | :--------- | :------ |
| include/bottom_footer.php | 1.0.0      |

## page_buttons

Allows you to add custom buttons and HTML to the top of the graph.php page,
above the "Viewing graph" row.

| file      | introduced | retired |
| --------- | :--------- | :------ |
| graph.php | 1.0.0      |

## page_head

This hook allows you to add custom HTML tags to the page `<head>` tag.

| file                           | introduced | retired |
| ------------------------------ | :--------- | :------ |
| graph_realtime.php             | 1.0.0      | 1.1.33  |
| include/top_general_header.php | 1.0.0      | 1.1.33  |
| include/top_graph_header.php   | 1.0.0      | 1.1.33  |
| include/top_header.php         | 1.0.0      | 1.1.33  |
| lib/html.php                   | 1.1.34     |

## page_title

Allows the plugin to set/modify the page title

| file                           | introduced | retired |
| ------------------------------ | :--------- | :------ |
| include/top_general_header.php | 1.0.0      |
| include/top_graph_header.php   | 1.0.0      |
| include/top_header.php         | 1.0.0      |

## poller_bottom

This hook allows you to launch other polling activities once Cacti has complete
it's polling activities. Things like MacTrack, Boost, THold, and others use this
hook to launch their respective poller.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## poller_command_args

Using this hook, your plugin can pass additional command line arguments to the
poller.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 0.8.7i     | 1.2.8   |

## poller_exiting

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## poller_finishing

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## poller_output

This hook was designed specifically for the boost plug-in. However, it has found
new life in many plugins making them much faster now. What this hook allows you
to do is intercept the contents of the `poller_output` table before the data is
deleted. This allows for things like threshold checking and other interesting
actions such as checking for up/down events and the like. Previously, plugins
were reliant on using things like `rrdtool fetch` to perform these actions. Now
they can leverage the pollers output directly.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| lib/poller.php | 1.0.0      |

## poller_remote_maint

This hook will fire for plugins that need to perform remote maintenance. It will
only fire on the Remote Data Collectors.

| file                   | introduced | retired |
| ---------------------- | :--------- | :------ |
| poller_maintenance.php | 1.2.23     |

## poller_top

This hook allows you to launch processes concurrently with the Cacti poller for
things like THolds fast poller for example.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## remote_agent

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| remote_agent.php | 1.0.0      |

## replicate_in

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| lib/poller.php | 1.0.0      |

## replicate_out

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| lib/api_device.php |            |
| lib/poller.php     | 1.0.0      |

## resolve_dependencies

| file           | introduced  | retired |
| -------------- | :---------- | :------ |
| lib/export.php | 1.2.0-beta1 |

## rrd_graph_graph_options

This hook allows you to specify additional options or change parameters
regarding graph image rendering. Some of the parameters will be passed to
RRDtool.

| file        | introduced | retired |
| ----------- | :--------- | :------ |
| lib/rrd.php | 1.0.0      |

## run_data_query

This hook allows your plugin to perform additional operations after a data query
update was triggered.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| lib/data_query.php | 1.0.0      |

## snmpagent_cache_install

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/snmpagent.php | 1.0.0      |

## substitute_host_data

This allows you to add to the substitution variables that cacti can parse.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/variables.php | 1.0.0      | 1.1.5   |

## top_graph_header

Allows you to override the rendering of the top_graph_header.php include.

| file                         | introduced | retired |
| ---------------------------- | :--------- | :------ |
| include/top_graph_header.php | 0.8.7i     | 1.1.38  |

## top_graph_header_tabs

This hook is used to add tab's to Cacti's user interface.

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| lib/html.php | 1.0.0      |

## top_graph_jquery_function

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/html_tree.php | 1.0.0      |

## top_graph_refresh

This allows you to change the refresh on the graph (and any plug-in page that
calls the graph header)

| file                                      | introduced | retired |
| ----------------------------------------- | :--------- | :------ |
| include/global_session.php                | 1.0.0      |
| include/themes/sunrise/global_session.php | 1.1.11     | 1.1.38  |

## top_header

This hooks enables you to output custom HTML on top the the graph view page, if
navigation tabs are not rendered. Allows you to override the rendering of the
top_header.php include.

| file                           | introduced | retired |
| ------------------------------ | :--------- | :------ |
| include/top_general_header.php | 1.0.0      | 1.1.38  |
| include/top_header.php         | 0.8.7i     | 1.1.38  |

## tree_after

This hook allows you to add additional HTML at the bottom of the graph tree view
page. The HTML is rendered only if a valid graph tree leaf is selected.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/html_tree.php | 1.0.0      |

## tree_view_page_end

This hook allows you to add additional HTML at the bottom of the graph tree view
page, irrespective of the leaf selection.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| graph.php         | 1.0.0      |
| lib/html_tree.php | 1.0.0      |

## ugroup_tabs

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## update_data_source_title_cache

This hook is called after the data source title cache is updated.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/variables.php | 1.0.0      |

## user_admin_action

This hook is part of a series of hooks that allow you to add custom user
settings. Consider a plug-in called "abc". In that plug-in, you want to save
custom settings on a per user basis. Therefore, following our unpublished ?
table naming standards, you would create a table called "abc_settings". When you
tab over to the "abc" plug-in, you are provided an "abc settings" on the right
similar to "Graphs". The next series of hooks allow you to present those
settings to the user, enable or disable the users access to that specific "abc
settings" tab and allow an administrator to define customer values for that
plug-in on a per user basis.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| user_admin.php | 1.0.0      |

## user_admin_edit

See the explanation on `user_admin_action`

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| user_admin.php | 1.0.0      |

## user_admin_run_action

See the explanation on `user_admin_action`

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| user_admin.php | 1.0.0      |

## user_admin_setup_sql_save

See the explanation on `user_admin_action`

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| user_admin.php | 1.0.0      |

## user_admin_tab

See the explanation on `user_admin_action`

| file           | introduced | retired     |
| -------------- | :--------- | :---------- |
| user_admin.php | 0.8.7i     |
| utilities.php  | 1.0.0      | 1.2.0-beta3 |

## user_admin_user_save

See the explanation on `user_admin_action`

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| user_admin.php | 1.0.0      |

## user_group_admin_action

Similar to `user_admin_action`

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_edit

See the explanation on `user_admin_action`

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_save

See the explanation on `user_admin_action`

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_action

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_edit

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_save

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_setup_sql_save

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_remove

Allows the plugin to take part in the user removal process. Important when the
plugin maintains user settings.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| lib/auth.php   | 1.0.0      |
| user_admin.php | 1.0.0      |

## utilities_action

This hook set's up the function to be executed from within Cacti's utilities
section.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| utilities.php | 1.0.0      |

## utilities_array

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| utilities.php | 1.0.4      |

## utilities_list

This hook allows you to add a custom utilities pick under Cacti's "Utilities"
page.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| utilities.php | 1.0.0      |

## utilities_tab

This hook allows you to add a custom utilities tab under Cacti's "Utilities"
page.

| file          | introduced  | retired |
| ------------- | :---------- | :------ |
| utilities.php | 1.2.0-beta3 |

## valid_host_fields

Allows your plugin to define additional variables that will be used in
substitute_host_data.

Pretty sure that this hook allows you to define custom replacement values in
graphs.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| include/global_form.php | 1.0.0      |

---

Copyright (c) 2004-2024 The Cacti Group
