// Regenerate real app captures and Play Store artwork:
// flutter test tool/screenshots/render_test.dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:asmaul_husna/src/data/names.dart';
import 'package:asmaul_husna/src/detail/name_detail_screen.dart';
import 'package:asmaul_husna/src/home/home_screen.dart';
import 'package:asmaul_husna/src/settings/settings_screen.dart';
import 'package:asmaul_husna/src/settings/settings_store.dart';
import 'package:asmaul_husna/src/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> capture(
  WidgetTester tester,
  GlobalKey key,
  String path, {
  double scale = 1,
}) async {
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: scale);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    final icons = File(
      'build/unit_test_assets/fonts/MaterialIcons-Regular.otf',
    ).readAsBytesSync();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(Future.value(ByteData.view(icons.buffer)))).load();
    for (final entry in {
      AppFonts.sans: [
        'GoogleSans-Regular.ttf',
        'GoogleSans-SemiBold.ttf',
        'GoogleSans-Bold.ttf',
      ],
      AppFonts.display: ['Boldonse-Regular.ttf'],
      AppFonts.arabic: ['PDMSSaleemQuran.ttf'],
      AppFonts.urdu: ['JameelNooriNastaleeq.ttf'],
    }.entries) {
      final loader = FontLoader(entry.key);
      for (final name in entry.value) {
        final bytes = File('assets/fonts/$name').readAsBytesSync();
        loader.addFont(Future.value(ByteData.view(bytes.buffer)));
      }
      await loader.load();
    }
  });

  testWidgets('capture the app and compose store artwork', (tester) async {
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final scenarios = [
      'home',
      'rahman',
      'sabur',
      'favourites',
      'search',
      'grid',
      'dark',
      'settings',
    ];
    for (final name in scenarios) {
      tester.view.physicalSize = const Size(390, 844);
      // This standalone renderer runs with flutter test.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({
        'gridLayout': name == 'grid' || name == 'dark',
        'favourites': ['1', '3', '14', '99'],
      });
      await SettingsStore.instance.load();
      final dark = name == 'dark';
      final screen = switch (name) {
        'rahman' => NameDetailScreen(names: names, initialIndex: 0),
        'sabur' => NameDetailScreen(names: names, initialIndex: 98),
        'settings' => const SettingsScreen(),
        _ => const HomeScreen(),
      };
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(name),
          debugShowCheckedModeBanner: false,
          theme: buildTheme(dark ? Brightness.dark : Brightness.light),
          home: RepaintBoundary(
            key: key,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(390, 844),
                padding: EdgeInsets.only(top: 28, bottom: 20),
              ),
              child: screen,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (name == 'favourites') {
        await tester.tap(find.text('Favourites  4'));
        await tester.pumpAndSettle();
      }
      if (name == 'search') {
        await tester.enterText(find.byType(TextField), 'Merciful');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull, reason: name);
      await capture(tester, key, 'store/screenshots/$name.png', scale: 3);
    }

    const titles = [
      (
        'All 99 Names.\nAlways with you.',
        'Arabic, English and Urdu. Fully offline.',
      ),
      (
        'Read. Understand.\nReflect.',
        'A meaning and a reflection for every Name.',
      ),
      ('Make room\nfor reflection.', 'Explore each Name at your own pace.'),
      ('Keep your favourites\nclose.', 'Save the Names you want to return to.'),
      ('Find the Name\nyou need.', 'Search by name, meaning or number.'),
      (
        'See the beauty\nin every Name.',
        'Switch between a clear list and a simple grid.',
      ),
      (
        'A calmer view,\nday or night.',
        'Light and dark themes, made for reading.',
      ),
      (
        'Make it\nyour own.',
        'Adjust Arabic text size and reading preferences.',
      ),
    ];
    for (var i = 0; i < scenarios.length; i++) {
      tester.view.physicalSize = const Size(1080, 1920);
      final key = GlobalKey();
      final bytes = File(
        'store/screenshots/${scenarios[i]}.png',
      ).readAsBytesSync();
      final dark = i == 2 || i == 6;
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(dark ? Brightness.dark : Brightness.light),
          home: RepaintBoundary(
            key: key,
            child: Builder(
              builder: (context) {
                final p = context.palette;
                return Material(
                  color: p.background,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 64,
                        right: 64,
                        top: 58,
                        child: Row(
                          children: [
                            Text(
                              '99 NAMES',
                              style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w700,
                                color: p.accent,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'ASMAUL HUSNA',
                              style: TextStyle(
                                fontSize: 19,
                                letterSpacing: 3,
                                color: p.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 125,
                        left: 64,
                        right: 64,
                        child: Text(
                          titles[i].$1,
                          style: TextStyle(
                            fontSize: 72,
                            height: 1.08,
                            letterSpacing: -2,
                            fontWeight: FontWeight.w700,
                            color: p.title,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 306,
                        left: 64,
                        right: 64,
                        child: Text(
                          titles[i].$2,
                          style: TextStyle(fontSize: 27, color: p.body),
                        ),
                      ),
                      Positioned(
                        top: 405,
                        left: 200,
                        width: 680,
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: dark ? p.border : p.title,
                            borderRadius: BorderRadius.circular(38),
                            boxShadow: [
                              BoxShadow(
                                color: p.shadow,
                                blurRadius: 50,
                                offset: const Offset(0, 24),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.memory(bytes, fit: BoxFit.contain),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 64,
                        right: 64,
                        child: Row(
                          children: [
                            Text(
                              'A MOMENT TO REMEMBER',
                              style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 3,
                                color: p.muted,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${i + 1} / 8',
                              style: TextStyle(fontSize: 18, color: p.muted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => precacheImage(MemoryImage(bytes), key.currentContext!),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture(
        tester,
        key,
        'store/playstore/${(i + 1).toString().padLeft(2, '0')}.png',
      );
    }

    tester.view.physicalSize = const Size(1024, 500);
    final key = GlobalKey();
    final bytes = File('store/screenshots/rahman.png').readAsBytesSync();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark),
        home: RepaintBoundary(
          key: key,
          child: Builder(
            builder: (context) {
              final p = context.palette;
              return Material(
                color: p.background,
                child: Stack(
                  children: [
                    Positioned(
                      left: 54,
                      top: 62,
                      child: Text(
                        'ASMAUL HUSNA',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 4,
                          color: p.gold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: 107,
                      child: Text(
                        '99 Names',
                        style: TextStyle(
                          fontSize: 78,
                          fontWeight: FontWeight.w700,
                          color: p.title,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 54,
                      top: 221,
                      child: Text(
                        'A moment to remember.\nA meaning to reflect on.',
                        style: TextStyle(
                          fontSize: 29,
                          height: 1.4,
                          color: p.body,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 54,
                      bottom: 66,
                      child: Text(
                        'ARABIC  ·  ENGLISH  ·  URDU',
                        style: TextStyle(
                          fontSize: 17,
                          letterSpacing: 2,
                          color: p.gold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 690,
                      top: 28,
                      width: 205,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: p.border,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.memory(bytes),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(MemoryImage(bytes), key.currentContext!),
    );
    await tester.pumpAndSettle();
    await capture(tester, key, 'store/playstore/feature_graphic.png');
    debugDisableShadows = true;
  });
}
