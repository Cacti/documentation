# Patch Creation

Submit changes as a GitHub pull request to the repository that owns the code
or documentation. See [Contributing](Contributing.md) to choose a repository.

## Choose the target branch

Use `develop` unless maintainers request another branch. Confirm the target
before starting a maintenance fix. Check that the defect exists on that
branch and that the change preserves its runtime and dependency compatibility.

Keep independent changes in separate pull requests. If a change depends on an
unmerged pull request, target its branch and describe that dependency. Keep
stack branches in the same repository and merge from the bottom up.

## Create a working branch

Fork the relevant repository on GitHub, then clone your fork. This example is
for the Cacti application; substitute `documentation` or `spine` when needed.
Replace `YOUR-USERNAME` with your GitHub username.

```console
git clone https://github.com/YOUR-USERNAME/cacti.git
cd cacti
git remote add upstream https://github.com/Cacti/cacti.git
git fetch upstream
git switch -c fix/device-description upstream/develop
```

For a maintenance contribution, create the branch from the agreed upstream
maintenance branch instead. Configure your Git author identity locally if it
is not already configured; do not copy another contributor's identity.

## Make and validate the change

Keep the patch focused on one problem. Update affected documentation and add
regression coverage for realistic failures. Review the target branch's
contributor instructions, install its locked dependencies, and run the relevant
formatter, analysis, and tests.

For the Cacti development branch, the
[contributor guide](https://github.com/Cacti/cacti/blob/develop/CONTRIBUTING.md)
and `composer.json` describe the available checks. For this manual, follow
[Documentation Standards](Standards-Documentation.md). Maintenance branches may
have different checks; do not introduce new tooling solely for a backport.

Follow the target branch's changelog policy. Where `changelog.d/` fragments are
used, follow its README. If maintainers require a direct root `CHANGELOG` edit,
use the current unreleased section and the real associated issue or advisory
identifier. Keep security entries before issues and issues before features,
placing a numbered issue among its numeric neighbors. Do not put a new fix in
an already released version.

Inspect the patch before committing:

```console
git diff --check
git diff
git status --short
```

Stage the intended files explicitly and write a commit message that explains
the change. Avoid committing generated dependencies, credentials, or unrelated
formatting changes.

## Submit the pull request

Push your working branch to your fork:

```console
git push -u origin fix/device-description
```

Open a pull request in the upstream repository. Confirm both the base branch
and the file diff before submitting. Explain the problem, resulting behavior,
and validation, and link the associated issue. Identify version-specific
behavior or limitations that matter to reviewers.

A pull request with no reported checks is unverified. Fork workflows may wait
for a maintainer's approval; distinguish pending or missing checks from passing
checks. Address review feedback on the same branch.

## Update the branch

Fetch upstream changes and rebase a branch you own onto its intended base when
needed. Resolve conflicts by preserving both changes' behavior, then rerun the
checks relevant to the resolution. Recheck changelog placement and duplicate
entries after resolving a changelog conflict.

If you must replace a previously pushed branch after a rebase, use
`git push --force-with-lease` only for a branch you own and coordinate with
anyone else using it. Do not rewrite shared target branches.

---

Copyright (c) 2004-2026 The Cacti Group
