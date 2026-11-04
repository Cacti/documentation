// Copyright (C) 2004-2026 The Cacti Group. GPL-2.0-or-later.
'use strict';
const { before, after, test } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const fs = require('node:fs/promises');
const path = require('node:path');
const { pathToFileURL, fileURLToPath } = require('node:url');
const { chromium } = require('playwright');
const root = path.resolve(process.env.HTML_MANUAL_ROOT || path.join(__dirname, '../../html'));
const artifacts = path.join(__dirname, 'artifacts');
let server, browser, context, base, manifest;
const evidence = { rendered_pages: [], legacy_pages: [], screenshots: [] };
let failed = false;

async function files(directory) {
  const entries = await fs.readdir(directory, { withFileTypes: true });
  const result = [];
  for (const entry of entries) {
    const name = path.join(directory, entry.name);
    if (entry.isDirectory()) result.push(...await files(name));
    else if (name.endsWith('.html')) result.push(path.relative(root, name));
  }
  return result;
}

before(async () => {
  for (const name of ['failure.png', 'failure-trace.zip']) {
    await fs.rm(path.join(artifacts, name), { force: true });
  }
  await fs.mkdir(artifacts, { recursive: true });
  manifest = JSON.parse(await fs.readFile(path.join(root, 'build-manifest.json')));
  assert.equal(manifest.generator, 'cacti-static-manual');
  server = http.createServer(async (request, response) => {
    try {
      const name = path.resolve(root, '.' + decodeURIComponent(new URL(request.url, 'http://localhost').pathname));
      if (!name.startsWith(root + path.sep) || !['GET', 'HEAD'].includes(request.method)) {
        response.writeHead(403).end(); return;
      }
      const types = { '.html': 'text/html', '.css': 'text/css', '.svg': 'image/svg+xml', '.png': 'image/png', '.txt': 'text/plain' };
      response.setHeader('Content-Type', types[path.extname(name)] || 'application/octet-stream');
      response.end(await fs.readFile(name));
    } catch {
      response.writeHead(404).end();
    }
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  base = `http://127.0.0.1:${server.address().port}/`;
  browser = await chromium.launch({ executablePath: process.env.CHROMIUM_EXECUTABLE || undefined });
  context = await browser.newContext();
  await context.route('**/*', route => {
    const url = new URL(route.request().url());
    const localFile = url.protocol === 'file:' && fileURLToPath(url).startsWith(root + path.sep);
    return localFile || url.href.startsWith(base) ? route.continue() : route.abort();
  });
  await context.tracing.start({ screenshots: true, snapshots: true });
  evidence.browser = browser.version();
  evidence.source_revision = manifest.source_revision;
  evidence.legacy_anchors = 0;
});

after(async () => {
  if (context) await context.tracing.stop(failed ? { path: path.join(artifacts, 'failure-trace.zip') } : {});
  evidence.complete = Boolean(manifest && !failed && evidence.rendered_pages.length === manifest.html_pages
    && evidence.legacy_pages.length === manifest.legacy_chapters);
  await fs.writeFile(path.join(artifacts, 'browser-evidence.json'), JSON.stringify(evidence, null, 2));
  if (browser) await browser.close();
  if (server) await new Promise(resolve => server.close(resolve));
});

function scenario(name, callback) {
  test(name, async () => {
    try { await callback(); } catch (error) { failed = true; throw error; }
  });
}

async function inspect(name) {
  const page = await context.newPage();
  try {
    const missing = [];
    page.on('response', response => {
      if (response.url().startsWith(base) && response.status() >= 400) missing.push(response.url());
    });
    const response = await page.goto(base + name);
    assert.equal(response.status(), 200, name);
    assert.ok((await page.locator('main').innerText()).length > 10, name);
    assert.match(await page.locator('body').innerText(), /unreleased Cacti 1\.3/);
    assert.equal(await page.locator('script, iframe, object, embed').count(), 0, name);
    assert.deepEqual(missing, [], name);
    assert.deepEqual(await page.locator('main img').evaluateAll(images => images
      .filter(image => new URL(image.src).origin === location.origin && image.naturalWidth === 0)
      .map(image => image.src)), [], name);
    evidence.rendered_pages.push(name);
  } catch (error) {
    failed = true;
    await page.screenshot({ path: path.join(artifacts, 'failure.png'), fullPage: true });
    throw error;
  } finally { await page.close(); }
}

scenario('every current and legacy chapter renders its content and local assets', async () => {
  const pages = await files(root);
  assert.equal(pages.length, manifest.html_pages);
  // Bounded parallelism keeps image-heavy reference chapters within runner memory.
  for (let offset = 0; offset < pages.length; offset += 3) {
    const results = await Promise.allSettled(pages.slice(offset, offset + 3).map(inspect));
    const failure = results.find(result => result.status === 'rejected');
    if (failure) throw failure.reason;
  }
});

scenario('all legacy filenames and bookmarks remain reachable', async () => {
  const mapping = JSON.parse(await fs.readFile(path.join(__dirname, '../../resources/build/legacy-html-chapters.json')));
  const page = await context.newPage();
  try {
    await page.goto(base + 'index.html');
    for (const fragment of mapping.homepage_fragments || []) {
      assert.equal(await page.evaluate(id => document.getElementById(id) !== null, fragment), true, fragment);
      evidence.legacy_anchors++;
    }
    for (const [name, entry] of Object.entries(mapping.chapters)) {
      assert.equal((await page.goto(base + name)).status(), 200, name);
      for (const fragment of entry.fragments) {
        assert.equal(await page.evaluate(id => document.getElementById(id) !== null, fragment), true, name + '#' + fragment);
        evidence.legacy_anchors++;
      }
      evidence.legacy_pages.push(name);
    }
  } finally { await page.close(); }
});

scenario('manual navigation, FreeBSD content, and populated graph screenshots work', async () => {
  const page = await context.newPage({ viewport: { width: 1440, height: 1000 } });
  try {
    await page.goto(base + 'index.html');
    await page.getByRole('link', { name: 'All chapters', exact: true }).click();
    assert.match(page.url(), /Manual-Index\.html$/);
    await page.goto(base + 'bsd_ports.html#BSD_PORTS');
    assert.match(await page.locator('main').innerText(), /cacti-php84/);
    assert.match(await page.locator('main').innerText(), /net-mgmt\/cacti-spine/);
    for (const [name, width] of [['index.html', 1440], ['Graph-Overview.html', 1440], ['bsd_ports.html', 390]]) {
      await page.setViewportSize({ width, height: 1000 });
      await page.goto(base + name);
      const screenshot = name.replace('.html', '') + '-' + width + '.png';
      await page.screenshot({ path: path.join(artifacts, screenshot), fullPage: true });
      evidence.screenshots.push(screenshot);
    }
  } finally { await page.close(); }
});

scenario('the extracted manual opens offline with local images and its existing stylesheet', async () => {
  const page = await context.newPage();
  try {
    await page.goto(pathToFileURL(path.join(root, 'Graph-Overview.html')).href);
    assert.match(await page.locator('main').innerText(), /Graph Overview/);
    assert.equal(await page.locator('link[rel=stylesheet]').evaluate(link => link.sheet !== null), true);
    assert.deepEqual(await page.locator('main img').evaluateAll(images => images
      .filter(image => image.naturalWidth === 0).map(image => image.src)), []);
  } finally { await page.close(); }
});
