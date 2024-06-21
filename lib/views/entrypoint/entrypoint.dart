import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import '../../core/ads/ad_state_provider.dart';
import '../../core/components/ad_widgets.dart';
import '../../core/utils/ui_util.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/controllers/config/config_controllers.dart';
import '../../core/repositories/others/onboarding_local.dart';
import '../auth/dialogs/consent_sheet.dart';
import '../explore/explore_page.dart';
import '../home/home_page/home_page.dart';
import '../saved/saved_page.dart';
import '../settings/settings_page.dart';
import '../webview_page.dart'; // Importando a nova página


class EntryPointUI extends ConsumerStatefulWidget {
  const EntryPointUI({super.key});

  @override
  ConsumerState<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends ConsumerState<EntryPointUI> {
  late PageController _controller;

  int _selectedIndex = 0;

  onTabTap(int index) {
    final showInterstitalAd = ref.read(loadInterstitalAd);
    showInterstitalAd?.call();

    _controller.animateToPage(
      index,
      duration: AppDefaults.duration,
      curve: Curves.ease,
    );
    _selectedIndex = index;
    setState(() {});
  }

  final screens = const [
    HomePage(),
    WebViewPage(), // Adicionando a nova página na terceira posição
    ExplorePage(),
    SavedPage(),
    SettingsPage(),
  ];

  DateTime timeBackPressed = DateTime.now();

  bool _onBackPressed() {
    final differeance = DateTime.now().difference(timeBackPressed);
    timeBackPressed = DateTime.now();
    if (differeance >= const Duration(seconds: 2)) {
      const String msg = 'Press the back button to exit';
      Fluttertoast.showToast(
        msg: msg,
      );
      return false;
    } else {
      Fluttertoast.cancel();
      SystemNavigator.pop();
      return true;
    }
  }

  bool canPop = false;

  _onPop(bool v) {
    int currentPage = _controller.page?.round() ?? 0;
    if (currentPage != 0) {
      _controller.animateToPage(0,
          duration: AppDefaults.duration, curve: Curves.ease);
      _selectedIndex = 0;
      canPop = false;
      setState(() {});
    } else {
      final result = _onBackPressed();
      if (result) {
        SystemNavigator.pop();
        canPop = true;
      } else {
        canPop = false;
      }
    }
  }

  checkIfConsent(BuildContext context, WidgetRef ref) {
    final showConsent =
        ref.watch(configProvider).value?.showCookieConsent ?? false;
    if (!showConsent) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final isDone = OnboardingRepository().isConsentDone();
      if (!isDone) {
        UiUtil.openBottomSheet(
            context: context, widget: const CookieConsentSheet());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navbarItems = [
      GButton(icon: IconlyLight.home, text: 'home'.tr()),
      GButton(icon: IconlyLight.wallet, text: 'Dinheiro'.tr()),
      GButton(icon: IconlyLight.category, text: 'explore'.tr()),
      GButton(icon: IconlyLight.heart, text: 'saved'.tr()),
      GButton(icon: IconlyLight.profile, text: 'settings'.tr()),
    ];

    checkIfConsent(context, ref);

    return PopScope(
      onPopInvoked: _onPop,
      child: Scaffold(
        body: PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: screens,
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GNav(
                  rippleColor: AppColors.primary.withOpacity(0.3),
                  hoverColor: Colors.grey.shade700,
                  haptic: true, // haptic feedback
                  tabBorderRadius: AppDefaults.radius,
                  curve: Curves.easeIn, // tab animation curves
                  duration: AppDefaults.duration, // tab animation duration
                  gap: 8,
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  color: Colors.grey, // unselected icon color
                  activeColor: AppColors.primary, // selected icon and text color
                  iconSize: 20, // tab button icon size
                  tabBackgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  tabs: navbarItems,
                  onTabChange: onTabTap,
                  selectedIndex: _selectedIndex,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ),
            ),
            const BannerAdWidget(), // Adiciona o banner de anúncio aqui
          ],
        ),
      ),
    );
  }
}