# Known Issues

Use the issue tracker and release notes to check whether a problem affects
**your installed version**. This page points to those maintained sources;
it is not a complete list of open defects.

## Check existing reports

- [Open Cacti issues][ref-1]
  include reported problems and proposed improvements. An open report is not
  confirmation that every release is affected.
- [Cacti releases](https://github.com/Cacti/cacti/releases) describe published
  versions. Check the changelog included with your version and the target
  release of any linked fix. A fix merged into `develop` may not be available
  in a released maintenance version.
- [Security advisories](https://github.com/Cacti/cacti/security/advisories)
  describe published vulnerabilities, affected versions, and available fixes.
- For a plugin problem, use the issue tracker and release notes of that
  [Cacti plugin's repository](https://github.com/orgs/Cacti/repositories).

Search both open and closed issues using the error message, affected feature,
and version. Before applying a workaround, confirm that it matches your
release and environment. Back up the database, RRD files, and configuration
before an upgrade or a change that can alter stored data.

## Troubleshoot or report a problem

For installation and usage questions, search the
[Cacti Forums](https://forums.cacti.net/). For missing measurements or blank
graphs, start with [data source debugging](Data-Debug.md) and the
[Cacti log](Cacti-Log.md).

If you find a reproducible defect, follow the
[contribution guide](Contributing.md). Include the Cacti and Spine versions,
operating system, PHP and database versions, steps to reproduce, expected
behavior, and relevant logs with credentials and sensitive information removed.

Report suspected vulnerabilities privately using the
[Cacti security policy](https://github.com/Cacti/cacti/security/policy).
Do not put credentials or exploit details in a public issue.

[ref-1]: https://github.com/Cacti/cacti/issues?q=is%3Aissue+is%3Aopen

---

Copyright (c) 2004-2026 The Cacti Group
