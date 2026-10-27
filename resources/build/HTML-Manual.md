# HTML Manual Content and Publication

The static manual uses the current Markdown chapters, images and examples.
It replaces the old DocBook chapter content while retaining the 75 chapter
filenames and 313 bookmarks inventoried from
[the published HTML manual](https://files.cacti.net/docs/html/).

The content follows the work already prepared for the documentation website:
version selection, installation and upgrade guides, collector and graphing
concepts, the manual index, and the code-checked FAQ. The updated website
manuals page distinguishes released and development documentation. The static
build uses that distinction and the documentation repository's
chapters. It retains `resources/css/Cacti-Github.css` as the documentation
stylesheet.

![Rendered graph chapter with populated example data][preview]

[preview]: ../../images/html-manual-preview.png

This is a browser screenshot of the generated Graph Overview chapter. Its
existing screenshots contain example devices and historical graph data;
they illustrate an earlier Cacti interface rather than a live deployment.

## Build the Manual

Install `mise` and `uv`, then run from the repository root:

```sh
bin/build_html_docs.sh --output html \
  --archive html-artifacts/cacti-development-manual.zip
```

The wrapper selects Python 3.12 and uv 0.12.23 through `mise`. The renderer and
its transitive dependency are pinned in `bin/build_html_docs.py.lock`.
The ZIP contains the complete HTML manual, local images and downloadable
examples. The adjacent `.zip.sha256` file records its checksum.

Open `html/index.html`, or serve the directory with a static web server. Every
page identifies the source as unreleased Cacti 1.3 documentation and links to
the released 1.2.x manual. The ZIP is a development manual, not a Cacti release
or a supported FreeBSD installation image.

The manifest records the source revision, chapter hashes, renderer version,
build inputs and counts. The builder checks local links, images and heading
fragments before replacing a previous generated output. It refuses to replace
an unrelated directory. Repeated archive builds of identical output files use
stable ZIP metadata.

## Check the Content

The regression suite uses the locked Markdown renderer:

```sh
mise exec python@3.12 uv@0.12.23 -- uv export --locked \
  --script bin/build_html_docs.py --format requirements-txt \
  --output-file /tmp/cacti-html-requirements.txt
mise exec python@3.12 uv@0.12.23 -- uv run \
  --with-requirements /tmp/cacti-html-requirements.txt \
  python -m unittest discover -s bin/tests -p test_html_manual.py
```

Run the browser checks against the built directory:

```sh
mise exec node@22 -- npm ci --ignore-scripts --prefix tests/browser
cd tests/browser
mise exec node@22 -- npx --no-install playwright install chromium
mise exec node@22 -- npm test
```

Set `HTML_MANUAL_ROOT` to an absolute directory for an alternate build, or
`CHROMIUM_EXECUTABLE` to an existing Chromium executable. Checks render every
HTML page and its local images, verify every legacy route and bookmark, and
exercise navigation, FreeBSD content and offline use. Evidence is written to
`tests/browser/artifacts`, including desktop and mobile screenshots, JSON
counts and a trace when a scenario fails.

The **HTML manual content** workflow builds the ZIP and checksum, requires
100% line and branch coverage of the new renderer, and runs the browser checks.
It retains the archive, coverage, JUnit results, screenshots and browser
metadata for fourteen days. That coverage applies to the renderer; it is not a
claim that every manual instruction was executed on every operating system.

## Publish the Reviewed Artifact

Review the exact artifact and source manifest before publication. The committed
snapshot is `resource/html/cacti-development-manual.zip`; CI also builds an
artifact for the PR revision. CI artifacts expire and should not be permanent
website download links.

A site maintainer must publish the approved artifact to the documentation host.
This workflow does not hold deployment credentials or write to files.cacti.net.
A merged PR alone does not refresh the host's local files.

1. Keep a separate copy of the existing archived manual and the site's current
   routing and access configuration.
2. Extract the complete ZIP into a staging directory. Verify the checksum,
   source revision and links there before changing the served directory.
3. Publish the staged files using the host's normal deployment process. Keep
   PHP examples as `.php.txt` downloads; the generated manual needs no PHP or
   JavaScript execution.
4. Verify `index.html`, `Manual-Index.html`, `bsd_ports.html` and several graph,
   script and troubleshooting pages at the public URL. Check a legacy bookmark
   and a local screenshot as well.
5. Retain the previous snapshot so a publication problem can be rolled back.

The legacy route registry is `resources/build/legacy-html-chapters.json`.
It records the captured source hashes and corresponding current chapters or
sections. Recheck a mapping when renaming its target; do not remove an old
filename simply because a newer chapter has a different name.

---

Copyright (c) 2004-2026 The Cacti Group
