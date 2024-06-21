import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/wp_ad.dart';
import '../../repositories/wp_ad/wp_ad_repository.dart';
import '../config/config_controllers.dart';
import '../dio/dio_provider.dart';

final wpAdProvider =
    StateNotifierProvider<WPAdNotifier, AsyncData<List<WPAd>>>((ref) {
  final dio = ref.read(dioProvider);
  final repo = WPAdRepository(dio);
  final isCustomOn = ref.watch(configProvider).value?.isCustomAdOn ?? false;
  return WPAdNotifier(repo, isCustomOn);
});

class WPAdNotifier extends StateNotifier<AsyncData<List<WPAd>>> {
  WPAdNotifier(this.repo, this.isCustomAdOn) : super(const AsyncData([])) {
    {
      onInit();
    }
  }

  final WPAdRepository repo;
  final bool isCustomAdOn;

  onInit() async {
    if (isCustomAdOn) {
      state = AsyncData(await repo.getAllAds());
    } else {
      state = const AsyncData([]);
    }
  }

  int getRandomAdNumber() {
    final totalAds = state.value.length;

    if (totalAds > 0) {
      final random = math.Random();
      final adNumber = random.nextInt(totalAds);
      return adNumber;
    } else {
      // this is ignored
      return -1;
    }
  }

  WPAd? getABannerAd() {
    final allBannerAds =
        state.value.where((element) => element.isBanner).toList();
    if (allBannerAds.isNotEmpty) {
      final totalAds = allBannerAds.length;
      final random = math.Random();
      final adNumber = random.nextInt(totalAds);
      return allBannerAds[adNumber];
    } else {
      return null;
    }
  }

  WPAd? getALargeBannerAd() {
    final allBannerAds =
        state.value.where((element) => !element.isBanner).toList();
    if (allBannerAds.isNotEmpty) {
      final totalAds = allBannerAds.length;
      final random = math.Random();
      final adNumber = random.nextInt(totalAds);
      return allBannerAds[adNumber];
    } else {
      return null;
    }
  }
}
