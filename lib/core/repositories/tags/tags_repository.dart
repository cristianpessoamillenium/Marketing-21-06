import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../config/wp_config.dart';
import '../../models/post_tag.dart';

class TagRepository {
  TagRepository(this.dio);
  final Dio dio;

  Future<List<PostTag>> getTagsNameById(List<int> ids) async {
    List<PostTag> allTags = [];

    if (ids.isEmpty) {
      return allTags;
    } else if (ids.length <= 10) {
      final tags = ids.join(',');
      final url = 'https://${WPConfig.url}/wp-json/wp/v2/tags/?include=$tags';
      try {
        final response = await dio.get(url);
        final decodedList = response.data as List;
        allTags = decodedList.map((e) => PostTag.fromMap(e)).toList();
        return allTags;
      } catch (e) {
        debugPrint(e.toString());
        return allTags;
      }
    } else {
      for (var i = 0; i < ids.length; i++) {
        final url = 'https://${WPConfig.url}/wp-json/wp/v2/tags/${ids[i]}';
        try {
          final response = await dio.get(url);
          if (response.statusCode == 200) {
            allTags.add(PostTag.fromMap(response.data));
          } else {}
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      return allTags;
    }
  }
}
