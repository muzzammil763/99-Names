import 'package:asmaul_husna/main.dart';
import 'package:asmaul_husna/src/home/home_screen.dart';
import 'package:asmaul_husna/src/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('opens Home on the first frame with saved ${mode.name} theme', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'themeMode': mode.index});
      await SettingsStore.instance.load();
      await tester.pumpWidget(const AsmaulHusnaApp());

      expect(find.byType(HomeScreen), findsOneWidget);
      final context = tester.element(find.byType(HomeScreen));
      expect(
        Theme.of(context).brightness,
        mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
