import 'dart:async';
import 'dart:io';

import 'package:in_app_update_flutter/in_app_update_flutter.dart';

/// Asks the store whether a newer release exists. Android downloads it in the
/// background (flexible update) and installs once ready; iOS shows the App
/// Store sheet. Fails silently: offline, sideloaded or debug builds just skip.
Future<void> checkForAppUpdate() async {
  final plugin = InAppUpdateFlutter();
  try {
    if (Platform.isAndroid) {
      final info = await plugin.checkUpdateAndroid();
      if (info.updateAvailability !=
              UpdateAvailabilityAndroid.updateAvailable ||
          !info.isFlexibleUpdateAllowed) {
        return;
      }
      late final StreamSubscription<InstallStateAndroid> sub;
      sub = plugin.installStateStreamAndroid.listen((state) {
        if (state.status == InstallStatusAndroid.downloaded) {
          sub.cancel();
          plugin.completeUpdateAndroid();
        }
      });
      await plugin.startFlexibleUpdateAndroid();
    } else if (Platform.isIOS) {
      final info = await plugin.checkUpdateIos();
      if (info.updateAvailability == UpdateAvailabilityIos.updateAvailable) {
        await plugin.showUpdateForIos(appStoreId: info.appStoreId);
      }
    }
  } catch (_) {}
}
