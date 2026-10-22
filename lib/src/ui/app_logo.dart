import 'package:flutter/material.dart';

import 'theme.dart';
import 'wordmark_path.dart';

/// Layers shared by the in-app logo and native launcher icon exports.
enum LogoLayer { full, background, foreground, monochrome }

/// Approved stacked Urdu wordmark: اسماء الحسنیٰ.
/// Outlined Nastaleeq keeps the calligraphy identical at every size.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 64,
    this.layer = LogoLayer.full,
    this.radius,
    this.wordmarkScale = 1,
  });

  final double size;
  final LogoLayer layer;
  final double? radius;

  /// Adaptive launcher layers use a smaller mark to stay inside crop masks.
  final double wordmarkScale;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    Widget logo = Semantics(
      label: '99 Names — Asmaul Husna',
      image: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _WordmarkPainter(
            background: p.logoBackground,
            ink: layer == LogoLayer.monochrome ? p.surface : p.logoInk,
            layer: layer,
            scale: wordmarkScale,
          ),
        ),
      ),
    );
    if (radius != null) {
      logo = ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: logo,
      );
    }
    return logo;
  }
}

class _WordmarkPainter extends CustomPainter {
  _WordmarkPainter({
    required this.background,
    required this.ink,
    required this.layer,
    required this.scale,
  });

  final Color background;
  final Color ink;
  final LogoLayer layer;
  final double scale;
  static final Path _wordmark = createWordmarkPath();

  @override
  void paint(Canvas canvas, Size size) {
    if (layer == LogoLayer.full || layer == LogoLayer.background) {
      canvas.drawRect(Offset.zero & size, Paint()..color = background);
    }
    if (layer == LogoLayer.background) return;
    canvas.save();
    canvas.scale(size.width / 256, size.height / 256);
    canvas.translate(128, 128);
    canvas.scale(scale);
    canvas.translate(-128, -128);
    canvas.drawPath(_wordmark, Paint()..color = ink);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WordmarkPainter old) =>
      old.background != background ||
      old.ink != ink ||
      old.layer != layer ||
      old.scale != scale;
}
