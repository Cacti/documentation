# Plugin Hook API Reference

The following table shows all known Cacti plugin hooks and a brief description
of their function.

| hook                                                                                              | hook                                                                                    | hook                                                                                  |
| ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| [add_graph_template_to_host](Plugin-Hook-API-Ref.md#add_graph_template_to_host)                   | [api_device_new](Plugin-Hook-API-Ref.md#api_device_new)                                 | [api_device_save](Plugin-Hook-API-Ref.md#api_device_save)                             |
| [auth_alternate_realms](Plugin-Hook-API-Ref.md#auth_alternate_realms)                             | [auth_profile_reset](Plugin-Hook-API-Ref.md#auth_profile_reset)                         | [auth_profile_reset_value](Plugin-Hook-API-Ref.md#auth_profile_reset_value)           |
| [auth_profile_run_action](Plugin-Hook-API-Ref.md#auth_profile_run_action)                         | [auth_profile_save](Plugin-Hook-API-Ref.md#auth_profile_save)                           | [auth_profile_tabs](Plugin-Hook-API-Ref.md#auth_profile_tabs)                         |
| [auth_profile_update_data](Plugin-Hook-API-Ref.md#auth_profile_update_data)                       | [boost_poller_bottom](Plugin-Hook-API-Ref.md#boost_poller_bottom)                       | [bottom_footer](Plugin-Hook-API-Ref.md#bottom_footer)                                 |
| [cacti_stats_update](Plugin-Hook-API-Ref.md#cacti_stats_update)                                   | [change_password_title](Plugin-Hook-API-Ref.md#change_password_title)                   | [changelog_action](Plugin-Hook-API-Ref.md#changelog_action)                           |
| [changelog_tab](Plugin-Hook-API-Ref.md#changelog_tab)                                             | [clog_regex_array](Plugin-Hook-API-Ref.md#clog_regex_array)                             | [config_arrays](Plugin-Hook-API-Ref.md#config_arrays)                                 |
| [config_form](Plugin-Hook-API-Ref.md#config_form)                                                 | [config_insert](Plugin-Hook-API-Ref.md#config_insert)                                   | [config_settings](Plugin-Hook-API-Ref.md#config_settings)                             |
| [console_after](Plugin-Hook-API-Ref.md#console_after)                                             | [console_before](Plugin-Hook-API-Ref.md#console_before)                                 | [copy_user](Plugin-Hook-API-Ref.md#copy_user)                                         |
| [create_complete_graph_from_template](Plugin-Hook-API-Ref.md#create_complete_graph_from_template) | [custom_2fa_login](Plugin-Hook-API-Ref.md#custom_2fa_login)                             | [custom_denied](Plugin-Hook-API-Ref.md#custom_denied)                                 |
| [custom_login](Plugin-Hook-API-Ref.md#custom_login)                                               | [custom_logout_message](Plugin-Hook-API-Ref.md#custom_logout_message)                   | [custom_password](Plugin-Hook-API-Ref.md#custom_password)                             |
| [custom_version_info](Plugin-Hook-API-Ref.md#custom_version_info)                                 | [customize_graph](Plugin-Hook-API-Ref.md#customize_graph)                               | [customize_template_details](Plugin-Hook-API-Ref.md#customize_template_details)       |
| [data_input_sql_where](Plugin-Hook-API-Ref.md#data_input_sql_where)                               | [data_source_action_array](Plugin-Hook-API-Ref.md#data_source_action_array)             | [data_source_action_bottom](Plugin-Hook-API-Ref.md#data_source_action_bottom)         |
| [data_source_action_execute](Plugin-Hook-API-Ref.md#data_source_action_execute)                   | [data_source_action_prepare](Plugin-Hook-API-Ref.md#data_source_action_prepare)         | [data_source_confirmation_form](Plugin-Hook-API-Ref.md#data_source_confirmation_form) |
| [data_source_edit_bottom](Plugin-Hook-API-Ref.md#data_source_edit_bottom)                         | [data_source_edit_top](Plugin-Hook-API-Ref.md#data_source_edit_top)                     | [data_source_remove](Plugin-Hook-API-Ref.md#data_source_remove)                       |
| [data_source_to_poller_items](Plugin-Hook-API-Ref.md#data_source_to_poller_items)                 | [data_sources_table](Plugin-Hook-API-Ref.md#data_sources_table)                         | [device_action_array](Plugin-Hook-API-Ref.md#device_action_array)                     |
| [device_action_bottom](Plugin-Hook-API-Ref.md#device_action_bottom)                               | [device_action_execute](Plugin-Hook-API-Ref.md#device_action_execute)                   | [device_action_prepare](Plugin-Hook-API-Ref.md#device_action_prepare)                 |
| [device_change_javascript](Plugin-Hook-API-Ref.md#device_change_javascript)                       | [device_confirmation_form](Plugin-Hook-API-Ref.md#device_confirmation_form)             | [device_display_text](Plugin-Hook-API-Ref.md#device_display_text)                     |
| [device_edit_pre_bottom](Plugin-Hook-API-Ref.md#device_edit_pre_bottom)                           | [device_edit_top_links](Plugin-Hook-API-Ref.md#device_edit_top_links)                   | [device_filters](Plugin-Hook-API-Ref.md#device_filters)                               |
| [device_remove](Plugin-Hook-API-Ref.md#device_remove)                                             | [device_sql_where](Plugin-Hook-API-Ref.md#device_sql_where)                             | [device_table_bottom](Plugin-Hook-API-Ref.md#device_table_bottom)                     |
| [device_table_replace](Plugin-Hook-API-Ref.md#device_table_replace)                               | [device_template_change](Plugin-Hook-API-Ref.md#device_template_change)                 | [device_template_edit](Plugin-Hook-API-Ref.md#device_template_edit)                   |
| [device_template_top](Plugin-Hook-API-Ref.md#device_template_top)                                 | [device_threshold_autocreate](Plugin-Hook-API-Ref.md#device_threshold_autocreate)       | [device_top](Plugin-Hook-API-Ref.md#device_top)                                       |
| [draw_navigation_text](Plugin-Hook-API-Ref.md#draw_navigation_text)                               | [expand_title](Plugin-Hook-API-Ref.md#expand_title)                                     | [export_action](Plugin-Hook-API-Ref.md#export_action)                                 |
| [fgc_contextoption](Plugin-Hook-API-Ref.md#fgc_contextoption)                                     | [get_friendly_name](Plugin-Hook-API-Ref.md#get_friendly_name)                           | [get_template_account](Plugin-Hook-API-Ref.md#get_template_account)                   |
| [global_settings_update](Plugin-Hook-API-Ref.md#global_settings_update)                           | [graph](Plugin-Hook-API-Ref.md#graph)                                                   | [graph_buttons](Plugin-Hook-API-Ref.md#graph_buttons)                                 |
| [graph_edit_after](Plugin-Hook-API-Ref.md#graph_edit_after)                                       | [graph_image](Plugin-Hook-API-Ref.md#graph_image)                                       | [graph_items_remove](Plugin-Hook-API-Ref.md#graph_items_remove)                       |
| [graph_tree_page_buttons](Plugin-Hook-API-Ref.md#graph_tree_page_buttons)                         | [graphs_action_array](Plugin-Hook-API-Ref.md#graphs_action_array)                       | [graphs_action_bottom](Plugin-Hook-API-Ref.md#graphs_action_bottom)                   |
| [graphs_action_execute](Plugin-Hook-API-Ref.md#graphs_action_execute)                             | [graphs_action_prepare](Plugin-Hook-API-Ref.md#graphs_action_prepare)                   | [graphs_confirmation_form](Plugin-Hook-API-Ref.md#graphs_confirmation_form)           |
| [graphs_item_array](Plugin-Hook-API-Ref.md#graphs_item_array)                                     | [graphs_new_top_links](Plugin-Hook-API-Ref.md#graphs_new_top_links)                     | [graphs_remove](Plugin-Hook-API-Ref.md#graphs_remove)                                 |
| [graphs_sql_where](Plugin-Hook-API-Ref.md#graphs_sql_where)                                       | [help_page](Plugin-Hook-API-Ref.md#help_page)                                           | [hmib_get_cpu](Plugin-Hook-API-Ref.md#hmib_get_cpu)                                   |
| [hmib_get_cpu_indexes](Plugin-Hook-API-Ref.md#hmib_get_cpu_indexes)                               | [hmib_get_disk](Plugin-Hook-API-Ref.md#hmib_get_disk)                                   | [host_edit_bottom](Plugin-Hook-API-Ref.md#host_edit_bottom)                           |
| [host_edit_top](Plugin-Hook-API-Ref.md#host_edit_top)                                             | [host_save](Plugin-Hook-API-Ref.md#host_save)                                           | [import_action](Plugin-Hook-API-Ref.md#import_action)                                 |
| [is_console_page](Plugin-Hook-API-Ref.md#is_console_page)                                         | [is_device_in_maintenance](Plugin-Hook-API-Ref.md#is_device_in_maintenance)             | [login_after](Plugin-Hook-API-Ref.md#login_after)                                     |
| [login_before](Plugin-Hook-API-Ref.md#login_before)                                               | [login_options_navigate](Plugin-Hook-API-Ref.md#login_options_navigate)                 | [login_process](Plugin-Hook-API-Ref.md#login_process)                                 |
| [login_title](Plugin-Hook-API-Ref.md#login_title)                                                 | [logout_post_session_destroy](Plugin-Hook-API-Ref.md#logout_post_session_destroy)       | [logout_pre_session_destroy](Plugin-Hook-API-Ref.md#logout_pre_session_destroy)       |
| [nav_login_after](Plugin-Hook-API-Ref.md#nav_login_after)                                         | [nav_login_before](Plugin-Hook-API-Ref.md#nav_login_before)                             | [notification_channels](Plugin-Hook-API-Ref.md#notification_channels)                 |
| [page_bottom](Plugin-Hook-API-Ref.md#page_bottom)                                                 | [page_buttons](Plugin-Hook-API-Ref.md#page_buttons)                                     | [page_head](Plugin-Hook-API-Ref.md#page_head)                                         |
| [page_title](Plugin-Hook-API-Ref.md#page_title)                                                   | [poller_bottom](Plugin-Hook-API-Ref.md#poller_bottom)                                   | [poller_command_args](Plugin-Hook-API-Ref.md#poller_command_args)                     |
| [poller_exiting](Plugin-Hook-API-Ref.md#poller_exiting)                                           | [poller_finishing](Plugin-Hook-API-Ref.md#poller_finishing)                             | [poller_output](Plugin-Hook-API-Ref.md#poller_output)                                 |
| [poller_remote_maint](Plugin-Hook-API-Ref.md#poller_remote_maint)                                 | [poller_top](Plugin-Hook-API-Ref.md#poller_top)                                         | [remote_agent](Plugin-Hook-API-Ref.md#remote_agent)                                   |
| [replicate_out](Plugin-Hook-API-Ref.md#replicate_out)                                             | [resolve_dependencies](Plugin-Hook-API-Ref.md#resolve_dependencies)                     | [rrd_graph_graph_options](Plugin-Hook-API-Ref.md#rrd_graph_graph_options)             |
| [run_data_query](Plugin-Hook-API-Ref.md#run_data_query)                                           | [settings_bottom](Plugin-Hook-API-Ref.md#settings_bottom)                               | [snmpagent_cache_install](Plugin-Hook-API-Ref.md#snmpagent_cache_install)             |
| [substitute_host_data](Plugin-Hook-API-Ref.md#substitute_host_data)                               | [support_process_tables](Plugin-Hook-API-Ref.md#support_process_tables)                 | [text_regex_array](Plugin-Hook-API-Ref.md#text_regex_array)                           |
| [top_graph_header](Plugin-Hook-API-Ref.md#top_graph_header)                                       | [top_graph_header_tabs](Plugin-Hook-API-Ref.md#top_graph_header_tabs)                   | [top_graph_jquery_function](Plugin-Hook-API-Ref.md#top_graph_jquery_function)         |
| [top_graph_refresh](Plugin-Hook-API-Ref.md#top_graph_refresh)                                     | [top_header](Plugin-Hook-API-Ref.md#top_header)                                         | [tree_after](Plugin-Hook-API-Ref.md#tree_after)                                       |
| [tree_view_page_end](Plugin-Hook-API-Ref.md#tree_view_page_end)                                   | [update_data_source_title_cache](Plugin-Hook-API-Ref.md#update_data_source_title_cache) | [user_admin_action](Plugin-Hook-API-Ref.md#user_admin_action)                         |
| [user_admin_edit](Plugin-Hook-API-Ref.md#user_admin_edit)                                         | [user_admin_run_action](Plugin-Hook-API-Ref.md#user_admin_run_action)                   | [user_admin_setup_sql_save](Plugin-Hook-API-Ref.md#user_admin_setup_sql_save)         |
| [user_admin_tab](Plugin-Hook-API-Ref.md#user_admin_tab)                                           | [user_admin_user_save](Plugin-Hook-API-Ref.md#user_admin_user_save)                     | [user_group_admin_action](Plugin-Hook-API-Ref.md#user_group_admin_action)             |
| [user_group_admin_edit](Plugin-Hook-API-Ref.md#user_group_admin_edit)                             | [user_group_admin_run_action](Plugin-Hook-API-Ref.md#user_group_admin_run_action)       | [user_group_admin_save](Plugin-Hook-API-Ref.md#user_group_admin_save)                 |
| [user_group_admin_setup_sql_save](Plugin-Hook-API-Ref.md#user_group_admin_setup_sql_save)         | [user_group_admin_tab](Plugin-Hook-API-Ref.md#user_group_admin_tab)                     | [user_group_remove](Plugin-Hook-API-Ref.md#user_group_remove)                         |
| [user_remove](Plugin-Hook-API-Ref.md#user_remove)                                                 | [utilities_action](Plugin-Hook-API-Ref.md#utilities_action)                             | [utilities_array](Plugin-Hook-API-Ref.md#utilities_array)                             |
| [utilities_list](Plugin-Hook-API-Ref.md#utilities_list)                                           | [utilities_tab](Plugin-Hook-API-Ref.md#utilities_tab)                                   | [valid_host_fields](Plugin-Hook-API-Ref.md#valid_host_fields)                         |

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

This hook allows you to perform additional operations at the end of
api_device_save function. Unlike the api_device_save hook, the device ID is
already defined here.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| lib/api_device.php | 1.0.0      |

## api_device_save

This hook allows you to perform additional operations at the end of
api_device_save function. Unlike the api_device_new hook, the device ID might
not be defined here.

This hook allows you to alter the contents to the device table with custom
fields. When used properly, it allows you to extend the host table with your
plugin's custom fields.

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

Allows you to reset plugin's all user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_reset_value

Allows you to reset plugin's single user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_run_action

Allows you to draw plugin's user settings form

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_save

Allows you to save plugin's all user settings

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_tabs

Allows you to draw plugin's user setting tabs

| file             | introduced  | retired |
| ---------------- | :---------- | :------ |
| auth_profile.php | 1.2.0-beta3 |

## auth_profile_update_data

Allows you to update plugin's single user setting

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

## changelog_action

Called with the requested action before the Change Log page is drawn.  If a
plugin handles the action and returns a true value, Cacti skips drawing its own
Change Log page.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| changelog.php |            |         |

## changelog_tab

Allows you to add custom tabs to the Change Log page.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| changelog.php |            |         |

## clog_regex_array

Allows you to enhance the Logs display with additional information or links.

| file                | introduced | retired |
| ------------------- | :--------- | :------ |
| lib/clog_webapi.php | 1.1.34     |

## config_arrays

Allows your plug-in to define custom array elements to be used throughout Cacti.
Things like dropdown arrays and the like.

| file                      | introduced | retired |
| ------------------------- | :--------- | :------ |
| include/global_arrays.php | 1.0.0      |

## config_form

Allows you to define a form object to represent data to be stored in your
tables. In the case of MacTrack, there is a table called `mac_track_sites` and
in order to drive the UI and allow for the user to provide input and save a
site, you must provide the Cacti form engine a form array to allow for the form
to be presented and contents to be saved.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| include/global_form.php | 1.0.0      |

## config_insert

This is a general purpose hook used for connecting to another database, or
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

Allows a plugin to take part in the Copy User actions. This is important if a
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

## custom_2fa_login

Allows you to override the rendering of the two factor authentication page.
The default value passed is `OPER_MODE_NATIVE`.  If the plugin returns
`OPER_MODE_RESKIN`, Cacti does not draw its own page.

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| auth_2fa.php |            |         |

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

Allows your plugin to display additional information on the Cacti tech support
page.

| file          | introduced | retired |
| ------------- | :--------- | :------ |
| utilities.php | 1.0.0      |

## customize_graph

Allows you to modify the graph record for a graph that is not created from a
graph template, when graphs are listed.  The graph array is passed and must be
returned.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| graphs.php         |            |         |
| lib/html_graph.php |            |         |

## customize_template_details

Allows you to modify the template details for a graph that is not created from
a graph template, when graphs are listed.  The template details array is passed
and must be returned.

| file               | introduced | retired |
| ------------------ | :--------- | :------ |
| graphs.php         |            |         |
| lib/html_graph.php |            |         |

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

Allows you to define custom actions to be taken upon your dropdown selection.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_action_prepare

This is the final component to creating a custom action within the data sources.
In Cacti's form engine, you must provide the dropdown action and then two
follow-up actions to complete the cycle. This is where you actually save the
data.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php | 1.0.0      |

## data_source_confirmation_form

Allows you to modify the form data shown on the confirmation page for Data
Source actions.  The form data array is passed and must be returned.

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| data_sources.php |            |         |

## data_source_edit_bottom

Allows you to make minor changes to the Data Sources page, like add a tabbed
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
parameters are the graph's data sources.

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
this to create a link to that data source's threshold.

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

Allows you to define custom actions to be taken upon your dropdown selection.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_action_prepare

This is the final component to creating a custom action within the devices. In
Cacti's form engine, you must provide the dropdown action and then two follow-up
actions to complete the cycle. This is where you actually save the data.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_confirmation_form

Allows you to modify the form data shown on the confirmation page for Device
actions.  The form data array is passed and must be returned.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php |            |         |

## device_display_text

This hook allows you to add custom column headers to the host list page

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

## device_filters

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.0.0      |

## device_change_javascript

This hook allows you to add custom JavaScript to Change device settings page

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php | 1.2.31      |

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

Allows you to add template items such as a threshold upon a
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

## device_threshold_autocreate

Called with the new device ID after Automation successfully creates a device.
It is used by the thold plugin to create thresholds for the new device.

| file                   | introduced | retired |
| ---------------------- | :--------- | :------ |
| lib/api_automation.php |            |         |

## device_top

This hook is called at the top of the Devices page, before the requested
action is processed.

| file     | introduced | retired |
| -------- | :--------- | :------ |
| host.php |            |         |

## draw_navigation_text

Just below the Cacti "Console" and "Graphs" tabs, Cacti provides a Navigation
bar that allows you to move backward in a selection tree. Although it is not
foolproof, this hook allows you to populate and navigate that tree.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php | 1.0.0      |

## expand_title

Allows you to modify a data source or graph title after Cacti has expanded its
variables.  The array passed contains `host_id`, `snmp_query_id`, `snmp_index`
and `title`.  If the returned array contains a `title`, it replaces the title.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/variables.php |            |         |

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

## get_template_account

Allows you to select the user account used as the template when a new user is
created.  The user is passed.  Return the same value to use the default
template account setting, an account ID to use that account, or 0 for no
template account.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php |            |         |

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

This hook allows displaying of alternative graphics in place of a graph image.
This hook cannot output text, only modify the image, as it is only called when a
graph is required to be outputted.

| file            | introduced | retired |
| --------------- | :--------- | :------ |
| graph_image.php | 1.0.0      |
| graph_json.php  | 1.0.0      |

## graph_items_remove

This hook is called when the data source is deleted, and the option to
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

## graphs_confirmation_form

Allows you to modify the form data shown on the confirmation page for Graph
actions.  The form data array is passed and must be returned.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php |            |         |

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

This hook allows you to add additional where clauses to the select statement
used to display graphs on the graphs.php page.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| graphs.php | 1.0.0      |

## help_page

Allows you to add to or change the array that maps Cacti pages to their online
help page.  The array is passed and must be returned.

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| lib/html.php |            |         |

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

## is_device_in_maintenance

Called with a device ID while the SNMP agent builds device notifications.  If a
plugin returns a true value, the device is treated as being in maintenance and
is skipped when the notifications are built.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/snmpagent.php |            |         |

## login_after

This allows you to display text or html after the login form.  It is the
`{section}_after` hook, drawn for every authentication page; see `login_title`
for the sections.

| file           | introduced | retired |
| -------------- | :--------- | :------ |
| auth_login.php | 1.0.0      |

## login_before

This allows you to display text or html before the login form.  It is the
`{section}_before` hook, drawn for every authentication page; see `login_title`
for the sections.

Combined with the `login_after` hook, you could draw a box, etc around the form,
change its background color, etc to slightly customize the login page.

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

## login_title

Allows the plugin to set/modify that page title.

The `login_title`, `login_before` and `login_after` hooks are built from the
section name, as `{section}_title`, `{section}_before` and `{section}_after`,
when Cacti draws an authentication page.  The sections are:

| section         | page                                 | file                    |
| --------------- | ------------------------------------ | ----------------------- |
| login           | Login                                | auth_login.php          |
| login_2fa       | Two factor authentication            | auth_2fa.php            |
| change_password | Change Password                      | auth_changepassword.php |
| reset_password  | Reset Password                       | auth_resetpassword.php  |
| logout          | Automatic logout                     | logout.php              |
| disabled        | Automatic logout, account suspension | logout.php              |
| denied          | Permission Denied                    | permission_denied.php   |

The page is drawn in `html_auth_header()` and `html_auth_footer()` in
lib/html.php.  The `{section}_title` hook is passed the browser title, and the
`{section}_before` hook is passed the extra arguments given for the page.

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

## notification_channels

Allows you to add notification channels.  The array of existing channels,
indexed by name, is passed.  Return it with additional Symfony
`ChannelInterface` instances added.

| file                     | introduced | retired |
| ------------------------ | :--------- | :------ |
| lib/api_notification.php |            |         |

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

This hook allows you to launch other polling activities once Cacti has completed
its polling activities. Things like MacTrack, Boost, THold, and others use this
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
they can leverage the poller's output directly.

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
things like THold's fast poller for example.

| file       | introduced | retired |
| ---------- | :--------- | :------ |
| poller.php | 1.0.0      |

## remote_agent

| file             | introduced | retired |
| ---------------- | :--------- | :------ |
| remote_agent.php | 1.0.0      |

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

## settings_bottom

This hook is called at the bottom of the Settings page.

| file         | introduced | retired |
| ------------ | :--------- | :------ |
| settings.php |            |         |

## snmpagent_cache_install

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/snmpagent.php | 1.0.0      |

## substitute_host_data

This allows you to add to the substitution variables that Cacti can parse.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/variables.php | 1.0.0      | 1.1.5   |

## support_process_tables

Allows you to add process tables to the running process listing on the Support
page.  The array of definitions, indexed by an alphanumeric key, is passed.
Each definition requires a `label`, `table` and `select`.  Malformed
definitions are discarded.

| file        | introduced | retired |
| ----------- | :--------- | :------ |
| support.php |            |         |

## text_regex_array

Allows you to add regular expressions that Cacti applies to log text, in the
same way as its built-in `Graph[1]` style references.  The array is passed and
must be returned.  It is issued in addition to the older `clog_regex_array`
hook.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/functions.php |            |         |

## top_graph_header

Allows you to override the rendering of the top_graph_header.php include.

| file                         | introduced | retired |
| ---------------------------- | :--------- | :------ |
| include/top_graph_header.php | 0.8.7i     | 1.1.38  |

## top_graph_header_tabs

This hook is used to add tabs to Cacti's user interface.

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

This hook enables you to output custom HTML on top of the graph view page, if
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

## update_data_source_title_cache

This hook is called after the data source title cache is updated.

| file              | introduced | retired |
| ----------------- | :--------- | :------ |
| lib/variables.php | 1.0.0      |

## user_admin_action

This hook is part of a series of hooks that allow you to add custom user
settings. Consider a plug-in called "abc". In that plug-in, you want to save
custom settings on a per user basis. Therefore, following our unpublished
table naming standards, you would create a table called "abc_settings". When you
tab over to the "abc" plug-in, you are provided an "abc settings" on the right
similar to "Graphs". The next series of hooks allow you to present those
settings to the user, enable or disable the user's access to that specific "abc
settings" tab and allow an administrator to define custom values for that
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

## user_group_admin_run_action

Similar to `user_admin_run_action`

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_admin_tab

Similar to `user_admin_tab`

| file                 | introduced | retired |
| -------------------- | :--------- | :------ |
| user_group_admin.php | 1.0.0      |

## user_group_remove

Similar to `user_remove` for user groups.

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

This hook sets up the function to be executed from within Cacti's utilities
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

The list it returns sets the valid **Special Type Code** keywords for **Data
Input Method** fields that take their value from the **Device**.

| file                    | introduced | retired |
| ----------------------- | :--------- | :------ |
| include/global_form.php | 1.0.0      |

---
Copyright (c) 2004-2026 The Cacti Group
