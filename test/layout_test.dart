import 'package:asmaul_husna/src/data/names.dart';
import 'package:asmaul_husna/src/detail/name_detail_screen.dart';
import 'package:asmaul_husna/src/home/home_screen.dart';
import 'package:asmaul_husna/src/settings/settings_screen.dart';
import 'package:asmaul_husna/src/settings/settings_store.dart';
import 'package:asmaul_husna/src/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('reading screens fit a small phone in ${brightness.name}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      SharedPreferences.setMockInitialValues({});
      await SettingsStore.instance.load();
      for (final screen in <Widget>[
        const HomeScreen(),
        NameDetailScreen(names: names, initialIndex: 84),
        const SettingsScreen(),
      ]) {
        await tester.pumpWidget(
          MaterialApp(theme: buildTheme(brightness), home: screen),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: screen.runtimeType.toString(),
        );
      }
    });
  }
}
