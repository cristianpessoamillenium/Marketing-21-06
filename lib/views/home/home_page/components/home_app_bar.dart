import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import necessário para anúncios

import '../../../../config/wp_config.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/category.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/responsive.dart';
import 'horizontal_app_logo.dart';

class HomeAppBarWithTab extends StatefulWidget {
  const HomeAppBarWithTab({
    super.key,
    required this.categories,
    required this.tabController,
    required this.forceElevated,
    required this.showLogoInHome,
  });

  final List<CategoryModel> categories;
  final TabController tabController;
  final bool forceElevated;
  final bool showLogoInHome;

  @override
  _HomeAppBarWithTabState createState() => _HomeAppBarWithTabState();
}

class _HomeAppBarWithTabState extends State<HomeAppBarWithTab> {
  InterstitialAd? _interstitialAd;
  int _tabChangeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9311012556587578/9562817604', // Use o seu Ad Unit ID aqui
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _loadInterstitialAd(); // Load another interstitial ad
    }
  }

  void _onTabChanged() {
    _tabChangeCount++;
    if (_tabChangeCount % 2 == 0) { // Show interstitial ad every 2 tab changes
      _showInterstitialAd();
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.tabController.addListener(_onTabChanged);

    return SliverAppBar(
      elevation: 1,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      forceElevated: widget.forceElevated,
      title: widget.showLogoInHome ? null : const Text(WPConfig.appName),
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      centerTitle: false,
      leading: widget.showLogoInHome ? HorizontalAppLogo(isElevated: widget.forceElevated) : null,
      leadingWidth: widget.showLogoInHome
          ? Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width * 0.35
          : MediaQuery.of(context).size.width * 0.15
          : null,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          icon: const Icon(IconlyLight.search),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notification),
          icon: const Icon(IconlyLight.notification),
        ),
      ],
      bottom: TabBar(
        controller: widget.tabController,
        enableFeedback: true,
        isScrollable: true,
        padding: const EdgeInsets.only(left: AppDefaults.padding),
        tabs: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: List.generate(
            widget.categories.length,
                (index) => Text(AppUtil.trimHtml(widget.categories[index].name)),
          ),
        ),
      ),
    );
  }
}
