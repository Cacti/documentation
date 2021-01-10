# Version Specific Release Notes

## Summary

Below you will find the release note for all versions of Cacti 1.0.0 and
above.  Release notes for earlier Cacti versions have been excluded
due to the large list of changes that have occurred over the years,
and since Cacti 0.8.x is no longer supported, it's a good time
to for the purposes of this document, move them aside.

Before that list, let's talks about Cacti 1.0.0 first.

## Cacti 1.0.0

This was the initial release of Cacti 1.x.  With the release of Cacti 1.0.0
many improvements and enhancements have been made. As part of ongoing
efforts to improve Cacti almost 20 plugins were merged
into the core of Cacti eliminating the need for the plugins. A major refresh
of the interface has been started and will continue to occur as development on
Cacti continues.

### Plugins integrated into Cacti Core

The following plugins have been merged into the core Cacti code as of
version 1.0.0:

| Plugin      | Description                                              |
| ----------- | -------------------------------------------------------- |
| snmpagent   | An SNMP Agent extension, trap and notification generator |
| clog        | Log viewers for administrators                           |
| settings    | Core plugin providing email and DNS services             |
| boost       | Large system performance boost plugin                    |
| dsstats     | Cacti data source statistics                             |
| watermark   | Watermark graphs                                         |
| ssl         | Force https connection                                   |
| ugroup      | User groups support                                      |
| domains     | Multiple authentication domains                          |
| jqueryskin  | User interface skinning                                  |
| secpass     | C3 level password and site security                      |
| logrotate   | Log management                                           |
| realtime    | Realtime graphing                                        |
| rrdclean    | RRDfile maintenance                                     |
| nectar      | Email based graph reporting                              |
| aggregate   | Templating, creation and management of aggregate graphs  |
| autom8      | Graph and Tree creation automation                       |
| discovery   | Network Discovery and Device automation                  |
| spikekill   | Removes spikes from Graphs                               |
| superlinks  | Allows administrators to links to additional sites       |

## ChangeLog for All Cacti 1.x Releases

This is the comprehensive ChangeLog for all Cacti 1.x releases.  The issues
are broken down as follows:

Category | Description
--- | ---
issue[issue#] | Normal issues either experienced by a Developer or logged in GitHub and fixed
feature[issue#] | Features either implemented or logged in GitHub and addressed
security[issue#] | Security vulnerability either fixed or logged in GitHub and addressed
bug[bug#] | Feature of Bug reported in the old Cacti Mantis system that was addressed.

All Issues from Cacti 1.0.0 to the Cacti 1.2.17 release.

Version | Feature/Bug | Description
--- | --- | ---
1.2.17 | issue#3981 | PHP ERROR: Call to undefined function api_data_source_cache_crc_update()
1.2.17 | issue#3879 | Graph/Data Source creation with custom fields not prompting during 1st creation
1.2.17 | issue#3969 | SNMPv3 Password Length Limit
1.2.17 | issue#3976 | Multi-Selectable dropdown filter's option class is ignored
1.2.17 | issue#3977 | Cacti CLI upgrade_database.php misses constant IN_CACTI_INSTAL which may result in upgrade failures
1.2.17 | issue#3978 | CMDPHP Input Validation Not Performed for Tree
1.2.17 | issue#3985 | Update database library function to properly handle collate
1.2.17 | issue#3988 | Automation raises errors when default snmp options is set to none
1.2.17 | issue#3990 | Utilities-System Utilities-technich support-php info is not a row, should not use form_alternate_row
1.2.17 | issue#4001 | PHP8 support: Debian test suites shows lots of PHP Errors and Warnings with PHP8
1.2.17 | issue#4002 | Poller Recovery is not predictable
1.2.17 | issue#4005 | Automation raises errors when default snmp options is set to none
1.2.17 | issue#4008 | Fix #3808 causes a massive decrease in poller performance
1.2.17 | issue#4009 | The function number_format_i18n() should consider null to align with standard number_format() function
1.2.17 | feature#3513 | Add hooks for plugins to show customize graph source and customize template url
1.2.17 | feature#4012 | Provide CLI script to renew the CSRF security key for CSRF protection
1.2.17 | feature#4013 | Remote Poller - reset avg/max polling time
1.2.16 | issue#3704 | When generating a report, the Cascade to Branches function does not as expected
1.2.16 | issue#3859 | When viewing graphs, automatic refresh so not always work as expected
1.2.16 | issue#3898 | Realtime graph pop up counter bug
1.2.16 | issue#3903 | Undefined variable errors may occur when creating a new datasource
1.2.16 | issue#3907 | The cli-based installer does not exit with a non-zero exit code when error occurs
1.2.16 | issue#3912 | When an export is complete, sometimes the progress bar remains
1.2.16 | issue#3915 | When enabling many devices, a threshold can be reached causing a slowdown in the process
1.2.16 | issue#3916 | When performing actions against Devices, replicated device information could sometimes be lost
1.2.16 | issue#3917 | When using API to rename a tree node, backtrace may be incorrectly shown
1.2.16 | issue#3919 | When searching, valid pages can sometimes be shown as empty by ddb4github
1.2.16 | issue#3920 | When exporting data from graphs, not all data was properly included
1.2.16 | issue#3924 | Graph Templates filter is not updated after new graph created by ddb4github
1.2.16 | issue#3926 | Username and password on the login page is not visible in Classic theme
1.2.16 | issue#3929 | Improve wording of concurrent process and thread settings
1.2.16 | issue#3930 | Location filter should remove blank entries by ddb4github
1.2.16 | issue#3931 | When syncing data collectors, a reindex event may be triggered unnecessarily
1.2.16 | issue#3932 | Automation Networks allows discovery of invalid IP addresses
1.2.16 | issue#3933 | When changing permissions of the current user, they don't take effect immediately
1.2.16 | issue#3935 | When reindexing a device, an incorrect page was sometimes displayed
1.2.16 | issue#3942 | When repairing database, audit_database.php does not add missing columns
1.2.16 | issue#3948 | Spine 1.2.15 - Spine Encountered An Unhandled Exception Signal Number: '6' [11, Resource temporarily unavailable] (Spine thread)
1.2.16 | issue#3949 | Log page should not be empty if no log info exists
1.2.16 | issue#3953 | During upgrade, there are times when realms can be duplicated leading to SQL errors
1.2.16 | issue#3957 | When using ping.php, UDP response times are not interpreted properly by hypnotoad
1.2.16 | issue#3960 | Improve warning you get when attempting to view a log file you don't have access to
1.2.16 | issue#3962 | When replicating files, scripts are not marked as executable
1.2.16 | issue#3963 | When creating plugin tables, collation is not set properly
1.2.16 | feature | Update c3.js to version 0.7.20
1.2.16 | feature | Update Chart.js to version 2.9.4
1.2.16 | feature | Update phpseclib to version 2.0.29
1.2.16 | feature | Update PHPMailer to version 6.1.8
1.2.16 | feature | Use LSB shebang notation for cli scripts
1.2.16 | feature | Add support for cactid daemon based launcher
1.2.16 | feature#3923 | Add ability to hide the Graph Drilldown icons by datatecuk
1.2.16 | feature#3943 | Add hooks for plugins to show custom Graph Source and custom Template URL (List View)
1.2.15 | issue#3643 | When editing Maximum OIDs Per Get Request, blank value can cause errors
1.2.15 | issue#3656 | Boost may run more often than it should
1.2.15 | issue#3693 | Recache Event Loop can cause Interface Graphs to show gaps
1.2.15 | issue#3703 | When searching Graph Tree's, non matching devices remain visible
1.2.15 | issue#3711 | Page validation errors may occur when opening real time graphs
1.2.15 | issue#3722 | External Links do not always open if they are still open from previous usage
1.2.15 | issue#3730 | Cultural changes to various word usage
1.2.15 | issue#3741 | Replicate deleted device status instead of poller sync
1.2.15 | issue#3743 | Description field allows more characters entered than is stored
1.2.15 | issue#3747 | When installing or upgrading, LDAP functions may not always be included properly
1.2.15 | issue#3748 | Unable to remove discovered device
1.2.15 | issue#3753 | When installing or upgrading, PHP recommendations may not always return a valid value
1.2.15 | issue#3755 | Graph Templates has duplicate SQL delete statement
1.2.15 | issue#3759 | When syncing to remote poller, missing function errors may occur
1.2.15 | issue#3760 | When removing devices from remote pollers, devices may reappear without details
1.2.15 | issue#3761 | When removing devices, array errors may sometimes be recorded
1.2.15 | issue#3763 | Variable injection does not always work as expected
1.2.15 | issue#3764 | Editing Data Queries with multiple data templates can give errors about Suggested values
1.2.15 | issue#3767 | Progress bar does not provide enough visual information during long page loads
1.2.15 | issue#3768 | Some themes do not allow for a way to see which user is currently signed in
1.2.15 | issue#3769 | When viewing tables, allow users to force all columns to be visible
1.2.15 | issue#3770 | Column sizing is being lost between pages refreshes
1.2.15 | issue#3771 | When viewing input methods table, no ID is shown to help identify which method is being viewed
1.2.15 | issue#3775 | Filters do not always respect using keyboard to initiate searching
1.2.15 | issue#3778 | When exporting a data query, an invalid column name error can sometimes be shown
1.2.15 | issue#3781 | When checking if a view is allowed, having no session can result in errors
1.2.15 | issue#3782 | When removing devices via the CLI, undefined variable errors may be seen
1.2.15 | issue#3786 | Real Time Graphs may cause invalid index errors
1.2.15 | issue#3790 | On newer versions of MySQL/MariaDB, 'system' keyword can cause issues
1.2.15 | issue#3793 | Plugin setup can generate errors when reading options via system function
1.2.15 | issue#3809 | Plugin version numbers can be unexpectedly truncated
1.2.15 | issue#3815 | When PHP Session is set to autostart, an error can be reported as Cacti attempts to start it
1.2.15 | issue#3820 | When removing multiple items, selection process does not always work
1.2.15 | issue#3821 | When exporting colors, the indicator is not always removed upon completion
1.2.15 | issue#3825 | Unable to pass tree and leaf ID to 'graph_button' hook
1.2.15 | issue#3827 | When performing maintenance, various errors may sometimes be seen
1.2.15 | issue#3828 | When Guest User setting is active, current user is not always properly set
1.2.15 | issue#3831 | When installing Cacti, minor errors in text can be seen
1.2.15 | issue#3835 | Numbers are not always formatted properly when there are no decimal places
1.2.15 | issue#3836 | When viewing Real Time Graphs, an undefined index error may be recorded
1.2.15 | issue#3844 | Minor memory leaks and refresh issues when zooming on graphs
1.2.15 | issue#3847 | Real Time Graphs may sometimes fail due to folder permissions
1.2.15 | issue#3849 | Navigation can sometimes occur unexpectedly due to background timers
1.2.15 | issue#3850 | Trees management screen not reporting correct number of trees
1.2.15 | issue#3858 | Tree sequences can sometimes skip numbers during resorting
1.2.15 | issue#3862 | Guest user selection should not allow setting the currently logged in user
1.2.15 | issue#3864 | Links in Table Headers do not show clearly when in modern theme
1.2.15 | issue#3868 | Under some cases tree logic leads to undefined index errors
1.2.15 | issue#3869 | Cacti Data Debug can show errors if the Data Source is damaged or has been removed
1.2.15 | issue#3871 | When importing a data query, an invalid column name error can sometimes be shown
1.2.15 | issue#3874 | When using shift functions on graphs, negative values are not allowed
1.2.15 | issue#3881 | Correct issue when file is unreadable reporting no file was specified
1.2.15 | issue#3883 | Orphaned Plugins have no option to be removed
1.2.15 | issue#3884 | Update MySQL recommendations for Character Set and Colation
1.2.15 | issue#3888 | Correct sorting of IP addresses to be numeric not alpha by JamesTilt
1.2.15 | issue#3890 | Saving a device should not always repopulate the poller cache
1.2.15 | feature | Update FontAwesome to Version 5.14
1.2.14 | issue#3676 | Device not showing up in device page but showing up in Monitor tab
1.2.14 | issue#3678 | More or Equal incorrect highlighting max_heap_table_size and tmp_table_size
1.2.14 | issue#3694 | Spikekill `percent` is converted from percent to decimal twice, making it 1/100 of the true size
1.2.14 | issue#3713 | When sorting data debug checks by user, no results are shown and errors recorded
1.2.14 | issue#3719 | When tooltip is too long, the scroll bar exists, and cannot be scrolled, which makes the tooltip be hided
1.2.14 | issue#3723 | Improper escaping of error message leads to XSS during template import preview
1.2.14 | issue#3728 | Invalid uptime is not handled properly
1.2.14 | issue#3737 | Poller functions may not run if 'processes' table is missing
1.2.14 | feature#3615 | Poller keeps using old IP address for a device
1.2.13 | security#3544 | jQuery XSS vulnerabilities require vendor package update (CVE-2020-11022 / CVE-2020-11023)
1.2.13 | security#3549 | Lack of escaping on some pages can lead to XSS exposure
1.2.13 | security#3582 | Update PHPMailer to 6.1.6 (CVE-2020-13625)
1.2.13 | security#3622 | SQL Injection vulnerability due to input validation failure when editing colors (CVE-2020-14295)
1.2.13 | security#3628 | Lack of escaping on template import can lead to XSS exposure
1.2.13 | issue#3517 | When generating reports, function looping can occur resulting in 100% cpu usage
1.2.13 | issue#3525 | When viewing Graphs, zoom functionality prevents drag and drop of image
1.2.13 | issue#3527 | When using 95th Percentiles, undefined index errors can be generated
1.2.13 | issue#3532 | When using Realtime, if no graph contents are present an error is generated
1.2.13 | issue#3533 | When exporting data, Start date for RRDfile does not match start date of first data row
1.2.13 | issue#3536 | When using Navigation Menu, Show/Hide in Response mode does not always work
1.2.13 | issue#3538 | When using Realtime, race conditions between browser and function loading can occur
1.2.13 | issue#3543 | When exporting CSV data, Unicode prefix is not properly set
1.2.13 | issue#3551 | Authentication can fail when using Web Basic Authentication and Template User
1.2.13 | issue#3553 | When attempting to view an aggregate graph that does not exist, many errors are generated
1.2.13 | issue#3563 | Current orphan handling disrupts graphing transient indexes
1.2.13 | issue#3566 | Automation incorrectly attempts to use MacTrack to duplicate options
1.2.13 | issue#3567 | When Boost runs, locks are not always released properly and crash is detected
1.2.13 | issue#3569 | Invalid font results in large number of log entries
1.2.13 | issue#3571 | Correct various runtime errors due to incorrect message variables
1.2.13 | issue#3574 | Saving Graph Template Items take a long time on large systems
1.2.13 | issue#3577 | Hosts are being incorrectly filtered when first displaying with filter set to all
1.2.13 | issue#3579 | Graphs can incorrectly show as 'Empty Graph'
1.2.13 | issue#3581 | Realtime graph window is not resizing properly
1.2.13 | issue#3588 | Validation warnings are generated when viewing/editing devices
1.2.13 | issue#3594 | Automation hangs for certain schedule types
1.2.13 | issue#3595 | Template to Device sync text is not consistent
1.2.13 | issue#3596 | When importing template, resources aren't checked properly
1.2.13 | issue#3597 | Template to Device sync provides no feedback
1.2.13 | issue#3598 | When editing graphs and graph templates, back button results in broken page
1.2.13 | issue#3599 | When downgrading, templates are fully selected for install
1.2.13 | issue#3601 | When a device is down, instate can show wrong time
1.2.13 | issue#3607 | When session timeout occurs, subsequent authorized access to areas can become blocked
1.2.13 | issue#3611 | Allow CHANGELOG to be viewable from the GUI
1.2.13 | issue#3613 | When modifying trees, devices and graphs lists ignore Autocomplete Rows setting
1.2.13 | issue#3614 | When section tabs wrap, the title of the first section can become obscured
1.2.13 | issue#3624 | When previewing graphs, sometimes the images fail to appear
1.2.13 | issue#3629 | Log files are not rotated properly on remote pollers
1.2.13 | issue#3631 | Command line scripts do not allow an unlimited runtime causing timeouts
1.2.13 | issue#3632 | When mysql connection fails, various unexpected errors are recorded
1.2.13 | issue#3635 | Automate generates undefined index errors when communicating with remote pollers
1.2.13 | issue#3639 | When updating a device, duplicate entry errors occur when inserting to the database
1.2.13 | issue#3646 | Adding datasource fails from CLI due to missing function
1.2.13 | issue#3651 | Editing any item on an Aggregate Graph that has been converted to a normal graph breaks entire graph
1.2.13 | issue#3655 | Rare race condition between Boost and Poller can result in unexpected missing table errors
1.2.13 | issue#3659 | When viewing logs, unexpected 'needle' errors can be seen on rare occasions
1.2.13 | issue#3663 | Disabling a Data Collector can cause unexpected errors
1.2.13 | issue#3668 | When Input Field is in error, message reports field will be highlighted which is incorrect
1.2.13 | issue#3669 | When adding an Input Field, the Input Method can be renamed unexpected
1.2.13 | issue#3673 | Spikekill does not receive correct `avgnan` value when launching from GUI
1.2.13 | issue#3676 | Device not showing up in device page but showing up in Monitor tab
1.2.13 | issue#3681 | Item movement arrows do not properly align on all themes
1.2.13 | issue#3682 | When in 'Time Graph View' mode, Zoom features do not work correctly
1.2.13 | feature#3611 | Allow CHANGELOG to be viewable from the GUI
1.2.13 | feature#3647 | When adding datasource fails from CLI, created Datasource ID should be printed
1.2.13 | feature#3666 | Update jstree.js to 3.3.10
1.2.13 | feature#3688 | Update phpseclib to 2.0.28
1.2.12 | security#3467 | Lack of escaping of color items can lead to XSS exposure (CVE-2020-7106)
1.2.12 | issue#3422 | When Graph Item is not linked to a data source, Comments do not always get variables substituted correctly
1.2.12 | issue#3424 | Hosts are being incorrectly filtered when no location filter is set
1.2.12 | issue#3427 | When exporting to a CSV with unicode characters, contents can become garbled
1.2.12 | issue#3429 | When using SNMP v3, Automation can report extraneous warnings
1.2.12 | issue#3432 | Rare race condition exists when both boost and dsstats enabled
1.2.12 | issue#3434 | When attempting to exploit Cacti using alert, unexpected errors can be seen
1.2.12 | issue#3436 | Unable to login due to incorrect default of Cookie Domains in config.php.dist
1.2.12 | issue#3438 | When upgrading to 1.2.11, installer can appear to stop at 42%
1.2.12 | issue#3447 | SNMP Issues on recent version of PHP
1.2.12 | issue#3449 | When viewing the installation wizard's directory permission step, items are overlapping unexpectedly
1.2.12 | issue#3450 | When installing Cacti under XAMPP and PHP 7.4, exceptions are being recorded and installation fails
1.2.12 | issue#3452 | New Content-Security-Policy prevents External Links from being opened
1.2.12 | issue#3454 | Cacti's Reports are not displaying messages correctly
1.2.12 | issue#3457 | Graphs can not properly handle negative axis values
1.2.12 | issue#3459 | When installing a new remote poller, connection tests can incorrectly fail
1.2.12 | issue#3460 | Addtional changes to allow plugin folder/display names to be handled better
1.2.12 | issue#3462 | Increase default memory limit for cli scripts to prevent runtime memory issues
1.2.12 | issue#3463 | When listing VDEF's, selecting 'has graph' can cause unexpected exceptions in logs
1.2.12 | issue#3468 | Graph rules cannot be created for automation
1.2.12 | issue#3474 | The SSL option to set the SSL_CA should be optional for Client Connections
1.2.12 | issue#3477 | Boost leaking memory when a large number of Data Sources disabled
1.2.12 | issue#3478 | Reindexing can sometimes run longer than expected
1.2.12 | issue#3479 | When viewing the Data Query table interface, the Data Input Method should be right aligned
1.2.12 | issue#3483 | When recording log entries, cacti should default to hyphenated date format
1.2.12 | issue#3484 | When editing SNMP v3 passwords, previous setting is not obfuscated
1.2.12 | issue#3488 | In automation, when viewing an 'SNMP option set', the private passphrase is in clear
1.2.12 | issue#3495 | When installing templates, default 'all' selection will reset all existing graphs, removing customisations
1.2.12 | issue#3496 | Graph Items can show a double percent sign incorrectly
1.2.12 | issue#3502 | When viewing Graphs, can not switch between list, preview and tree submodes
1.2.12 | issue#3504 | Viewing graphs before the poller has run for the first time can produce unexpected errors
1.2.12 | issue#3505 | When viewing graph previews, clicking Go or Refresh prevents calendars from working
1.2.12 | issue#3506 | After successfully logging in, a user can become automatically logged out again
1.2.12 | issue#3507 | Changes to JavaScript's Storage API cause exceptions to be thrown
1.2.12 | issue#3510 | Only guests can actually guest only pages, logged in users are denied access incorrectly
1.2.12 | issue#3512 | When plugins update, registered files list cannot always be updated
1.2.12 | issue#3520 | When viewing graphs, shifting time does not work when using non-english languages
1.2.12 | issue#3576 | LDAP Authentication succeeds, but login fails due to bad session handling
1.2.12 | issue#3629 | Log files are not rotated properly on remote pollers
1.2.12 | feature#3480 | Created 'custom_denied' hook to allow customisation of permission denied notifications
1.2.12 | feature#3498 | Update js.storage.js to 1.1.0
1.2.12 | feature#3499 | Update jstree.js to 3.3.9
1.2.12 | feature#3500 | Update phpseclib to 2.0.27
1.2.11 | security#1566 | Add SameSite support for cookies
1.2.11 | security#1985 | Cookie should be properly verified against password
1.2.11 | security#3342 | CSRF at Admin Email
1.2.11 | security#3343 | Improper Access Control on disabling a user.
1.2.11 | security#3414 | Update to jQuery 3.4.1 to resolve XSS issues with jQuery 3.3.1
1.2.11 | issue#2265 | When attempting to save Graph field, query_ifSpeed is not properly validated
1.2.11 | issue#2400 | Allow ability to duplicate site settings
1.2.11 | issue#2428 | Make plugins non-case sensitive for folder names, whilst allowing nicer display names
1.2.11 | issue#2580 | When running DSSTATS, system isn't properly detecting that another is already running
1.2.11 | issue#2853 | Discovered Devices filtering do not include snmp description or name
1.2.11 | issue#3231 | Allow user to unlock a tree that has been locked for editing by another
1.2.11 | issue#3237 | Report gets resent every poller cycle
1.2.11 | issue#3247 | Language source files do not update "PO-Revision-Date" attribute
1.2.11 | issue#3261 | Automation rules aren't run for new devices on remote data collectors
1.2.11 | issue#3296 | Bad PHP memory limit values can result in failed upgrades
1.2.11 | issue#3299 | When using php-snmp and setting SNMPv3, warning is now shown as library does not support it properly
1.2.11 | issue#3303 | When installing under Windows OS, path expansion is not converted to PHP required format
1.2.11 | issue#3310 | When using 32-bit OS, automation errors can be seen due to subnet mask calculations
1.2.11 | issue#3312 | Console menu does not auto-expand for graph item editor page
1.2.11 | issue#3313 | When installing, multiple issues can be seen due to bad packages
1.2.11 | issue#3314 | Script Server has invalid debug code left in
1.2.11 | issue#3317 | Warnings can appear from CSRF Magic library due to multiple token values being found
1.2.11 | issue#3319 | Errors can occur upgrading from 0.8.x due to incorrectly detected data source profile id
1.2.11 | issue#3322 | When searching for LDAP accounts, allow recursive searching
1.2.11 | issue#3330 | Packages that are not properly formatted can cause installation issues
1.2.11 | issue#3334 | When upgrading from 0.8.x Automation SNMP Options should be populated
1.2.11 | issue#3335 | Unable to hide Device based Aggregate Graphs on Tree
1.2.11 | issue#3336 | Plugins need the ability to relax some content security policies in order to work properly
1.2.11 | issue#3340 | Undefined variable warning can appear when using 95th percentile graphs
1.2.11 | issue#3341 | MoTranslator does not appear to be handing null values properly
1.2.11 | issue#3345 | When attempting to refresh datetime picker, unexpected results can appear
1.2.11 | issue#3346 | When attempting to rewrite octet strings, extra space breaks pattern matching
1.2.11 | issue#3348 | When attempting to handle Orphans and/or Sync Graphs, results are not as expected
1.2.11 | issue#3349 | Prevent setting the PHP variable max_input_vars since it is read only
1.2.11 | issue#3350 | When editing a data source template, inconsistent results can be seen due to database query
1.2.11 | issue#3355 | When viewing raw graph data via the GUI, values are not always calculated correctly
1.2.11 | issue#3357 | Tree Search textbox resizes to 0 in some cases
1.2.11 | issue#3360 | When using guest accounts, after several timeouts result in refreshes, guest becomes logged out
1.2.11 | issue#3363 | The current user and user group permissions pages are not responsive
1.2.11 | issue#3367 | When Data Queries timeout, data is removed from the Host SNMP Cache table causing issues
1.2.11 | issue#3368 | Saving a Graph Template Item fails due to missing includes
1.2.11 | issue#3373 | When logging in via LDAP, ActiveDirectory would sometimes report insufficient access
1.2.11 | issue#3375 | When polling more often than default period of collecting data, distribution of collected data was not occurring
1.2.11 | issue#3376 | Improve speed when recovering from a poller from offline state
1.2.11 | issue#3378 | When attempting to check whether to include MoTranslator, typo makes it appear unavailable
1.2.11 | issue#3380 | php error when trigger threshold sendmail
1.2.11 | issue#3386 | Second data collector shows as running when its has no items to gather
1.2.11 | issue#3387 | Minor corrections to CSRF Magic
1.2.11 | issue#3388 | Naming of CLI programs does not always match name used within syntax usage advice
1.2.11 | issue#3390 | Incorrect breadcrumb bar if current tab is not "Graphs"
1.2.11 | issue#3402 | Cacti scores low on performance audit on lighthouse audit
1.2.11 | issue#3408 | CSRF Secret path is not passed properly when attempting to initialize secret
1.2.11 | issue#3409 | Issues with navigation link activations to other base Cacti pages
1.2.11 | issue#3410 | Zoom looses focus in advanced mode while crossing chart border
1.2.11 | issue#3411 | When upgrading a primary server, full synchronization is not happening as expected
1.2.11 | issue#3412 | When upgrading a primary server, automation templates are removed
1.2.11 | issue#3413 | When upgrading and choosing to upgrade your packages, installer finishes without package data in log
1.2.11 | feature#1551 | Allow system uptime to be a variable for use with graphs
1.2.11 | feature#1990 | Plugin Realm should have a 'role' to help maintain changes between plugins
1.2.11 | feature#2110 | Add Refresh Interval to Data Collectors display
1.2.11 | feature#2156 | Add Location based filtering
1.2.11 | feature#2236 | Allow for Purging of Data Source Statistics from the GUI
1.2.11 | feature#2268 | Restore ability to duplicate a data profile
1.2.11 | feature#2534 | Enhance table navigation bars to support systems with larger number of items
1.2.11 | feature#2688 | Increase length of Graph Item 'value' field to support pango-markup better
1.2.11 | feature#3304 | Allow Basic Auth Accounts to be mapped by CSV file
1.2.11 | feature#3366 | Make form elements under checkbox_groups flow using flex grid style
1.2.11 | feature#3374 | Set the domain attribute to secure cookies for the 'remember me' option
1.2.11 | feature#3403 | Enhance the "Graph Debug Mode" to display RRDtool Command lengths and excess warnings
1.2.10 | security#3285 | When guest users have access to realtime graphs, remote code could be executed (CVE-2020-8813)
1.2.10 | issue#3240 | When using User Domains, global template user is used instead of the configured domain template user
1.2.10 | issue#3245 | Unix timestamps after Sep 13 2020 are rejected as graph start/end arguments
1.2.10 | issue#3246 | When upgrading with remote collectors, sync status does not always return properly
1.2.10 | issue#3250 | When PHP memory limit is set to -1, recommendation value fails
1.2.10 | issue#3253 | Upgrade can stall when checking permissions on csrf-secret.php
1.2.10 | issue#3254 | Installer shows script owner rather than running user for suggested chown command
1.2.10 | issue#3266 | When setting User Groups to 'Defer to the User', setting can lead to user being told they have no permissions
1.2.10 | issue#3269 | When searching Graphs under a Chinese language, an unexpected error as sometimes shown
1.2.10 | issue#3274 | When editing a tree, multiple device drag/drop does not work
1.2.10 | issue#3276 | When spine aborts, script server can be left wanting or generating unnecessary logs
1.2.10 | issue#3277 | When boost does not find an initial time, numeric errors can be raised
1.2.10 | issue#3281 | When changing Graph Template options, incorrect image format may be selected
1.2.10 | issue#3282 | Graph's can be sized incorrectly if image is SVG format
1.2.10 | issue#3283 | When setting a file path, valid characters not recognised properly
1.2.10 | issue#3287 | When using graph template 'Cacti Stats - User Logins', an incorrect count of invalid users can be seen
1.2.10 | issue#3288 | When on Device page, pressing 'Go' on the filter caused Device New menu pick to appear
1.2.10 | issue#3289 | When using CMD.PHP, poller id is not always shown properly
1.2.10 | issue#3290 | When using CMD.PHP, inconsistent device logging levels may occur
1.2.10 | issue#3298 | When initialising fields in JavaScript, text/textarea elements have width set to zero if it is hidden by parent
1.2.10 | issue#3302 | Editing a Graph Template does not show the Data Template name
1.2.9 | security#3191 | Lack of escaping on some pages can lead to XSS exposure (CVE-2020-7106)
1.2.9 | security#3201 | Remote Code Execution due to input validation failure in Performance Boost Debug Log (CVE-2020-7237)
1.2.9 | issue#2937 | Devices still show in lists despite being deleted
1.2.9 | issue#3038 | When editing an aggregate on smaller screens, layout may not be correct
1.2.9 | issue#3136 | Upgrade may fail between 1.2.7 and 1.2.8 if incompatible database format used
1.2.9 | issue#3142 | Chrome sets graphs tree navigation view to width 0px
1.2.9 | issue#3146 | Unable to create aggregate graphs on new installations
1.2.9 | issue#3149 | After refresh of page, tooltips stop working
1.2.9 | issue#3150 | When using Time Graph View, Zooming can cause errors
1.2.9 | issue#3151 | Passing glue string after array is deprecated in PHP 7.4
1.2.9 | issue#3155 | Aggregate does not correctly follow color template when reordered
1.2.9 | issue#3156 | On new installs, gprint_format was missing from table aggregate_graphs
1.2.9 | issue#3157 | Back button not working properly with Classic theme
1.2.9 | issue#3158 | Classic theme show only 3 tabs on mobile device. Don't show Console menu
1.2.9 | issue#3159 | PHP Memory is not correctly identified when value is not in megabytes
1.2.9 | issue#3161 | When the poller_output_boost table is missing, recreate it before a poller run
1.2.9 | issue#3163 | When using RPMlint, Free Software Foundation address is shown to be incorrect
1.2.9 | issue#3165 | Zoom looses its focus after all graphs on page rendered
1.2.9 | issue#3166 | When changing zoom level, graphs are resized inappropriately at the end
1.2.9 | issue#3167 | Installer should initialize the csrf-secret.php file automatically
1.2.9 | issue#3168 | sqltable_to_php.php script does not pick up row_format
1.2.9 | issue#3177 | Remove legacy plugin hook that presents potential 3rd party security issues
1.2.9 | issue#3178 | The change password page is not displaying the rules
1.2.9 | issue#3180 | Receiving undefined index errors when working with some Data Queries
1.2.9 | issue#3181 | When configuration file is unreadable, Cacti shows database connection errors if non defaults are needed
1.2.9 | issue#3182 | When a database connection error occurs, there is no way to report actual error
1.2.9 | issue#3184 | Improve program path detection by using system path and PHP_BINDIR
1.2.9 | issue#3193 | Starting with MySQL 5.7 some sql_mode variables are required for some plugins
1.2.9 | issue#3196 | Minimize use of eval() in JavaScript due to emerging Content-Security-Context guidelines
1.2.9 | issue#3200 | Unable to mass change Graph Template image format in mass
1.2.9 | issue#3206 | Converted aggregate graph cannot be edited
1.2.9 | issue#3209 | Error occurs when Creating New Graphs through Automatically Added Devices using Sync Device Template
1.2.9 | issue#3216 | When editing a Data Source Profile size is shown as 'N/A'
1.2.9 | issue#3224 | When removing graphs by command line, regex is not properly validated when empty
1.2.9 | issue#3225 | Unable to Import Templates due to invalid dependency hash
1.2.9 | issue#3226 | When processing secpass login, failed logins are not recorded
1.2.9 | issue#3228 | Login page does not remember the last realm used by user
1.2.9 | issue#3232 | When editing HRULE and VRULE items, color selector was not presented
1.2.9 | issue#3233 | When working with non-templated graphs, it can be difficult to determine what items represent
1.2.9 | issue#3235 | Transient errors may occur with table poller_output_boost_arch
1.2.8 | security#3025 | CVE-2019-17357 When viewing graphs, some input variables are not properly checked (SQL injection possible)
1.2.8 | security#3026 | CVE-2019-17358 When deserializating data, ensure basic sanitization has been performed
1.2.8 | security#3066 | When using HTTPS, secure cookie to prevent potential weakness
1.2.8 | issue#1228 | Any tree or branch with a long name force main content off screen
1.2.8 | issue#2133 | Long snmp_indexes are being cut off
1.2.8 | issue#2888 | Long hostnames cause template filter to go off page
1.2.8 | issue#2987 | Changing Color Template does not update Aggregate
1.2.8 | issue#2989 | Allow Remote Data Collectors to maintain their own path variables
1.2.8 | issue#2991 | Cacti Statistics device template can generate unexpected errors
1.2.8 | issue#2995 | When editing a report, column setting may be ignored incorrectly
1.2.8 | issue#2996 | When editing a user, graph options do not properly reflect previously saved settings
1.2.8 | issue#2998 | Session performance issues due to excessive use for database storage
1.2.8 | issue#2999 | Blank arguments can lead to extra spaces in script arguments
1.2.8 | issue#3006 | Boost generates undefined variables warning during poller run
1.2.8 | issue#3011 | i18n logging does not check write permission exists
1.2.8 | issue#3012 | When viewing realtime graphs, some input variables are not properly checked
1.2.8 | issue#3013 | Allow legends to be modified for Aggregate Graphs
1.2.8 | issue#3017 | Automation network range with spaces fails validation
1.2.8 | issue#3019 | User selected language is not always adhered to
1.2.8 | issue#3021 | Tree view cuts off at the bottom of page on modern theme
1.2.8 | issue#3023 | When clicking highlighted tab, side panel is not always shown/hidden correctly
1.2.8 | issue#3027 | Aggregate Graph re-ordering does not work
1.2.8 | issue#3028 | When zooming a graph, unable to reach edge of graph without losing focus
1.2.8 | issue#3030 | Pace continues to run even after a page is finished rendering
1.2.8 | issue#3032 | Graphs may select MAX instead of AVERAGE as consolidation function even if there is no item with MAX present.
1.2.8 | issue#3035 | When editing a tree, can not remove entries due to CSS bug
1.2.8 | issue#3037 | When emptying poller output using cli, debug functions are not properly included
1.2.8 | issue#3039 | Allow packagers to be able to specify an alternate location of csrf-secret.php file
1.2.8 | issue#3040 | When running automation, discovery can still run even if cancelled
1.2.8 | issue#3041 | When running automation, scans do not always respond to being cancelled
1.2.8 | issue#3042 | When running automation, scan can fail when selecting remote pollers
1.2.8 | issue#3045 | When viewing Aggregate Graphs, an error due to undefined referrer may occur
1.2.8 | issue#3047 | When saving settings, ignore remote pollers who have not checked in recently
1.2.8 | issue#3050 | When viewing graph trees, some input variables are not properly checked
1.2.8 | issue#3052 | When editing CDEF's, slow database performance can occur
1.2.8 | issue#3053 | When viewing graph thumbnails, some input variables are not properly checked
1.2.8 | issue#3055 | During install/upgrade, database tests are not performed correctly
1.2.8 | issue#3059 | When using nth_percentile, correct value is not always returned if using MAX consolidation
1.2.8 | issue#3060 | When upgrading from older MySQL databases, format is not changed from compact to dynamic
1.2.8 | issue#3061 | When running automation, allow SNMP to be used as a ping method
1.2.8 | issue#3068 | When administrating users, some input variables are not properly checked
1.2.8 | issue#3070 | Improve database logging when a crashed table is encountered
1.2.8 | issue#3073 | Automation network range does not always produce the correct start/end values
1.2.8 | issue#3078 | When viewing graph debug from remote data collector, File Not Found warnings can appear incorrectly
1.2.8 | issue#3079 | Allow domain names to be stripped from a device's long description
1.2.8 | issue#3080 | Remote Agent throws warnings that graph_nolegend has not been sanitized
1.2.8 | issue#3085 | When editing a poller, ensure each listening IP is unique
1.2.8 | issue#3081 | External Links are not showing a glyph when they appear on the Console menu
1.2.8 | issue#3089 | When viewing graphs in realtime, undefined variable can be logged for 95th Percentile graphs
1.2.8 | issue#3099 | Graph template 'Linux - Memory Usage' has the wrong unit on its vertical_label
1.2.8 | issue#3101 | Polling times can be slightly inconsistent due
1.2.8 | issue#3104 | When viewing graphs, a byref error can be seen in the error logs
1.2.8 | issue#3105 | When viewing hosts, some input variables are not properly checked
1.2.8 | issue#3111 | When adding devices via command line, bad SNMP versions are not reported
1.2.8 | issue#3112 | When zooming on Graphs, too many requests are being made causing slowness
1.2.8 | issue#3114 | Support for USB devices that change name due to their hosts restarting
1.2.8 | issue#3118 | When converting tables, the dynamic row format should be selected
1.2.8 | issue#3119 | Main Data Collector should perform a Full Sync whenever it is installed/upgraded
1.2.8 | issue#3120 | Correct issues causing incompatibility with PHP 7.4
1.2.8 | issue#3121 | When converting tables during install, show what will be changed
1.2.8 | issue#3123 | Named colors table is not properly imported/upgraded
1.2.8 | issue#3124 | When a second data collector is added, boost is not enabled automatically
1.2.8 | issue#3128 | i18n handler checks for existence of wrong mo file
1.2.8 | issue#3129 | Logout repeated occurs even when already logged out
1.2.8 | issue#3132 | Installer fails to continue if automation range is array of networks
1.2.8 | issue#3098 | Support percent sign(%) in graph gprint item like legend area.
1.2.8 | feature#3077 | Allow disabling remote poller resource cache replication to support upgrade testing
1.2.7 | security#2964 | CVE-2019-16723 Security issue allows to view all graphs
1.2.7 | issue#1181 | When opening the Scheduler, it may appear off screen when opened near the bottom of a window
1.2.7 | issue#2894 | When using Remote Data Collectors, database information and recommendations may show Incorrect values
1.2.7 | issue#2895 | When using data sources from different RRDs, Percentile calculation may be incorrect
1.2.7 | issue#2899 | When displaying a form, variable substitution may not always work as expected
1.2.7 | issue#2922 | When running a data query, the result may come back as undefined
1.2.7 | issue#2925 | When using consolidation functions, retrieving the first step can cause errors
1.2.7 | issue#2926 | When editing a graph, variable validation errors may prevent changes from being saved
1.2.7 | issue#2929 | Boost performance may become poor even in single server mode
1.2.7 | issue#2930 | RRDtool can generate errors to standard output which can corrupt images
1.2.7 | issue#2932 | When RRDTool generates an error creating an image, it is not always reportedly properly
1.2.7 | issue#2936 | Installer will loop when number of tables exceeds PHP's max_input_vars limit
1.2.7 | issue#2938 | Under CentOS packages, upgrade_database.php script uses incorrect location for DB upgrade scripts
1.2.7 | issue#2940 | Images are not always properly sized until the page size changes
1.2.7 | issue#2949 | Order icons may not be properly aligned
1.2.7 | issue#2951 | Allow legends to be modified for Aggregate Graphs
1.2.7 | issue#2958 | Drop down autocomplete lists do not always open as expected
1.2.7 | issue#2961 | When syncing device templates, undefined function may be raised
1.2.7 | issue#2963 | When running ss_cpoller script, avgTime incorrect returns maxTime
1.2.7 | issue#2966 | Realtime popup windows do not always honor settings
1.2.7 | issue#2967 | When using Spikekill, gap and range fill are not operating as expected
1.2.7 | issue#2970 | When a user edits their profile, buttons may appear as unusable whilst still being enabled
1.2.7 | issue#2973 | User menu does not always display properly on mobile devices
1.2.7 | issue#2974 | Script Server can raise unexpected warnings when 'arg_num_indexes' set but not found in data source
1.2.7 | issue#2975 | Datasource Debug does not properly handle European numbers in certain circumstances
1.2.7 | issue#2976 | Boost messages should be stored in their own log file
1.2.7 | issue#2977 | Data updates with past timestamps can cause boost errors
1.2.7 | issue#2978 | Moving hosts between data collectors is slow
1.2.7 | issue#2979 | Multi Output Fields are not parsed correctly
1.2.7 | issue#2984 | When checking SQL fields, value was not always primed
1.2.7 | issue#2986 | Selecting 'Devices' menu pick closes 'Management' menu
1.2.7 | feature#2943 | Allow all Data Queries of a device to be re-indexed at once
1.2.7 | feature#2952 | If device is down or threshold breached, highlight in tree view
1.2.7 | feature#2985 | Update phpseclib to 2.0.23
1.2.6 | issue#2794 | Graph template not saved on graph edit
1.2.6 | issue#2825 | "innodb_doublewrite = off" possibly dangerous recommendation
1.2.6 | issue#2829 | PHP recommendations always see memory limit as unlimited
1.2.6 | issue#2830 | Disabled Top/Bottom external links should not be displayed
1.2.6 | issue#2832 | Install/Upgrade log does not show anything
1.2.6 | issue#2833 | Undefined index can occur when data source does not have an snmp_index
1.2.6 | issue#2834 | Boost performance drops on very large systems
1.2.6 | issue#2835 | When creating graphs and inneficient query is causing long creation times
1.2.6 | issue#2837 | Sunrise theme does not render checkboxes 100% correctly
1.2.6 | issue#2838 | jQueryMultiselect does not match upstream due to forking
1.2.6 | issue#2839 | Non regular expression search filters don't support international characters
1.2.6 | issue#2841 | Total count is wrong after searching for External Link pages
1.2.6 | issue#2843 | DSStats reruns Daily Aggregation every minute
1.2.6 | issue#2844 | Autocomplete settings for passwords are not properly defined
1.2.6 | issue#2845 | Data Template can't be edited when it is in use
1.2.6 | issue#2846 | Allow tooltips for section headers with 'question' icon
1.2.6 | issue#2847 | Permanently convert an Aggregate to a regular graph
1.2.6 | issue#2848 | Aggregate graphs get clipped due to incorrect date range
1.2.6 | issue#2856 | Aggregate issues with very long RRDtool command lines
1.2.6 | issue#2857 | When trying to find the best index to use, a 'must implement Countable' warning appears
1.2.6 | issue#2860 | When testing remote poller connections during install, undefined variable warning can occur
1.2.6 | issue#2862 | Automation does not calculate network information correctly for single hosts
1.2.6 | issue#2866 | Add poller ID to subject for admin notifications
1.2.6 | issue#2869 | When creating aggregates from Graphs, JavaScript issues can occur
1.2.6 | issue#2872 | Add support for MySQL 8 and use of grouping as name for a column
1.2.6 | issue#2875 | Undefined variable when removing spikes in some cases
1.2.6 | issue#2877 | When attempting to send report, undefined function 'get_tinespan' messages appear
1.2.6 | issue#2878 | Function get_magic_quotes_gpc() is now deprecated in PHP 7.4
1.2.6 | issue#2879 | Switching from authPriv to authNoPriv produces error when saving
1.2.6 | issue#2884 | Replication continues to occur when poller has been disabled by sysres-dev
1.2.6 | issue#2891 | Script server script ss_fping.php generates error when not called by script server
1.2.6 | issue#2901 | Poller overrun warning message is badly worded
1.2.6 | issue#2902 | Mailer incorrectly reports it is sending to noone
1.2.6 | issue#2903 | PHP recommendations can generate a warning causing JSON issues
1.2.6 | issue#2905 | Sorting plugins by version can lead to unexpected ordering
1.2.6 | issue#2907 | SSL column for multiple pollers can be incorrectly set causing SQL errors
1.2.6 | issue#2908 | When URL_PATH is blank, it should assume that it is '/'
1.2.6 | issue#2909 | Correct usage of affect vs effect in strings
1.2.6 | issue#2910 | Can not show user menu when in portrait mode on mobile devices
1.2.6 | issue#2911 | Graph variables are not always encoded to JSON properly resulting in warnings
1.2.6 | issue#2912 | Navigation cache can sometimes be corrupted resulting in a non-array value
1.2.6 | issue#2913 | When adding new graphs, the type of graph is not remembered
1.2.6 | issue#2917 | Action icons next to graphs can sometimes become unselectable due to zoom
1.2.6 | issue#2919 | When refreshing menu, selected items are sometimes lost and submenu items can become hidden
1.2.5 | issue#1978 | Popup Menus can appear off screen when using Graph Thumbnails
1.2.5 | issue#2282 | Installation wizard does not detect RRDtool version correctly
1.2.5 | issue#2524 | When editing a tree, Drag and Drop of Devices does not always work as expected
1.2.5 | issue#2573 | Associated Graph Template for Data Query can sometime disappear
1.2.5 | issue#2656 | GPRINT text_format does not replace Data Query and Host Fields
1.2.5 | issue#2661 | Automation does not always calculate network range/subnet correctly
1.2.5 | issue#2663 | Some legacy Data Queries can not determine their index order causing broken graphs
1.2.5 | issue#2674 | Large strings can sometimes cause language translation can fail
1.2.5 | issue#2719 | Automation may sometimes create empty graphs
1.2.5 | issue#2721 | When replacing '|input_xxxx|' strings, undefined index can occur
1.2.5 | issue#2722 | Calls to \_db_replace() are not consistent resulting in warnings
1.2.5 | issue#2723 | When replicating to remote pollers, Undefined Variable errors may be seen
1.2.5 | issue#2724 | When graphing HRULE items, 'Only Variables should be passed by reference' error may be seen
1.2.5 | issue#2725 | When viewing logs in utilities, filenames should be limited the same as clog
1.2.5 | issue#2726 | During Automation logging, include the Rule ID that triggers the creation of an item by xmacan
1.2.5 | issue#2732 | When using basic authentication, automatically strip any @domain information
1.2.5 | issue#2734 | Allow non-english labels to be used on Graph Templates
1.2.5 | issue#2727 | When using Polling Hosts Template, warnings can be issued when CMD.PHP is the poller
1.2.5 | issue#2733 | When processing SNMP data, space delimited hex strings do not always convert into MAC addresses
1.2.5 | issue#2735 | Mouse cursor should show as default pointer if column is not sortable
1.2.5 | issue#2736 | When using MySQL 8 or above, 'function' is considered a reserved word unless quoted by xmacan
1.2.5 | issue#2741 | Various errors can occur due to undefined or incorrect variable names
1.2.5 | issue#2742 | Various errors can occur due to undefined or incorrect variable names
1.2.5 | issue#2743 | Attempts to close a tooltip when no tooltip has been set may cause errors
1.2.5 | issue#2744 | When changing password, undefined index error can occur if user is not logged in
1.2.5 | issue#2748 | If PHP location setting is invalid during install/upgrade, this should be notified on modules page
1.2.5 | issue#2750 | When performing multiple sort, highlighting of content occurs
1.2.5 | issue#2751 | When editing a Tree, display filter may not allow 'All' option to work
1.2.5 | issue#2752 | When running verbose query on device, you are unable to copy text from items
1.2.5 | issue#2753 | Unable to copy entire verbose query using clipboard command
1.2.5 | issue#2757 | Page Navigation can be subject to XSS injection
1.2.5 | issue#2758 | Various sensitive directories are browsable if web server directory browsing is enabled
1.2.5 | issue#2760 | Unable to add items into a report
1.2.5 | issue#2762 | Creating an aggregate graph can sometimes fail due to unknown RRD tools error
1.2.5 | issue#2766 | When modifying Aggregate Templates, changes are not always cascaded to Graph
1.2.5 | issue#2768 | Aggregate Graphs may sometimes show the wrong row count
1.2.5 | issue#2770 | ItemType is not updated when saving Report Items
1.2.5 | issue#2772 | Add tooltip support to html_header() and html_header_checkbox()
1.2.5 | issue#2775 | Remote pollers may sometimes fail to replicate data back to main system
1.2.5 | issue#2777 | Attempting to edit a non-existent report generates an error
1.2.5 | issue#2778 | When rendering graphs, resizing can sometimes occur repeatedly
1.2.5 | issue#2779 | On new installations, automation rules for Interface Graphs are broken
1.2.5 | issue#2780 | Upgrade database script not actually upgrading Cacti
1.2.5 | issue#2782 | When replicating the syslog plugin, the configuration file is ignored causing errors
1.2.5 | issue#2783 | When limiting the number of displayed characters, international characters may sometimes display incorrectly
1.2.5 | issue#2784 | When removing a device with graphs but no data sources , errors are generated
1.2.5 | issue#2785 | When editing a graph rule, warnings incorrectly appear about unsaved changes
1.2.5 | issue#2792 | When a checkbox 'friendly name' has a comma, checkbox functionality stops working
1.2.5 | issue#2797 | When upgrading from before 1.x, SuperLinks view permissions may not be correct
1.2.5 | issue#2799 | Under heavy use of Real Time Graphs, SQL errors may start appearing
1.2.5 | issue#2800 | When editing a tree, using a comma in the search field stops search from working
1.2.5 | issue#2802 | If a Device lacks ifName, an alternative field is not always found even if available
1.2.5 | issue#2807 | When editing a Data Template that has dependant graphs, some attributes should not be modifiable
1.2.5 | issue#2808 | When navigating a tree, the layout may unexpectedly move
1.2.5 | issue#2814 | When viewing the utilities page, HTML tags may be seen rather than rendered
1.2.5 | issue#2816 | When viewing logs, paging does not always working correctly
1.2.5 | issue#2818 | Automation can sometimes incorrectly add duplicate devices with the same sysname
1.2.5 | issue#2820 | When path is blank, is_resource_writable() will generate 'Uninitialized string offset: -1'
1.2.5 | issue#2821 | When the desired locale can not be located, a number format issue may occur
1.2.5 | feature#2728 | Update phpseclib to 2.0.17 by DavidLiedke
1.2.5 | feature#2809 | Update c3.js & d3.js by DavidLiedke
1.2.5 | feature#2730 | Update jstree.js to 3.3.8 by DavidLiedke
1.2.5 | feature#2754 | Allow Devices, Graphs and Data Sources to be searched by ID
1.2.5 | feature#2765 | When editing a tree, allow cascading selection of available graphics
1.2.5 | feature#2805 | Merged plugins are not always upgraded correctly
1.2.5 | feature#2823 | Enhance the splice_rrd.php to be able to merge RRDfiles of differing step
1.2.4 | issue#2523 | Send A Test Email stops working under PHP 7.3
1.2.4 | issue#2589 | Missing RRDfile can cause DSSTATS to throw errors
1.2.4 | issue#2590 | When installing, chosen language is sometimes lost
1.2.4 | issue#2591 | Menu selection does not always match selected page/section
1.2.4 | issue#2592 | When viewing an aggregate graph, 'Display graphs from this aggregate' option does always not work
1.2.4 | issue#2593 | Unable to migrate aggregate graphs to matching aggregate template
1.2.4 | issue#2598 | Creating an aggregate graph without associated template causes RRDtool error
1.2.4 | issue#2599 | Creating/Updating an Aggregate Graph to use LINE/STACK's generates invalid SQL statements
1.2.4 | issue#2604 | When adding a dataquery, SQL errors can be generated
1.2.4 | issue#2605 | When installing, checking database tables can cause errors
1.2.4 | issue#2608 | db_update_table() function should not require an engine type or comment
1.2.4 | issue#2609 | When updating from earlier than 1.2, timezone column might not exist
1.2.4 | issue#2610 | Data Sources troubleshooter generates warning that each() function is deprecated
1.2.4 | issue#2612 | When RRDtool fails to initialize, DSStats generates lots of warnings
1.2.4 | issue#2618 | ifAdminStatus in snmp_queries/interfaces.xml
1.2.4 | issue#2621 | File paths that accept blanks are not allowing blanks
1.2.4 | issue#2622 | Various undefined variables generate errors within database.php
1.2.4 | issue#2623 | When using form_text_area(), invalid HTML can be generated
1.2.4 | issue#2627 | Some filenames can be lost in log file selection list
1.2.4 | issue#2629 | When upgrading, ldap library is not loaded properly due to incorrect paths
1.2.4 | issue#2632 | Automated Networks are not being properly replicated to additional pollers
1.2.4 | issue#2635 | When running automation scans, database connection should be forced to central database
1.2.4 | issue#2638 | Support disabling PHP SNMP extension by mhoran
1.2.4 | issue#2645 | Some URLs are incorrectly calculated
1.2.4 | issue#2649 | Automation not creating graphs when there are custom items
1.2.4 | issue#2650 | Several undefined variables are generating warnings
1.2.4 | issue#2662 | HRULE objects broken in some cases
1.2.4 | issue#2668 | Trailing parentheses are removed from the SNMP system description
1.2.4 | issue#2672 | Cacti Install on Windows Fails
1.2.4 | issue#2676 | Skin paper plane not working on iPhone XR
1.2.4 | issue#2678 | Call to undefined function \_() in data_queries.php
1.2.4 | issue#2679 | Users with passwords that do not meet complexity requirements are not redirected to the Change Password page
1.2.4 | issue#2680 | Remove deprecated $php_errormsg usage
1.2.4 | issue#2689 | Increase boost maximum memory limits
1.2.4 | issue#2693 | Graph links do not contain URL path causing links to fail
1.2.4 | issue#2698 | Avoid duplicated icon in the main.js of all themes
1.2.4 | issue#2699 | Login option "Show the page that user pointed their browser to" does not work properly
1.2.4 | issue#2702 | sqltable_to_php.php does not always generate valid table data arrays
1.2.4 | issue#2707 | Some pages that have permission errors dont raise proper messages
1.2.4 | issue#2712 | PHP memory should be unlimited in scripts that need more memory than the default
1.2.4 | issue#2713 | SNMP System Description with UTF8 strings properly are not properly parsed
1.2.4 | issue#2718 | When links are converted to ajax calls, mailto links should not be included
1.2.4 | issue#2720 | When calculating percentiles, the value is incorrect as the steps are not placed in correct order
1.2.4 | issue#2822 | When stderr log file is not populated, clog generates 'empty needle' error
1.2.4 | feature#2538 | Allow users to change default method of removing data sources when deleting graphs
1.2.4 | feature#2539 | Allow users to set the default graph lock status
1.2.4 | feature#2540 | Allow users to enable/disable graph tree history
1.2.4 | feature#2646 | Allow application of automation rules on CLI by rb83
1.2.4 | feature#2654 | New hook to notify plugins of user profile changes ('auth_profile_update_data')
1.2.4 | feature#2664 | Add option to purge spikekill backups
1.2.4 | feature#2701 | Provide option to continue graphing objects that loose their index
1.2.4 | feature#2704 | Device and template cache do not refresh properly
1.2.3 | issue#1063 | Tree View does not display the last item correctly under 'Modern' theme
1.2.3 | issue#2282 | Install Wizard does not Detect RRDtool Version on Windows
1.2.3 | issue#2430 | "New Device" menu item showing as selected incorrect when "Devices" clicked
1.2.3 | issue#2435 | Tree View becomes narrower and narrower when expanding/collapsing nodes with long names
1.2.3 | issue#2449 | Index incorrectly changed to 1 if the index is alphanumeric when OID/REGEXP: or OIDVALUE/REGEXP:
1.2.3 | issue#2452 | Missing 'getSNMPQueries()' function when calling add_data_query.php
1.2.3 | issue#2453 | When running add_graphs.php, cannot retrieve list of valid snmp values
1.2.3 | issue#2460 | sqltable_to_php.php does not export 'default' value of columns correctly
1.2.3 | issue#2456 | When attempting to display actions that can be taken, having no actions caused error
1.2.3 | issue#2457 | When creating a graph, undefined function prevents confirmation from appearing
1.2.3 | issue#2459 | ss_host_disk.php attempts to return an empty array instead of a string
1.2.3 | issue#2463 | Partial Fix: Display zombie data sources without graphs
1.2.3 | issue#2464 | When viewing a User's effective permissions, disabled devices should show denied
1.2.3 | issue#2465 | Too many groups hide effective permission column when viewing User's effective permissions
1.2.3 | issue#2466 | Manual data source creation is broken
1.2.3 | issue#2469 | When using Matching Objects filter within Automation Graph Rules, unexpected redirect occurs
1.2.3 | issue#2471 | When Creating a new Graph Template, clear the Graph Template permissions cache
1.2.3 | issue#2472 | Bad navigation items cause Array to string conversion errors
1.2.3 | issue#2474 | REGEXP_SNMP_TRIM does not handle Gauge fields properly
1.2.3 | issue#2475 | When resetting filters, multiple sort session variables do not always reset properly
1.2.3 | issue#2476 | When using CMD.PHP for polling, device polling time is not updated
1.2.3 | issue#2477 | When saving a Data Input Method, Output Field name changes to incorrect value
1.2.3 | issue#2478 | When saving a LINEX type Graph Item, the Line Width value is too restrictive
1.2.3 | issue#2479 | RPN function select list should be sorted when editing CDEF and VDEF's
1.2.3 | issue#2480 | RRDtool versions in Cacti not granular enough
1.2.3 | issue#2482 | When upgrading past 1.1.34, upgrade attempts to drop a non-existing primary key
1.2.3 | issue#2491 | Data Source Info suggests commands RRDTool can't honor
1.2.3 | issue#2492 | When data templates are filtered by profile, data source list does not get same filter applied
1.2.3 | issue#2493 | Data Source Info is not separated properly
1.2.3 | issue#2494 | User Login History is not fully enabled for translations
1.2.3 | issue#2497 | When linking to Graphs, unless both start and end are specified, only defaults are used
1.2.3 | issue#2499 | Data Source reapply names does not update name from data query or template.
1.2.3 | issue#2500 | Allow Data Source repairs from the Data Source Debug and Data Source Info pages
1.2.3 | issue#2502 | Unable to have a min or max value for RRDfile at zero '0'
1.2.3 | issue#2503 | The Cacti Statistics Device Template is not include in release
1.2.3 | issue#2509 | When checking for correct Unicode, minimum MySQL version is incorrect
1.2.3 | issue#2513 | When a plugin INFO file is malformed or missing elements, plugin_load_info_file() should fill missing elements with defaults
1.2.3 | issue#2519 | When editing a data query, graph template picker shows poor performance
1.2.3 | issue#2518 | Unexpected errors when filtering Data Sources with invalid 'rows' value
1.2.3 | issue#2522 | When upgrading from pre-1.0.0, colors were not upgraded properly by Givo29
1.2.3 | issue#2525 | Tree branches that includes sites which have valid devices do not appear on Graph Tree
1.2.3 | issue#2527 | When importing a package, if Cacti version is below the version which that exported, a clear message should be shown
1.2.3 | issue#2531 | When updating color template items, the table name used is incorrect by Givo29
1.2.3 | issue#2532 | Ensure Graph ListView table is displayed in line with Management -> Graphs
1.2.3 | issue#2535 | Ensure Graph ListView uses same UI logic as Graph Management -> Graphs
1.2.3 | issue#2537 | Incorrect title showing when changes are made to Tree
1.2.3 | issue#2543 | Poor performance showing a device's graphs on a tree
1.2.3 | issue#2547 | RRD values are not being properly trimmed
1.2.3 | issue#2551 | When checking MySQL configuration values, consider ON/OFF to be equal to 1/0
1.2.3 | issue#2553 | When upgrading from 1.0.0 or below, renaming automation columns can cause issues
1.2.3 | issue#2555 | Missing configuration defaults prevent installations/upgrades without showing reason
1.2.3 | issue#2563 | When sorting Data Sources, missing index causes unnecessary delays
1.2.3 | issue#2564 | Filtering for Orphan Data Sources is unreliable
1.2.3 | issue#2565 | Pages with 500+ selectable items in a single able can suffer from poor performance
1.2.3 | issue#2568 | When querying for diagnostic data, devices on remote pollers should proxy the request
1.2.3 | issue#2571 | External Links do not properly validate user permissions
1.2.3 | issue#2575 | Poller errors occur if a file exists that the website cannot read
1.2.3 | issue#2576 | Spikekill API does not work when called from plugins
1.2.3 | issue#2578 | When importing packages, missing/new resources are not created
1.2.3 | issue#2581 | When viewing poller cache, Device SNMP community is not properly escaped
1.2.3 | issue#2583 | When JSON module is not installed, Installer does not correctly show missing message
1.2.3 | issue#2584 | When user/group permissions are reset, this is not reflected immediately to the end user
1.2.3 | feature#2505 | Improve performance of Data Source Statistics
1.2.3 | feature#2515 | Allow more than one SNMP port to be specified when adding devices via CLI
1.2.3 | feature | Update phpseclib to version 2.0.15
1.2.3 | feature | Adjust the max table rows based upon value of 'max_input_vars'
1.2.2 | issue#599 | Aggregate graph templates assume AVG consolidation function
1.2.2 | issue#2312 | Retrieving Device Information appears to fail on Safari
1.2.2 | issue#2317 | Unabe to add new records to 'poller_time' table
1.2.2 | issue#2327 | Memory exhausted whilst running poller replication
1.2.2 | issue#2334 | Some browsers report JavaScript errors when switching to console
1.2.2 | issue#2337 | When running an upgrade, the path of the log file is reset
1.2.2 | issue#2339 | Certain characters in recipient address can cause email to fail
1.2.2 | issue#2343 | Export hooks no longer work due to missing default keyword
1.2.2 | issue#2346 | When listing plugin permissions, "Legacy 1.x Plugins" can appear in the wrong cell
1.2.2 | issue#2347 | Allow sort output to inject returned data into a specific object
1.2.2 | issue#2350 | Unable to Select Data Source for HRULES and COMMENTS that include nth Percentile and Bandwidth
1.2.2 | issue#2352 | SNMP description field can sometimes contain mangled data
1.2.2 | issue#2354 | When reindexing in Automation, titles are not updated for Graph and Data Source
1.2.2 | issue#2355 | Data Sources are sometimes duplicated when Custom Data is specified
1.2.2 | issue#2357 | When indexes are incorrect, poller should log more information
1.2.2 | issue#2359 | When upgrading, "Install/Upgrade" privilege may have been previously lost
1.2.2 | issue#2360 | When retrieving database / table / column information, schema name is not always applied
1.2.2 | issue#2362 | No way to default an interface speed when ifSpeed and ifHighSpeed come back as zero
1.2.2 | issue#2365 | When editing Aggregate Graphs, orphaned items were not always removed
1.2.2 | issue#2372 | Data Query reindexing leads gaps in Graphs
1.2.2 | issue#2376 | Manually adding a device discovered by Automation causes errors to be logged
1.2.2 | issue#2380 | Devices may experience constant reindexing
1.2.2 | issue#2384 | When authentication method is set to None, change to Builtin as None has been removed
1.2.2 | issue#2393 | When reindexing a device, Graph Automation creates duplicate graphs every time
1.2.2 | issue#2416 | SELinux wants APPEND not WRITE permission for Fedora/EPEL (RHEL, Centos)
1.2.2 | issue#2419 | Host state time was not correctly calculated
1.2.2 | issue#2426 | Reinstate missing plugin hooks for 'custom_logout_message' and 'custom_denied'
1.2.2 | issue#2431 | Default value for 'Mail Method' (settings_how) is incorrect resulting in errors
1.2.2 | issue#2432 | Undefined variable warnings when updating RRD data
1.2.2 | issue#2451 | Drag and drop does not always function correctly
1.2.2 | feature | Update JavaScript library c3.js to version 0.6.12
1.2.2 | feature | Update phpseclib to version 2.0.14
1.2.2 | feature | Update PHPMailer to version 6.0.7
1.2.2 | feature | Update JavaScript library d3.js to version 5.9.1
1.2.1 | issue#2259 | Unable to View Aggregate Graphs
1.2.1 | issue#2267 | Remove unnecessary includes in aggregate template code
1.2.1 | issue#2270 | Realtime Graphs consuming too much memory
1.2.1 | issue#2272 | Site Tree Branches not showing Graphs
1.2.1 | issue#2273 | Error when saving changes to Data Collectors
1.2.1 | issue#2279 | SQL Errors in add_graphs.php
1.2.1 | issue#2280 | SQL Errors in snmpagent cache table inserts
1.2.1 | issue#2281 | Database audit cli giving incorrect results
1.2.1 | issue#2285 | Allow HRULEs for bandwith and ptile
1.2.1 | issue#2292 | Allow Realtime to use 1 second data collection
1.2.1 | issue#2298 | Ambiguous Toggle Switches in Sunrise Theme
1.2.1 | issue#2303 | Problem with "Notify Primary Admin of Issues" function
1.2.1 | issue#2304 | Installation progress stays at 0%
1.2.1 | issue#2305 | BOOST PROGERR: ERRNO:'8'
1.2.1 | issue#2311 | Unable to update PHP location during installation due to incorrect CLI environment
1.2.1 | issue#2319 | Primary admin account not always given access to a plugin when that plugin is enabled
1.2.1 | issue#2321 | Date separator not being used properly for graphs
1.2.1 | issue#2322 | Modifying plugin realm registration files and description not supported
1.2.1 | issue | Installer does not identify when shell_exec()/exec() are disabled
1.2.1 | issue | Removing a Device or Graph Template can not be seen till next login
1.2.1 | issue | Visual issues with custom data when using paper-plane theme
1.2.1 | issue | Undefined function errors attempting to sync device templates
1.2.1 | issue | Plugin dependency handling inconsistant
1.2.1 | issue | Editing a report shows incorrect graphs from dropdown
1.2.0 | feature | Add a Timeout setting for Remote Agent calls
1.2.0 | feature | Add Graphs and Data Sources hyperlinks on Device page
1.2.0 | feature | Add One Minute Sampling to the default Data Source Profiles
1.2.0 | feature | Add support for DDERIVE and DCOUNTER to Cacti
1.2.0 | feature | Add Timezone support for Remote Data Collectors
1.2.0 | feature | Allow Adding Aggregate Graphs to a Report
1.2.0 | feature | Allow ASCII filepath paths to not be found on settings save
1.2.0 | feature | Allow drill down from Graphs to Data Queries or Templates
1.2.0 | feature | Allow Import/Export to be hookable
1.2.0 | feature | Allow snmpagent to be disabled for very large installs
1.2.0 | feature | Allow Top tabs to be Glyphs or Text or both
1.2.0 | feature | Big Spanish translation update plus massive QA fixes
1.2.0 | feature | Change password page provides visible confirmation of password rules
1.2.0 | feature | Do not allow second data source to be added to an SNMP Get data template
1.2.0 | feature | Don't allow removal of Data Sources from Data Template once its in use
1.2.0 | feature | Inform the primary Cacti administrator of problems by Email
1.2.0 | feature | Make all user settings dynamic and allow resetting to default.
1.2.0 | feature | Make Graph and Data Source suggested naming more efficient
1.2.0 | feature | Make it easy to find Data Query based graphs that have lost indexes
1.2.0 | feature | Make Top Tabs use Ajax Callback
1.2.0 | feature | Make tree editing responive
1.2.0 | feature | New Install/Upgrade user permission to limit access to being able to upgrade
1.2.0 | feature | Provide option to debug width errors where output exceeds column width
1.2.0 | feature | Removed the Authentication Method of 'None'
1.2.0 | feature | Tree automation is now defaulted to on for new install
1.2.0 | feature | Update JavaScript library c3.js to version 0.6.8
1.2.0 | feature | Update JavaScript library Chart.js to 2.7.3
1.2.0 | feature | Update JavaScript library d3.js to version 5.7.0
1.2.0 | feature | Update JavaScript library jquery.js to 3.3.1
1.2.0 | feature | Update JavaScript library jquery-migrate.js to 3.0.1
1.2.0 | feature | Update JavaScript library jquery.tablesorter.js to version 2.30.7
1.2.0 | feature | Update JavaScript library jstree.js to 3.3.7
1.2.0 | feature | Update JavaScript library screenfull.js to 3.3.3
1.2.0 | feature | Update phpmailer to version 6.0.6
1.2.0 | feature | Update phpseclib to version 2.0.13
1.2.0 | feature#289 | Allow external nologin access for Realtime Graphs
1.2.0 | feature#553 | When display a host, include Aggregated Graphs as well as standard graphs
1.2.0 | feature#614 | Allow users to duplicate Data Input Methods
1.2.0 | feature#973 | When creating a new user authenticated via LDAP, attempt to retrieve users email and full name
1.2.0 | feature#122 | Support a Site Branch Type
1.2.0 | feature#1060 | Design Enhancement for Large scale Cacti Implementations
1.2.0 | feature#1142 | Add Site dropdown to the Graphs and Data Source pages
1.2.0 | feature#1184 | Improve Data Input Methods editability and message handling
1.2.0 | feature#1200 | Aggregate Graphs can now include COMMENT
1.2.0 | feature#1282 | Email notification for Automation Network discovery process
1.2.0 | feature#1347 | Update automation logging to work better
1.2.0 | feature#1395 | Ensure messages have each new line keep the same prefix in cacti_log()
1.2.0 | feature#1399 | Allow 'requires' to include version against a plugin
1.2.0 | feature#1400 | User settings are now dynamic and can be reset (removed) to return to global settings
1.2.0 | feature#1422 | Automatically select the next unused data input field when clicking add on data input method
1.2.0 | feature#1505 | When displaying a graph, provide breadcrumb link to edit device
1.2.0 | feature#1527 | Update Fontawesome from 4.7 to 5.0.10
1.2.0 | feature#1580 | Support Drag & Drop for Builtin Report Items
1.2.0 | feature#1581 | Allow Mass Adding of Graphs to Reports
1.2.0 | feature#1584 | Allow theme selection when installing
1.2.0 | feature#1588 | Check that PHP can run a test file
1.2.0 | feature#1593 | Allow External links to auto refresh
1.2.0 | feature#1597 | Ensure synchronised files have same attributes as originals
1.2.0 | feature#1610 | On Unix, redirect error messages to log files when running external scripts
1.2.0 | feature#1628 | Allow the User to define an initial Automation Network for discovery when installing
1.2.0 | feature#1670 | Improve Graph Management to show type of source for a graph
1.2.0 | feature#1671 | When duplicating a Graph Template, properly duplicate Data Query Graph Template Mappings
1.2.0 | feature#1677 | Default Tree nodes sorting to be inherited
1.2.0 | feature#1691 | On Graph context menu, add a 'Copy graph' option to copy graph image
1.2.0 | feature#1692 | Separate option for logging Input Validation issues
1.2.0 | feature#1703 | On Graph context menu, text is now multi-lingual
1.2.0 | feature#1708 | Allow the User to override global Automation email recipients at the Automation Network level
1.2.0 | feature#1709 | Suppress warning from RRDTool when attempting to make updates in the past
1.2.0 | feature#1711 | Add support for SSL connections to MySQL
1.2.0 | feature#1731 | Prevent loss of changes by warning user about unsaved items
1.2.0 | feature#1734 | When displaying a graph, provide more information when error image is displayed (see also #1428)
1.2.0 | feature#1763 | Enable automatic refresh for Time Graph View
1.2.0 | feature#1806 | Control low level debug routines via config.php (Develoepr Use)
1.2.0 | feature#1819 | Provide CLI program to enable graphs to be removed by scripts
1.2.0 | feature#1969 | Graph previews can now be linked using a host's external id
1.2.0 | feature#2006 | Introduce new Data Source Profile to handle decade long graphs
1.2.0 | feature#2173 | Introduce Device and Graph Template Caching to Speed UI
1.2.0 | feature#2228 | Add Device ID to Device search field
1.2.0 | issue | Fix issue with display_custom_error_message() causing problem with system error message handling
1.2.0 | issue | Graph List View was not fully responsive
1.2.0 | issue | Move Graph removal function to Graph API
1.2.0 | issue | On the Data Sources page, if there is no filtered Device and a Data Source is edited, device association is lost
1.2.0 | issue | Typo in Dutch translations when an error occurred while downgrading
1.2.0 | issue | Unable to display user profile tabs
1.2.0 | issue | Verify all Fields not working due to Cacti 1.x upgrade error
1.2.0 | issue#186 | Cacti does not support jQueryUI 1.12.x
1.2.0 | issue#187 | Remove the use of jQuery Migrate plugin
1.2.0 | issue#948 | Do not create a new datasource when adding a new Graph for the same device/field
1.2.0 | issue#454 | Cacti Re-Index does not resolve index changes properly during re-index
1.2.0 | issue#983 | Import Template Preview is misleading
1.2.0 | issue#1097 | When copying template user, newly created user should always be enabled to allow logging in
1.2.0 | issue#1097 | When copying template user, it should be disable to prevent logging in as template user directly
1.2.0 | issue#1174 | When display a tree, disable drag and drop unless in edit mode
1.2.0 | issue#1298 | Display fatal error to prevent issues caused when system log is not writable
1.2.0 | issue#1350 | When switching an Automation Tree Rule's leaf type, remove invalid Automation Rule Items
1.2.0 | issue#1383 | CSRF Timeout does not obey session timeout
1.2.0 | issue#1408 | Update SQL / Backtrace to use new clean_up_lines() function
1.2.0 | issue#1414 | DSSTATS reports incorrectly that a data source does not exist
1.2.0 | issue#1420 | Fix issues found by Debian package builds
1.2.0 | issue#1421 | Fix issue when SQL had all bad modes, missing variable warning was generated
1.2.0 | issue#1426 | Fix issue where remote poller was not using unique filenames when attempting to verify files
1.2.0 | issue#1437 | Plugin install hover message sometimes shows line breaks rather than formatted text
1.2.0 | issue#1454 | When using oid_regexp_parse, filter indexes to those that match
1.2.0 | issue#1473 | Recovery Date overwritten by subsequent checks
1.2.0 | issue#1494 | Unable to Deep Link/Bookmark Trees
1.2.0 | issue#1503 | Undefined function clearstatscache in DSSTATS
1.2.0 | issue#1507 | When saving graph settings from the graph page, the graph template id should not be included
1.2.0 | issue#1510 | New Graphs Undefined Variable $graph_template_name
1.2.0 | issue#1521 | Force boost to be enabled when there are Remote Data Collectors
1.2.0 | issue#1528 | Saving a device can result in WARNINGS related to string vs array handling
1.2.0 | issue#1529 | Allow Aggregate Graphs to Sum Bandwidth and Percentile COMMENTS
1.2.0 | issue#1543 | Graph Preview appends header=false too many times
1.2.0 | issue#1553 | Poller does not set rrd_step_counter correctly if no steps taken
1.2.0 | issue#1559 | CLI Output Issues due to over escaping
1.2.0 | issue#1560 | Warning that escapeshellarg() is escaping a null
1.2.0 | issue#1567 | Technical support - add notification if Cacti and Spine version is different
1.2.0 | issue#1574 | User templates are not correctly being applied
1.2.0 | issue#1589 | Installer now checks that the temporary folder is writable
1.2.0 | issue#1590 | User Admin generates SQL error if user is not part of any groups
1.2.0 | issue#1601 | Aggregate Graphs can not include some classes of COMMENT
1.2.0 | issue#1602 | PHP ERROR: Call to undefined function api_data_source_cache_crc_update()
1.2.0 | issue#1604 | Failed to connect to remote collector
1.2.0 | issue#1606 | Boost debug log not functional
1.2.0 | issue#1607 | Boost next run time occurs in the past
1.2.0 | issue#1608 | Possible boost race conditions
1.2.0 | issue#1609 | Remote pollers update 'stats_poller' on main poller
1.2.0 | issue#1617 | Editing a data query results in missing $header variable
1.2.0 | issue#1621 | Realtime Popup can cause automatic logout
1.2.0 | issue#1626 | httpd-error.log have message about Fontconfig
1.2.0 | issue#1634 | Default snmp quick print setting resulting in false poller ASSERTS on some php releases
1.2.0 | issue#1651 | Check temporary folder has write access during import
1.2.0 | issue#1655 | Correct Cacti to handle new MySQL 8.0 reserved word `system`
1.2.0 | issue#1658 | Devices drop down should be filtered by Site
1.2.0 | issue#1660 | Reports based upon Tree don't maintain graph order
1.2.0 | issue#1665 | Must change password not working for local users when main realm is not local
1.2.0 | issue#1669 | Console log header grammar issue
1.2.0 | issue#1674 | Threads and Processes values not migrated to Poller table during upgrade
1.2.0 | issue#1676 | Allow automation discovery to add the same sysname on different hosts
1.2.0 | issue#1682 | Slow Select Statement lib/api_automation.php
1.2.0 | issue#1689 | Technical Support's RRDTool version should show detected RRD version
1.2.0 | issue#1690 | Report a warning if the default collation is not utf8mb4_unicode_ci
1.2.0 | issue#1700 | Mail sent without auth causes errors to appear in logs
1.2.0 | issue#1710 | RRDtool create command causes first update to fail
1.2.0 | issue#1721 | Console Side Bar not correct on first login
1.2.0 | issue#1723 | die() messages should include PHP_EOF for better logging
1.2.0 | issue#1726 | Poor page performance editing a Graphs Graph Items
1.2.0 | issue#1746 | Poller with no hosts does not exit until timeout is reached
1.2.0 | issue#1761 | Graph Management page shows bogus template names
1.2.0 | issue#1783 | Browser Back button still does not working
1.2.0 | issue#1796 | Import: Fixed handling of references to objects not included in file
1.2.0 | issue#1799 | Default User log sort should be date descending
1.2.0 | issue#1810 | Correct SQL errors with authentication set to no authentication
1.2.0 | issue#1839 | Dummy cosmetic bug on down device selection option
1.2.0 | issue#1841 | Data Source Stats table not properly migrated from pre 1.x Cacti plugin
1.2.0 | issue#1849 | SNMPAgent not sending traps
1.2.0 | issue#1852 | Reports Preview/Mails show no graphs
1.2.0 | issue#1889 | Insecure $ENV{ENV} which running setgid
1.2.0 | issue#1901 | Upgrade from 0.8.8h fails on external_links statement
1.2.0 | issue#1921 | Data Query XML field method 'rewrite_index' does not correctly query for value
1.2.0 | issue#1926 | Deselecting items should present warning or disable GO button
1.2.0 | issue#1948 | Device Template should warn about need to re-sync
1.2.0 | issue#1953 | set_default_action() should warn if more than one action provided
1.2.0 | issue#1973 | SpikeKill Menu does not display properly
1.2.0 | issue#1976 | Default admin permissions do not allow everything
1.2.0 | issue#1982 | Certain hooks should occur within api functions rather than UI functions
1.2.0 | issue#2002 | api_plugin_db_table_create should support non-string defaults
1.2.0 | issue#2012 | For kernel 3.2+, "Linux - Memory - Free" should grep for "MemAvailable:", not "MemFree:"
1.2.0 | issue#2085 | CLOG Regex Parser does not verify registered function exists
1.2.0 | issue#2126 | api_device.php generates undefined function poller_push_to_remote_db_connect()
1.2.0 | issue#2127 | Unable to save error when duplicating graph
1.2.0 | issue#2135 | api_tree_lock() and api_tree_unlock() forcing redirection incorrectly
1.2.0 | issue#2143 | export.php Illegal string offset 'method'
1.2.0 | issue#2144 | Device Management "Status" column does not sort properly
1.2.0 | issue#2152 | When editing a device, should show disable/enable option
1.2.0 | issue#2153 | Utilities page issues the wrong hook for tabs
1.2.0 | issue#2163 | LDAP functions are not consistent
1.2.0 | issue#2164 | Login page does not remember selected realm
1.2.0 | issue#2171 | datepicker and timepick translation not available
1.2.0 | issue#2178 | Header/Footer included more than once
1.2.0 | issue#2182 | Graph View missing 'html_graph_template_multiselect()' function
1.2.0 | issue#2184 | html_host_filter() does not handle host_id consequently
1.2.0 | issue#2186 | Boost generates invalid SQL during on demand update
1.2.0 | issue#2188 | SNMP timeout errors are being duplicated
1.2.0 | issue#2191 | i18n_themes is not properly primed in global_arrays.php
1.2.0 | issue#2202 | Can't create more than one graph with add_graphs.php from one template
1.2.0 | issue#2207 | Removing Graph Template does not Remove Data Query Associations
1.2.0 | issue#2217 | cmd.php not handling quoted snmp values properly
1.2.0 | issue#2240 | SNMP system Data Input Methods should not be modified on import
1.2.0 | issue#2241 | Spike removal not functional due to Debian packaging
1.2.0 | security#1072 | Prevent exploitation of Data Input Methods to escalate privileges (CVE-2009-4112)
1.2.0 | security#1882 | Bypass output validation in select cases
1.2.0 | security#2212 | Stored XSS in "Website Hostname" field
1.2.0 | security#2213 | Stored XSS in "Website Hostname" field - Devices
1.2.0 | security#2214 | Stored XSS in "Vertical Label" field - Graph
1.2.0 | security#2215 | Stored XSS in "Name" field - Color
1.1.38 | issue#1501 | cmd.php poller not stripping alpha from snmp get values
1.1.38 | issue#1515 | Special characters not rendered properly in settings
1.1.38 | issue#1530 | Inconsistent behaviour handling blank Field Name/Value when editing data query suggested values
1.1.38 | issue#1537 | Numeric validation not ignoring blank elements
1.1.37 | issue#274 | Allow Realtime Graph Popup Mode
1.1.37 | issue#1405 | When Data Query columns are wide, they cause rendering issues
1.1.37 | issue#1414 | DSSTATS reports incorrectly that a data source does not exist
1.1.37 | issue#1419 | Filtering log results in errors in the log
1.1.37 | issue#1420 | PHP NOTICE editing cdef and vdef items
1.1.37 | issue#1421 | CLI upgrade_database.php PHP Warning on execution
1.1.37 | issue#1426 | Remote poller erroring attempting to verify files
1.1.37 | issue#1432 | Delete confirmation does not disappear
1.1.37 | issue#1443 | Partial Save warnings under Settings -> Mail/Reporting/DNS
1.1.37 | issue#1447 | CLI audit_database.php not detecting database name, and failed to create audit tables when run fresh
1.1.37 | issue#1453 | CLI add_graph.php not allowing title to be set
1.1.37 | issue#1456 | Increase minimum php version maintaining support for RHEL6
1.1.37 | issue#1457 | Path-Based Cross-Site Scripting (XSS) issues
1.1.37 | issue#1458 | Error in logs when creating new graphs
1.1.37 | issue#1459 | Automation filter not applied correctly
1.1.37 | issue#1461 | Setting output_format on input type causes no values to be returned
1.1.37 | issue#1464 | Poller stuck in infinitely loop causing excess logging
1.1.37 | issue#1466 | No scrollbars in mobile browsers
1.1.37 | issue#1468 | Increase max length of host.snmp_sysObjectID column
1.1.37 | issue#1471 | Undefined function found in global_languages.php
1.1.37 | issue#1472 | Change Device Options - Style needs updating
1.1.37 | issue#1474 | Check possibility for creation of temporary tables on install
1.1.37 | issue#1487 | Undefined constant in ldap.php
1.1.37 | issue#1483 | Create New Graphs - Paw Styling Issue
1.1.37 | issue#1493 | Can't create tree branches with '#' sign
1.1.37 | feature#1489 | Add ability to use parts of OID as value via regex
1.1.37 | feature | Updated Chinese Simplified translations
1.1.37 | feature | Updated Dutch translations
1.1.37 | feature | JavaScript library Chart.js updated 2.7.2
1.1.37 | feature | Allow snmp formatting functions to detect UTF-8 output
1.1.36 | issue#934 | Template names missing in graph management list
1.1.36 | issue#1211 | CDEF and VDEF Item Edit do not use correct procedures
1.1.36 | issue#1250 | Language support does not support localization properly
1.1.36 | issue#1331 | Log Rotation should occur at midnight on system
1.1.36 | issue#1334 | Console->Users->(Edit) Permissions checkmark descriptions missing
1.1.36 | issue#1336 | Debian test suite reports php error
1.1.36 | issue#1338 | Allow automation to be run in debug mode from GUI
1.1.36 | issue#1339 | First graph of second page does not render
1.1.36 | issue#1340 | Unable to open Time Graph View in new tab
1.1.36 | issue#1348 | Toggle context menu of Zoom
1.1.36 | issue#1351 | Errorimage does not render on systems without GD ttf support
1.1.36 | issue#1353 | New installation without config.php silently throws errors
1.1.36 | issue#1355 | Single tree can have the order of the tree changed
1.1.36 | issue#1357 | Data Profile disable fields shown temporarily as editable
1.1.36 | issue#1359 | Settings page generates error for removed plugin tab
1.1.36 | issue#1362 | DSStats Avg/Peak function broken due to change in RRDtool processing
1.1.36 | issue#1365 | Plugin Management enforce folder name
1.1.36 | issue#1366 | Improve error/info message display
1.1.36 | issue#1380 | Potential failure when updating script type
1.1.36 | issue#1384 | When installing/enabling plugins, current user and admin should get permissions
1.1.36 | issue#1386 | form_selectable_cell() ignores width if no style_or_class is passed
1.1.36 | issue#1389 | Poller is including plugins that are not installed
1.1.36 | issue#1390 | Plugin uninstall should prompt user before removal
1.1.36 | issue#1396 | Prevent installation/uninstallation of a plugin if dependency is present
1.1.36 | issue#1397 | Distinguish between plugin tabs and core tabs in settings
1.1.36 | issue#1371 | Allow dynamic setting of from name when emailing
1.1.36 | issue | Data Query Cache filter layout more consistent
1.1.36 | issue | Minor plugin permissions format change
1.1.36 | issue | Implementation of error handling causes errors creating New Graphs
1.1.36 | issue | Deprecated DDStats setting removed
1.1.36 | issue | Graph context menu items are now context aware
1.1.36 | issue | Validate spine path before allowing enabling of spine
1.1.36 | issue | Errored settings fields now highlighted correctly on error
1.1.36 | issue | Add the Default Device to the Default Tree at install time
1.1.36 | issue | Secpass password verification error message unuseful
1.1.36 | feature | Searching of SNMP Index in View Data Query Cache now works
1.1.36 | feature | Presets now have default device Template
1.1.36 | feature | JavaScript library c3.js updated (v0.4.21) / jstree.js (3.3.5)
1.1.36 | feature | PHPSecLib updated 2.0.10
1.1.36 | feature | Updated Dutch translations
1.1.35 | issue#114 | *all_max_peak* percentile calculations incorrect
1.1.35 | issue#430 | Pressing Back often fails to work as expected
1.1.35 | issue#564 | Fail to move items in graph template as desired
1.1.35 | issue#981 | Hyperlinks for Data Profile stats
1.1.35 | issue#993 | Realtime not working on remote pollers for certain data query
1.1.35 | issue#1244 | Errors importing templates with deprecated hashes
1.1.35 | issue#1251 | Allow zoom out through mouse mmiddle button
1.1.35 | issue#1281 | Max OIDs setting is for bulkget and not bulkwalk operations
1.1.35 | issue#1286 | Correct CHUNKED_ENCODING error when retrieving graph with some browsers
1.1.35 | issue#1306 | Graphs are not always refreshed properly
1.1.35 | issue#1309 | Provide meaningful authentication errors in graph_json.php and graph_image.php
1.1.35 | issue#1310 | Return button fails on change password page
1.1.35 | issue#1315 | Realtime not working on local data collector
1.1.35 | issue#1316 | CDEF Item Value dialog does not update creating items
1.1.35 | issue#1319 | Front end + remote poller - connection timeout issue
1.1.35 | issue#1321 | Use RRDtool pipelining functions within DSSTATS
1.1.35 | issue#1323 | Enhance form layout for readability
1.1.35 | issue#1329 | Spelling errors in automation_networks.php
1.1.35 | issue | Validate regular expressions if specified in add_graphs.php
1.1.35 | issue | Ensure compression levels are consistent when importing package
1.1.34 | issue#1040 | PHP version 7.2 - ERROR PHP WARNING: sizeof()
1.1.34 | issue#1195 | Improved Javascript error message handling
1.1.34 | issue#1245 | Unable to reorder graph name suggested values
1.1.34 | issue#1256 | Error reporting of custom errors not displayed correctly
1.1.34 | issue#1257 | Boost excessively logging updates
1.1.34 | issue#1258 | cacti.sql updated to match expected schema
1.1.34 | issue#1260 | Tab images fail to render due to TrueType support in PHP GD Module
1.1.34 | issue#1261 | Automatic logout timeout does not apply to web basic authenication
1.1.34 | issue#1263 | CLI utility to validate database schema
1.1.34 | issue#1266 | Inconsistent usage graphWrapper CSS causes odd graph zoom behavior
1.1.34 | issue#1268 | Regex filters not working properly
1.1.34 | issue#1274 | Host CPU script checks value existance to avoid error
1.1.34 | issue#1275 | SNMP v3 authPriv fails to work
1.1.34 | issue#1287 | JSON calls return validation error in HTML format
1.1.34 | issue#1289 | Script Server should output parameter array rather than parameters
1.1.34 | issue#1292 | Chrome to aggressively caches Javascript files
1.1.34 | issue#1293 | Correctly identify if command 'snmpbulkwalk' is available
1.1.34 | issue#1296 | CactiErrorHandler does not ignore PHP suppressed errors
1.1.34 | issue#1300 | Automation discovery : New devices added by automation discovery have empty SNMP community field
1.1.34 | issue#1302 | Automatic logout should not be enforced on login page
1.1.34 | issue#1304 | mib_cache.php file contains unsafe transactions for binary logging
1.1.34 | feature | CLI utilily to generate and verify file hashes for installed Cacti files
1.1.34 | feature | Logging links back to appropriate areas for troubleshooting
1.1.34 | feature | Logging lists filenames in reverse order
1.1.33 | issue#1253 | Automatically generated RRDtool DEF names in Cacti 1.1.32 break existing Graph Templates
1.1.32 | issue#969 | Undefined index: color_id / task_item when viewing graphs
1.1.32 | issue#1166 | Fix typo of 'locale' in global_languages.php
1.1.32 | issue#1222 | Graphs with large number of items causes RRDTool to error
1.1.32 | issue#1230 | PHP Fatal error: Call to undefined function get_max_tree_sequence()
1.1.32 | issue#1238 | SNMP functions fail to handle "Invalid object identifier" error
1.1.32 | issue#1239 | Browser console error in layout.js
1.1.32 | issue#1240 | Page layout issues caused by library update
1.1.32 | issue#1246 | Make SNMP Error return more info
1.1.32 | issue | Missing or corrupted theme files can corrupt user settings
1.1.32 | issue | Theme may not change until next login
1.1.32 | issue | Tree edit Tree/Device/Graph drag areas incorrect
1.1.32 | issue | Make callback error handling compatible with jQuery 3.x
1.1.32 | issue | Ensure the snmp_error is cleared before every call
1.1.32 | issue | Indicate unknown error when RRDTool returns no error message
1.1.32 | feature | Update Javascript library: js.storage.js, d3.js, jquery.js, jquery.tablednd.js, jquery.timepicker.js
1.1.31 | issue#629 | Site reload after delete the last letter in the searchbar
1.1.31 | issue#1022 | Discovery network stuck in "running" state does not return results
1.1.31 | issue#1164 | Version compare function fails on major/minor only versions
1.1.31 | issue#1166 | Invalid New User default language selection
1.1.31 | issue#1175 | Automatic logout inconsistent redirect
1.1.31 | issue#1179 | Warn during installation if installing moving to older version
1.1.31 | issue#1183 | Automatically detect missing Theme and use alternate
1.1.31 | issue#1185 | Layout with Graphs having large number of data columns
1.1.31 | issue#1189 | Allow ability to sort tree list by name asc/desc
1.1.31 | issue#1190 | Enabling, Disabling, Uninstalling plugin, you should page refresh
1.1.31 | issue#1191 | Tree sequences were not set or checked
1.1.31 | issue#1197 | Add more collection intervals to Data Source Profiles
1.1.31 | issue#1206 | Display issue with internationalization number format
1.1.31 | issue#1210 | CDEF and VDEF Items can not be properly edited
1.1.31 | issue#1212 | Navigation breadcrumbs fail to handle External links correctly
1.1.31 | issue#1213 | PHPMailer trying TLS despite SMTPSecure setting
1.1.31 | issue#1215 | Show version when installation prompts for license
1.1.31 | issue#1217 | Add ability to view/edit Input/Query when editing Data Template
1.1.31 | issue | Named colors fail to import on install or upgrade
1.1.31 | issue | Drag and Drop issues on multiple pages could corrupt sequencing
1.1.31 | feature | Enhance filter to permit more glyphs for table headers
1.1.31 | feature | Add a page refresh dropdown to the Automation Networks
1.1.31 | feature | Enhanced SNMP v3 input forms
1.1.31 | feature | Allow Trees to be rearranged using Drag and Drop
1.1.31 | feature | Trap GUI callback errors and present error message
1.1.30 | issue#1155 | Non-secure mail setting not functional due to changes in phpmailer
1.1.30 | issue#1157 | Resolve issue with branch permission api
1.1.30 | issue#1158 | Change CLOG to use regex replacement so line details are not mangled
1.1.30 | issue#1161 | Graph View regex's are not preserved during automatic page refresh
1.1.30 | issue#1162 | Error messages are not display when editing a user
1.1.30 | issue#1166 | Default language was not correctly set when editing a user
1.1.30 | issue | basename function undefined during upgrade to 1.0.x
1.1.30 | issue | Storage API and translations required for Change password function
1.1.30 | issue | ALTER IGNORE still throws an error when attempting to drop the primary key
1.1.30 | issue | Data Source profile form API generates error when system is half upgraded
1.1.30 | issue | Resolve issue with importing packages
1.1.30 | feature | Update package versions for Cacti version 1.1.29
1.1.29 | issue#871 | Allow Nth Percentile and Bandwidth Summation to respect 'Base Value' in template
1.1.29 | issue#965 | Duplicate error message and incorrect error code when using LDAP authentication
1.1.29 | issue#1084 | Graph Tree Branch not properly populating when editing report item
1.1.29 | issue#1104 | Datetime formatting in developer debug mode incorrect
1.1.29 | issue#1106 | Template Filters has empty row
1.1.29 | issue#1109 | URL used in redirection when referrer already has parameters in it
1.1.29 | issue#1110 | Add CPU Total to 'SNMP - Get Processor Information'
1.1.29 | issue#1111 | PHP NOTICE when using LDAP authenication
1.1.29 | issue#1116 | Filters not allowing "None" or "All" when editing report item
1.1.29 | issue#1119 | Reduced amount of data fetched for CPU usage to just the data used
1.1.29 | issue#1121 | Bandwidth summation not using correct locale
1.1.29 | issue#1122 | Fix issue with local login / potential password problems
1.1.29 | issue#1128 | Resolve php warning when raising messages
1.1.29 | issue#1130 | Fix logging level issue where logs of same level as setting where not logged
1.1.29 | issue#1131 | Make upgrade_database.php use same version compare as /install/ system
1.1.29 | issue#1133 | Fix issues with variable name and debug log
1.1.29 | issue#1141 | When viewing graphs from list view, pagination causes list view filter to be cleared
1.1.29 | issue#1143 | ss_host_cpu.php - Division by zero / Invalid Return Value
1.1.29 | issue#1146 | Installation now checks URI path matchs with configuration option URL_PATH
1.1.29 | issue | Updated Graph pagenation and filter reset
1.1.29 | issue | Resolve issues with cacti_version_compare() processing
1.1.29 | issue | Zoom context menu stays open after zoom out actions
1.1.29 | issue | Paginator object was not always translated
1.1.28 | issue#958 | User Group Tree permissions not calculated fully
1.1.28 | issue#959 | Issue viewing email reports due to email client decoding problems
1.1.28 | issue#992 | RRDfile naming issues that result from random sorting during export
1.1.28 | issue#1012 | Issue where disabled devices will not appear in Tree editor
1.1.28 | issue#1044 | Handle invalid exclusion regex properly when viewing the log
1.1.28 | issue#1045 | Issue with multiple pages and confirmation dialogs
1.1.28 | issue#1048 | Problem importing vdefs from templates
1.1.28 | issue#1053 | Remote Data Collector now works with https and self signed certificates
1.1.28 | issue#1055 | Errors in data source statistics inserts when invalid output is encountered
1.1.28 | issue#1057 | CVE-2017-16641 - Potential vulnerability in RRDtool functions
1.1.28 | issue#1058 | ICMP Ping to and IPv6 address fails to gather data for ping latency
1.1.28 | issue#1059 | Aggregate item filter should use regular expressions to avoid SQL errors due to flawed filter logic
1.1.28 | issue#1064 | When a Device Template is removed, Automation Templates for that Device Template remain
1.1.28 | issue#1066 | CVE-2017-16660 in remote_agent.php logging function
1.1.28 | issue#1066 | CVE-2017-16661 in view log file
1.1.28 | issue#1071 | CVE-2017-16785 in global_session.php Reflection XSS
1.1.28 | issue#1074 | Boost records get stuck in archive
1.1.28 | issue#1079 | Undefined index in lib/snmpagent.php
1.1.28 | issue#1085 | Undefined function html_log_input_error
1.1.28 | issue#1086 | Rerun data queries in automation process has no effect
1.1.28 | issue#1087 | cli/add_device.php --proxy option does not work with non-snmp devices
1.1.28 | issue#1088 | Set timeout for remote data collector context
1.1.28 | issue | Minor performance increase in boost processing
1.1.28 | issue | Poller output not empty not processed correctly on Log tab
1.1.28 | feature | Timeout to the remote agent for realtime graphs
1.1.28 | feature | Updated Dutch translations
1.1.28 | feature | Database update adding additional indexes for increased performance
1.1.28 | feature | Updated PHPMailer to version 5.2.26
1.1.28 | feature | Updated phpseclib to version 2.0.7
1.1.27 | issue#1033 | Issues inserting into dsstats table due to legacy data
1.1.27 | issue#1039 | Using html_escape still double escapes.  Use strip_tags instead
1.1.27 | issue#1040 | Resolving compatibility issue with PHP7.2
1.1.26 | issue#841 | --input-fields variable not working with add_graphs.php cli
1.1.26 | issue#986 | Resolve minor appearance problem on Modern theme
1.1.26 | issue#989 | Resolve issue with data input method commands loosing spaces on import
1.1.26 | issue#1000 | add_graphs.php not recognizing input fields
1.1.26 | issue#1003 | Reversing resolution to Issue#995 due to adverse impact to polling times
1.1.26 | issue#1008 | Remove developer debug warning about thumbnail validation
1.1.26 | issue#1009 | Resolving minor issue with cmd_realtime.php and a changing hostname
1.1.26 | issue#1010 | CVE-2017-15194 - Path-Based Cross-Site Scripting (XSS)
1.1.26 | issue#1027 | Confirm that the PHP date.timezone setting is properly set during install
1.1.26 | issue | Fixed database session handling for PHP 7.1
1.1.26 | issue | Fixed some missing i18n
1.1.26 | issue | Fixed typo's
1.1.26 | feature | Updated Dutch translations
1.1.26 | feature | Schema changes; Examined queries without key usage and added/changed some keys
1.1.26 | feature | Some small improvements
1.1.25 | issue#966 | Email still using SMTP security even though set to none
1.1.25 | issue#995 | Redirecting exec_background() to dev null breaks some functions
1.1.25 | issue#998 | Allow removal of external data template and prevent their creation
1.1.25 | issue | Remove spikes uses wrong variance value from WebGUI
1.1.25 | issue | Changing filters on log page does not reset to first page
1.1.25 | issue | Allow manual creation of external data sources once again
1.1.25 | feature | Updated Dutch translations
1.1.24 | issue#932 | Zoom positioning breaks when you scroll the graph page
1.1.24 | issue#970 | Remote Data Collector Cache Synchronization missing plugin sub-directories
1.1.24 | issue#980 | Resolve issue where a new tree branches refreshs before you have a chance to name it
1.1.24 | issue#982 | Data Source Profile size information not showing properly
1.1.24 | issue | Long sysDescriptions on automation page cause columns to be hidden
1.1.24 | issue | Resolve visual issues in Classic theme
1.1.24 | feature | Allow Resynchronization of Poller Resource Cache
1.1.24 | feature | Update Spanish Translation
1.1.23 | issue#963 | SQL Errors with snmpagent and MariaDB 10.2
1.1.23 | issue#964 | SQL Mode optimization failing in 1.1.22
1.1.22 | issue#950 | Automation - New graph rule looses name on change
1.1.22 | issue#952 | CSV Export not rendering chinese characters correctly (Second attempt)
1.1.22 | issue#955 | Validation error trying to view graph debug syntax
1.1.22 | issue | MySQL/MariaDB database sql_mode NO_AUTO_VALUE_ON_ZERO corrupts Cacti database
1.1.22 | issue | When creating a data source, the data source profile does not default to the system default
1.1.22 | feature | Enhance table filters to support new Cycle plugin
1.1.22 | feature | Updated Dutch Translations
1.1.21 | issue#938 | Problems upgrading to 1.1.20 with one table alter statement
1.1.21 | issue#952 | CSV Export not rendering chinese characters correctly
1.1.21 | issue | Minor alignment issue on tables
1.1.20 | issue#920 | Issue with scrollbars after update to 1.1.19 related to #902
1.1.20 | issue#921 | Tree Mode no longer expands to accomodate full tree item names
1.1.20 | issue#922 | When using LDAP domains some setings are not passed correctly to the Cacti LDAP library
1.1.20 | issue#923 | Warninga in cacti.log are displayed incorrectly
1.1.20 | issue#926 | Update Utilities page to provide more information on rebuilding poller cache
1.1.20 | issue#927 | Minor schema change to support XtraDB Cluster
1.1.20 | issue#929 | Overlapping frames on certain themes
1.1.20 | issue#931 | Aggregate graphs missing from list view
1.1.20 | issue#933 | Aggregate graphs page counter off
1.1.20 | issue#935 | Support utf8 printable in data query inserts
1.1.20 | issue#936 | TimeZone query failure undefined function
1.1.20 | issue | Taking actions on users does not use callbacks
1.1.20 | issue | Undefined constant in lib/snmp.php on RHEL7
1.1.20 | issue | Human readable socket errno's not defined
1.1.20 | issue | Audit of ping methods tcp, udp, and icmp ping. IPv6 will still not work till php 5.5.4
1.1.19 | issue#810 | Scripts in packages don't match distribution
1.1.19 | issue#919 | Unable to upgrade to 1.1.18
1.1.19 | issue | Update documentation for minimum PHP 5.4
1.1.18 | issue#902 | Correcting some issues with Console and External Links
1.1.18 | issue#903 | Upgrade pace.js to v0.7.8
1.1.18 | issue#904 | Allow user to hide Graphs from disabled Devices
1.1.18 | issue#906 | Create a separate Realm for Realtime Graphs
1.1.18 | issue#907 | XSS issue in spikekill.php
1.1.18 | issue#910 | Boost last run duration generates an error on new install
1.1.18 | issue#914 | Unable to purge Cacti logfile from System Utilities
1.1.18 | issue#915 | Non-numeric data in ss_host_disk.php
1.1.18 | issue#916 | Resolve display of errors when encountering ldap issues
1.1.18 | issue#918 | Minor XSS and create generalized escape function
1.1.18 | issue | Resolve JavaScript errors on Login page
1.1.18 | issue | Resolve JavaScript errors on Permission Denied pages
1.1.18 | issue | Graphs tab would appear in non-classic even if you did not have permissions
1.1.18 | feature | Updated dutch translations
1.1.17 | issue#450 | List View to Preview shows no results
1.1.17 | issue#486 | Export Device table results to CSV
1.1.17 | issue#544 | Allow Log Rotation to be other than Daily
1.1.17 | issue#673 | Downtime/Recovery time/date is set incorrectly
1.1.17 | issue#819 | Customized timespans for graphs
1.1.17 | issue#888 | Rebuilding Poller Cache when External data sources are present results in false positive warnings in the log
1.1.17 | issue#891 | Database.php unable to connect to MySQL when using port different than 3306
1.1.17 | issue#893 | Warning messages when duplicating CDEF objects
1.1.17 | issue#897 | Due to browser use of special key, deprecate ctrl-shift-x for clearing filter
1.1.17 | issue#898 | Issue with tcp and udp ping due to file description allocation changes
1.1.17 | issue | Unable use ipv6 ip addresses for snmp ping in the Cacti GUI
1.1.17 | issue | Update language of the Rebuild Poller Cache menu pick
1.1.17 | issue | Broken design for input controls with Sunrise theme
1.1.17 | issue | Timespan switching not switching to Custom in Preview Mode
1.1.17 | issue | Log rotation would not occur under certain conditions.  Provide more control over log functions
1.1.17 | issue | Purge log file always purged the cacti.log, not the selected log
1.1.17 | issue | Unable to view graphs for errored data sources from Cacti log
1.1.16 | issue#865 | Escape Data Query arguments to prevent issues with special characters
1.1.16 | issue#872 | Can't add device items to graphs generated with no device and no template
1.1.16 | issue#875 | When modifying Realm permissions, realms that are listed multiple times don't stay in sync
1.1.16 | issue#877 | Improving resolution to issue#847 and one additional vulnerability
1.1.16 | issue#878 | Ambiguous language in purge log function
1.1.16 | issue#879 | SQL Error when adding a report item to a report
1.1.16 | issue#880 | Device drop down is limited to 20 devices and lacks a scroll bar
1.1.16 | issue#885 | Graph generated with no device and no graph template forgets device definitions
1.1.16 | issue#886 | Unable to export templates other than Device templates
1.1.16 | issue | Address additional corner cases around get_order_string usage
1.1.16 | issue | Data Queries sharing a Data Source can result in poller output table not empty errors
1.1.16 | issue | Fix Sunrise theme to properly theme multiselect widgets
1.1.16 | issue | Increase height of multiselects so that more options are visible
1.1.16 | issue | When a graph is locked, anchor tags are still functional
1.1.16 | issue | Autocomplete does not populate none-value when the selected value is not set
1.1.15 | issue | PHP Fatal Exception on upgrade from 1.1.11 or earlier
1.1.15 | feature | Added test to detect install upgrade code problems
1.1.14 | issue#849 | Unable to select host in Graph Item pick
1.1.14 | issue#850 | Reporting not allowing Non-templated Graphs
1.1.14 | issue#858 | Pagination on SNMP Options wrong
1.1.14 | issue#860 | Network Discovery Subnet Range character limit too small
1.1.14 | issue#861 | The search filter does not support Cyrillic
1.1.14 | issue#862 | Automation - When editing Graph Rules, unable to Change Data Query
1.1.14 | issue#863 | Typo error in auth_login.php for LDAP authentication
1.1.14 | issue#867 | Cross-site scripting (XSS) vulnerability in auth_profile.php
1.1.14 | issue | Link's not showing in Automation Graph and Tree rules on Sunshine theme
1.1.14 | issue | Make Templates Export responsive
1.1.14 | issue | Don't wrap menu glyphs and menuitems
1.1.14 | issue | The function get_order_string() can fail when encountering reserved word columns
1.1.14 | issue | Data Query Delete is not using callback
1.1.14 | feature | Resize Graphs on Graph page to be responsive
1.1.14 | feature | Make import text a hidden field as it is likely seldom used
1.1.13 | issue#605 | Remove Spikes feature not fully functional
1.1.13 | issue#814 | Allow 'Save' feature from New Graphs
1.1.13 | issue#837 | Using the add_device.php CLI script, you can not 'default' the device threads to other than 1
1.1.13 | issue#838 | CVE-2017-10970: XSS Issue in link.php
1.1.13 | issue#839 | The Database column name 'rows' is a reserved word in MariaDB 10.2+
1.1.13 | issue#845 | External links tabs should appear at the end of the tab view
1.1.13 | issue#846 | Web crawl of Cacti site shows errors in the log
1.1.13 | issue#847 | CVE-2017-10970: XSS Issue in lib/html_form.php.
1.1.13 | issue#853 | Go and Clear buttons do not work in all cases on Graph Rules pages
1.1.13 | issue | Up/Down arrow titles labeled incorrectly on Tree Management page
1.1.13 | issue | Make the default Export Type a Device Template
1.1.13 | issue | Fix SNMPagent MIB cache issues
1.1.13 | issue | Realtime cache cleanup now only removes rrd and png
1.1.13 | issue | When redirected from reports, you can receive a validation error
1.1.13 | feature | updated Dutch language
1.1.12 | issue#822 | Aggregate Graph Items are incorrectly editable
1.1.12 | issue#823 | Allow Filters to be hidden
1.1.12 | issue#834 | Add spacing on graphs pages
1.1.12 | issue | Uninstalled plugins can not install
1.1.12 | issue | Location of filter functions in host.php prevent full responsive filter implementation
1.1.12 | feature | Implement first phase of responsive search filters
1.1.11 | issue#642 | RRA not written or WARNING: Poller Output Table not Empty
1.1.11 | issue#779 | PHP running out of memory due to date format issues
1.1.11 | issue#791 | SeLinux causing problems due to recent enhancement of the Cacti log
1.1.11 | issue#818 | Unable to unselect all SpikeKill templates under settings
1.1.11 | issue#831 | Unable to add devices from automation devices that don't have a snmpSysname
1.1.11 | issue | incorrect version of pace: fix progess bar
1.1.11 | issue | date_format(): fix date separator character
1.1.11 | issue | host.php: fix itemCount en rowCount when result = null
1.1.11 | issue | clog: fix scandir for systems with limited permissions to log directory
1.1.11 | issue | clog: fix listing of logfiles
1.1.11 | issue | Stop New Graphs filter interface from taking too much space
1.1.11 | issue | Pagination of clog is not done via ajax
1.1.11 | issue | Unable to dry run spikekill's from Graphs page
1.1.11 | issue | Default sort order does not highlight on Aggregate Template page
1.1.11 | issue | Correct display issue with Graph Templates when editing Device
1.1.11 | issue | External Data Sources show as having poller interval on Data Source page
1.1.11 | issue | Allow Selecting 'External' as the Data Source Profile when creating non-templated Data Source
1.1.11 | issue | Remove Field Order on Data Input output data as it's not required
1.1.11 | issue | Data Templates not using Ajax callbacks to switch Data Sources
1.1.11 | issue | Visual issue when creating non-templated Aggregate Graphs
1.1.11 | feature | new skin: Sunrise
1.1.11 | feature | Provide Non Compatible explanation when a plugin is not compatible
1.1.11 | feature | Updated Dutch translations
1.1.11 | feature | Allow Graph Templates with multiple flag to be created repeatedly from Graphs New interface
1.1.11 | feature | Allow plugins to exclude files and directories from their remote poller synchronization process
1.1.11 | feature | Add Device Description to View Poller Cache UI
1.1.10 | issue#779 | Resolve random Apache segfault due to recursion
1.1.10 | issue#786 | Unable to create second RRA for a Data Source Profile with collection rate less than 5 minutes
1.1.10 | issue#789 | Unable to Clear Filter due to JavaScript name space collision
1.1.10 | issue#791 | cacti 1.1.9 and clog_webapi.php permission issue
1.1.10 | issue#794 | SQL Error when creating graphs manually
1.1.10 | issue#798 | Cosmetic issue when checking checkboxes in Cacti
1.1.10 | issue#800 | Unchecked loop in lib/html_utility.php causing race condition
1.1.10 | issue#802 | Issue updating device hostname with SNMP data queries
1.1.10 | issue#803 | Issues with utf8mb4 introduced via optimization
1.1.10 | issue | If the device is down and snmp_sysUpTimeInstance is 0, time in state can be wrong
1.1.10 | feature | Updated Dutch translations
1.1.9 | issue#788 | Fails on PHP Fatal error if LDAP auth enabled
1.1.8 | issue#529 | Issue on Graph New page with checkbox unselected
1.1.8 | issue#552 | Minor selectable row checkbox issue
1.1.8 | issue#577 | Dragging multiple items causes the tree to refresh too early
1.1.8 | issue#617 | Correct poller timeouts when no devices are associated with active data collector
1.1.8 | issue#706 | Classic external link template images missing
1.1.8 | issue#726 | Undefined variable in upgrade script
1.1.8 | issue#728 | Resolve issues with jQueryUI empty dialogs
1.1.8 | issue#731 | Add class to radio button labels to correct display issue
1.1.8 | issue#736 | Sequence numbers not visible when editing templates using modern theme
1.1.8 | issue#739 | Graph Titles missing on aggregate graphs
1.1.8 | issue#740 | Spacer manipulation broken after update to responsive forms
1.1.8 | issue#741 | Errors in dsstats with very large RRDfiles with more than 60 data sources
1.1.8 | issue#748 | Search results are not cleared on Aggregates
1.1.8 | issue#754 | Default Language for user and system are not set on new installation
1.1.8 | issue#755 | RRDtool Graph Watermark is incorrect
1.1.8 | issue#756 | Resolving some translation issues
1.1.8 | issue#763 | Template Export not functional
1.1.8 | issue#765 | Validation error when viewing Utility View
1.1.8 | issue#771 | Editing a report renders no options after creation
1.1.8 | issue#780 | Preview always shows thumbnails in reports interface
1.1.8 | issue | Hide Aggregate system cdefs when editing graphs and graph templates
1.1.8 | issue | Updating Utility View zoom was not updating table data
1.1.8 | feature#723 | Convert Data Source dropdown to autocomplete when editing standalone graphs
1.1.8 | feature#735 | Allow color selection in graphs and templates to be autocomplete
1.1.8 | feature#753 | Preliminary support for RRDtool 1.7.
1.1.8 | feature | Add function to obtain the current execution user
1.1.8 | feature | Implement Site timezones as autocomplete for performance
1.1.8 | feature | For themes other than classic, make color id selection autocomplete
1.1.8 | feature | CLOG timestamp is now formatted as defined in settings
1.1.8 | feature | CLOG can show loginformation from rotated logfiles
1.1.7 | issue#470 | Enhance Cacti's SNMP function and Data Query XML, add &lt;output_format&gt;hex|string|guess&lt;/output_format&gt;
1.1.7 | issue#653 | Devices with empty sysNames are not added to discovered devices
1.1.7 | issue#655 | Data source not displaying device name
1.1.7 | issue#658 | Scheduled Reports (type "tree") not working
1.1.7 | issue#662 | Sending test Email should optionally bypass ping
1.1.7 | issue#667 | In Classic theme initial view of Tree view broken
1.1.7 | issue#669 | Invalid SQL Messages when upgrading to Cacti 1.0.5
1.1.7 | issue#670 | Validation error when you do "Change Graph Template" in Cacti
1.1.7 | issue#672 | Cacti unable to enable snmp notification receiver mibs
1.1.7 | issue#680 | Sort order in Time Graph View
1.1.7 | issue#687 | Cacti DB access not compatible with PHP 7
1.1.7 | issue#696 | Multiple issues with snmpagent notification UI
1.1.7 | issue#699 | Add custom error handler for ping functions
1.1.7 | issue#704 | Fix GUI issues for Graphs not belonging to a device
1.1.7 | issue#707 | Back button not working
1.1.7 | issue#708 | Issues finding lib/snmp.php in host disk functions
1.1.7 | issue#712 | Change Graph Template dropdown invalid
1.1.7 | issue#717 | Allow ajax callbacks when adding non-templated graph items
1.1.7 | issue | Reports were not using Cacti's permission system for checking access
1.1.7 | issue | User Admin page reported wrong permissions at Tree level missing some i18n as well
1.1.7 | issue | Short data_name can cause data collection issues
1.1.7 | feature | Updated Dutch language
1.1.7 | feature | Updating PHPMailer to 5.2.23
1.1.7 | feature | Support input-output Data Query types
1.1.7 | feature | Introduce new get_cacti_version() to reduce database calls on pages
1.1.6 | issue#620 | The table poller_data_template_field_mappings can get out of sync when manipulating data templates
1.1.6 | issue#622 | Can not connect to MySQL over a socket
1.1.6 | issue#628 | Cacti upgrade process is complex and error pront for developers
1.1.6 | issue#635 | Error when saving change to data template
1.1.6 | issue#637 | When displaying tree graphs, use the same layout as preview mode
1.1.6 | issue#646 | When a plugin is disabled during page operations, warnings can appear
1.1.6 | issue#651 | Unable to view cacti log (because of allowed memory size exhausted)
1.1.6 | issue#657 | Error in log when host is down, using icmp and using cmd.php on FreeBSD
1.1.6 | issue | List for creating a Graph type shows already added Graph Templates
1.1.6 | issue | Fix and undefined variable on data source page when first creating a manual data source
1.1.6 | issue | Remove tabindex and other non-required manual aria controls from pages
1.1.6 | issue | Table type and column type in poller_output table wrong
1.1.6 | issue | FILTER_VALIDATE_MAC not defined on PHP less than 5.5
1.1.6 | issue | When changing your language Cacti would not do a full page refresh
1.1.6 | feature#106 | Paginated CLOG and log administration
1.1.6 | feature | Dutch translations
1.1.6 | feature | Responsive Graphs page
1.1.6 | feature | Convert forms from table based to div based for responsive design
1.1.6 | feature | Better support for phones and tablets
1.1.6 | feature | Simplified installation code to facilitate easier release cycle
1.1.6 | feature | Updating Tablesorter to v2.28.9, adding widgets and pager
1.1.5 | issue#580 | Data collection warnings when using cmd.php
1.1.5 | issue#592 | Incorrectly formatted HTML
1.1.5 | issue#606 | Replace &lt;path_php_binary&gt; in data input methods
1.1.5 | issue#607 | Allow draw_menu to specify multiple actions for the same URL
1.1.5 | issue#608 | Spaces adjacent to double quotes are eliminated during data input method import
1.1.5 | issue#609 | Honor the column setting in graph tree view mode
1.1.5 | issue#610 | Change Graph Template action not available
1.1.5 | issue#611 | Cacti Installation Wizard - Spine page incorrect on Windows
1.1.5 | issue#612 | Uncaught Error: Call to a member function row() on a string
1.1.5 | issue#613 | Network Automation, now requires a site or your are unable to save rules
1.1.5 | issue#615 | Data Input field length too short for longer scripts
1.1.5 | issue#619 | Export logging option in settings no longer used
1.1.4 | issue#524 | Reporting not working when Tree branch is device
1.1.4 | issue#560 | Add 'Duplicate' and 'Convert to Graph Template' back to Graph Management page for Advanced mode
1.1.4 | issue#573 | Missing Graph Template dropdown items
1.1.4 | issue#575 | Very large hex strings result in scientific notation that RRDtool rejects
1.1.4 | issue#579 | Problems logging in using nginx web server
1.1.4 | issue#581 | session_start() warnings when manually sending reports
1.1.4 | issue#584 | Issues reporting memory recommendation on utilities page
1.1.4 | issue#586 | Overrunning pollers can cause system load spikes
1.1.4 | issue#587 | Data Collector setting under Network Discovery is not being used
1.1.4 | issue#588 | Devices with blank sysDescr are added to the first Device Template in error
1.1.4 | issue#589 | Automation discovery does not allow site association
1.1.4 | issue#590 | Unable to create a plugin based menu
1.1.4 | issue#591 | Row selection in Device Automation Templates not sane with drag-n-drop enabled
1.1.4 | issue#601 | Resolving some translation issues
1.1.4 | issue#604 | Unexpected backtrace on regular expression filters
1.1.4 | issue#605 | Remove Spikes non-numeric data causes warnings
1.1.4 | issue | Ping email does not use a from email address
1.1.4 | issue | Automation does not recognize default size or poller
1.1.4 | issue | Unable to drag-n-drop on automation templates pages when enabled
1.1.4 | issue | Fixed number of hosts in poller stats for first poller
1.1.4 | issue | Fixed screenwidth issue in tab PHP-Info of Utilities module
1.1.4 | issue | Recovery poller could get stuck in some situations
1.1.4 | issue | Fix JavaScript errors when managing Aggregate Graphs
1.1.4 | feature | Reorganize defaults to place more on device defaults page
1.1.4 | feature | Update jQuery tableDnD to version 0.9
1.1.4 | feature | More tolerant of empty PHP_SELF found with some web servers
1.1.3 | issue#515 | Unable to import color CSV file
1.1.3 | issue#519 | In non-classic themes its not possible to remove Cacti log or reporting tabs
1.1.3 | issue#520 | SQL error in graph automation
1.1.3 | issue#521 | Cacti allows removal of Data Query Graph Template associations when they are in use
1.1.3 | issue#525 | LAST GPRINT type not rendered correctly due to lack of escaping
1.1.3 | issue#530 | Undefined function get_vdef in lib/rrd.php
1.1.3 | issue#531 | Issues with TextAlign and Tick graph items
1.1.3 | issue#532 | Unreliable scroll height causes issues in Chrome
1.1.3 | issue#533 | User settings not cleared after saving profile
1.1.3 | issue#534 | Automation issue with AS clause
1.1.3 | issue#538 | Unable to rename tree folder
1.1.3 | issue#541 | Issues with mobile graph viewing
1.1.3 | issue#555 | DSStats SQL insert errors due to data collection issues
1.1.3 | issue#563 | Division by zero in removespikes.php
1.1.3 | issue | Fixed rendering issues with HRULE's on graphs
1.1.3 | issue | Update jsTree to 3.3.4 version
1.1.3 | feature | Improved responsiveness UI tables, filters, and menus
1.1.2 | issue#492 | Error while adding non data query (cg) graphs
1.1.2 | issue#494 | CLI error while importing template
1.1.2 | issue#499 | SQL error in graph automation resulting in no graphs on tree
1.1.2 | issue#500 | Generic SNMP device package damaged - Unix Ping Host
1.1.2 | issue#505 | Log rotation does not work in some cases
1.1.2 | issue#506 | Undefined index: cactiStatsDeviceFailedPolls
1.1.2 | issue#507 | Nextwork discovery 'export' produces no results
1.1.2 | issue#509 | Minor bug with device ownership selection
1.1.2 | feature | Add new legend type that includes Current/Average/Minimum/Maximum
1.1.2 | feature | Update d3.js to latest version 4.7.4
1.1.1 | issue#457 | Continued LDAP issues with initial user creation
1.1.1 | issue#461 | The function escapeshell arg not appropriate on Windows
1.1.1 | issue#462 | LDAP authorization issues: group membership check broken for 'Group Member Type' = 'Username'
1.1.1 | issue#464 | Change default batch spike removal limits for standard deviation and variance
1.1.1 | issue#465 | Less than sign inside items and labels of graph break graph
1.1.1 | issue#466 | Call to member function row() on a non-object in lib/snmpagent.php
1.1.1 | issue#467 | Reduce the number of queries in log function
1.1.1 | issue#472 | Schema changes to improve performance
1.1.1 | issue#485 | When editing a device, the ping status was not always returned
1.1.1 | issue | Back button issues due to syntax problems in JavaScript
1.1.1 | issue | Zoom periodically would loose it's crosshairs after zooming
1.1.1 | issue | Zoom would zoom out into the future even when disabled
1.1.1 | issue | Fixing lite corruption in graph_templates_item table
1.1.1 | feature | Make SpikeKill options more consistent
1.1.1 | feature#459 | Add variable date time option to report mail subject
1.1.1 | feature#460 | Add external_id to host variables
1.1.1 | feature#469 | Change re-index method of Data Query from Device edit
1.1.1 | feature | Support generalized date format approach in the GUI
1.1.1 | feature | Use localStorage over a Cookie for Zoom setting storage
1.1.1 | feature | Fully implement 'Remove Orphans' from Package import process
1.1.0 | issue#337 | Generic SNMP OID Graph Template damanged
1.1.0 | issue#338 | Extremely slow new graph/DS creation
1.1.0 | issue#353 | Broadcast & Multicast Packet counters missing
1.1.0 | issue#376 | Structured RRD path permission issues
1.1.0 | issue#389 | Manual template based graph creation not working
1.1.0 | issue#407 | The RRDfile does not exist message is misleading
1.1.0 | issue#410 | Select character data was interpreted as hex by cacti_snmp_walk()
1.1.0 | issue#422 | additional issues with LDAP authentication
1.1.0 | issue#424 | Automation does not discover devices w/o resolvable hostnames
1.1.0 | issue#427 | undefined index TotalVisibleMemorySize on FreeBSD
1.1.0 | issue#432 | SpikeKill menu wonky on Paw Theme
1.1.0 | issue#434 | password_verify not compatible in php5.4-
1.1.0 | issue#435 | urlPath missing from paw theme links
1.1.0 | issue#436 | Restricted user does not see graphs in tree view
1.1.0 | issue#443 | Allow remote_agent.php through a NAT
1.1.0 | issue#446 | No local admin when using multiple LDAP configuration
1.1.0 | issue#447 | Creating another non data query graph from same template reuses first data source
1.1.0 | issue#449 | exec_poll_php does not flush pipes when using script server
1.1.0 | issue#450 | Graph list view - No Graphs Found
1.1.0 | issue | Improve email test exception errors and change default timeout to 10 seconds
1.1.0 | issue | When on links page, breadcrumbs would become corrupted
1.1.0 | issue | When upgrading from any version of Cacti to 1.0.5, SQL's relative to poller_reindex might appear
1.1.0 | issue | Color page performance poor
1.1.0 | issue | The Device dropdown on the Graph View page was unreliable
1.1.0 | issue | Aggregate and non-Device Graphs in list view had not Device or Title description
1.1.0 | issue | Re-engineer back button design to accomocate ajax and native navigation
1.1.0 | issue | Make Graph Template filter wider
1.1.0 | issue | Resolve some visual issues in Classic theme
1.1.0 | feature | Add page refresh API to make page refreshing in Ajax easier to accomplish
1.1.0 | feature | Update fontawesome to version 4.7
1.1.0 | feature | Use fontawesome glyphs for menu items
1.1.0 | feature | Support multiple column sort in table library
1.1.0 | feature | Add glyphs to main Cacti console menu
1.0.6 | issue#386 | Allow special characters in graph title
1.0.6 | issue#414 | Install Wizard check path for spine
1.0.6 | issue#415 | SNMP session handling broken
1.0.6 | issue#418 | LDAP create user from template not working
1.0.5 | issue#296 | Poller warning for Non-SNMP device
1.0.5 | issue#319 | Add default 'High Collection Rate' data source profile to new installs to demonstrate concept of multiple rates
1.0.5 | issue#330 | Import templates to non-default Data Profile
1.0.5 | issue#337 | Error when try create new graph - SNMP - Generic OID
1.0.5 | issue#342 | Infinite loop in poller_automation.php with invalid schedule
1.0.5 | issue#343 | Device discovery cannot handle dots in device name
1.0.5 | issue#344 | Unable to upgrade to latest Cacti on FreeBSD
1.0.5 | issue#353 | Legacy broadcast & multicast packet counters missing in interface.xml
1.0.5 | issue#354 | Place on tree dashes / ordering is not correct
1.0.5 | issue#355 | Replace table rows with count when using InnoDB tables
1.0.5 | issue#357 | If recovery mode runs longer than a polling interval, a second is spawned
1.0.5 | issue#358 | Sending test e-mail results in warning
1.0.5 | issue#360 | Issue importing cacti.sql with some charsets
1.0.5 | issue#364 | Moving graph item causes page render issue
1.0.5 | issue#365 | ss_host_disk.php and ss_host_cpu.php should use return
1.0.5 | issue#367 | Upgrade chart.js to version 2.5
1.0.5 | issue#368 | Issue with device automation ip vs. ip_address
1.0.5 | issue#369 | Interface bits/second total Bandwidth wrong CDEF
1.0.5 | issue#375 | Drag and Drop of Devices and Graphs allows dropping onto self
1.0.5 | issue#380 | Ignores a non-standard SNMP port
1.0.5 | issue#382 | When using php5.5+ new users unable to change their password
1.0.5 | issue#384 | graph_view.php backtrace errors
1.0.5 | issue#385 | Unable to place an aggregate grapn on a subtree
1.0.5 | issue#390 | Display graphs from this aggregate icon next to graph not displaying
1.0.5 | issue#392 | cdef.php missing sql where for system cdef's
1.0.5 | issue#398 | checkbox is not honored when creating tree
1.0.5 | issue#399 | External link configuration: Order buttons don't work
1.0.5 | issue#400 | SNMP Engine ID (v3) field too short
1.0.5 | issue#401 | Graphs -> Apply Automation Rules fails
1.0.5 | issue#404 | Success even when test mail fails
1.0.5 | issue#406 | HRULE text format special characters not escaped
1.0.5 | issue#408 | Suppress SNMP units suffix from cacti_snmp_get() output
1.0.5 | issue | Improve is_ipaddress functions
1.0.5 | issue | Drag & drop showing when disabled on page automation_templates.php
1.0.5 | issue | Output messages displayed incorrectly in automation_templates.php and automation_snmp.php
1.0.5 | issue | Importing template from old Cacti would not show data templates
1.0.5 | issue | Handle snmp error exceptions better
1.0.5 | issue | Update Apache .htaccess files to support multiple version
1.0.5 | issue | When executing a full sync, if the table structured has changed, recreate the remote table
1.0.5 | issue | Multiple domains not working as expected
1.0.5 | feature#197 | Add external_id to Cacti for linking Cacti to other monitoring systems
1.0.5 | feature#332 | Support copy user groups
1.0.5 | feature | Log proper IP address if logging in behind a NAT
1.0.5 | feature | New qquery parsing rules: VALUE/TEST, VALUE/TABLE, VALUE/HEX2IP
1.0.4 | feature | Javascript: make menu movement smooth and use localStorage
1.0.4 | feature | Added cacti_snmp_get_raw() for plugin developers
1.0.4 | issue#288 | Function cacti_snmp_get bad handling of wierd value into snmp_value
1.0.4 | issue#298 | Graph generation issue with SNMP - Bits/Sec + Total Bandwith
1.0.4 | issue#301 | Unresolvable DNS hostname causing backtraces
1.0.4 | issue#302 | spikekill memory leak
1.0.4 | issue#303 | Error when creating tree items with "&" in the name
1.0.4 | issue#307 | Aggregate graph gives CMDPHP errors
1.0.4 | issue#308 | UI resize issue
1.0.4 | issue#309 | Show "Save Successful" notification permanently
1.0.4 | issue#311 | Graph thumbnail settings in profile setting does not work
1.0.4 | issue#320 | Users can not change their own password
1.0.4 | issue#324 | Aggregate template graph template JavaScript error
1.0.4 | issue#352 | Add configurable auto-logout and page-reload options
1.0.4 | issue#329 | Customize the favicon
1.0.4 | issue#334 | primary key on poller output boost table not efficient/not being used correctly
1.0.4 | issue | Fixed issues with Dark theme
1.0.4 | issue | Fixed issues with Paw theme
1.0.4 | issue | Fix timespan calculation
1.0.4 | issue | Added misplaced join condition when generating RRDtool graphs
1.0.4 | issue | Fix the selection of timestan based on local_graph_id and rra_id
1.0.4 | issue | Correct error in discovery not adding devices
1.0.4 | issue | Action message did not always display
1.0.4 | issue | fix regex to use Domains like www.t-online.de
1.0.4 | issue | Properly align Order columns.
1.0.4 | issue | address renaming issues with tree items.
1.0.4 | issue | Add device snmp --version is ambiguous
1.0.4 | issue | SNMP Availability failed to report down devices - This only was occuring for cmd.php collector.
1.0.4 | issue | i18n remove embedded HTML syntax
1.0.4 | issue | Wrap menu items to avoid scrolling
1.0.3 | issue#297 | Upgrade 0.8.8h to 1.0.0 fails to create poller_output_boost table
1.0.3 | issue | Added missing template import hash for 1.0.2
1.0.2 | issue#279 | Correct Boost Status display issue
1.0.2 | issue#275 | Permission View issue and Device Dropdown when in Classic Theme
1.0.2 | issue#270 | Major Mib Cache corruption.  Rebuild your MIB Cache after upgrading
1.0.2 | issue | Resolve Cacti logo on Graphs page in Classic Theme
1.0.1 | feature | SpikeKill allows filling range to last known good value
1.0.1 | issue#261 | Add IPv4 and IPv6 Specific Counters to interfaces.xml
1.0.1 | issue#257 | Poller Output Table not Empty WARNING messages in cacti.log
1.0.1 | issue#256 | New Graph - Add Graph Items Fails (Data Sources shows None)
1.0.1 | issue#255 | Errors Creating new Graphs - Undefined Index Errors
1.0.1 | issue#254 | Unable to Properly add Data Source
1.0.1 | issue#251 | Remote Data Collector stuck on upgrade page
1.0.1 | issue#247 | Devices missing from tree device list
1.0.1 | issue#245 | Drag and Drop in Tree Edit Erratic
1.0.1 | issue#243 | SMTP Ping Failure with not SNMP Authentication
1.0.1 | issue#241 | Authentication Method: None not functional
1.0.1 | issue#240 | SQL error when install plugin
1.0.1 | issue#238 | Duplicate color id's cause error during Upgrade
1.0.1 | issue#231 | SNMPv3 - PHP ERROR WARNING: Fatal error: Unknown user name in file
1.0.1 | issue | Resolving visual issues with row counts.
1.0.1 | issue | When deleting Graphs prevent the removal of Data Sources that are still in use
1.0.1 | issue | Improve SNMP agent performance through SQL optimizations
1.0.0 | feature | Support for remote data collectors
1.0.0 | feature | Support Internationalization (i18n) for the main Cacti site, and supported plugins
1.0.0 | feature | Data Source Profiles replace RRA settings allowing a single system to have multiple polling intervals
1.0.0 | feature | Redesigned Tree page including Drag & Drop functionality
1.0.0 | feature | New Graph Permissions system designed to make permissions simple to manage
1.0.0 | feature | Add Themes 'Classic', 'Modern', 'Dark', and 'Paw'
1.0.0 | feature | Debug Data Sources by comparing them to the Data Template
1.0.0 | feature | New special Data Source type to detect the poller interval
1.0.0 | feature | Bulk inserts in PHP poller to address latency issues
1.0.0 | feature | Optimize data collection through in memory caching giving a 50% reduction in polling times when dealing with large sites
1.0.0 | feature | Support RRDtool VDEFs
1.0.0 | feature | Support new Graph Items: AREA:STACK, GPRINT:AVERAGE, GPRINT:LAST, GPRINT:MAX, GPRINT:MIN, LINE:STACK, TEXTALIGN, TICK
1.0.0 | feature | Support RRDtool features: Right Axis Support, Dynamic Labels, Tab Width, Legend Position, Legend Direction
1.0.0 | feature | Resizeable table columns
1.0.0 | feature | Deprecated Single Pane Tree View
1.0.0 | feature | Role Based Access Control (RBAC)
1.0.0 | feature | Support User Group Permissions
1.0.0 | feature | Show number of in use Graphs, Data Sources, and Devices for a given Template
1.0.0 | feature | Support bulk re-sync of graphs to assigned Graph Template
1.0.0 | feature | Bulk Device Settings changes
1.0.0 | feature | CDEFs, Colors, GPrint Presets consolidated to Presets menu
1.0.0 | feature | Authentication cookies for 'remember me' functionality
1.0.0 | feature | Automatic logout after session inactivity
1.0.0 | feature | Replace Boost server in favor of RRDtool Proxy
1.0.0 | feature | Graph Details include CSV output, zoom, debug, and download links
1.0.0 | feature | Graph Export moved to a plugin
1.0.0 | feature | User change password functionality
1.0.0 | feature | Automation added to core functionality through the merge of the Discovery and AutoM8 plugins
1.0.0 | feature | Change interface graphs from 32 bit to 64 bit with ease
1.0.0 | feature | Plugins now have hooks in device templates and automation
1.0.0 | feature | Allow users to preview template imports to determine if there will be issues from importing
1.0.0 | feature | Automatic removal of orphaned graph items when importing newer versions of graph templates
1.0.0 | feature | Support for MySQL 5.7
1.0.0 | feature | Support for PHP 7.0
1.0.0 | feature | Merge Aggregate Plugin - Aggregate graph creation
1.0.0 | feature | Merge AutoM8 Plugin - Automation of graph creation
1.0.0 | feature | Merge Boost Plugin - Faster polling, result caching, on-demand RRDtool file updates
1.0.0 | feature | Merge CLog Plugin - View Cacti logs
1.0.0 | feature | Merge Discovery Plugin - Device discovery
1.0.0 | feature | Merge Domains Plugin - Support for domain (ADS/LDAP) specific user templates
1.0.0 | feature | Merge DSStats Plugin - Cache Data Source values for easy retrieval
1.0.0 | feature | Merge Logrotate Plugin - Rotate Cacti logs
1.0.0 | feature | Merge Realtime Plugin - Realtime graph viewing
1.0.0 | feature | Merge Reporting (Nectar) Plugin - Reporting
1.0.0 | feature | Merge RRDclean Plugin - RRDfile cleanup and management
1.0.0 | feature | Merge Secpass Plugin - User password policy enforcement
1.0.0 | feature | Merge Settings Plugin - Shared settings for plugins
1.0.0 | feature | Merge SNMP Agent Plugin - SNMP Agent for Cacti providing system statistics
1.0.0 | feature | Merge SpikeKill Plugin - Remove unwanted spikes from graphs
1.0.0 | feature | Merge SSL Plugin - Force https
1.0.0 | feature | Merge SuperLinks Plugin - Add external links within Cacti
1.0.0 | feature | Merge UGroup Plugin - User groups with permissions
1.0.0 | feature | Merge Watermark Plugin - Watermark your Cacti graphs
1.0.0 | bug | Fixed issue where old graph templates (0.8.6-), could import bogus data causing issues with Data Input Methods
1.0.0 | bug#0000168 | Duplicate data sources should be avoided when creating new graphs
1.0.0 | bug#0000851 | Review an imported template
1.0.0 | bug#0001155 | When viewing graph tree do not show empty nodes
1.0.0 | bug#0001337 | Form to filter for graphs in host view mode
1.0.0 | bug#0001552 | Date ranges not shown on graphs in the view with Daily, Weekly, Monthly & Yearly graphs
1.0.0 | bug#0001573 | RRA templates/grouping
1.0.0 | bug#0001577 | Override session handling and store session in Database
1.0.0 | bug#0001790 | Allow for XML delimiter in fields of a script query
1.0.0 | bug#0001820 | Unable to use a Data Input Method Output Field in more than one Data Source Item
1.0.0 | bug#0001827 | Changing the graph template messes up the graph item fields
1.0.0 | bug#0001836 | Add mysql error message to log
1.0.0 | bug#0001877 | Cookies path is not properly set
1.0.0 | bug#0001966 | Expand Devices in tree view not honored
1.0.0 | bug#0001970 | Data query index order cache should be populated on re-index
1.0.0 | bug#0001981 | Cacti is not full UTF-8
1.0.0 | bug#0001986 | CLI allow add_graphs.php to have multiples --snmp-field and --snmp-value options
1.0.0 | bug#0001996 | Allow using data input field in graph title
1.0.0 | bug#0002096 | Enumerated SNMP values not parsed correctly
1.0.0 | bug#0002112 | CLI add configurable parameters for device_add.php
1.0.0 | bug#0002133 | Restrict User to only manage specific device(s)
1.0.0 | bug#0002135 | Regular expression support for filter
1.0.0 | bug#0002137 | Data query oid_suffix parameter does not function
1.0.0 | bug#0002159 | Database creation file not fully compliant with strict SQL mode
1.0.0 | bug#0002162 | Unable to authenticate user with password containing UTF-8
1.0.0 | bug#0002196 | Incorrect script server instance number in log
1.0.0 | bug#0002225 | Make -Cc SNMP option configurable
1.0.0 | bug#0002255 | Script query_unix_partitions.pl should only query local mounts
1.0.0 | bug#0002336 | Implement php-snmp class library
1.0.0 | bug#0002340 | Data query script execution should be escaped
1.0.0 | bug#0002350 | SNMP Data Query index_order ignored
1.0.0 | bug#0002351 | Ping does not work with non-English locale
1.0.0 | bug#0002361 | Spine does not log unknowns the same way cmd.php
1.0.0 | bug#0002362 | Poller cmd.php makes wrong hex-string to decimal conversion
1.0.0 | bug#0002370 | Cacti prints wrong date formats, does not honor a systems locale
1.0.0 | bug#0002403 | Typo in DELETE statement leading to poor graphing performance
1.0.0 | bug#0002412 | Graph Template duplication causes \t to be converted to TAB char
1.0.0 | bug#0002418 | Data Source Items named 'ds' break UI ability to add more items
1.0.0 | bug#0002419 | SNMP enum results not parsed correctly by cmd.php poller
1.0.0 | bug#0002452 | CVE-2014-4000 PHP Object Injection Vulnerabilities
1.0.0 | bug#0002454 | OS Command Injection
1.0.0 | bug#0002468 | Changing graph format to anything but PNG causes no output
1.0.0 | bug#0002476 | Add support for SNMP v3 EngineID
1.0.0 | bug#0002483 | Cisco ASA using Re-index method of verify all causes recache event every time
1.0.0 | bug#0002484 | Incorrect SQL request in cli script repair_database.php
1.0.0 | bug#0002521 | Unable to create two devices via CLI with the same IP-Address
1.0.0 | bug#0002522 | Zero padded hex strings are parsed incorrectly
1.0.0 | bug#0002535 | Graph Template Changes not updating RRDtool command
1.0.0 | bug#0002636 | Creating Data Template with "U" for min and max saves field data_input_field_id as 0 for first item
1.0.0 | bug#0002697 | CVE-2016-2313 allows remote authenticated users who use web authentication to bypass intended access
1.0.0 | bug#0002698 | When the host is down the wrong data type are used for some columns in the host table
1.0.0 | bug#0002723 | Renaming a disabled device still attempts to connect and get SNMP host information
1.0.0 | bug#0002724 | Multipage graphs the menu can disappear
1.0.0 | bug#0002725 | Changing graph template does not mark correct interfaces disabled on data query generated list

---
Copyright (c) 2004-2021 The Cacti Group
