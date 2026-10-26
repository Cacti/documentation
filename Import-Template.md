# Template Import

**Import Templates** imports ordinary template XML into Cacti. Templates can
create new objects or update objects identified by matching hashes. Back up
existing definitions before importing an update from a template author.

## Template XML and signed packages

Signed `.xml.gz` packages also contain resource files. Select bundled packages
in the installer, or use `cli/import_package.php` on the main collector for an
existing installation. Run it with PHP from the Cacti installation and consult
`--help` for the selected release's options. `--filename` selects the package
and `--preview` previews proposed template changes. Do not upload these
packages to the ordinary XML importer.

An ordinary XML import may require scripts under `scripts` and query
definitions under `resource` to be installed separately. Follow the author's
instructions and inspect the collection method and dependencies first.

## Import template XML

1. Open **Console > Import/Export > Import Templates**.
2. Choose the **Data Source Profile** for the resulting definitions, or
   **Create New from Template** when the export includes a profile to import.
   Review graph format/dimension overrides and the update options before
   choosing the file.
3. Use **Select File** to choose the XML. File selection automatically requests
   a preview and displays the proposed objects and changes. There is no preview
   checkbox to untick and no need to upload the same file a second time.
4. Review new, updated, damaged and unchanged objects and missing dependencies.
   Select the objects you intend to import; the interface notes that selecting
   none imports all. Resolve errors before continuing.
5. Press **Import** to submit the selected file and options. Check the
   resulting messages and `cacti.log`, then verify the imported templates and
   required resources before creating graphs.

![Import Template](images/import-template.png)

Preview is not a strictly read-only audit. Compatibility repair can update
existing system data-input metadata during the import path, even in preview.
Use an isolated copy when assessing an untrusted or disruptive update.

## Update options

**Remove Orphaned Graph Items** deletes items absent from the incoming graph
template, from both that template and its attached graphs. This can be useful
when deliberately adopting a revised definition; it is not restricted to
damaged templates and is not required for every update. Review orphaned items
first, especially when retaining local customizations.

**Replace Data Query Suggested Value Patterns** replaces the query's suggested
naming patterns. Graph and data-source names can change after reindexing or a
forced suggested-value replacement. Review these changes separately from graph
item deletion.

The selected profile and graph overrides affect imported definitions; importing
a new profile does not automatically migrate the physical structure of existing
RRD files. See [Data Source Profiles](Data-Profiles.md).

For compatibility errors, see [Determine a Template
Version](How-To-Determine-Template-Version.md). For sharing complete
definitions, see [Template Export](Export-Template.md).

---
Copyright (c) 2004-2026 The Cacti Group
