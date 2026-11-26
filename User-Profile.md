# User Profile

The user profile is where a signed-in **User** maintains their own account
details and personal display settings, changes their password, and enables
two-factor authentication.  This page follows **develop**, the unreleased
Cacti 1.3 series; labels and defaults are those of the development source.

## Open the Profile

Open the user menu and select **Edit Profile**.  The entry is shown to users
with the **Update Profile** permission.  The profile is not available when
Cacti's user management is turned off.

The page has a **General** tab.  A **2FA** tab is added when the administrator
has checked **Enable Localized 2FA**, and plugins can add further tabs.  When
only one tab exists, no tabs are drawn.

## User Account Details

| Field               | Purpose                                                  |
| ------------------- | -------------------------------------------------------- |
| User Name           | The login name for this user.  It cannot be changed here |
| Full Name           | A more descriptive name for the user                     |
| Email Address       | An Email Address where the user can be reached           |
| Clear User Settings | Returns all User Settings to their default values        |
| Clear Private Data  | Clears data kept in the browser, including column sizing |
| Logout Everywhere   | Ends the user's sessions on all other devices            |

**Logout Everywhere** is shown only when **Support Authentication Cookies** is
checked in the [Authentication settings](Settings-Auth.md), and is hidden with
Basic Authentication.  It removes the user's authentication cookies and ends
the user's other sessions; the current session stays signed in.

## User Settings

The **User Settings** box is shown only to users with the
**Maintain Custom Graph and User Settings** option.  A change to a setting is
saved as soon as it is made; the page has no save button.  Hovering over a
setting shows a **Reset** link that returns that one setting to its default.

### General Settings

| Setting                     | Purpose                                           | Default               |
| --------------------------- | ------------------------------------------------- | --------------------- |
| Theme                       | The Theme used to skin Cacti                      | The global **Theme**  |
| Graph Actions               | Show graph actions in a collapsed menu or as always-visible icons beside each graph | Collapsed Menu |
| Default View Mode           | The Graph mode displayed when first visiting the Graphs page | Tree View  |
| Page Filter Format          | How table filters are presented.  `Modern` collapses the filter into a Layouts selector with an Edit dialog; `Legacy` shows the classic inline filter | Modern |
| TimeZone Support            | Present dates in the Cacti server timezone or the browser timezone | Cacti Server Timezone |
| User Language               | The preferred GUI language                        | The default language for new users |
| Show Graph Title            | Display the graph title on the page so that it can be searched using the browser | Unchecked |
| Show Business Hours         | Show business hours on the Graphs by default      | Unchecked             |
| Hide Disabled               | Hide disabled Devices and Graphs when viewing outside of the Console tab | Checked |
| Show Device Aggregates      | Show an Aggregate Graph along with the other Graphs of a Device whose Data Source it includes | Checked |
| Enable Horizontal Scrolling | Enable horizontal scrolling of tables, disabling responsive column visibility | Unchecked |
| Date Display Format         | The date format to use in Cacti                   | The global setting    |
| Date Separator              | The date separator to use in Cacti                | The global setting    |
| Page Refresh                | The number of seconds between automatic page refreshes | 5 Minutes        |
| Preview Graphs Per Page     | The number of graphs on one page in preview mode  | 20                    |
| Realtime View Mode          | How Realtime Graphs are viewed: `Inline` or `New Window` | Inline         |
| Auto Log Out Time           | How long the user can stay logged in before being logged out automatically | The PHP session lifetime |

Some settings are shown only in certain cases:

- **Default View Mode** offers only the views the user is permitted to see.
- **TimeZone Support** is hidden when the global **TimeZone Support** setting
  is disabled.
- **Realtime View Mode** requires the **Realtime Graphs** permission.  See
  [Realtime Graphs](Viewing-Graphs.md#realtime-graphs).
- **Auto Log Out Time** requires the **Console Access** permission.  It is
  not offered with Basic Authentication, or for a remembered session when
  authentication cookies are enabled, and it has no effect when authentication
  cookies are enabled.  Choices longer than the PHP `session.gc_maxlifetime`
  value are removed.

### Time Spanning/Shifting

| Setting                         | Purpose                                         | Default  |
| ------------------------------- | ----------------------------------------------- | -------- |
| Default Time Range              | The default RRA to use in rare occasions        | The RRA with ID 1 |
| Default Timespan                | The Timespan displayed when viewing Graphs and other time specific data | Last Day |
| Default Timeshift               | The Timeshift displayed when viewing Graphs and other time specific data | 1 Day |
| Allow Graph to extend to Future | Allow Graph dates to extend into the future     | Checked  |
| First Day of the Week           | The first day of the week for weekly Graph displays | Monday |
| Start of Daily Shift            | Start time of the daily shift                   | 07:00    |
| End of Daily Shift              | End time of the daily shift                     | 18:00    |

### Graph Thumbnail Settings

| Setting                     | Purpose                                             | Default |
| --------------------------- | --------------------------------------------------- | ------- |
| Thumbnail Sections          | Which portions of Cacti display Thumbnails by default: **Preview Mode** and **Tree View** | Preview Mode checked, Tree View unchecked |
| Preview Thumbnail Columns   | The number of columns for Thumbnail graphs in Preview mode, 1 to 6 | 2 Columns |
| Tree View Thumbnail Columns | The number of columns for Thumbnail graphs in Tree mode, 1 to 6 | 2 Columns |
| Thumbnail Height            | The height of Thumbnail graphs in pixels            | 100     |
| Thumbnail Width             | The width of Thumbnail graphs in pixels             | 300     |

### Tree Settings

| Setting            | Purpose                                                   | Default |
| ------------------ | --------------------------------------------------------- | ------- |
| Default Tree       | The graph tree used when displaying graphs in tree mode   | Not set |
| Graphs Per Page    | The number of graphs to display on one page               | 10      |
| Expand Devices     | Expand the Graph Templates and Data Queries used by a Device on a Tree | Unchecked |
| Tree History       | Remember the Tree History between logins and when returning to the Graphs page | Checked |
| Minimum Tree Width | The minimum width the Tree contracts to                   | The global setting |
| Maximum Tree Width | The maximum width the Tree expands to, after which Tree branches scroll | The global setting |

**Default Tree** lists only the **Trees** the user is allowed to view.  The
global tree widths are set in
[Visual Settings](Settings-Visual.md#theme-table-tree-and-filter-settings).

### Graph Fonts

| Setting          | Purpose                                             | Default   |
| ---------------- | --------------------------------------------------- | --------- |
| Use Custom Fonts | Use your own fonts and font sizes or the system defaults | Unchecked |
| Title Font Size  | The size of the font used for Graph Titles          | 12        |
| Title Font File  | The font file to use for Graph Titles               | Not set   |
| Legend Font Size | The size of the font used for Graph Legend items    | 10        |
| Legend Font File | The font file to use for Graph Legend items         | Not set   |
| Axis Font Size   | The size of the font used for Graph Axis            | 8         |
| Axis Font File   | The font file to use for Graph Axis items           | Not set   |
| Unit Font Size   | The size of the font used for Graph Units           | 8         |
| Unit Font File   | The font file to use for Graph Unit items           | Not set   |

The font size and font file fields are shown only when **Use Custom Fonts** is
checked and the global **Font Selection Method** in
[Visual Settings](Settings-Visual.md#realtime-and-rrdtool-graph-options) is
`Theme`.

## Change Password

A **User** changes their own password from the **Change Password** entry of
the user menu.  The entry is shown for local accounts that have the
**Change Password** account option.  The page is not available to accounts of
other login realms or to the guest account.

Enter the **Current password**, the **New password** and
**Confirm password**, then press **Save**.  The current password is not
requested when the account has no stored password.  The page lists the
password requirements that the administrator has set in
[Local Authentication](Settings-Auth-Local.md).  Cacti rejects a new password
that fails those requirements, that does not match its confirmation, that is
the same as the old password, or that is still in the password history.

When a password change is required, for example because the account has
**Must Change Password at Next Login** set, Cacti redirects to the same page,
and it offers no **Return** button until the password has been changed.

## Two-Factor Authentication

Localized two-factor authentication adds a time-based token from an
authenticator app to the login of one account.  It is available when the
administrator has checked **Enable Localized 2FA** in
[Local Authentication](Settings-Auth-Local.md#localized-2fa), which is
unchecked by default.

To enable it for your account:

1. Open **Edit Profile** and select the **2FA** tab.
2. Check **2FA Enabled**.  Cacti generates a secret and shows it as a QR code
   in the **2FA QA Code** row.
3. Scan the code with Google Authenticator, Authy or any compatible 2FA app.
4. Enter the token that the app shows in **2FA App Token** and press
   **Verify App Token**.

Two-factor authentication is active only after the token has been verified.
If the code is not accepted, the page reports the error and the token can be
entered again.

At the next login, Cacti asks for the token after the password, on the
**2FA Verification** page.  A verified token is remembered for the
**Token Lifetime**, which defaults to 1 Day, by a cookie that is bound to the
account and the browser.

To disable two-factor authentication, clear **2FA Enabled** on the same tab.
This also discards the secret, so enabling it again requires a new scan.  An
administrator can do the same for a user who has lost their device: under
**Console > Configuration > Users**, select the account and choose the
**Reset 2FA** action, which is offered while **Enable Localized 2FA** is
checked.

---

Copyright (c) 2004-2026 The Cacti Group
