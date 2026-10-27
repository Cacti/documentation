# Build the PDF, Text, and Contributed Manual Replacements

The [manual index](../../Other-Manuals.md) distinguishes current replacements
from historical contributions. Original files retain their URLs and credits.
The new guides use the current manual's content and documentation styles.

## Inputs and versions

Use Python 3.12 and uv through `mise`. The existing PDF builder's committed
script lock pins MarkdownIt, WeasyPrint, Mammoth, and Pillow. WeasyPrint also
needs native Pango libraries and fonts with German, Turkish, and Cyrillic
glyphs. CI installs DejaVu fonts. Native libraries and fonts affect pagination;
checksums identify built artifacts, not cross-platform reproducible bytes.

The main PDF and text editions contain every main chapter selected by
`bin/check_navigation.py`. German and Turkish editions add localized entries
to that complete chapter set. Russian and platform editions contain every
chapter listed in `resources/manuals/editions.json`. They do not claim a full
translation or successful runtime installation on every platform.

The schema source is the unchanged upstream `cacti.sql` at the revision in
`resources/manuals/schema-source.json`. Its hash is checked before extracting
all table declarations. The reference omits seed data, session settings, and
database alteration commands. It does not infer relationships or plugin tables.
Update the source snapshot and provenance together when intentionally refreshing
the schema. Compare the generated reference before committing it.

## Build

Commit source changes before generating publication snapshots. From the
documentation root:

```sh
mise exec python@3.12 uv@0.12.23 -- uv run --locked --python python \
  --script bin/build_pdf_docs.py --only manual --companions
```

On macOS with Homebrew, set `DYLD_FALLBACK_LIBRARY_PATH` to the Homebrew `lib`
directory after selecting runtimes if WeasyPrint cannot locate Pango. For
example, use `mise exec python@3.12 uv@0.12.23 -- env` followed by
`DYLD_FALLBACK_LIBRARY_PATH=/opt/homebrew/lib uv run` and the remaining build
arguments on an Apple Silicon Homebrew installation.

The command above preserves the
existing ReportIt edition and its metadata. To rebuild ReportIt too, omit
`--only manual`.

Outputs are `resource/pdf/cacti-manual.pdf`, its existing PDF manifest, and
`resource/manuals/`: eight companion PDFs, nine UTF-8 text editions, a schema
DDL reference, and a source/checksum manifest. The main manual text preserves
examples, table cells, image descriptions, and full source links.

The generated `resources/manuals/Schema-Reference.md` is also committed so it
can be read online. Rebuild the HTML manual to include these new pages:

```sh
bin/build_html_docs.sh --output /tmp/cacti-manual-preview
```

## Validate and review

The publication workflow uses the same locked renderer environment for unit
tests and a real complete build. Unit tests exercise source containment,
link conversion, schema provenance, extraction failures, and edition selection.
The PDF checks read the generated documents, check chapter bookmarks and
destinations, verify every declared source/output hash, and check the text
editions against the complete selected chapter lists. Browser checks render
the HTML chapters and populated screenshots through the existing HTML workflow.

Review the localized introductions as prose as well as checking rendering.
Rendered glyphs and passing tests do not establish translation quality or OS
compatibility. The Windows development dependency restriction is intentional;
the Solaris edition is a migration guide.

CI keeps the PDF/text editions, manifests, checksums, coverage report, and PDF
page previews for 14 days. It has read-only repository permissions and no
production deployment credentials. Use the artifacts from the successful run
for review; a failed or interrupted build is not a publication candidate.

## Publish without replacing archives

After review and merge, stage the current editions under versioned development
paths on the documentation file host. Include the manifest and checksums.
Label them as unreleased Cacti 1.3; do not advertise them as the Cacti 1.2
manuals. Keep the historical `pdf/manual.pdf`, `text/manual.txt`, `contrib/`,
and `sql/` files intact. Link both the new editions and the clearly labeled
archives from the download index. Keep original contributor notices with the
original files.

Check downloaded hashes, non-ASCII text, internal PDF links, and a populated
graph preview before promoting the staged directory. Refresh the deployed
documentation source separately; repository artifacts do not change the live
website by themselves.

---

Copyright (c) 2004-2026 The Cacti Group
