# Creating Translations

## Translate Cacti and its plugins

Create an account at the [Cacti Translation Site](https://translate.cacti.net/),
select the project and branch, and choose a language. Review existing strings
or add missing translations through the site's Weblate interface.

Cacti is licensed under GPL 2.0 or later, and translations submitted through
the translation site are contributed under the same terms.

Weblate manages synchronization of language translations with GitHub. Do not
include unrelated language catalog changes in a code pull request.

## Update the source message template

Wrap user-facing strings with Cacti's translation helpers, such as `__()`.
When adding, changing, or removing translatable strings, update
`locales/po/cacti.pot` in the same pull request.

From the Cacti application repository root, use its extraction script:

```console
./locales/update-pot.sh
msgfmt --check-format -o /dev/null locales/po/cacti.pot
```

The script requires GNU gettext (`xgettext`) and `realpath` (GNU coreutils). It
finds the repository from its own location and writes `locales/po/cacti.pot`;
`msgfmt` validates the template. It reads only PHP files at most two directory
levels below the repository root, so confirm that each new or changed message
appears in the template, especially for files in deeper directories. Review the
resulting diff and keep it focused on the changed strings.

Commit the source template, `locales/po/cacti.pot`, with your code change.
Leave per-language `.po` and compiled `.mo` updates to Weblate.

`locales/build_gettext.sh` also regenerates `cacti.pot`, but then merges it into
every language `.po` file with `msgmerge` and compiles each one into
`locales/LC_MESSAGES/`. Use `update-pot.sh` for a code pull request so that
only the template changes.

For a plugin, the repository has `locales/build_gettext.sh` and no
`update-pot.sh`. Like the Cacti script it regenerates the template from the
plugin's PHP files, and it also merges the result into the plugin's `.po` files
and rewrites its `.mo` files. After running it, review the diff and keep the
pull request to the plugin's `locales/po/cacti.pot` template; do not include
hand-edited or merged language catalogs.

## Catalog locations and local testing

Cacti stores the source template and language `.po` files under `locales/po/`.
Compiled runtime catalogs are under `locales/LC_MESSAGES/`.

For local testing, use a separate Cacti installation, compile the relevant
catalog using gettext, and select the language in your user profile. Preserve
the repository's locale names and directory layout. Language catalogs use a
hyphenated locale, such as `fr-FR.po`, not `fr_FR.po`; rename the file if your
editor, for example Poedit, saves it with an underscore. Do not deploy catalog
files from an unrelated branch to a production installation.

You can edit translations with a gettext-compatible editor such as
[Poedit](https://poedit.net/), then submit them through Weblate. Consult the
[Weblate upload documentation][ref-1]
for supported formats and upload options.

Preserve placeholders, plural forms, and formatting markers when translating.
Test messages with substituted values as well as messages containing accented
or non-Latin characters.

[ref-1]: https://docs.weblate.org/en/latest/user/files.html

---

Copyright (c) 2004-2026 The Cacti Group
