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
}
