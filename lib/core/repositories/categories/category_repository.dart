import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/wp_config.dart';
import '../../controllers/config/config_controllers.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../models/category.dart';

final categoriesRepoProvider = Provider<CategoriesRepository>((ref) {
  final dio = ref.read(dioProvider);
  final blockedCategories =
      ref.watch(configProvider).value?.blockedCategories ?? [];

  return CategoriesRepository(dio: dio, blockedCategories: blockedCategories);
});

abstract class CategoriesRepoAbstract {
  /// Gets all the category from the website
  Future<List<CategoryModel>> getAllCategory();

  /// Get Single Category
  Future<CategoryModel?> getCategory(int id);

  /// Get These Categories
  Future<List<CategoryModel>> getTheseCategories(List<int> ids);

  /// Get All Parent Categories
  Future<List<CategoryModel>> getAllParentCategories(int page);

  /// Get All Sub Categories
  Future<List<CategoryModel>> getAllSubcategories(
      {required int page, required int parentId});
}

class CategoriesRepository extends CategoriesRepoAbstract {
  final Dio dio;
  CategoriesRepository({
    required this.dio,
    required this.blockedCategories,
  });

  final List<int> blockedCategories;

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    final blocked = _getBlockedCategories();

    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories?exclude=$blocked';
    List<CategoryModel> allCategories = [];
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final allData = response.data as List;
        allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
        // Log.info(allCategories.toString());
        return allCategories;
      } else {
        // Log.info('Status code for getAllCategory: ${response.statusCode}');
        // Log.info('getAllCategory: ${response.data}');
        return allCategories;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<CategoryModel?> getCategory(int id) async {
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/categories/$id';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return CategoryModel.fromMap(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Get Blocked Categories defined in [WPConfig]
  String _getBlockedCategories() {
    String data = '';
    final blockedData = blockedCategories;
    if (blockedData.isNotEmpty) {
      if (blockedData.length > 1) {
        data = blockedData.join(',');
      } else {
        data = blockedData.first.toString();
      }
    }
    return data;
  }

  @override
  Future<List<CategoryModel>> getTheseCategories(List<int> ids) async {
    List<CategoryModel> allCategories = [];

    final List<int> filteredIds =
        ids.where((id) => !blockedCategories.contains(id)).toList();

    if (filteredIds.isEmpty) {
      return allCategories;
    } else if (filteredIds.length <= 10) {
      final categories = ids.join(',');
      final url =
          'https://${WPConfig.url}/wp-json/wp/v2/categories?include=$categories&orderby=include';

      try {
        final response = await dio.get(url);
        if (response.statusCode == 200) {
          final allData = response.data as List;
          allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
          return allCategories;
        } else {
          debugPrint(response.data);
          return allCategories;
        }
      } catch (e) {
        debugPrint(e.toString());
        return allCategories;
      }
    } else {
      for (var i = 0; i < ids.length; i++) {
        final url =
            'https://${WPConfig.url}/wp-json/wp/v2/categories/${ids[i]}';
        try {
          final response = await dio.get(url);
          if (response.statusCode == 200) {
            allCategories.add(CategoryModel.fromMap(response.data));
          } else {}
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      return allCategories;
    }
  }

  @override
  Future<List<CategoryModel>> getAllParentCategories(int page) async {
    final blockedCategories = _getBlockedCategories();

    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories/?parent=0&page=$page&exclude=$blockedCategories';
    List<CategoryModel> allCategories = [];
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {}
      final allData = response.data as List;
      allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
      // debugPrint(allCategories.toString());
      return allCategories;
    } catch (e) {
      Fluttertoast.showToast(msg: 'There is an error while getting categories');
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<CategoryModel>> getAllSubcategories({
    required int page,
    required int parentId,
  }) async {
    final blockedCategories = _getBlockedCategories();

    String url =
        'https://${WPConfig.url}/wp-json/wp/v2/categories/?parent=$parentId&page=$page&exclude=$blockedCategories';
    List<CategoryModel> allCategories = [];
    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {}
      final allData = response.data as List;
      allCategories = allData.map((e) => CategoryModel.fromMap(e)).toList();
      // debugPrint(allCategories.toString());
      return allCategories;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
