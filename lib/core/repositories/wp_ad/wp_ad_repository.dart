import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../config/wp_config.dart';
import '../../models/wp_ad.dart';

class WPAdRepository {
  final Dio dio;

  WPAdRepository(this.dio);

  Future<List<WPAd>> getAllAds() async {
    List<WPAd> allAds = [];
    const url = 'https://${WPConfig.url}/wp-json/wp/v2/custom-ads';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = response.data as List;
        allAds = decodedResponse.map((e) => WPAd.fromMap(e)).toList();
        // debugPrint(allAds.toString());
        return allAds;
      } else {
        debugPrint('Response Code: ${response.statusCode}');
        debugPrint(response.data);
        return allAds;
      }
    } catch (e) {
      debugPrint(e.toString());
      return allAds;
    }
  }
}
