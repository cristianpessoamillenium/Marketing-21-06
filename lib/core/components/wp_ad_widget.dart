import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/config/config_controllers.dart';
import '../controllers/wp_ad/wp_ad_controller.dart';
import '../models/wp_ad.dart';
import '../utils/app_utils.dart';
import '../utils/responsive.dart';
import 'ad_widgets.dart';
import 'animated_page_switcher.dart';
import 'network_image.dart';

class WPADWidget extends ConsumerWidget {
  const WPADWidget({
    super.key,
    this.isBannerOnly = false,
  });

  final bool isBannerOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watch(configProvider).value?.isCustomAdOn ?? false;
    if (isOn) {
      final adProvider = ref.watch(wpAdProvider);

      return TransitionWidget(
        child: adProvider.map(
            data: (data) {
              if (data.value.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Opacity(
                    //   opacity: 0.7,
                    //   child: Text('advertisement_key'.tr(),
                    //       style: Theme.of(context).textTheme.bodySmall),
                    // ),
                    _HandleCustomAdData(
                      data: data.value,
                      isBannerOnly: isBannerOnly,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
            error: (v) => Text('ad_load_failed_message'.tr()),
            loading: (data) => const CircularProgressIndicator()),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _HandleCustomAdData extends ConsumerWidget {
  const _HandleCustomAdData({
    required this.data,
    required this.isBannerOnly,
  });

  final List<WPAd> data;
  final bool isBannerOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adController = ref.read(wpAdProvider.notifier);
    final int randomAdIndex = adController.getRandomAdNumber();
    if (isBannerOnly) {
      final theBannerAd = adController.getABannerAd();
      if (theBannerAd != null) {
        bool isTablet = Responsive.isTablet(context) ||
            Responsive.isTabletPortrait(context);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isTablet)
              Expanded(
                child: _TheBannerAd(ad: theBannerAd),
              ),
            Expanded(
              child: _TheBannerAd(ad: theBannerAd),
            ),
          ],
        );
      } else {
        return const NativeAdWidget();
      }
    } else {
      if (data.isNotEmpty) {
        final ad = data[randomAdIndex];

        if (ad.isBanner) {
          return _TheBannerAd(ad: ad);
        } else {
          return _TheLargeBannerAD(ad: ad);
        }
      } else {
        return const SizedBox();
      }
    }
  }
}

class _TheBannerAd extends StatelessWidget {
  const _TheBannerAd({
    required this.ad,
  });

  final WPAd ad;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4.6,
          child: NetworkImageWithLoader(
            ad.imageURL,
            fit: BoxFit.fitWidth,
            radius: 0,
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => AppUtil.openLink(ad.adTarget),
            ),
          ),
        ),
      ],
    );
  }
}

class _TheLargeBannerAD extends StatelessWidget {
  const _TheLargeBannerAD({
    required this.ad,
  });

  final WPAd ad;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: NetworkImageWithLoader(
              ad.imageURL,
              fit: BoxFit.contain,
              radius: 0,
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => AppUtil.openLink(ad.adTarget),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
