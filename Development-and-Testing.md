# Development and Testing

Use the contribution instructions in the branch and repository you change.
Application code belongs in Cacti, manual content in this documentation
repository, and plugin behavior in the relevant plugin repository.

## Choose the Source and Version

Start with [Contributing](Contributing.md) and the target branch's
[application contributor guide][contributing]. Read the supported PHP and Node
versions and install dependencies from their committed lockfiles. Maintenance
branches can use a different toolchain from `develop`.

Follow the applicable [development standards][standards]
and [security guidance](Standards-Security.md). Keep a fix focused on its
reported behavior and preserve the target branch's compatibility.

## Theme and Plugin Checks

The workflow described below was proposed in
[Cacti pull request 8522][theme-pr], which was closed without merging.
It is not an available upstream workflow. The pinned
[validation guides][guides] preserve reproduction commands, fixture revisions,
and per-theme screenshots for that proposal. Check your target branch for
the workflows and commands it currently supports.

The proposal's browser component suites cover core theme rendering, seven
standalone Cacti plugins, and the available RTM plugin surfaces across eleven
core themes
and both Midwinter palettes. Fixtures use synthetic monitoring values and real
stylesheets. They do not exercise plugin authentication, backend requests,
pollers, schedulers, or live license servers.

RTM source inventory checks account for all eighteen plugin directories.
Project Mapping contains demo setup files rather than an installable UI.
FusionCharts and its theme scripts are absent from the public RTM source, so
chart rendering and tooltips require the matching runtime assets.

## Read Actions Results

The proposed theme workflow separates core rendering, each standalone plugin,
and RTM into named jobs. The aggregate **Theme validation** check requires
every job to succeed. It runs for pull requests, merge-queue checks,
development pushes,
and manual runs in repositories that adopt the workflow.

Open a job's summary to see actual pass, fail, flaky, and skipped counts.
Download its artifact for the HTML report, JSON and JUnit results, populated
screenshots, contrast comparisons, fixture provenance, and available CSS
coverage. Failed tests retain traces, screenshots, and videos. Artifacts are
named per suite or plugin and run attempt and are retained for fourteen days.

The core gate requires 100% coverage of changed executable CSS lines on PR
and merge-queue runs. That is not whole-project or branch coverage. Existing
plugin palette deficits remain recorded against a pinned baseline; a passing
comparison does not certify every pre-existing color as accessible.

Use the [Actions guide][ci] for local commands, artifact downloads,
reruns, and failure diagnosis. Commit a small reviewed set of screenshots with
the relevant guide; expiring run artifacts should not be README image URLs.

## Documentation Checks

Follow [Documentation Standards](Standards-Documentation.md#validate-changes).
New guides belong in the [complete manual index](Manual-Index.md), with their
entry points linked from the [documentation homepage](README.md).

Check Markdown style, spelling, navigation targets, image paths, and heading
fragments. Preserve public page names and existing fragment links when
reorganizing a page. Generated manuals must follow the same chapter order and
record their source revision and checksums in the
[download manifest](resource/pdf/build_manifest.json).

[standards]: Manual-Index.md#development-standards
[contributing]: https://github.com/Cacti/cacti/blob/develop/CONTRIBUTING.md
[theme-pr]: https://github.com/Cacti/cacti/pull/8522
[guides]: https://github.com/Cacti/cacti/tree/35d036f/docs/validation
[ci]:
  <https://github.com/Cacti/cacti/blob/35d036f/docs/validation/github-actions.md>

---

Copyright (c) 2004-2026 The Cacti Group
