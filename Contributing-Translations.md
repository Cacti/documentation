# Creating Translations

## Internationalization of Cacti and its Plugins

If you wish to help with the development of translations of Cacti from English
to other languages, the Cacti Group has simplified the process for you.

You simply have to go to the following Web Site and create an account.
[Cacti Translation Site](https://translate.cacti.net). From there, you can
simply select what you want translated, and then push the "translate" button on
your language of choice, and the beauty of the translation is that if the string
that you translate is in another plugin, it can also be automatically translated
at the same time.

If you make a change to the translations, they are automatically committed back
to GitHub programmatically. To install the new language strings, you simply have
to update the `locales` directory from the latest GitHub branch that you were
translating.

The `locales` directory has two subdirectories and four files. They are:

```console
# ls -1 locales/
LC_MESSAGES
build_gettext.sh
build_mo.sh
index.php
po
update-pot.sh
```

The LC_MESSAGES includes the compiled language files, and the po directory
includes not only the base Cacti translation file `cacti.pot`, but all currently
supported languages as well. The scripts are described in the next section.

## Pull Requests

If you are making changes to the core Cacti code that add, change or remove
strings to be translated, your Pull Request should include an updated
`locales/po/cacti.pot` file. Open a shell and run the script `update-pot.sh`
from the `locales` directory:

```console
cd locales
./update-pot.sh
```

The script locates the Cacti base directory from its own path, so it can also
be started from elsewhere. It requires `realpath` and `xgettext` (GNU gettext).
It scans the PHP files in the Cacti source for strings to be internationalized
and rewrites only `locales/po/cacti.pot`. You can check the result with
`msgfmt --check-format -o /dev/null locales/po/cacti.pot`. Commit only
`cacti.pot` with your code change. The per-language `.po` files and the compiled
`.mo` files are left to the translation site, which commits them itself.

Do not use `build_gettext.sh` for a code Pull Request. As well as rebuilding
`cacti.pot`, it runs `msgmerge --update` on every `.po` file in `locales/po` and
then compiles every `.po` file into `locales/LC_MESSAGES`, so following it
changes every language catalog. The `build_mo.sh` script only compiles the `.po`
files into `.mo` files.

Plugins have a `locales/build_gettext.sh` script and no `update-pot.sh`. It
works as described above: it rebuilds `locales/po/cacti.pot` from the plugin's
PHP files, merges the changes into every `.po` file and compiles the `.mo`
files. Language catalogs of plugins are also maintained through the translation
site, which commits them to the plugin repository. If you run the script for a
plugin Pull Request, review the diff and keep the Pull Request to the template.

## Translating using other tools

You may use other tools to Translate Cacti as well. One popular tool is
Poedit, you can download it here: [Poedit](https://poedit.net/).

If you choose to use that route, you will need to still have a Cacti Translation
account. From there, you can upload your modified `language.po` files into the
interface directly. See the Weblate documentation on how to upload your modified
`language.po` files.

1. Once Poedit is installed, open it, and select File -> New from POT/PO file,
   and select the cacti.pot file. When you click 'Open', it will ask you for
   what language you are translating to. Cacti uses the dual syntax of Language
   (Country). So, for French, you would select 'French (France)'.

1. Once you have done that, you can start your translation. You will select each
   phrase one at a time, and enter in the translation in your language.

1. You should save your work often.

1. You can test your work on a test installation. Upload both .mo and .po files
   to your test installation and change your user profile to use the language
   you have just updated.

1. Cacti and its plugins get updates very often. To make sure the translations
   are up to date, the translator should download the latest version and run
   `update-pot.sh` (`build_gettext.sh` in a plugin) to create an up-to-date
   version of cacti.pot.

When translating, preserve placeholders such as `%s` and `%d`, plural forms and
formatting markers exactly as they appear in the original string. Check messages
that contain substituted values, and messages with accented or non-Latin
characters, on a test installation.

## Editing PO Files

The PO Editor will create both a PO and MO file every time you save the file.
The final name of the file will have to be changed to Cacti's standard naming.
For example, Poedit saves the file from the example above as `fr_FR.po`, but
Cacti will need these file names in hyphenated format, so: `fr_FR.po`, becomes
`fr-FR.po`. Make that note especially if you are starting a new language.

## Considerations

As Cacti is GPL2.0+, you acknowledge, by signing up to the Cacti Weblate site,
that your contributions will be GPL2.0+ as well.

---

Copyright (c) 2004-2026 The Cacti Group
