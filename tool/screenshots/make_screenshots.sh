#!/bin/sh
# Actual Flutter screens, Play Store artwork, and website assets.
set -eu
cd "$(dirname "$0")/../.."
flutter test tool/screenshots/render_test.dart
# Google Play requires 24-bit PNG files without an alpha channel.
for file in store/playstore/*.png; do
  magick "$file" -alpha off -define png:color-type=2 "$file"
done
for name in home rahman sabur favourites search grid dark settings; do
  magick "store/screenshots/$name.png" -resize 780x1688 -quality 88 "website/public/img/$name.webp"
done
magick store/playstore/feature_graphic.png -resize 1200x586 -background '#101820' -gravity center -extent 1200x630 website/public/og.png
cp assets/fonts/PDMSSaleemQuran.ttf website/public/fonts/saleem-quran.ttf
cp assets/fonts/JameelNooriNastaleeq.ttf website/public/fonts/nastaleeq.ttf
