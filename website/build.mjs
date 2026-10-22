// Builds the Asmaul Husna landing page into dist/: copies public/, and fills
// src/index.html with all 99 Names read straight from the app's
// lib/src/data/names.dart, so the site never drifts from the app.
// Run: node build.mjs
import { cp, mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const dist = path.join(here, 'dist');

// Dart string literal, single or double quoted, with escapes.
const literal = String.raw`'(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*"`;
const unquote = (s) => s.slice(1, -1).replace(/\\(.)/g, '$1');

const dart = await readFile(path.join(here, '..', 'lib/src/data/names.dart'), 'utf8');
const entry = new RegExp(
  String.raw`DivineName\(\s*(\d+),\s*(${literal}),\s*(${literal}),\s*(${literal}),\s*(${literal}),\s*(${literal}),?\s*\)`,
  'g',
);
const names = [...dart.matchAll(entry)].map((m) => ({
  number: Number(m[1]),
  arabic: unquote(m[2]),
  transliteration: unquote(m[3]),
  english: unquote(m[4]),
  urdu: unquote(m[5]),
  reflection: unquote(m[6]),
}));
if (names.length !== 99) throw new Error(`Expected 99 names in names.dart, found ${names.length}`);

const esc = (s) => s.replace(/[&<>"]/g, (c) => `&#${c.charCodeAt(0)};`);
const grid = names
  .map(
    (n) => `<li class="name" data-search="${esc(`${n.number} ${n.transliteration} ${n.english}`.toLowerCase())}">
  <span class="num">${n.number}</span>
  <span class="ar" lang="ar" dir="rtl">${esc(n.arabic)}</span>
  <span class="tr">${esc(n.transliteration)}</span>
  <span class="en">${esc(n.english)}</span>
  <span class="ur" lang="ur" dir="rtl">${esc(n.urdu)}</span>
  <span class="rf">${esc(n.reflection)}</span>
</li>`,
  )
  .join('\n');

const template = await readFile(path.join(here, 'src/index.html'), 'utf8');
await rm(dist, { recursive: true, force: true });
await mkdir(dist, { recursive: true });
await cp(path.join(here, 'public'), dist, { recursive: true });
// The privacy policy has one source, docs/privacy-policy/, published with the Cloudflare website.
await mkdir(path.join(dist, 'privacy'), { recursive: true });
await cp(path.join(here, '..', 'docs/privacy-policy/index.html'), path.join(dist, 'privacy/index.html'));
await writeFile(path.join(dist, 'index.html'), template.replace('{{NAMES}}', grid));
console.log(`dist/ built with ${names.length} Names`);
