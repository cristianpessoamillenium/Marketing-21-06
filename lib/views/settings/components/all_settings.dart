import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/components/ad_widgets.dart';
import '../../../core/constants/constants.dart';
import 'about_settings.dart';
import 'buy_this_app.dart';
import 'general_settings.dart';
import 'social_settings.dart';
import 'user_settings.dart';

class AllSettings extends StatelessWidget {
  const AllSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor,
      child: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (child) => SlideAnimation(
              duration: AppDefaults.duration,
              verticalOffset: 50.00,
              child: child,
            ),
            children: [
              const NativeAdWidget(),
              const UserSettings(),
              const GeneralSettings(),
              const AboutSettings(),
              const SocialSettings(),
              const BuyAppSettings(),
            ],
          ),
        ),
      ),
    );
  }
}
