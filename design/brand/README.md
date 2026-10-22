# 99 Names — Urdu wordmark

Approved direction: **A, stacked Nastaleeq**, spelling **اسماء الحسنیٰ**.
Derived from the app's existing Jameel Noori Nastaleeq font, with a custom stacked
arrangement and detached flourish. Font credits remain in Settings and README.

## Masters

- `wordmark.svg`: black, transparent background; source of truth for geometry.
- `wordmark-white.svg`: reversed lettering.
- `wordmark-bronze.svg`: brand lettering on a transparent background.
- `app-icon.svg`: bronze lettering on the ink-blue square.

Brand colours: ink blue **#101820**, muted bronze **#D9BC89**.
The icon uses the same colours in light and dark mode.

Keep the proportions and the whitespace in the 256 × 256 master. Do not stretch,
rotate, add shadows, separate the diacritics, or add competing patterns. Give the
standalone lettering at least 16 master units of clear space. Prefer 64 px or
larger for reading the full phrase; at favicon sizes it serves as a recognisable
silhouette. Android foreground and monochrome layers use 66% scale to protect
lettering under launcher masks.

## Regenerate

From the repository root:

```sh
python3 tool/icon/build_wordmark.py
dart format lib/src/ui/wordmark_path.dart
tool/icon/make_icons.sh
tool/screenshots/make_screenshots.sh
```

The compiler converts SVG outlines directly to Dart paths; it does not require an
SVG runtime dependency or font loading at app startup. After edits to app text,
run `tool/subset_fonts.py` before rendering, as described in the main README.

Native and web icon exports come from the same Flutter `AppLogo` widget. The
square source deliberately has no rounded corners; launcher masks and UI widgets
apply their own corner treatment. Third-party font terms and the project's
branding policy continue to apply.
