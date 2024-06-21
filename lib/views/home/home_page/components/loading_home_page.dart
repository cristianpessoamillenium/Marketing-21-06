import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../config/wp_config.dart';
import '../../../../core/components/app_shimmer.dart';
import '../../../../core/components/headline_with_row.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/responsive.dart';
import 'horizontal_app_logo.dart';
import 'loading_posts_responsive.dart';

class LoadingHomePage extends StatelessWidget {
  const LoadingHomePage({
    super.key,
    required this.showLogoInHome,
  });
  final bool showLogoInHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (child) => SlideAnimation(child: child),
            children: [
              AppBar(
                title: showLogoInHome ? null : const Text(WPConfig.appName),
                titleTextStyle:
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                centerTitle: false,
                leading: showLogoInHome
                    ? const HorizontalAppLogo(isElevated: false)
                    : null,
                leadingWidth: showLogoInHome
                    ? Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.15
                    : null,
                actions: [
                  AppShimmer(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconlyLight.search),
                    ),
                  ),
                  AppShimmer(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(IconlyLight.notification),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppDefaults.padding / 2),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: AppShimmer(child: Chip(label: Text('hhhh gekg'))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppShimmer(
                  enabled: false,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(AppDefaults.margin),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppDefaults.borderRadius,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: AppShimmer(
                  child: HeadlineRow(
                    headline: 'recent_news',
                    isHeader: false,
                  ),
                ),
              ),
              const LoadingPostsResponsive(isEnabled: false, isInSliver: false),
            ],
          ),
        ),
      ),
    );
  }
}
