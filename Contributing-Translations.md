# Creating Translations

## Internationalization of Cacti and its Plugins

If you wish to help with the development of translations of Cacti from English
to other languages, the Cacti Group has simplified the process for you.

You simply have to goto the following Web Site and create an account.
[Cacti Translation Site](https://translate.cacti.net).  From there, you
can simply select what you want translated, and the push the "translate"
button on your language of choice, and the beauty of the translation is
that if the string that you tranlate is in another plugin, it can also
be automatically translated at the same time.

If you make a change to the translations, they are automatically committed
back to GitHub programatically.  To install the new language strings,
you simply have to update the `locales` directory from the latest
GitHub branch that you were translating.

The `locales` directory has two separate subdirectories.  They are:

   ```console
   # ls -1 locales/
   LC_MESSAGES
   po
   ```

The LC_MESSAGES includes the compiled language files, and the po
directory includes not only the base Cacti translation file
`cacti.pot`, but all currently supported languages as well.

## Pull Requests

If you are making changes to the core Cacti code that involve new
strings to be translated, you have to ensure that your Pull Request
includes an updated `cacti.pot` file.  To update the `cacti.pot`
file, you simply open a shell and change to the `locales`
directory and run the script `build_gettext.sh`.  It will scan
the Cacti source code for all strings to be internationalized
and update the `cacti.pot` file.

If you include the updated file in your pull request, it will
keep the development engine running smooth.

## Translating using other tools

You may use other tools to Translate Cacti as well.  One popular
tool is PO Editor, you can download it here:
[Poedit Pro](https://poedit.net/pro).  The tool does work well and also run
machine translations for you at an added cost.

If you choose to use that route, you will need to still have a Cacti Translation
account.  From there, you can upload your modified `language.po` files into
the interface directly.  See the Weblate documentation on how to upload your
modified `language.po` files.

4. Once Poedit is installed, open it, and select File -> New from POT/PO file,
   and select the cacti.pot file.  When you click 'Open', it will ask you for
   what language you are translating to.  Cacti uses the dual syntax of
   Language (Country).  So, for French, you would select 'French (France)'.

5. Once you have done that, you can start your translation.  You will select
   each phrase one at a time, and enter in the translation in your language.

6. You should save your work often.

7. You can test your work on a test installation. Upload both .mo and .po files
   to your test installation and change your user profile to use the language
   you have just updated.

8. Cacti and its plugins get updates very often. To make sure the translations
   are up to date, the translator should download the latest version and run
   `build_gettext.sh` to create an up-to-date version of cacti.pot.

## Editing PO Files

The PO Editor will create both a PO and MO file every time you save the file.
The final name of the file will have to be changed to Cacti's standard naming.
For example, Poedit saves the file from the example above as `fr_FR.po`, but
Cacti will need these files name in hyphenated format, so: `fr_FR.po`, becomes
`fr-FR.po`.  Make that note especially if you are starting a new language.

## Considerations

As Cacti is GPL2.0+, you acknowledge, by sigining up to the Cacti Weblate
site, that your contributions will be GPL2.0+ as well.

---
<copy>Copyright (c) 2004-2021 The Cacti Group</copy>
