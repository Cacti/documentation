# Plugin Guidelines

---
## Note:

All file attachments (except for images) should be in tar.gz,
tar.bz or zip format.
---

## Plugin Creation

## Plugin Namespaces

User submitted plugin pages can be created by simply entering
`http://docs.cacti.net/userplugin:` followed by the name of your plugin.  ie:
`http://docs.cacti.net/userplugin:my_new_plugin`

## Plugin Defaults

When creating a plugin for the first time, it is automagically populated with a
standard set of defaults. Please complete as many of the sections as possible
to maintain the site standard.

## plugin Data Entry

The very first section is the Data Entry area. Completing this section will
allow for the plugin to be listed on the Plugins page.

### Sample Data Entry

```markdown
---- dataentry plugin_style ----
type:userplugin <-- do not change
userplugin_nspage:my_new_plugin <-- do not change
author_page:wiki:user:my_name
description: A valid description
version:1.0.0
homepage_url: http://example.com
date: 2009-01-30
email: my_name@example.com
license: GPLv2
plugins_tags: syslog
----
```

### Template Tags

At the very bottom of the Plugin_Data_Entry after 'plugins_tags', you can enter
tags that will allow for filtering via the 'tag cloud' at the top of the
Plugins page

Attempt to make these tags as generic as possible, while still retaining
meaningful information.  For example, 'syslog' is sufficient, 'capturing,
syslog, wicked cool, damn near magic' is unnecessary.

---
**Note**: All tags should be in **lowercase** to avoid duplication of tags.
---

## Plugin Deletion

Remove everything in the page except for `DELETEME` and the
admins will purge it.

If there is a file attached to the page, leave the link to the file and place
`DELETEME` beside it.

In 'Edit Summary' ensure you enter `DELETEME` as it will make it easier to
find under Recent Changes.
