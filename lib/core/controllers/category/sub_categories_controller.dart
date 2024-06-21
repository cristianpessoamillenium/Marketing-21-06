import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/categories/category_repository.dart';
import 'parent_categories_pagination.dart';

final subCategoriesController = StateNotifierProvider.family<
    SubCategoriesController, CategoryPagination, int>((ref, parentID) {
  final categoryRepo = ref.read(categoriesRepoProvider);
  return SubCategoriesController(categoryRepo, parentID);
});

class SubCategoriesController extends StateNotifier<CategoryPagination> {
  SubCategoriesController(
    this.repository,
    this.parentID, [
    CategoryPagination? state,
  ]) : super(state ?? CategoryPagination.initial()) {
    {
      getPosts();
    }
  }

  final CategoriesRepository repository;
  final int parentID;

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

        final fetched = await repository.getAllSubcategories(
          page: state.page,
          parentId: parentID,
        );

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
