#!/usr/bin/env python3
# /// script
# requires-python = ">=3.12"
# dependencies = ["markdown-it-py==4.0.0", "mammoth==1.13.0", "weasyprint==70.0", "Pillow==13.0.0"]
# ///
"""Build the manual and ReportIt PDFs from the checked-in sources."""

import argparse
import base64
import io
import struct
from collections import Counter
from datetime import datetime, timezone
import hashlib
from html import escape
import importlib.metadata
import json
import logging
import os
from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urlsplit

from check_navigation import ordered_pages
from markdown_it import MarkdownIt
import mammoth
from PIL import Image
from weasyprint import CSS, HTML, URLFetcher

ROOT = Path(__file__).resolve().parent.parent
PUBLIC = "https://docs.cacti.net/"
REPORTIT_REVISION = "86726fc5eff51e23baf18834f69da2aa0b1efa77"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def slug(text):
    return re.sub(r"[^\w -]", "", text.lower()).replace(" ", "-")


def chapter_id(path):
    return "chapter-" + slug(path.relative_to(ROOT).with_suffix("").as_posix().replace("/", "-"))


class LocalFetcher(URLFetcher):
    def __init__(self):
        super().__init__(allowed_protocols=("file", "data"), fail_on_errors=True)

    def fetch(self, url, headers=None):
        parsed = urlsplit(url)
        if parsed.scheme == "file" and not Path(unquote(parsed.path)).resolve().is_relative_to(ROOT):
            raise ValueError("PDF assets must be inside the documentation repository")
        return super().fetch(url, headers)


def document(title, body):
    return ('<!doctype html><html lang="en"><head><meta charset="utf-8">'
            f'<title>{escape(title)}</title><meta name="author" content="The Cacti Group">'
            f'</head><body>{body}</body></html>')


def build_manual(output, revision, built):
    paths = ordered_pages(ROOT)
    available = set(paths)
    md = MarkdownIt("commonmark", {"html": True}).enable(["table", "strikethrough"])
    chapters = []
    titles = []
    missing = set()
    online_images = set()
    for path in paths:
        prefix = chapter_id(path)
        tokens = md.parse(path.read_text(encoding="utf-8"))
        counts = Counter()
        title = path.stem
        first_heading = True
        for i, token in enumerate(tokens):
            if token.type == "heading_open":
                inline = tokens[i + 1]
                heading = "".join(child.content for child in (inline.children or [])
                                  if child.type not in ("html_inline", "softbreak"))
                ident = slug(heading)
                number = counts[ident]
                counts[ident] += 1
                token.attrSet("id", f"{prefix}--{ident}" + (f"-{number}" if number else ""))
                if first_heading:
                    title = heading
                    first_heading = False
            if token.type in ("html_block", "html_inline"):
                token.content = re.sub(r'\b(id|name)="([^"]+)"',
                                       lambda m: f'{m[1]}="{prefix}--{m[2]}"', token.content)
            for child in token.children or []:
                if child.type == "html_inline":
                    child.content = re.sub(r'\b(id|name)="([^"]+)"',
                                           lambda m: f'{m[1]}="{prefix}--{m[2]}"', child.content)
                if child.type == "link_open":
                    href = child.attrGet("href") or ""
                    url = urlsplit(href)
                    if not url.scheme and not url.netloc:
                        target = (path.parent / unquote(url.path)).resolve() if url.path else path
                        if target in available:
                            child.attrSet("href", "#" + chapter_id(target) +
                                          ("--" + unquote(url.fragment) if url.fragment else ""))
                        else:
                            child.attrSet("href", PUBLIC + target.relative_to(ROOT).as_posix() +
                                          ("#" + url.fragment if url.fragment else ""))
                if child.type == "image":
                    source = child.attrGet("src") or ""
                    if urlsplit(source).scheme in ("http", "https"):
                        online_images.add(source)
                        child.type = "text"
                        child.tag = ""
                        child.content = "[" + (child.content or "Image") + " available online]"
                    else:
                        image = (path.parent / unquote(source)).resolve()
                        if not image.is_file():
                            missing.add(str(image.relative_to(ROOT)))
                        child.attrSet("src", image.as_uri())
        titles.append((prefix, title))
        chapters.append(f'<section class="chapter" id="{prefix}">' + md.renderer.render(tokens, md.options, {}) + '</section>')
    if missing:
        raise ValueError("Missing local images: " + ", ".join(sorted(missing)))
    toc = '<nav class="contents"><h1>Contents</h1><ol>' + ''.join(
        f'<li><a href="#{prefix}">{escape(title)}</a></li>' for prefix, title in titles) + '</ol></nav>'
    cover = (f'<section class="cover"><h1>Cacti Development Manual</h1>'
             '<p class="subtitle">Cacti 1.3 development series</p>'
             f'<p>Documentation source base: {escape(revision)}<br>Built: {built}</p>'
             '<p>This snapshot includes the XML example refresh in this branch. '
             'The accompanying build manifest records each source file hash.</p>'
             '<p>For Cacti 1.2, use the maintenance manual for your installed release.</p>'
             '<p>Video thumbnails are represented by links; local screenshots are embedded.</p>'
             '<p>Copyright (c) 2004-2026 The Cacti Group</p></section>')
    HTML(string=document("Cacti Development Manual", cover + toc + ''.join(chapters)),
         base_url=ROOT.as_uri() + "/", url_fetcher=LocalFetcher()).write_pdf(
             output, stylesheets=[CSS(filename=ROOT / "resources/css/pdf.css")],
             pdf_tags=True, optimize_images=True, dpi=144, jpeg_quality=85)
    return {"sources": {p.relative_to(ROOT).as_posix(): digest(p) for p in paths},
            "online_images": sorted(online_images), "chapters": len(paths)}


def reportit_image(image):
    with image.open() as stream:
        data = stream.read()
    content_type = image.content_type
    if content_type == "image/x-emf":
        # This upstream figure is a bitmap wrapped in one EMR_STRETCHDIBITS
        # record, not vector artwork. Recover the bitmap without redrawing it.
        offset = 0
        bitmaps = []
        while offset + 8 <= len(data):
            kind, size = struct.unpack_from("<II", data, offset)
            if size < 8 or offset + size > len(data):
                raise ValueError("Invalid ReportIt metafile record")
            if kind == 81:
                bmi, bmi_size, bits, bits_size = struct.unpack_from("<IIII", data, offset + 48)
                if bmi + bmi_size > size or bits + bits_size > size:
                    raise ValueError("Invalid ReportIt bitmap offsets")
                header = struct.pack("<2sIHHI", b"BM", 14 + bmi_size + bits_size, 0, 0, 14 + bmi_size)
                bitmap = header + data[offset + bmi:offset + bmi + bmi_size] + data[offset + bits:offset + bits + bits_size]
                buffer = io.BytesIO()
                Image.open(io.BytesIO(bitmap)).save(buffer, format="PNG")
                bitmaps.append(buffer.getvalue())
            elif kind not in (1, 14):
                raise ValueError("ReportIt metafile contains unsupported vector records")
            offset += size
        if len(bitmaps) != 1:
            raise ValueError("ReportIt metafile must contain exactly one bitmap")
        data, content_type = bitmaps[0], "image/png"
    return {"src": "data:" + content_type + ";base64," + base64.b64encode(data).decode("ascii")}


def build_reportit(output):
    source = ROOT / "resource/docx/manual_reportit.docx"
    with source.open("rb") as stream:
        result = mammoth.convert_to_html(
            stream, convert_image=mammoth.images.img_element(reportit_image),
            style_map="p[style-name='Title'] => h1:fresh\np[style-name='Subtitle'] => p.subtitle:fresh")
    notice = ('<section class="cover"><h1>ReportIt 3.0 Development Manual</h1>'
              '<p>Regenerated from the upstream editable manual.</p>'
              '<p>The current plugin development branch requires Cacti 1.3. '
              'Its screenshots and some examples describe earlier versions.</p>'
              '<p>The original author credits, preface, copyright, and GNU Free '
              'Documentation License notice follow in the source text.</p>'
              f'<p>Source revision: {REPORTIT_REVISION}</p></section>')
    HTML(string=document("ReportIt 3.0 Development Manual", notice + result.value),
         base_url=ROOT.as_uri() + "/", url_fetcher=LocalFetcher()).write_pdf(
             output, stylesheets=[CSS(filename=ROOT / "resources/css/pdf.css")],
             pdf_tags=True, optimize_images=True, dpi=144, jpeg_quality=85)
    return {"source": source.relative_to(ROOT).as_posix(), "source_sha256": digest(source),
            "upstream_revision": REPORTIT_REVISION,
            "conversion_messages": [m.message for m in result.messages]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--only", choices=("manual", "reportit"))
    args = parser.parse_args()
    logging.getLogger("weasyprint").setLevel(logging.ERROR)
    revision = subprocess.check_output(["git", "rev-parse", "--short=12", "HEAD"], cwd=ROOT, text=True).strip()
    epoch = os.environ.get("SOURCE_DATE_EPOCH")
    built = (datetime.fromtimestamp(int(epoch), timezone.utc) if epoch else datetime.now(timezone.utc)).strftime("%Y-%m-%d")
    folder = ROOT / "resource/pdf"
    manifest_path = folder / "build_manifest.json"
    manifest = json.loads(manifest_path.read_text()) if args.only and manifest_path.exists() else {}
    manifest.update({"documentation_base": revision, "build_date": built,
                     "builder_sha256": digest(Path(__file__)),
                     "navigation_sha256": digest(ROOT / "bin/check_navigation.py"),
                     "tool_lock_sha256": digest(Path(__file__).with_suffix(".py.lock")),
                     "stylesheet_sha256": digest(ROOT / "resources/css/pdf.css"),
                     "tools": {p: importlib.metadata.version(p) for p in ("markdown-it-py", "mammoth", "weasyprint", "Pillow")}})
    for kind, filename in (("manual", "cacti-manual.pdf"), ("reportit", "manual_reportit_3.0.pdf")):
        if args.only and args.only != kind:
            continue
        output = folder / filename
        print(f"Building {output.relative_to(ROOT)}", flush=True)
        info = build_manual(output, revision, built) if kind == "manual" else build_reportit(output)
        manifest[kind] = {**info, "pdf": output.relative_to(ROOT).as_posix(), "pdf_sha256": digest(output)}
        print(f"Wrote {output.stat().st_size:,} bytes", flush=True)
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")


if __name__ == "__main__":
    main()
