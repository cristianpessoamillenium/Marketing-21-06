import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/categories/category_repository.dart';
import 'parent_categories_pagination.dart';

final parentCategoriesController =
    StateNotifierProvider<ParentCategoriesController, CategoryPagination>(
        (ref) {
  final categoryRepo = ref.read(categoriesRepoProvider);
  return ParentCategoriesController(categoryRepo);
});

class ParentCategoriesController extends StateNotifier<CategoryPagination> {
  ParentCategoriesController(
    this.repository, [
    CategoryPagination? state,
  ]) : super(state ?? CategoryPagination.initial()) {
    {
      getPosts();
    }
  }

  final CategoriesRepository repository;

  bool _isAlreadyLoading = false;

  getPosts() async {
    if (_isAlreadyLoading) {
    } else {
      _isAlreadyLoading = true;

      try {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted && state.page > 1) {
            state = state.copyWith(isPaginationLoading: true);
          }
        });

        final fetched = await repository.getAllParentCategories(state.page);

        /// Make's seperate list for categories with different hero ID

        final categories =
            fetched.map((e) => e.copyWith(slug: '${e.slug}recents')).toList();

        if (mounted && state.page == 1) {
          state = state.copyWith(initialLoaded: true);
        }

        if (mounted) {
          state = state.copyWith(
            items: [...state.items, ...categories],
            page: state.page + 1,
            isPaginationLoading: false,
          );
        }
      } on Exception {
        state = state.copyWith(
          errorMessage: 'Fetch Error',
          initialLoaded: true,
          isPaginationLoading: false,
        );
      }
      _isAlreadyLoading = false;
    }
  }

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 10 == 0 && itemPosition != 0;

    final pageToRequest = itemPosition ~/ 10;
    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getPosts();
    }
  }

  Future<void> onRefresh() async {
    state = CategoryPagination.initial();
    await getPosts();
  }
}
