# Import Packages

Use **Console > Import/Export > Import Packages** for signed `.xml.gz` packages
on the development branch. Unlike [Template Import](Import-Template.md), this
workflow can install selected scripts and query resources as well as database
objects. The repository and public-key screens described here are not Cacti 1.2
interfaces; use its installer or `cli/import_package.php` instead.

## Select the source and preferences

1. Select an enabled **Package Location**, or **Local Package File** to upload
   a package from your computer. Configure missing locations through
   [Repositories](Package-Repositories.md).
2. Review **Data Source Profile**, including **Create New from Template** when
   appropriate. Profile selection does not convert existing RRD files.
3. Review graph format/dimensions, **Remove Orphaned Graph Items**, and
   suggested value-pattern replacement. Orphan removal can delete local graph
   items; pattern replacement can affect names after reindexing or forced
   replacement.
4. Choose the local `.xml.gz` file or select the packages from the repository.
   Inspect the preview before submitting the import.

## Verify the signer and changes

The importer validates package signatures and checks signer trust. Compare an
unfamiliar signing identity with information obtained independently from the
author before accepting it. The name or homepage inside a package is not
independent proof. See [Package Public Keys](Public-Keys.md).

Inspect the template objects and file changes, including paths and whether
existing files will be replaced. Import only the objects and files needed for
the selected templates. Make a database and file backup before updating
existing objects. Preview is not a strictly read-only audit: compatibility
repair can update existing system data-input metadata in the import path.

If a signature, key, dependency, file permission or download check fails,
resolve that failure before continuing. Do not modify a signed payload to work
around verification; obtain a corrected package from the author.

## Apply and verify

Submit **Import** after reviewing the selected templates, files and signer.
Check the result messages and `cacti.log`; a downloaded package or completed
preview does not establish that all requested objects/files were installed.

Confirm the imported templates and required scripts/query resources on the
collector that will poll the device. Grant temporary resource-directory write
access only where required by the operation, then restore intended permissions.
Complete the package's external setup, such as SNMP-agent configuration or
credentials. Create a test graph and verify its measurements before applying
the template across a fleet.

For command-line use, run `php cli/import_package.php --help` from the
installed Cacti directory and use the selected release's options. `--filename`
selects a package and `--preview` requests a preview; CLI and web preferences
are not interchangeable arguments.

---
Copyright (c) 2004-2026 The Cacti Group
