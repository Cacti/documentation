# How To Determine a Cacti Template Version

Template XML object names combine an object-type code, a compatibility code,
and an object identity. The compatibility code does not identify an exact
exporting Cacti release, because several releases can share it.

For example:

```text
hash_040018258d1c9487a6c58dd804f4a012007664
     04     object type
       0018 compatibility code
           258d1c9487a6c58dd804f4a012007664 object identity
```

The first two characters identify the object type. The next four are the
compatibility code, and the remaining 32 hexadecimal characters identify the
object. Preserve these identities when exporting an update to existing objects.
The author's template or package version is a separate value.

## Compatibility code families

###### Table 1. Selected code families

| Code | Releases represented in the source mapping |
| --- | --- |
| `0018` | Cacti 0.8.7d, the legacy example above. |
| `0024` | Cacti 0.8.8, 0.8.8a and 0.8.8b. |
| `0025` | Cacti 0.8.8c through 0.8.8h. |
| `0100` | Cacti 1.0.x and 1.1.0 through 1.1.5. |
| `0101` | Cacti 1.1.6 through 1.2.2. |
| `0102` | Cacti 1.2.3 through 1.2.18. |
| `0103` | Cacti 1.2.19 and later 1.2.x entries in the mapping. |

For the complete mapping, consult `include/global_arrays.php` in the selected
Cacti release. Older `0000`–`0017` codes also appear there. The [source
mapping][mapping] and [version gate][gate] show the behavior inspected for this
documentation branch.

For example, the gate for a Cacti 1.2.3 installation recognizes the same `0102`
code used by 1.2.18. Passing this gate does not prove every dependency or
imported field is usable; review the import preview and the template author's
requirements.

## Resolve an import error

An unknown code is absent from the installed mapping. A recognized code can
also be newer than the installed version's code. These conditions differ from
an invalid XML document, an unmet dependency, or a damaged export.

Check the full error in `cacti.log`, confirm the exporting release and required
dependencies with the author, and use a compatible export or upgrade Cacti when
required. Do not rewrite hash prefixes to bypass validation. See [Template
Import](Import-Template.md) for the actual import workflow.

[mapping]:
  <https://github.com/Cacti/cacti/blob/728c376118e4a2b0c16f66c57d7b000002a63394/include/global_arrays.php>
[gate]:
  <https://github.com/Cacti/cacti/blob/728c376118e4a2b0c16f66c57d7b000002a63394/lib/import.php>

---
Copyright (c) 2004-2026 The Cacti Group
