# Create Packages

A Cacti package is a signed `.xml.gz` file containing template definitions and
selected scripts or query resources. This development-branch interface is
separate from [ordinary XML export](Export-Template.md). Cacti 1.2 has
installer and CLI package import support, but not these package-management
screens.

## Prepare the author and signing keys

Run `cli/genkey.php --help` with PHP from the Cacti installation to review the
options for that version. For a new author identity, an example is:

```sh
php cli/genkey.php --generate \
  --author="Template Author" \
  --homepage="https://example.org/templates" \
  --email="templates@example.org" \
  --country=US --state=Example --org=Example --unit=Monitoring --days=365
```

Replace the example metadata with the author's details. The tool writes the
signing material and author information into the configured PKI directory.
`package.key` is private; `package.pem` is the certificate, `package.pub` is
the public key, and `package.info` contains author metadata. Allow the
packaging process to read what it needs, keep the private key inaccessible
through HTTP, and back up the author identity securely. Do not publish the
private key.

Reuse the existing identity when publishing an update. `--replace` replaces
signing material; it is not an ordinary package-update step. Changing keys also
changes the identity recipients must verify and trust. See [Package Public
Keys](Public-Keys.md).

## Build the package

1. Open **Console > Import/Export > Create Packages**.
2. Choose the object type and exact template to export. Select **Include
   Dependencies** when the recipient needs its referenced templates, input
   methods, queries, profiles, CDEFs and VDEFs.
3. Complete the description, license, version, class, tags and installation
   instructions. The package version is the author's version, not the Cacti XML
   hash compatibility code.
4. Inspect the dependent files and include the scripts/query resources required
   by the template. Check any dependencies that cannot be discovered from paths
   in the template; an external agent, credentials or device configuration is
   not supplied merely by including a script.
5. Submit the package and check for export errors. Download the resulting
   signed `.xml.gz` file.

The Device Templates screen can also **Download** a package or **Archive** its
current definition with a note. Those actions appear when the package public
key exists; successful packaging also needs the matching signing material and
author information. An archive is a saved package definition, not a backup of
collected RRD data.

## Verify before distribution

Test the package in a separate Cacti installation using the recipient's
release. Follow [Import Packages](Import-Packages.md), review the signer and
selected files, and confirm the templates, scripts and queries are present.
Then create a graph for a device exposing the required measurements and verify
collected values. A valid signature does not establish device or firmware
compatibility.

Distribute the package with its author version, required Cacti/runtime
versions, external setup instructions and independently verifiable signer
information. For repository distribution, see [Package
Repositories](Package-Repositories.md).

---
Copyright (c) 2004-2026 The Cacti Group
