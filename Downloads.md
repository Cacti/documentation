# Manual and Example Downloads

## PDF Manuals

- [Cacti development manual](resource/pdf/cacti-manual.pdf): A snapshot of the
  current development manual, with a contents list, bookmarks, screenshots,
  and links between chapters. It documents the unreleased Cacti 1.3 series.
- [ReportIt 3.0 development manual](resource/pdf/manual_reportit_3.0.pdf):
  Regenerated from the plugin's newer editable source. The current plugin
  development branch requires Cacti 1.3. Screenshots and some examples show
  earlier versions. The original credits and license notice are preserved.

[The original ReportIt 0.6.1 PDF](resource/pdf/manual_reportit.pdf)
remains available as a historical reference.

The [build manifest](resource/pdf/build_manifest.json) records source hashes,
build date, tool versions, and PDF checksums. It identifies the documentation
base and the exact Markdown content used, including changes in this branch.
Use the [online manual](README.md) for subsequent documentation updates.

The ReportIt source is the [upstream Word document][reportit-source], copied
without changes to [manual_reportit.docx](resource/docx/manual_reportit.docx).
The distributed PDF in that upstream revision is still the older 2009 manual;
this download is rebuilt from the newer source, not copied from that PDF.
Its metafile diagram contains a bitmap, which the builder extracts so the
figure is preserved in the PDF.

## XML Examples

The XML downloads accompany these walkthroughs:

- [SNMP data queries](How-To-New-SNMP-Data-Queries.md): Download
  [hrStorageTable.xml](resource/xml/hrStorageTable.xml) to
  `resource/snmp_queries/`, then import the
  [graph template][storage]
  through **Import Templates**.
- [Script data queries](How-To-Script-Data-Queries.md): Download
  [ifTraffic.xml](resource/xml/ifTraffic.xml) to `resource/script_queries/` and
  [query_interface_traffic.php](resource/xml/query_interface_traffic.php) to
  `scripts/`, then import the
  [data query template][traffic-template].

These template exports keep their existing object hashes. Importing one can
update an existing matching template. Use a disposable Cacti database to check
an import before applying it to an installation you manage. The script query
uses 32-bit interface counters; use Cacti's built-in interface query and
64-bit graphs for production traffic monitoring on fast interfaces.

The storage example accepts allocation units both as a plain number and as
`4096 Bytes`. The traffic template uses the same field names as its query XML,
and the helper preserves each interface index when query results are sparse
or returned in a different order.

## Rebuild the PDFs

The builder uses Python 3.12 or newer, `uv`, and WeasyPrint's native Pango
libraries. Select Python through `mise` and run from the documentation root:

```sh
mise exec python@3.12 -- uv run --frozen --python 3.12 bin/build_pdf_docs.py
```

The script declares pinned Python package versions and includes a dependency
lockfile. On macOS with Homebrew,
WeasyPrint may also need the library search path:

```sh
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib"
```

Use `--only manual` or `--only reportit` to rebuild one PDF. PDF builds use
local sources and images. Remote video thumbnails become linked text, so no
network image download is required. The source manifest makes a content
snapshot traceable; byte-identical output also requires the same fonts and
native libraries.

[storage]: resource/xml/cacti_graph_template_host_mib_hrstoragetable.xml
[traffic-template]: resource/xml/cacti_data_query_php_interface_traffic.xml
[reportit-source]:
  <https://github.com/Cacti/plugin_reportit/blob/86726fc5eff51e23baf18834f69da2aa0b1efa77/ReportIt%20Documentation.docx>

---

Copyright (c) 2004-2026 The Cacti Group
