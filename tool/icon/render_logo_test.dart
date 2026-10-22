// Renders AppLogo to 1024px PNGs in branding/. Run via tool/icon/make_icons.sh.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:asmaul_husna/src/ui/app_logo.dart';
import 'package:asmaul_husna/src/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = 1024.0;

/// Adaptive icons are 108dp, of which launchers show at least the middle
/// 66dp; keep the lettering well inside that.
const _adaptiveText = .66;

void main() {
  for (final (layer, file, wordmarkScale) in const [
    (LogoLayer.full, 'icon_1024.png', 1.0),
    (LogoLayer.background, 'icon_background_1024.png', 1.0),
    (LogoLayer.foreground, 'icon_foreground_1024.png', _adaptiveText),
    (LogoLayer.monochrome, 'icon_monochrome_1024.png', _adaptiveText),
  ]) {
    testWidgets(file, (tester) async {
      tester.view.physicalSize = const Size(_size, _size);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RepaintBoundary(
              key: key,
              child: Theme(
                data: buildTheme(Brightness.light),
                child: AppLogo(
                  size: _size,
                  layer: layer,
                  wordmarkScale: wordmarkScale,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final rgba = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (layer == LogoLayer.foreground || layer == LogoLayer.monochrome) {
          // Android guarantees the central 66dp circle within a 108dp layer.
          final radius = _size * 33 / 108;
          for (var y = 0; y < image.height; y++) {
            for (var x = 0; x < image.width; x++) {
              if (rgba!.getUint8((y * image.width + x) * 4 + 3) == 0) continue;
              final dx = x + .5 - _size / 2;
              final dy = y + .5 - _size / 2;
              expect(
                dx * dx + dy * dy,
                lessThan(radius * radius),
                reason: 'Lettering must survive the adaptive icon crop',
              );
            }
          }
        }
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        File('branding/$file')
          ..createSync(recursive: true)
          ..writeAsBytesSync(png!.buffer.asUint8List());
        image.dispose();
      });
    });
  }
}
