# Contributing

Cacti accepts bug reports, code changes, documentation corrections, and
translations. Choose the repository that owns the affected component:

- [Cacti](https://github.com/Cacti/cacti) for the application.
- [Documentation](https://github.com/Cacti/documentation) for this manual.
- [Spine](https://github.com/Cacti/spine) for the C poller.
- The relevant [Cacti plugin repository][ref-1]
  for a plugin.

## Report a problem

Search the project's open and closed issues before opening a report. Include
versions, reproduction steps, expected and actual behavior, and relevant logs.
Remove passwords, SNMP communities, tokens, and other sensitive information.
See [Known Issues](Known-Issues.md) for release notes and existing reports.
For installation or usage help, use the [Cacti
Forums](https://forums.cacti.net/).

Report suspected vulnerabilities privately through the
[Cacti security policy](https://github.com/Cacti/cacti/security/policy).

## Code contributions

Create a branch for one focused change and submit a pull request to the
repository that owns it. Use `develop` unless maintainers request another
branch. Check the issue and target branch before starting a maintenance fix;
a change needed on one branch may already be fixed on another.

Read the contributor instructions in that branch. In the Cacti development
repository, `composer.json` defines PHP requirements and checks, `.nvmrc`
specifies the Node version, and `package-lock.json` locks frontend dependencies.
For a development checkout, install dependencies from the repository root:

```console
composer install
npm ci
```

Use the branch's formatter, static analysis, and relevant tests before
submitting. The development branch provides `composer check`; consult its
[contributor guide](https://github.com/Cacti/cacti/blob/develop/CONTRIBUTING.md)
for individual commands. Maintenance branches may have different tools.
Describe what changed and how you verified it. Add regression coverage when
it protects against a realistic failure, and link the associated issue.

Follow the [code formatting](Standards-Code-Formatting.md),
[PHP](Standards-PHP-Spec-Constructs.md), [SQL](Standards-SQL.md), and
[security](Standards-Security.md) guides. Update relevant documentation and
follow the target branch's changelog instructions. See
[Patch Creation](Standards-Patch-Creation.md) for the submission workflow.

## Documentation contributions

Submit manual changes to
[the documentation repository](https://github.com/Cacti/documentation).
Explain the correction and link an existing issue where applicable. Check
instructions against the Cacti branch being documented, distinguish released
features from development features, and verify commands, links, and images.

Follow the [Documentation Standards](Standards-Documentation.md) and link new
pages from `README.md`. Updating this repository does not immediately update
the public website; publication depends on the project's documentation build
and deployment process.

## Translations

Use the [translation guide](Contributing-Translations.md) to contribute through
Cacti's translation service. Changes to translatable application strings must
also update the source message template as described in that guide.

[ref-1]: https://github.com/orgs/Cacti/repositories

---

Copyright (c) 2004-2026 The Cacti Group
