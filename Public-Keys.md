# Package Public Keys

The development branch's **Console > Import/Export > Public Keys** screen
manages accepted package-signing identities. A public key verifies a package
signature; the corresponding private key remains with the author. Do not
confuse these keys with SSH login keys, HTTPS server trust, or SNMP
credentials.

## Accept a signing identity

When importing an unfamiliar package, compare the signing key with
independently obtained author information before accepting it. A package's
embedded author name and homepage are claims made by that package, not
independent verification. Cacti validates the signature and enforces the
implementation's key requirements; a signature alone does not prove that
included code is appropriate for your installation.

Acceptance stores the public identity for later imports. Review the accepted
keys when an author rotates keys or an identity is no longer trusted. A valid
signature made with a different key is a different signing identity even if the
displayed author name is unchanged.

## Remove or replace trust

Removing an accepted key changes the stored trust decision for future imports.
It does not undo templates already imported, remove installed scripts, or
revoke an author's access to another system. Cacti also recognizes its
configured built-in signing identities; deleting an accepted-key row does not
redefine those built-in identities.

If a package is invalid or fails the current key requirements, obtain a
corrected release from its author. Do not weaken validation or edit the signed
data to make an import pass.

## Publish packages

Authors generate signing material with `cli/genkey.php`; see [Create
Packages](Create-Packages.md). Keep `package.key` private and protect the
configured PKI directory from HTTP access. Preserve a secured backup so updates
can retain the same identity. Use key replacement deliberately and tell
recipients how to verify the new public identity independently.

This screen manages package trust on the development branch. It is not a
configuration step for Cacti 1.2's ordinary XML importer. See [Import
Packages](Import-Packages.md) and [Template Import](Import-Template.md) for the
different formats and workflows.

---
Copyright (c) 2004-2026 The Cacti Group
