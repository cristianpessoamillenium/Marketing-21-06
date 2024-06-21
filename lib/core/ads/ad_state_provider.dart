import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/config/config_controllers.dart';
import '../logger/app_logger.dart';

final loadInterstitalAd = Provider<Function?>((ref) {
  return () {
    final count = ref.watch(interstialCountProvider);
    final controller = ref.read(interstialCountProvider.notifier);
    final config = ref.watch(configProvider).value;
    final isAdOn = config?.isAdOn ?? false;
    final interstialCountTap = config?.interstialAdCount ?? 3;

    if (isAdOn) {
      final totalTap = count;
      controller.increaseTap();
      if (totalTap != 0 && totalTap % interstialCountTap == 0) {
        Log.info('Showing interstial ad, Count is now = $totalTap');
        EasyAds.instance.showAd(AdUnitType.interstitial);
      } else {
        /// nothing here
      }
    } else {
      // Log.info('Ad is not on');
      return null;
    }
  };
});

final interstialCountProvider =
    StateNotifierProvider<AppInterstialAdNotifier, int>((ref) {
  return AppInterstialAdNotifier();
});

class AppInterstialAdNotifier extends StateNotifier<int> {
  AppInterstialAdNotifier() : super(0);

  increaseTap() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final count = state;
        state = count + 1;
      }
    });
  }
}
