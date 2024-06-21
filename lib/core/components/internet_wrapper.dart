import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../views/entrypoint/loading_app_page.dart';
import '../../views/home/home_page/components/internet_not_available.dart';
import '../controllers/internet/internet_state.dart';
import '../controllers/internet/internet_state_provider.dart';

class InternetWrapper extends ConsumerWidget {
  const InternetWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetAvailable = ref.watch(internetStateProvider);
    switch (internetAvailable) {
      case InternetState.connected:
        return child;

      case InternetState.disconnected:
        return const InternetNotAvailablePage();

      case InternetState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      default:
        return const LoadingAppPage();
    }
  }
}
