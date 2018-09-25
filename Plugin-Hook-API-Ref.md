# Hook API Reference

Cacti Plugin Developers,

Below you will find documentation on the current Plug-in Architecture (3.1). If
you are looking to start a plugin, some good reference material would be the
following plugins:

## Documentation Link to github

[MacTrack](https://github.com/Cacti/plugin_mactrack)

[Thold](https://github.com/Cacti/plugin_thold)

[Syslog](https://github.com/Cacti/plugin_syslog)

[Monitor](https://github.com/Cacti/plugin_monitor)

## Hook API Table

Hook Name | File Appearing | Explanation
--- | --- | ---
add_graph_template_to_host | host.php | Allows you to perform additional operations when adding a graph template to host. The parameters  passed are host_id and graph_template_id.
add_graph_template_to_host | cli/add_graph_template.php | See the note above.
add_graph_template_to_host | cli/host_update_template.php | See the note above.
add_graph_template_to_host | lib/api_device.php | See the note above.
api_device_new | lib/api_device.php | This hooks allows you to perform additional operation at the end of api_device_save function. Unlike the api_device_save hook, the device ID is already defined here.
api_device_save | lib/api_device.php | This hook allows you to alter the contents to the device table with custom fields. When used properly, it allows you to extend the host table with your plugins custom fields.
auth_alternate_realms | include/auth.php | This hook allows you to handle user login check alternate plugin defined authentication realms.
body_style | include/top_graph_header.php | Allows additional style, javascript, and the adding of other important HTML objects at initial page load time
body_style | include/top_graph_header.php | Allows additional style, javascript, and the adding of other important HTML objects at initial page load time
body_style | include/top_header.php | Allows additional style, javascript, and the adding of other important HTML objects at initial page load time
body_style | include/top_header.php | Allows additional style, javascript, and the adding of other important HTML objects at initial page load time
bottom_footer | include/bottom_footer.php | Allows you to override the rendering of the bottom_footer html snippet.
cacti_image | auth_login.php | This allows you to change the image displayed on the Login screen
config_arrays | include/global_arrays.php | Allows your plug-in to define custom array elements to be used throughout cacti. Things like dropdown arrays and the like.
config_form | include/global_form.php | Allows you to define form object to represent data to be stored in your tables. In the case of MacTrack, there is a table called mac_track_sites and in order to drive the UI and allow for the user to provide input and save a site, you must provide the Cacti form engine a form array to allow for the form to be presented and contents to be saved.
config_insert | include/global.php | The is a general purpose hook used for connecting to other database, or sourcing common includes that would otherwise not be sourced.
config_settings | include/global_settings.php | Allows you to extend the Cacti settings page to allow for custom tabs and global settings within them.
console_after | index.php | Allows you to add text before the default message on the console page
console_before | index.php | Allows you to add text before the default message on the console page. For instance, the Update plug-in will display a message here if there are new versions of plugins.
copy_user | lib/auth.php | Allows a plugin to take part in the Copy User actions.  This is important a plugin maintains user settings.
create_complete_graph_from_template | lib/template.php | Allows you to perform additional operations when adding new graph to device from graph template.
custom_login | auth_login.php | Allows you to override the rendering of the auth_login.php page.
custom_logout_message | logout.php | Allows you to override the rendering of the logout.php page.
custom_password | auth_changepassword.php | Allows you to override the rendering of the auth_changepassword.php page.
custom_version_info | utilities.php | Allows your plugin to display additional information on the cacti tech support page.
data_source_action_array | data_sources.php | Allows you to define custom dropdown actions from within the data sources page.
data_source_action_execute | data_sources.php | Allows you to define custom actions to be taken upon you dropdown selection.
data_source_action_prepare | data_sources.php | This is the final component to creating a custom action within the data sources. In Cacti's form engine, you must provide the dropdown action and then two follow-up actions to complete the cycle. This is were you actually save the data.
data_source_edit_bottom | data_sources.php | Allows you to make minor change to the Data Sources page, like add a tabbed interface.
data_source_edit_top | data_sources.php | Allows you to make minor changes to the Data Sources page, like add a tabbed interface.
data_source_remove | data_sources.php | This hook is called when the data sources used by a graph are removed. The parameters are the graphs data sources.
data_source_remove | graphs.php | See the note above.
data_source_remove | host.php | See the note above.
data_sources_table | data_sources.php | Allows you to change the data displayed on the Data Sources table. THold uses this to create a link to that datasources threshold
device_action_array | host.php | Allows you to define custom dropdown actions from within the device/host page.
device_action_execute | host.php | Allows you to define custom actions to be taken upon you dropdown selection.
device_action_prepare | host.php | This is the final component to creating a custom action within the devices. In Cacti's form engine, you must provide the dropdown action and then two follow-up actions to complete the cycle. This is were you actually save the data.
device_edit_top_links | host.php | This hook allows you to add custom actions to the host edit page, below the "Create graphs for this Host".
device_remove | host.php | This hook allows you to perform additional actions on devices that have been selected for deletion. The parameter is an array of deleted device IDs. Note that at this point, the devices are already deleted from the host table.
draw_navigation_text | lib/functions.php | Just below the Cacti "Console", and "Graphs" tabs, cacti provides a Navigation bar that allows you to move backward in a selection tree. Although it is not foolproof, this hook allows you to populate and navigate that tree.
graph | graph.php | This hook is called at the top of graph.php page.
graph_buttons | graph.php | You know about the zoom button right? Well this allows you to add any additional custom button to the right of a graph.
graph_buttons | graph.php | You know about the zoom button right? Well this allows you to add any additional custom button to the right of a graph.
graph_buttons | graph.php | You know about the zoom button right? Well this allows you to add any additional custom button to the right of a graph.
graph_buttons | lib/html.php | This hook has the same purpose as the hook above. However, there are several sections of Cacti that allow for the insertion of your Icon image and action.
graph_buttons_thumbnails | lib/html.php | This hook has the same purpose as the hook above. However, there are several sections of Cacti that allow for the insertion of your Icon image and action.
graph_image | graph_image.php | This hooks allows displaying of alternative graphics in place of a graph image. This hook can no output text, only modify the image, as it is only called when a graph is required to be outputted.
graph_items_remove | data_sources.php | This hook is called when when the data source is deleted, and the option to remove all graph items tied to the data source is selected.
graph_tree_page_buttons | lib/html_tree.php | Allows you to add custom HTML to the graph tree view page, under the timespan presets and the graph search box.
graphs_action_array | graphs.php | Similar to the host actions and host, prepare and execute hooks. It allows you to have custom dropdown actions within the graph management interface.
graphs_action_execute | graphs.php | See the note above.
graphs_action_prepare | graphs.php | See the note above.
graphs_new_top_links | graphs_new.php | Add a link at the top of the "Create New Graphs" page.
graphs_remove | data_sources.php | This hook is called after one or more graphs are removed. The parameters are the removed graph IDs.
graphs_remove | graphs.php | See the note above.
graphs_remove | host.php | See the note above.
graphs_sql_where | graphs.php | This hooks allows you to add additional where clauses to the select statement used to display graphs on the graphs.php page.
host_edit_bottom | host.php | Allows you to make minor changes to the Devices page, like add a tabbed interface.
host_edit_top | host.php | Allows you to make minor changes to the Devices page, like add a tabbed interface.
login_after | auth_login.php | This allows you to display text or html before the login form.
login_before | auth_login.php | This allows you to display text after the login form. Combined with the above hook, you could draw a box, etc around the form, change its background color, etc to slightly customize the login page.
login_options_navigate | auth_changepassword.php | Used to support alternate login realm types.
login_options_navigate | auth_login.php | Used to support alternate login realm types.
login_process | auth_login.php | Used to authenticate the user logging in to a custom plugin defined realm.
login_realms | auth_login.php | Used to defined additional custom plugin defined authentication realms. The parameter passed is an array of existing authentication realms.
login_realms_exist | auth_login.php | Used as an indication that a custom plugin defined login realm exists.
login_title | auth_login.php | Allows the plugin to set/modify that page title.
logout_post_session_destroy | logout.php | This pair of hooks (logout_pre_session_destroy and logout_post_session_destroy) allows you to preserve some session variables that would otherwise get unset, when session_destroy() is called.
logout_pre_session_destroy | logout.php | See the note above.
nav_login_after | include/top_graph_header.php | This pair of hooks (nav_login_before and nav_login_after) allows you to add custom HTML to the navigation bar, before and after the "Logged in as " text.
nav_login_after | include/top_header.php | See the note above.
nav_login_before | include/top_graph_header.php | See the note above.
nav_login_before | include/top_header.php | See the note above.
page_bottom | include/bottom_footer.php | This hook allows you to add custom HTML to the bottom of the page, after the main layout table.
page_buttons | graph.php | Allows you to add custom buttons and HTML to the top of the graph.php pag, above the "Viewing graph" row.
page_head | include/top_graph_header.php | This hook allows you to add custom HTML tags to the page <head> tag.
page_head | include/top_header.php | See the note above.
page_title | include/top_graph_header.php | Allows the plugin to set/modify that page title
page_title | include/top_header.php | Allows the plugin to set/modify the page title
poller_bottom | poller.php | This hook allows you to launch other polling activities once Cacti has complete it's polling activities. Things like MacTrack, Boost, THold, and others use this hook to launch their respective poller.
poller_bottom | poller.php | This hook allows you to launch other polling activities once Cacti has complete it's polling activities. Things like MacTrack, Boost, THold, and others use this hook to launch their respective poller.
poller_command_args | poller.php | Using this hook, your plugin can pass additional command line arguments to the poller.
poller_on_demand | lib/poller.php | This hook was designed specifically for the boost plug-in. It allows Cacti to evaluate whether or not there are RRDtool update's to perform for a set of data sources that will be used in the upcoming graph operation. It will update them prior to any graphing operations.
poller_output | lib/poller.php | This hook was designed specifically for the boost plug-in. However, it has found new life in many plugins making them much faster now. What this hook allows you to do is intercept the contents of the poller_output table before the data is deleted. This allows for things like threshold checking and other interesting actions such as checking for up/down events and the like. Previously, plugins were reliant on using things like RRDtool fetch to perform these actions. Now they can leverage the pollers output directly.
poller_top | poller.php | This hook allows you to launch processes concurrently with the Cacti poller for things like THolds fast poller for example.
poller_top | poller.php | This hook allows you to launch processes concurrently with the Cacti poller for things like THolds fast poller for example.
prep_graph_array | lib/rrd.php | NA
print_top_header | include/top_graph_header.php | This hooks enables you to output custom HTML on top the the graph view page, if navigation tabs are not rendered.
rrd_graph_graph_options | lib/rrd.php | This hook allows you to specify additional options or change parameters regarding graph image rendering. Some of the parameters will be passed to rrdtool.
rrdtool_function_fetch_cache_check | lib/rrd.php | NA
rrdtool_function_graph_cache_check | lib/rrd.php | This hook was designed specifically for the boost plug-in. This plug-in will check the image cache for a valid file. If the file is found to be stale, it will utilize RRDtool to generate a fresh one.
rrdtool_function_graph_set_file | lib/rrd.php | This hook was designed specifically for the boost plug-in. It will look for the presence of a cached graph image and setup it's presentation rather than regenerating a new graph.
run_data_query | lib/data_query.php | This hook allows your plugin to perform additional operations after a data query update was triggered.
top_graph_header | include/top_graph_header.php | Allows you to override the rendering of the top_graph_header.php include.
top_graph_header_tabs | include/top_graph_header.php | This hook is used to add tab's to Cacti's user interface.
top_graph_refresh | include/top_graph_header.php | This allows you to change the refresh on the graph (and any plug-in page that calls the graph header)
top_header | include/top_header.php | Allows you to override the rendering of the top_header.php include.
top_header_tabs | include/top_header.php | This hook is similar to the one above, except in the Console view and not the Graphs view.
tree_after | lib/html_tree.php | This hook allows you to add additional HTML at the bottom of the graph tree view page. The HTML is rendered only if a valid graph tree leaf is selected.
tree_view_page_end | graph.php | This hook allows you to add additional HTML at the bottom of the graph tree view page, irrespective of the leaf selection.
tree_view_page_end | lib/html_tree.php | See the note above.
update_data_source_title_cache | lib/variables.php | This hook is called after the data source title cache is updated.
user_admin_action | user_admin.php | This hook is part of a series of hooks that allow you to add custom user settings. Consider a plug-in called "abc". In that plug-in, you want to save custom settings on a per user basis. Therefore, following our unpublished ? table naming standards, you would create a table called "abc_settings". When you tab over to the "abc" plug-in, you are provided an "abc settings" on the right similar to "Graphs". The next series of hooks allow you to present those settings to the user, enable or disable the users access to that specific "abc settings" tab and allow an administrator to define customer values for that plug-in on a per user basis.
user_admin_edit | user_admin.php | See the explanation on "user_admin_action"
user_admin_run_action | user_admin.php | See the explanation on "user_admin_action"
user_admin_setup_sql_save | user_admin.php | See the explanation on "user_admin_action"
user_admin_tab | user_admin.php | See the explanation on "user_admin_action"
user_admin_user_save | user_admin.php | See the explanation on "user_admin_action"
user_remove | user_admin.php | Allows the plugin to take part in the user removal process.  Important when the plugin maintains user settings.
user_remove | lib/auth.php | See the note above.
utilities_action | utilities.php | This hook set's up the function to be executed from within Cacti's utilities section.
utilities_list | utilities.php | This hook allows you to add a custom utilities pick under Cacti's "Utilities" page.
valid_host_fields | include/global_form.php | Allows your plugin to define additional variables that will be used in substitute_host_data.
config_arrays | include/config_arrays.php | Allows your plug-in to define custom array elements to be used throughout cacti. Things like dropdown arrays and the like.
config_form | include/config_form.php | Allows you to define form object to represent data to be stored in your tables. In the case of MacTrack, there is a table called mac_track_sites and in order to drive the UI and allow for the user to provide input and save a site, you must provide the Cacti form engine a form array to allow for the form to be presented and contents to be saved.
config_settings | include/config_settings.php | Allows you to extend the Cacti settings page to allow for custom tabs and global settings within them.
substitute_host_data | lib/variables.php | This allows you to add to the substitution variables that cacti can parse. Ex  is one of them.
update_host_status | lib/functions.php | This is called when cmd.php detects a change in the status of a host. Granted, this is not used when you use Cactid, hence the reason THold will not send host down alerts when using Cactid.
valid_host_fields | include/config_form.php | Pretty sure that this hook allows you to define custom replacement values in graphs.
