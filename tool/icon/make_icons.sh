#!/bin/sh
# Renders AppLogo (lib/src/ui/app_logo.dart) and writes every Android and iOS
# launcher icon from it. Needs Flutter and ImageMagick (`brew install imagemagick`).
set -e
cd "$(dirname "$0")/../.."

flutter test tool/icon/render_logo_test.dart

res=android/app/src/main/res
for d in mdpi:48:108 hdpi:72:162 xhdpi:96:216 xxhdpi:144:324 xxxhdpi:192:432; do
  dpi=${d%%:*}; rest=${d#*:}; legacy=${rest%%:*}; adaptive=${rest#*:}
  magick branding/icon_1024.png -resize ${legacy}x${legacy} -strip $res/mipmap-$dpi/ic_launcher.png
  for layer in background foreground monochrome; do
    magick branding/icon_${layer}_1024.png -resize ${adaptive}x${adaptive} -strip \
      $res/mipmap-$dpi/ic_launcher_$layer.png
  done
done

# iOS icons must not have an alpha channel.
for f in ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png; do
  px=$(magick identify -format %w "$f")
  magick branding/icon_1024.png -resize ${px}x${px} -alpha off -strip "$f"
done
# Keep store, README and website identity in sync with the same master.
magick branding/icon_1024.png -resize 512x512 -alpha off -strip store/app_icon.png
cp branding/icon_1024.png .github/readme/icon.png
cp branding/icon_1024.png website/public/img/logo.png
magick branding/icon_1024.png -resize 64x64 -alpha off -strip website/public/favicon.png
magick branding/icon_1024.png -resize 180x180 -alpha off -strip website/public/apple-touch-icon.png
echo "Native, store and website icons written."
