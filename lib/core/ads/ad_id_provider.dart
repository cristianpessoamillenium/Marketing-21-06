import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../config/ad_config.dart';

class AppAdIdManager extends IAdIdManager {
  const AppAdIdManager();

  static bool isAndroid = Platform.isAndroid;

  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: isAndroid ? AdConfig.admobAndroidAppID : AdConfig.admobIOSappID,
        appOpenId: isAndroid
            ? AdConfig.admobAndroidAppOpenAd
            : AdConfig.admobIOSAppOpenAd,
        bannerId:
            isAndroid ? AdConfig.admobAndroidBannerAd : AdConfig.adMobIosBanner,
        interstitialId: isAndroid
            ? AdConfig.admobAndroidInterstitial
            : AdConfig.admobIosInterstitial,
        rewardedId: isAndroid
            ? AdConfig.admobAndroidRewardedAd
            : AdConfig.admobIOSRewardedAd,
      );

  @override
  AppAdIds? get unityAdIds => AppAdIds(
        appId: isAndroid ? AdConfig.unityappIdAndroid : AdConfig.unityappIdIOS,
        bannerId: isAndroid
            ? AdConfig.unitybannerIdAndroid
            : AdConfig.unitybannerIdIOS,
        interstitialId: isAndroid
            ? AdConfig.unityinterstitialIdAndroid
            : AdConfig.unityinterstitialIdIOS,
        rewardedId: isAndroid
            ? AdConfig.unityrewardedIdAndroid
            : AdConfig.unityrewardedIdIOS,
      );

  @override
  AppAdIds? get appLovinAdIds => AppAdIds(
        appId: AdConfig.appLovinappId,
        bannerId: isAndroid
            ? AdConfig.appLovinbannerIdAndroid
            : AdConfig.appLovinbannerIdIOS,
        interstitialId: isAndroid
            ? AdConfig.appLovininterstitialIdAndroid
            : AdConfig.appLovininterstitialIdIOS,
        rewardedId: isAndroid
            ? AdConfig.appLovinrewardedIdAndroid
            : AdConfig.appLovinrewardedIdIOS,
      );

  @override
  AppAdIds? get fbAdIds => const AppAdIds(
        appId: AdConfig.metaappId,
        interstitialId: AdConfig.metainterstitialId,
        bannerId: AdConfig.metabannerId,
        rewardedId: AdConfig.metarewardedId,
      );
}

Future<void> initializeAdNetworks() async {
  const IAdIdManager adIdManager = AppAdIdManager();
  await EasyAds.instance.initialize(
    adIdManager,
    adMobAdRequest: const AdRequest(),
    // Set true if you want to show age restricted (age below 16 years) ads for applovin
    isAgeRestrictedUserForApplovin: true,
    // To enable Facebook Test mode ads
    fbTestMode: kDebugMode,
    admobConfiguration: RequestConfiguration(testDeviceIds: [
      '072D2F3992EF5B4493042ADC632CE39F',
      '00008030-00163022226A802E',
    ]),
  );
}
