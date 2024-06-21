import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_images_config.dart';
import '../../../views/explore/category_page.dart';
import '../../models/category.dart';
import '../../repositories/categories/category_repository.dart';
import '../../routes/app_routes.dart';
import '../analytics/analytics_controller.dart';
import '../config/config_controllers.dart';

final categoriesController =
    StateNotifierProvider<CategoriesNotifier, List<CategoryModel>>((ref) {
  final repo = ref.read(categoriesRepoProvider);
  return CategoriesNotifier(repo, ref);
});

class CategoriesNotifier extends StateNotifier<List<CategoryModel>> {
  CategoriesNotifier(
    this.repo,
    this.ref,
  ) : super([]) {
    {
      getAllCategories();
    }
  }

  final CategoriesRepository repo;
  final StateNotifierProviderRef ref;

  Future<List<CategoryModel>> getAllCategories() async {
    final data = await repo.getAllCategory();
    state = data;
    return state;
  }

  List<CategoryModel> getAllSubCategories(int parentCategory) {
    List<CategoryModel> allSubCategories = [];

    allSubCategories =
        state.where((element) => element.parent == parentCategory).toList();

    debugPrint(allSubCategories.toString());

    return allSubCategories;
  }

  addCategories(List<CategoryModel> data) {
    for (var element in data) {
      if (state.contains(element)) {
      } else {
        state = [...state, element];
      }
    }
  }

  Future<List<CategoryModel>> getTheseCategories(List<int> ids) async {
    List<CategoryModel> foundCategories = [];
    List<CategoryModel> notFoundCategories = [];
    List<CategoryModel> allCategories = [];
    List<int> notFoundIds = [];

    for (var id in ids) {
      final index = state.indexWhere((element) => element.id == id);
      if (index == -1) {
        notFoundIds.add(id);
      } else {
        final localCategories = state;
        final singleName =
            localCategories.singleWhere((element) => element.id == id);
        foundCategories.add(singleName);
      }
    }

    notFoundCategories = await repo.getTheseCategories(notFoundIds);

    allCategories = [...foundCategories, ...notFoundCategories];

    addCategories(notFoundCategories);

    return allCategories;
  }

  /// Go to categories Page
  void goToCategoriesPage(BuildContext context, int id) {
    final data = state.where((element) => element.id == id);

    if (data.isNotEmpty) {
      final arguments = CategoryPageArguments(
        category: data.first,
        backgroundImage: data.first.thumbnail,
      );
      Navigator.pushNamed(
        context,
        AppRoutes.category,
        arguments: arguments,
      );
      AnalyticsController.logCategoryView(arguments.category);
    }
  }

  Future<List<CategoryModel>> getFeaturedCategories() async {
    final config = ref.read(configProvider).value;
    final homeCategories = config?.homeTopTabCategories ?? [];
    final mainTabName = config?.mainTabName ?? 'Trending';

    final list = await repo.getTheseCategories(homeCategories);

    final CategoryModel featureCategory = CategoryModel(
      id: 0, // ignored
      name: mainTabName,
      slug: '', // ignored
      link: '', // ignored
      parent: 0, // ignored,
      thumbnail: AppImagesConfig.defaultCategoryImage,
    );

    list.insert(0, featureCategory);

    return list;
  }
}
