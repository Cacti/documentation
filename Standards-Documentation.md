# Documentation Standards

## Introduction

The following are the standards to be used by Cacti Group members and
Contributers when maintaining the documentation of Cacti or any of its
plugins.  These standards have also been applied to the Travis CI
checker on GitHub.

## Reporting corrections / omissions

Please report any errors or corrections on the Cacti Documentation
GitHub repositiory which is located at
[https://github.com/cacti/documentation/](https://github.com/cacti/documentation/)
where all changes can be tracked.  Any **Pull Requests** will be welcome
to help speed up changes by allowing the Cacti Group to simply verify
the changes are correct before submitting them.

## Copyright

All documentation should be marked as copyright to the Cacti Group.
This is done by simply adding the following text to the bottom of the
page (including the blank line):

```markdown

---
Copyright (c) 2018 Cacti Group
```

## Titles

### Title Levels

When creating documentation titles, they should:

- use the \# symbol with 1 - 5 hashes

  *The actual count of hashes represents the sub-level of the title.*

- not have multiple level 1 headers

  ```MD025 Multiple top level headers in the same document```

- not have punctuation at the end of the header

  ```MD026 Trailing punctuation in header```

- not use `----` or `====` on a line that follows a header

   ```MD003 Header style```

- increment down only one sub-level at a time

  *You may go back up any number of levels*

  ```markdown

  # Main Title 1
  ## Main Title 1.Sub Title 1
  ### Main Title 1.Sub Title 1.Sub Title 1
  ### Main Title 1.Sub Title 1.Sub Title 2
  ## Main Title 1.Sub Title 2
  ### Main Title 1.Sub Title 2.Sub Title 1
  ### Main Title 1.Sub Title 2.Sub Title 2
  # Main Title 2
  ### Main Title 2.Invalid Sub Title 1.Invalid Sub Title 1

  ```

- not use other title definition symbols

  *Whilst they are valid markdown, they will result in style errors.*

Failure to follow this will result in an `MD001` error during Travis CI
checks.

###### Example 1. Incorrect Markdown for Title Levels

```markdown

# Welcome

Welcome to us

## Using the software 1.2

To use most functions of our software, navigate the menus

#### Accessing the menus 1.2.1.1

The menus are located at the top of the page ...

```

###### Example 2. Corrected Markdown for Title Levels

```markdown

# Welcome

Welcome to us

## Using the software 1.2

To use most functions of our software, navigate the menus

### Accessing the menus 1.2.1

The menus are located at the top of the page ...

```

### Title Spacing

All titles should be separated with blank linese either side of the
title.  The only exception to this is if the title is on the first line
of the page. They should also have a single space between the hash
symbols and text.

###### Example 3. Incorrect Markdown for Title Spacing

```markdown

# Welcome
Welcome to us

## Using the software 1.2
To use most functions of our software, navigate the menus
### Accessing the menus 1.2.1
The menus are located at the top of the page ...

```

###### Example 4. Incorrect Markdown for Title Spacing

```markdown

# Welcome

Welcome to us

## Using the software 1.2

To use most functions of our software, navigate the menus

### Accessing the menus 1.2.1

The menus are located at the top of the page ...

```

### Titles for Captions

Titles for examples, images and tables are the only exception to the
Title Level rule.  These are normally set to 6 (Six) hash symbols (eg,
`######`).  The format of the text should be such that it reads the type
of caption, a number, full stop, then the description

```markdown

###### <caption type> <number>. <descrption>

```

###### Example 5. Example of this caption

```markdown

###### Example 5. Example of this caption

```

## Text

### Standard Text

Any text written outside of code blocks must:

- be formatted such that it does not exceed 79 characters.  This is to
  make it easier to read and adjust the paragraphs in any editor.

  ```MD013 Line length```

- have blank lines between paragraphs

- not have multiple blank lines

  ```MD012 Multiple consecutive blank lines```

- not have trailing spaces

  ```MD009 Trailing spaces```

- not use HTML outside of fenced code blocks

  ```MD033 Inline HTML```

### Tables

All tables should have a caption applied to them in the style that was
listed above.

### Lists

All lists should:

- use a single `-` (dash) character for bullet points

- use a digit following by a full stop for numbered lists

- should have a single space between the list item marker and the start of the text

- have blanks lines around items in the same fashion as titles

  ```MD030 Spaces after list markers```

- wrap text with indentation as they are exempt from the text-width
  formatting rule

  ```markdown
  - wrap text with indentation as they are exempt from the text-width
    formatting rule
  ```

- may include sub-items in a similar fashion to titles by:

  - indenting sub-items or examples by two spaces per level

  - indenting one level at a time

  - include examples such as:

  ```markdown
  - may include sub-items in a similar fashion to titles by:

    - indenting sub-items or examples by three spaces per level

    - indenting one level at a time

    - include examples such as:

    ```markdown

    - may include sub-items in a similar fashion to titles by:

      - indenting sub-items or examples by three spaces per level

  ```

### Inline Code

Inline code can be included using the single backtick (\`) method to
produce code-like references. An example of this would be to:

###### Example 6. Inline Code

```markdown

use the \`--help\` parameter on the command

```

Which would produce:

---

use the `--help` parameter on the command

---

### Code Blocks

All code blocks must be:

- surround by blank lines to separate them from other text

  ```MD031 Fenced code blocks should be surrounded by blank lines```

- fenced with three backticks (\`\`\`) and not any other code block fencing characters.

- have a language applied to them by entering the name after the three backticks.

  ```MD040 Fenced code blocks should have a language specified```

- an exception to the above text formating rules as they may contain
  example lines that are required to be on a single line.

Where possible, it is advised to try and make use of continuation lines
(\\) so that these are easily readible on any screen.

###### Example 7. Code Block with Style

```markdown

```markdown
This is a markdown example, <b> will display <b> not start a bold HTML style
Also ` will actually be displayed not interpreted
```

The style used on the fenced code block should match the contents of the
code block.  In the above example, we used `markdown` as we were
displaying a markdown example.  The following table is a basic example
what is most commonly used in the documentation:

Type | Markdown Language | Usage
---: | :---: | ---
C++ | c++ | Formats code block as C++
PHP | php | Formats code block as PHP
SQL | sql | Formats code block as SQL
Script | bash | Formats code block as bash script
&nbsp; | sh | Formats code block as posix script
Shell | console | Formats code block as command line example
Markdown | markdown | Formats code block as Markdown

### URLs

All URLs should be formated in the markdown format and not just inserted
directly into the text.  The format for this is:

```markdown
[text for link](https://url/wanted)
```

Failing to do this will result in `MD034 Bare URL used`

This would produce: [text for link](https://url/wanted)

### Horizontal Rules

Horizontal rules should be made using three or more consecutive hyphens on
a single line.  Again, these should be surrounded by spaces.

```markdown
Paragraph 1 text

---

Paragraph 2 text
```

## Testing changes

To locally test the changes made to any Markdown document, you will need to
have installed ruby then run:

```console
gem install mdl
```

If this pre-requisite has already been completed, then you can simply
type the following into your shell

```console
cd <cacti_docs>
./check_markdown_style.sh
```

Which will generate the same output that is seen on the Travis CI build
status.  You should ensure that any reported errors are corrected before
submitting your pull request.

```console
Documentation-Standards.md:221: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:230: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:232: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:265: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:268: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:290: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:292: MD031 Fenced code blocks should be surrounded by blank lines
Documentation-Standards.md:161: MD032 Lists should be surrounded by blank lines
Documentation-Standards.md:250: MD032 Lists should be surrounded by blank lines
Documentation-Standards.md:253: MD032 Lists should be surrounded by blank lines
Documentation-Standards.md:256: MD032 Lists should be surrounded by blank lines
Documentation-Standards.md:236: MD033 Inline HTML
Documentation-Standards.md:240: MD033 Inline HTML
```

---
Copyright (c) 2018 Cacti Group
