import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/controllers/category/parent_categories_controller.dart';
import 'categories_list.dart';
import 'loading_categories.dart';

class ParentCategories extends ConsumerWidget {
  const ParentCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentCategories = ref.watch(parentCategoriesController);
    final controller = ref.watch(parentCategoriesController.notifier);
    if (!parentCategories.initialLoaded) {
      return const LoadingCategories();
    } else if (parentCategories.refershError) {
      return Center(child: Text(parentCategories.errorMessage));
    } else if (parentCategories.items.isEmpty) {
      return const Center(
        child: Text('No Categories Found'),
      );
    } else {
      return Expanded(
        child: CategoriesList(
          categories: parentCategories.items,
          handleScrollWithIndex: controller.handleScrollWithIndex,
          isPaginationLoading: parentCategories.isPaginationLoading,
          onRefresh: controller.onRefresh,
        ),
      );
    }
  }
}
