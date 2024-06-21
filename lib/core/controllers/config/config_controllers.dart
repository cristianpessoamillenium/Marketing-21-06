import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/core/ads/ad_id_provider.dart';

import '../../models/config.dart';
import '../../repositories/configs/config_repository.dart';
import '../dio/dio_provider.dart';

final configProvider =
    StateNotifierProvider<NewsProConfigNotifier, AsyncValue<NewsProConfig>>(
        (ref) {
  final dio = ref.read(dioProvider);
  final repo = ConfigRepository(dio: dio);

  return NewsProConfigNotifier(repo);
});

class NewsProConfigNotifier extends StateNotifier<AsyncValue<NewsProConfig>> {
  NewsProConfigNotifier(
    this.repo,
  ) : super(const AsyncLoading()) {
    {
      init();
    }
  }

  final ConfigRepository repo;

  init() async {
    final data = await repo.getNewsProConfig();
    if (data == null) {
      const errorMessage = 'No configuration found';
      state = AsyncError(errorMessage, StackTrace.fromString(errorMessage));
    } else {
      if (data.isAdOn) {
        await initializeAdNetworks();
      }
      state = AsyncData(data);
    }
  }
}
