import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logger/app_logger.dart';

import '../../core/app/core_provider.dart';
import '../../core/components/animated_page_switcher.dart';
import '../../core/controllers/config/config_controllers.dart';
import '../auth/login_intro_page.dart';
import '../onboarding/onboarding_page.dart';
import 'components/loading_dependency.dart';
import 'configuration_error_page.dart';
import 'core_error_page.dart';
import 'entrypoint.dart';

class LoadingAppPage extends ConsumerWidget {
  const LoadingAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(coreAppStateProvider(context));
    final config = ref.watch(configProvider);
    return config.map(
      data: (data) => handleAppState(appState),
      error: (t) => const ConfigErrorPage(),
      loading: (t) => const LoadingDependencies(),
    );
  }

  Widget handleAppState(AsyncValue<AppState> appState) {
    return TransitionWidget(
      child: appState.map(
          data: (initialState) {
            switch (initialState.value) {
              case AppState.introNotDone:
                return const OnboardingPage();
              case AppState.loggedIn:
                return const EntryPointUI();
              case AppState.loggedOut:
                return const EntryPointUI();
              default:
                return const EntryPointUI();
            }
          },
          error: (t) {
            Log.fatal(error: t, stackTrace: StackTrace.current);
            return const CoreErrorPage();
          },
          loading: (t) => const LoadingDependencies()),
    );
  }
}
