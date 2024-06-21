import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/category.dart';
import 'categories_controller.dart';

final categoriesProvider = FutureProvider.family
    .autoDispose<List<CategoryModel>, List<int>>((ref, ids) async {
  if (ids.isNotEmpty) {
    final controllers = ref.read(categoriesController.notifier);
    final gotCategories = await controllers.getTheseCategories(ids);
    return gotCategories;
  } else {
    return [];
  }
});
