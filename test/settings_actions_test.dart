import 'package:asmaul_husna/src/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:asmaul_husna/src/ui/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('com.muzamil.asmaulhusna/app_actions');
  testWidgets('settings dispatches share and rating to native actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call.method);
      return null;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.light),
        home: const SettingsScreen(),
      ),
    );
    await tester.tap(find.text('Share app'));
    await tester.pump();
    await tester.tap(find.text('Rate on Google Play'));
    await tester.pump();
    expect(calls, ['share', 'rate']);
    expect(tester.takeException(), isNull);
  });
  for (final brightness in Brightness.values) {
    testWidgets('other app links on a narrow ${brightness.name} screen', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call);
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(brightness),
          home: const SettingsScreen(),
        ),
      );
      for (final (name, package) in [
        ('Rafeeq', 'com.satechdev.rafeeqapp'),
        ('FM Crafts', 'com.fmcrafts.fmcrafts'),
        ('Budget AI', 'com.budgetai.android'),
        ('Quran Khatam Tracker', 'com.quran.khatam.tracker'),
      ]) {
        await tester.scrollUntilVisible(find.text(name), 200);
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
        expect(calls.last.method, 'openStore');
        expect(calls.last.arguments, {'packageName': package});
        expect(tester.takeException(), isNull);
      }
    });
  }
}
