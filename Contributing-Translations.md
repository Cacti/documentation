# Creating Translations

## Translate Cacti and its plugins

Create an account at the [Cacti Translation Site](https://translate.cacti.net/),
select the project and branch, and choose a language. Review existing strings
or add missing translations through the site's Weblate interface.

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

The script requires GNU gettext (`xgettext`); `msgfmt` validates the template.
Review the resulting diff and keep it focused on the changed strings. The
script and extraction coverage can differ by branch, so confirm that each new
or changed message appears in the template.

Commit the source template, `locales/po/cacti.pot`, with your code change.
Leave per-language `.po` and compiled `.mo` updates to Weblate.

## Catalog locations and local testing

Cacti stores the source template and language `.po` files under `locales/po/`.
Compiled runtime catalogs are under `locales/LC_MESSAGES/`.

For local testing, use a separate Cacti installation, compile the relevant
catalog using gettext, and select the language in your user profile. Preserve
the repository's locale names and directory layout. Do not deploy catalog
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
