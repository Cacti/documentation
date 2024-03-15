# Settings

Cacti has numerous settings that can be changed from the Web
Interface.  Cacti, from it's inception desired to have as many settings
as possible to be configurable without having to goto the Command Line to
make them.  While, for the most part this is still true, there are
several settings that must be configured in the config.php which we
will cover in a separate sub-section.

The standard Settings sub-tabs include:

- [General](Settings-General.md) - This is where Cacti holds a general
  collection of settings that every Cacti administrator should become
  familiar with.
- [Paths](Settings-Paths.md) - Mostly, this sub-tab holds all settings
  that the Cacti administrator has control of.  It also includes some
  settings around RRDfile maintenance.
- [Device Defaults](Settings-Device-Defaults.md) - This is where you can establish
  presets that every new Cacti **Device** get's by default, through
  **Automation**, the CLI or though the Web Interface.
- [Poller](Settings-Poller.md) - Though most **Poller** settings have been
  moved to the **Data Collectors**, some are still managed at the system
  level including the poller type to use, script server and a number
  of additional settings.
- [Data](Settings-Data.md) - This is where you can enable the RRDproxy
  and **Data Source Statistics** collection.  The **Data Source Statistics**
  module allows for the saving of key metrics that are important in
  dash-boarding plugins in Cacti.
- [Visual](Settings-Visual.md) - This is where you can set some preset
  like **Graph** and **Data Source** title lengths, and drop-down sizes
  these Visual settings are global in nature.
- [Authentication](Settings-Auth.md) - This is where Cacti
  defines how **Users** are managed.  There are three Classes of **Users**.

  They include:

  - [Local Users](Settings-Auth-Local.md) - Authentication and Authorization
    all handled in Cacti.  This means passwords are stored locally using strong encryption
  - [Basic Users](Settings-Auth-Basic.md) - Authentication outside of Cacti,
    for example SAML2, TACACS+, NIS, etc.). Authorization remains in Cacti
  - [LDAP Users](Settings-Auth-LDAP.md) - Authentication outside of Cacti,
    either LDAP or Active Directory.  Authorization remains in Cacti
  - [Multiple Domains](Settings-Domains.md) - Multiple Authentication LDAP or
    Active Directory Domains with their own Authorization User Templates.

- [Performance](Settings-Performance.md) - This is where Cacti's `Boost`
  functionality was moved to.  Cacti's `Boost` module allows Cacti to
  scale to systems with over a million **Graphs** and **Data Sources**.
- [Spikes](Settings-Spikes.md) - This is a built-in tool for killing
  spikes on graphs in a scheduled fashion.  It also holds system level
  spike killing defaults.
- [Mail/Reporting/DNS](Settings-Mail-Reporting-DNS.md) - This is where
  Cacti saves settings associated with these three services, for example
  Simple Mail Transfer Protocol (SMTP) settings used for general
  notification across all of Cacti.

In addition, to the base settings, Cacti Plugins can extend settings
for their own purposes.  When a Plugin has few settings
that it uses, the Cacti Group has recommended a sub-tab called
`Misc` for those Plugins for their purposes.  Most Plugins
conform to that guideline.

---
Copyright (c) 2004-2024 The Cacti Group
