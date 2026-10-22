# App captures and Play Store artwork

Run from the project root after regenerating fonts:

```sh
tool/screenshots/make_screenshots.sh
```

Requires Flutter and ImageMagick. No additional app dependencies.

- `store/screenshots/`: actual Flutter screen renders at 1170 × 2532, with the bundled fonts and real app widgets.
- `store/playstore/01.png` through `08.png`: 1080 × 1920 promotional screenshots, with headlines and the complete captured app viewport.
- `store/playstore/feature_graphic.png`: 1024 × 500 feature graphic.
- `website/public/img/`: compressed versions of the same app captures.
- `website/public/og.png`: matching social preview.

The renderer uses deterministic sample favourites and search state. It does not alter production defaults or add fictional UI. Edit headlines and capture scenarios in `render_test.dart`. The capture run fails on Flutter layout exceptions. The export script writes 24-bit PNGs without alpha, following [Google Play preview asset requirements](https://support.google.com/googleplay/android-developer/answer/9866151). Review the generated images before publishing. Upload the new store artwork together with the redesigned app release so the listing matches the installed app.
