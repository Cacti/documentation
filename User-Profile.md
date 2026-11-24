# User Profile

The user profile lets a logged in **User** maintain their own account details
and personal display settings, such as the theme, the default graph timespan
and the layout of the **Graphs** tab. The values set here apply to that
**User** only.

## Opening the Profile

Open the user menu by selecting your login name, shown next to `Logged in
as`, and select `Edit Profile`. The menu entry is only shown to a **User** who
holds the **Update Profile** permission, which is part of the `Normal User`
role in [User Management](User-Management.md).

The page has one tab, **General**. Plugins can add further tabs. When Cacti's
user authentication is turned off, the page shows the message `You must have
built in user authentication turned on to use this feature.` instead.

Use the `Return` button to go back to the page you came from.

## User Account Details

The first section shows the account itself.

###### Table 1. User Account Details

| Field | Description |
| --- | --- |
| **User Name** | The login name for this user. It is displayed only and can not be changed here. |
| **Full Name** | A more descriptive name for this user, that can include spaces or special characters. |
| **Email Address** | An Email Address you can be reached at. |
| **Clear User Settings** | Returns all **User Settings** to their default values. |
| **Clear Private Data** | Clears the data that Cacti keeps in the local and session storage of your browser, including column sizing. |
| **Logout Everywhere** | Clears all your login session tokens and ends your other sessions. The button is only available when **Support Authentication Cookies** is enabled in the Authentication settings and Web Basic Authentication is not in use. |

## User Settings

The **User Settings** section is only shown when the **Maintain Custom Graph
and User Settings** option is enabled for the **User**, or for an enabled
**User Group** that the **User** is a member of. The settings are grouped in
five sections that can be collapsed.

A change is saved as soon as you make it. Changing the **Theme**, the **User
Language** or **Enable Horizontal Scrolling** reloads the page. When you move
the mouse over a setting, a `Reset` link appears that returns that single
setting to its default.

### General Settings

###### Table 2. General Settings

| Setting | Description | Default |
| --- | --- | --- |
| **Theme** | Please select one of the available Themes to skin your Cacti with. | The system wide **Theme** setting |
| **Graph Actions** | Show graph actions in a collapsed menu or as always-visible icons beside each graph. The options are `Collapsed Menu` and `Always-visible Icons`. | `Collapsed Menu` |
| **Default View Mode** | Which Graph mode you want displayed by default when you first visit the Graphs page. Only the views you are permitted to use are offered. | `Tree View` |
| **TimeZone Support** | How Cacti presents dates, including the dates on **Graphs**. The options are `Cacti Server Timezone` and `My Browsers Timezone`. The browser timezone is only used when **Client TimeZone Support** is also enabled in the system settings. | `Cacti Server Timezone` |
| **User Language** | Defines the preferred GUI language. | The default language for new users |
| **Show Graph Title** | Display the graph title on the page so that it may be searched using the browser. | Off |
| **Hide Disabled** | Hides Disabled Devices and Graphs when viewing outside of Console tab. | On |
| **Show Device Aggregates** | If a Device Data Source is included in an Aggregate Graph, show that Graph along with other Device Graphs. | On |
| **Enable Horizontal Scrolling** | Enable Horizontal Scrolling of Tables, Disabling Responsive Column Visibility. | Off |
| **Date Display Format** | The date format to use in Cacti. | The system wide **Date Display Format** setting |
| **Date Separator** | The date separator to be used in Cacti. | The system wide **Date Separator** setting |
| **Page Refresh** | The number of seconds between automatic page refreshes. The options range from `15 Seconds` to `5 Minutes`. | `5 Minutes` |
| **Preview Graphs Per Page** | The number of graphs to display on one page in preview mode. | `10` |
| **Realtime View Mode** | How you wish to view Realtime Graphs, either `Inline` or in a `New Window`. Only shown to a **User** with the **Realtime Graphs** permission. | `Inline` |
| **Auto Log Out Time** | For users with Console access only, how long this user can stay logged in before being automatically logged out. The setting has no effect when Authentication Cookies are enabled. Only shown to a **User** with the **Console Access** permission, and not shown with Web Basic Authentication. | The PHP `session.gc_maxlifetime` value, at most `4 Weeks` |

### Time Spanning/Shifting

###### Table 3. Time Spanning/Shifting

| Setting | Description | Default |
| --- | --- | --- |
| **Default Time Range** | The default RRA to use in rare occasions. | The RRA with the id `1` |
| **Default Timespan** | The default Timespan displayed when viewing Graphs and other time specific data. | `Last Day` |
| **Default Timeshift** | The default Timeshift displayed when viewing Graphs and other time specific data. | `1 Day` |
| **Allow Graph to extend to Future** | When displaying Graphs, allow Graph Dates to extend 'to future'. | On |
| **First Day of the Week** | The first Day of the Week for weekly Graph Displays. | `Monday` |
| **Start of Daily Shift** | Start Time of the Daily Shift. | `07:00` |
| **End of Daily Shift** | End Time of the Daily Shift. | `18:00` |

### Graph Thumbnail Settings

###### Table 4. Graph Thumbnail Settings

| Setting | Description | Default |
| --- | --- | --- |
| **Thumbnail Sections** | Which portions of Cacti display Thumbnails by default. The check boxes are `Preview Mode` and `Tree View`. | `Preview Mode` on, `Tree View` off |
| **Preview Thumbnail Columns** | The number of columns to use when displaying Thumbnail graphs in Preview mode, from 1 to 6. | `2 Columns` |
| **Tree View Thumbnail Columns** | The number of columns to use when displaying Thumbnail graphs in Tree mode, from 1 to 6. | `2 Columns` |
| **Thumbnail Height** | The height of Thumbnail graphs in pixels. | `100` |
| **Thumbnail Width** | The width of Thumbnail graphs in pixels. | `300` |

### Tree Settings

###### Table 5. Tree Settings

| Setting | Description | Default |
| --- | --- | --- |
| **Default Tree** | The default graph tree to use when displaying graphs in tree mode. Only the **Trees** you are allowed to view are offered. | None selected |
| **Graphs Per Page** | The number of graphs to display on one page in tree mode. | `10` |
| **Expand Devices** | Choose whether to expand the Graph Templates and Data Queries used by a Device on Tree. | Off |
| **Site Graph Template Expansion** | When viewing Site Trees, should the Graph Templates branch be included as a Site sub-branch? | The system wide **Site Graph Template Expansion** setting |
| **Tree History** | If enabled, Cacti will remember your Tree History between logins and when you return to the Graphs page. | On |
| **Minimum Tree Width** | The Minimum width of the Tree to contract to. | The system wide **Minimum Tree Width** setting |
| **Maximum Tree Width** | The Maximum width of the Tree to expand to, after which time, Tree branches will scroll on the page. | The system wide **Maximum Tree Width** setting |

### Graph Fonts

The whole section is hidden when the system wide **Font Selection Method**
is set to `Theme`. Otherwise the size and file settings are shown once **Use
Custom Fonts** is checked.

###### Table 6. Graph Fonts

| Setting | Description | Default |
| --- | --- | --- |
| **Use Custom Fonts** | Choose whether to use your own custom fonts and font sizes or utilize the system defaults. | Off |
| **Title Font Size** | The size of the font used for Graph Titles. | `12` |
| **Title Font File** | The font file to use for Graph Titles. | Empty |
| **Legend Font Size** | The size of the font used for Graph Legend items. | `10` |
| **Legend Font File** | The font file to be used for Graph Legend items. | Empty |
| **Axis Font Size** | The size of the font used for Graph Axis. | `8` |
| **Axis Font File** | The font file to be used for Graph Axis items. | Empty |
| **Unit Font Size** | The size of the font used for Graph Units. | `8` |
| **Unit Font File** | The font file to be used for Graph Unit items. | Empty |

## Changing Your Password

The `Change Password` entry of the user menu opens a page where a **User**
replaces their own password. The entry is shown when the **Change Password**
option is enabled for the account and the account belongs to the local login
realm. Cacti does not change LDAP or Active Directory passwords; such an
account gets the message `LDAP/AD based password change not supported.` The
guest account is redirected to the **Graphs** page instead.

The form asks for the **Current password**, the **New password** and
**Confirm new password**. The new password is rejected when:

- it does not meet the password requirements configured in the local
  authentication settings, see [Local Auth](Settings-Auth-Local.md). The
  requirements in force are shown as a tooltip on the form.
- it has been used before and is still in the password history
- the two entries of the new password do not match
- the current password is not correct
- it is the same as the current password

After a successful change Cacti removes the login session tokens and the
stored sessions of the **User** and logs the **User** out, so you have to log
in again with the new password. The change is recorded in the user log as
`Success - Password Change`, see
[System Utilities](System-Utilities.md#view-user-login-history).

When an administrator sets **Must Change Password at Next Login** for an
account, the **User** is sent to this page after login and can not open other
pages until the password has been changed. This does not apply with Web Basic
Authentication.

---

Copyright (c) 2004-2026 The Cacti Group
