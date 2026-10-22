import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Every colour the app paints with. Light and dark share one shape, so each
/// widget reads `context.palette` and both themes keep the same look.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.accent,
    required this.onAccent,
    required this.accentDeep,
    required this.gold,
    required this.title,
    required this.body,
    required this.muted,
    required this.faint,
    required this.patternInk,
    required this.shadow,
    required this.logoBackground,
    required this.logoInk,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color accent;
  final Color onAccent;
  final Color accentDeep;
  final Color gold;
  final Color title;
  final Color body;
  final Color muted;
  final Color faint;

  /// Base colour of the geometric line patterns.
  final Color patternInk;
  final Color shadow;
  final Color logoBackground;
  final Color logoInk;

  /// Ink-blue canvas with soft blue and muted bronze accents.
  static const dark = AppPalette(
    logoBackground: Color(0xFF101820),
    logoInk: Color(0xFFD9BC89),
    background: Color(0xFF101820),
    surface: Color(0xFF18232E),
    surfaceRaised: Color(0xFF21303D),
    border: Color(0xFF30404E),
    accent: Color(0xFFA5C5DE),
    onAccent: Color(0xFF142838),
    accentDeep: Color(0xFF293F50),
    gold: Color(0xFFD9BC89),
    title: Colors.white,
    body: Color(0xFFC9D1D8),
    muted: Color(0xFFA0AFBB),
    faint: Color(0xFF758693),
    patternInk: Colors.white,
    shadow: Color(0x66000000),
  );

  /// Warm ivory canvas with blue and bronze, deepened for
  /// contrast on a light ground.
  static const light = AppPalette(
    logoBackground: Color(0xFF101820),
    logoInk: Color(0xFFD9BC89),
    background: Color(0xFFFAF8F3),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFEFEDE6),
    border: Color(0xFFE3E5E4),
    accent: Color(0xFF345F7B),
    onAccent: Colors.white,
    accentDeep: Color(0xFFE5EDF2),
    gold: Color(0xFF906C38),
    title: Color(0xFF1B2B36),
    body: Color(0xFF455865),
    muted: Color(0xFF667985),
    faint: Color(0xFF8B9BA5),
    patternInk: Color(0xFF345F7B),
    shadow: Color(0x1A345F7B),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      logoBackground: l(logoBackground, other.logoBackground),
      logoInk: l(logoInk, other.logoInk),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceRaised: l(surfaceRaised, other.surfaceRaised),
      border: l(border, other.border),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentDeep: l(accentDeep, other.accentDeep),
      gold: l(gold, other.gold),
      title: l(title, other.title),
      body: l(body, other.body),
      muted: l(muted, other.muted),
      faint: l(faint, other.faint),
      patternInk: l(patternInk, other.patternInk),
      shadow: l(shadow, other.shadow),
    );
  }
}

abstract final class AppFonts {
  static const sans = 'Google Sans';
  static const display = 'Boldonse';
  static const arabic = 'PDMS Saleem Quran';
  static const urdu = 'Jameel Noori Nastaleeq';
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final p = dark ? AppPalette.dark : AppPalette.light;
  const cupertinoText = CupertinoTextThemeData();
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: AppFonts.sans,
    scaffoldBackgroundColor: p.background,
    extensions: [p],
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: p.accent,
          brightness: brightness,
        ).copyWith(
          primary: p.accent,
          onPrimary: p.onAccent,
          secondary: p.gold,
          surface: p.surface,
          onSurface: p.title,
          outline: p.border,
        ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: p.accent,
      scaffoldBackgroundColor: p.background,
      textTheme: CupertinoTextThemeData(
        textStyle: cupertinoText.textStyle.copyWith(fontFamily: AppFonts.sans),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 14, color: p.body, height: 1.4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      foregroundColor: p.title,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.sans,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: p.title,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: dark ? const Color(0xFF293F50) : const Color(0xFF203747),
      contentTextStyle: const TextStyle(
        fontFamily: AppFonts.sans,
        color: Colors.white,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: p.accent,
      thumbColor: p.accent,
      inactiveTrackColor: p.border,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: p.accent,
      selectionColor: p.accent.withValues(alpha: .3),
      selectionHandleColor: p.accent,
    ),
    dividerColor: p.border,
  );
}

extension AppContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Scales a design value (authored at 390×844) to the current screen.
  double r(double value) {
    final size = MediaQuery.sizeOf(this);
    final k = math.min(size.width / 390, size.height / 844).clamp(.82, 1.2);
    return value * k;
  }
}

void showToast(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
