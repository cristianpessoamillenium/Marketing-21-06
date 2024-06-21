import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/ad_config.dart';
import '../../config/wp_config.dart';
import '../controllers/config/config_controllers.dart';
import '../themes/theme_manager.dart';

class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({
    super.key,
    this.isLarge = false,
  });

  final bool isLarge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).value;
    final isAdOn = config?.isAdOn ?? false;
    if (isAdOn) {
      return EasySmartBannerAd(
        priorityAdNetworks: AdConfig.adPriority,
        adSize: isLarge ? AdSize.largeBanner : AdSize.banner,
      );
    } else {
      return const SizedBox();
    }
  }
}

class NativeAdWidget extends HookConsumerWidget {
  final bool isSmallSize;

  const NativeAdWidget({super.key, this.isSmallSize = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double minHeight = isSmallSize ? 90.0 : 320.0;
    final double maxHeight = isSmallSize ? 120.0 : 360.0;

    final nativeAd = useState<NativeAd?>(null);
    final nativeAdIsLoaded = useState<bool>(false);
    final isDark = ref.watch(isDarkMode(context));
    final config = ref.watch(configProvider).value;
    final isAdOn = config?.isAdOn ?? false;

    useEffect(() {
      late NativeAd? ad;
      if (isAdOn) {
        ad = NativeAd(
          adUnitId: Platform.isIOS
              ? AdConfig.admobIosNative
              : AdConfig.admobAndroidNative,
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              debugPrint('$NativeAd loaded.');
              nativeAdIsLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error) {
              debugPrint('$NativeAd failed to load: $error');
              ad.dispose();
            },
          ),
          request: const AdRequest(),
          nativeAdOptions: NativeAdOptions(
            mediaAspectRatio: MediaAspectRatio.landscape,
            adChoicesPlacement: AdChoicesPlacement.topRightCorner,
          ),
          nativeTemplateStyle: isDark
              ? nativeTemplateDark(isSmallSize)
              : nativeTemplateLight(isSmallSize),
        )..load();

        nativeAd.value = ad;
      }

      return () {
        if (isAdOn) ad?.dispose();
      };
    }, []);

    return nativeAdIsLoaded.value && nativeAd.value != null
        ? ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320.0,
              minHeight: minHeight,
              maxHeight: maxHeight,
            ),
            child: AdWidget(ad: nativeAd.value!))
        : const SizedBox();
  }

  NativeTemplateStyle nativeTemplateDark(bool isSmallSize) {
    final templateType = isSmallSize ? TemplateType.small : TemplateType.medium;
    return NativeTemplateStyle(
      templateType: templateType,
      mainBackgroundColor: Colors.grey.shade800,
      cornerRadius: 10.0,
      callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: WPConfig.primaryColor,
          style: NativeTemplateFontStyle.normal,
          size: 16.0),
      primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0),
      secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade100,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0),
      tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade100,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0),
    );
  }

  NativeTemplateStyle nativeTemplateLight(bool isSmallSize) {
    final templateType = isSmallSize ? TemplateType.small : TemplateType.medium;
    return NativeTemplateStyle(
      templateType: templateType,
      mainBackgroundColor: Colors.white,
      cornerRadius: 10.0,
      callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: WPConfig.primaryColor,
          style: NativeTemplateFontStyle.normal,
          size: 16.0),
      primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey.shade900,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0),
      secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.blueGrey.shade600,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0),
      tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.blueGrey.shade500,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0),
    );
  }
}
