# Creating Translations

## Internationalization of Cacti and its Plugins

If you wish to help with the development of translations of Cacti from English
to other languages, here is your one source for starting and completing this
activity.  There are several steps, but if you follow them closely, you have a
chance to change the world and add to the Cacti community.

## Steps

1. In Cacti's base directory, there is a directory called `locales`.

   ```console
   # ls locales/
   LC_MESSAGES  po
   ```

   Inside of that directory, you will find a shell script called
   `build_gettext.sh`. If you run this script, a special file called a pot
   file will be created. It will be located in the 'po' directory.

   ```console
   # ls locales/po/
   bulgarian_bulgaria.po        dutch_netherlands.po  japanese_japan.po swedish_sweden.po
   cacti.pot                    french_france.po      russian_russia.po
   chinese_china_simplified.po  german_germany.po     spanish_spain.po
   ```

2. If when you run the `update-pot.sh` script you receive warnings about `\r`
   being included in some files, simply run dos2unix on those files, and rerun
   the script.

   ```console
   dos2unix somefile.xyz
   dos2unix: converting file somefile.xyz to Unix format ...
   ```

3. Download a PO Editor.  If using Windows, a good solution would be Poedit.
   You can download it from [Poedit Pro](https://poedit.net/pro).  If you
   donate approximately $20 USD to the author, he enables other features to
   allow auto-translation of several phrases using multiple online translation
   databases to save you time.

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

The PO Editor will create both a PO and MO file every time you save the file.d
The final name of the file will have to be changed to Cacti's standard naming.
For example, Poedit saves the file from the example above as `fr_FR.po`, but
Cacti will need these files name in their long format of `french_france.po` and
`french_france.mo`.

```console
# ls locales/LC_MESSAGES/
bulgarian_bulgaria.mo        french_france.mo   russian_russia.mo
chinese_china_simplified.mo  german_germany.mo  spanish_spain.mo
dutch_netherlands.mo         japanese_japan.mo  swedish_sweden.mo
```

```console
# ls locales/po/
bulgarian_bulgaria.po        dutch_netherlands.po  japanese_japan.po  swedish_sweden.po
cacti.pot                    french_france.po      russian_russia.po
chinese_china_simplified.po  german_germany.po     spanish_spain.po
```

Once you have completed your translation, you will need to open a pull request
in GitHub including your final PO and MO files.  Please ensure that in the PO
file that you assign copyright to the Cacti Group. You will find that
information in the header of the PO file.

## Considerations

We can only accept translations from people who are willing to turn over their
rights to The Cacti Group, though you will be recognized as its original
author.

You can repeat this process for every Cacti Group supported plugin. Right now,
all of our plugins include a `locales` directory with the `update-pot.sh` or
`build_gettext.sh` file included.

It's really just that easy!

---
Copyright (c) 2004-2020 The Cacti Group
