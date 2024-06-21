import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_utils.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AdaptiveThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<AdaptiveThemeMode> {
  ThemeModeNotifier() : super(AdaptiveThemeMode.light) {
    {
      onInit();
    }
  }

  void onInit() {
    getThemeMode();
  }

  Future<AdaptiveThemeMode> getThemeMode() async {
    state = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
    return state;
  }

  void changeThemeMode(AdaptiveThemeMode themeMode, BuildContext context) {
    if (themeMode == AdaptiveThemeMode.light) {
      AdaptiveTheme.of(context).setLight();
      AppUtil.setStatusBarLight();
      state = AdaptiveThemeMode.light;
    } else if (themeMode == AdaptiveThemeMode.dark) {
      AdaptiveTheme.of(context).setDark();
      AppUtil.setStatusBarDark();
      state = AdaptiveThemeMode.dark;
    } else if (themeMode == AdaptiveThemeMode.system) {
      AdaptiveTheme.of(context).setSystem();

      state = AdaptiveThemeMode.system;
      AppUtil.applyStatusBarColor(state == AdaptiveThemeMode.dark);
    }
  }
}

final isDarkMode = StateProvider.family<bool, BuildContext>((ref, context) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == AdaptiveThemeMode.dark) {
    return true;
  } else if (themeMode == AdaptiveThemeMode.system) {
    try {
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      return isDarkMode;
    } catch (e) {
      return false;
    }
  } else {
    return false;
  }
});
