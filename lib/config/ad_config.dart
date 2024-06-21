import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class AdConfig {
  /// Ad Priority (If one fails or doesn't have ads it will show from other network)
  /// If you want to only use a single ad network, you can comment or delete others
  static final adPriority = [
    AdNetwork.admob, // Admob first
    AdNetwork.unity,
    AdNetwork.appLovin,
    AdNetwork.facebook, // Facebook second
  ];

  /* <-----------------------> 
      GOOGLE ADMOB    
   <-----------------------> */
  // Android
  static const String admobAndroidAppID =
      'ca-app-pub-9311012556587578~5815144288';
  static const String admobAndroidBannerAd =
      'ca-app-pub-9311012556587578/6430731619';
  static const String admobAndroidInterstitial =
      'ca-app-pub-9311012556587578/9562817604';

  static const String admobAndroidRewardedAd =
      'ca-app-pub-9311012556587578/5705711417';
  static const String admobAndroidAppOpenAd =
      'ca-app-pub-9311012556587578/1587466458';

  static const String admobAndroidNative =
      'ca-app-pub-9311012556587578/8110553334';

  /// IOS
  static const String admobIOSappID = 'ca-app-pub-2548139596011442~3528363077';
  static const String adMobIosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String admobIosInterstitial =
      'ca-app-pub-3940256099942544/4411468910';

  static const String admobIOSRewardedAd =
      'ca-app-pub-3940256099942544/1712485313';
  static const String admobIOSAppOpenAd =
      'ca-app-pub-3940256099942544/5662855259';

  static const String admobIosNative =
      // 'ca-app-pub-2548139596011442/9515119673';
      'ca-app-pub-3940256099942544/3986624511';

  /* <-----------------------> 
      Meta (Facebook) Audience Network    
   <-----------------------> */

  static const metaappId = 'YOUR_APP_ID';
  static const metainterstitialId = 'VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID';
  static const metabannerId = 'IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID';
  static const metarewardedId = 'VID_HD_16_9_46S_APP_INSTALL#YOUR_PLACEMENT_ID';

  /* <-----------------------> 
       Unity    
    <-----------------------> */

  /// ANDROID
  static const unityappIdAndroid = '5632391';
  static const unitybannerIdAndroid = 'Banner_Android';
  static const unityinterstitialIdAndroid = '';
  static const unityrewardedIdAndroid = '';

  ///IOS
  static const unityappIdIOS = '4374880';
  static const unitybannerIdIOS = 'Banner_iOS';
  static const unityinterstitialIdIOS = 'Interstitial_iOS';
  static const unityrewardedIdIOS = 'Rewarded_iOS';

  /* <-----------------------> 
        App Lovin    
     <-----------------------> */
  static const appLovinappId =
      'Cc7gu0UvhCL2wuD4ypu9z2_3r6qKhDeumJl59pZI43Mi3i2DEaKOLS5zNIsVuCBimJSi8fLf2fXhbotLftyMvK';

  /// ANDROID
  static const appLovinbannerIdAndroid = '61e0baba95ebea25';
  static const appLovininterstitialIdAndroid = '';
  static const appLovinrewardedIdAndroid = '';

  ///IOS
  static const appLovinbannerIdIOS = '80c269494c0e45c2';
  static const appLovininterstitialIdIOS = 'e33147110a6d12d2';
  static const appLovinrewardedIdIOS = 'f4af3e10dd48ee4f';
}
