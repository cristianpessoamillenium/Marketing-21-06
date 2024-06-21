import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/components/headline_with_row.dart';
import '../../../core/constants/app_defaults.dart';
import '../../../core/models/category.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive.dart';
import '../category_page.dart';
import 'category_tile.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.handleScrollWithIndex,
    required this.isPaginationLoading,
    required this.onRefresh,
  });

  final List<CategoryModel> categories;
  final void Function(int index) handleScrollWithIndex;
  final bool isPaginationLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: HeadlineRow(headline: 'categories', isHeader: false),
        ),
        Expanded(
          child: Responsive(
            mobile: _MobileListView(
              categories: categories,
              handleScrollWithIndex: handleScrollWithIndex,
              onRefresh: onRefresh,
            ),
            tablet: _TabletView(
              categories: categories,
              handleScrollWithIndex: handleScrollWithIndex,
              onRefresh: onRefresh,
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileListView extends StatelessWidget {
  const _MobileListView({
    required this.categories,
    required this.handleScrollWithIndex,
    required this.onRefresh,
  });

  final List<CategoryModel> categories;
  final void Function(int index) handleScrollWithIndex;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          handleScrollWithIndex(index);
          final data = categories[index];
          final background = data.thumbnail;

          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: CategoryTile(
                categoryModel: data,
                backgroundImage: background,
                onTap: () {
                  final arguments = CategoryPageArguments(
                    category: data,
                    backgroundImage: background,
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.category,
                    arguments: arguments,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabletView extends StatelessWidget {
  const _TabletView({
    required this.categories,
    required this.handleScrollWithIndex,
    required this.onRefresh,
  });

  final List<CategoryModel> categories;
  final void Function(int index) handleScrollWithIndex;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3,
          mainAxisSpacing: AppDefaults.margin,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          handleScrollWithIndex(index);
          final data = categories[index];
          final background = data.thumbnail;
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: CategoryTile(
                categoryModel: data,
                backgroundImage: background,
                onTap: () {
                  final arguments = CategoryPageArguments(
                    category: data,
                    backgroundImage: background,
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.category,
                    arguments: arguments,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
