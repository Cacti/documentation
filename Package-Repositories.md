# Package Repositories

A package repository supplies a `package.manifest` and package files to the
**Import Packages** interface. On the development branch, manage locations
under **Console > Import/Export > Repositories**. These management screens are
separate from Cacti 1.2's installer and CLI package-import workflow.

## Add a repository

Create a repository and give it a recognizable name. Choose its type:

###### Table 1. Repository types

| Type | Location and additional settings |
| --- | --- |
| GitHub Based | The repository URL and an explicit branch. Use the optional API key only if access requires it. |
| File Based | The directory containing the manifest and packages on the Cacti server, not a path on your browser's computer. |
| Direct URL | The base URL serving the manifest and packages. |

For a GitHub-based location, use a repository URL such as
`https://github.com/Cacti/packages/` and a branch that actually contains the
manifest. Do not enter a browser URL for an individual file. The importer looks
for `package.manifest` at the selected repository location/branch.

For a direct URL, use the repository's base location so that the manifest and
referenced packages resolve beneath it. Use HTTPS where available. For a file
location, make the directory readable by the Cacti service account. Keep any
repository API credentials private and out of exported templates or examples.

Enable the repository to make it available in **Import Packages**. Mark it as
the default only if it should be selected initially. Save and inspect the
reachability/manifest result; a reachable host without the manifest is not a
usable repository.

## Import and maintain

Open [Import Packages](Import-Packages.md), select the enabled location, and
review available packages, signer identities and the proposed changes.
Repository access and package-signature trust are separate decisions. Merely
adding a URL does not establish that every package author should be trusted.

The Actions menu can enable, disable, delete, or select a default repository.
Disabling a location stops offering it for imports; it does not remove
templates or files previously imported from it. If a manifest or download
becomes unavailable, check the configured branch/path, credentials and
service-account access before retrying. Do not replace a failed signed download
with an edited payload.

Package authors should use [Create Packages](Create-Packages.md) and follow the
repository's manifest format and publication procedure when adding a release.
Record package versions and required external setup; a repository listing is
not a device-certification matrix.

---
Copyright (c) 2004-2026 The Cacti Group
