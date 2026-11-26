# Configuration - Users, User Groups, and User Domains

Cacti controls who can log in and what each person can see and change through
three areas of the `Configuration` menu in the **Console**: **Users**, **User
Groups** and **User Domains**. All three pages require the **Users/Groups**
permission.

- **Users** - `Console > Configuration > Users`

  A **User** is a single login account with its own permissions and settings.
  See [User Management](User-Management.md).

- **User Groups** - `Console > Configuration > User Groups`

  A **User Group** holds the same kinds of permissions and settings as a
  **User** and passes them on to its members. Only enabled **User Groups**
  are taken into account. See
  [User Group Management](User-Group-Management.md).

- **User Domains** - `Console > Configuration > User Domains`

  A **User Domain** defines an additional login realm that is offered during
  login. Each **User Domain** has a name, a type, the LDAP server settings and
  a **User Template**, which is the account that Cacti uses as a template for
  new user accounts of that domain. A **User Domain** can be enabled,
  disabled and made the default one. See [User Domains](User-Domains.md).

The authentication method itself is selected in the Cacti settings, see
[Authentication](Settings-Auth.md). A **User** who is permitted to do so can
maintain their own details and display settings, see
[User Profile](User-Profile.md).

---

Copyright (c) 2004-2026 The Cacti Group
