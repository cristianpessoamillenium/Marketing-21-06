import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/article.dart';
import '../../../core/utils/responsive.dart';
import 'empty_saved_list.dart';
import 'saved_article_tile.dart';
import 'saved_article_tile_tab.dart';

class SavedListViewBuilder extends StatelessWidget {
  const SavedListViewBuilder({
    super.key,
    required this.data,
    required this.listKey,
    required this.onRefresh,
    required this.handleScrollWithIndex,
  });

  final List<ArticleModel> data;
  final GlobalKey<AnimatedListState> listKey;
  final Future<void> Function() onRefresh;
  final void Function(int index) handleScrollWithIndex;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptySavedList();
    } else {
      return Responsive(
        mobile: _MobileListView(
          onRefresh: onRefresh,
          listKey: listKey,
          data: data,
          handleScrollWithIndex: handleScrollWithIndex,
        ),
        tablet: _TabletListView(
          onRefresh: onRefresh,
          listKey: listKey,
          data: data,
          handleScrollWithIndex: handleScrollWithIndex,
        ),
      );
    }
  }
}

class _MobileListView extends StatelessWidget {
  const _MobileListView({
    required this.onRefresh,
    required this.listKey,
    required this.data,
    required this.handleScrollWithIndex,
  });

  final Future<void> Function() onRefresh;
  final GlobalKey<AnimatedListState> listKey;
  final List<ArticleModel> data;
  final void Function(int index) handleScrollWithIndex;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AnimatedList(
        padding: const EdgeInsets.all(AppDefaults.padding),
        key: listKey,
        initialItemCount: data.length,
        itemBuilder: (context, index, animation) {
          handleScrollWithIndex(index);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppDefaults.duration,
            child: SlideAnimation(
              child: SavedArticleTile(
                article: data[index],
                animation: animation,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TabletListView extends StatelessWidget {
  const _TabletListView({
    required this.onRefresh,
    required this.listKey,
    required this.data,
    required this.handleScrollWithIndex,
  });

  final Future<void> Function() onRefresh;
  final GlobalKey<AnimatedListState> listKey;
  final List<ArticleModel> data;
  final void Function(int index) handleScrollWithIndex;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: AnimatedList(
        padding: const EdgeInsets.all(AppDefaults.padding),
        key: listKey,
        initialItemCount: data.length,
        itemBuilder: (context, index, animation) {
          handleScrollWithIndex(index);
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppDefaults.duration,
            child: SlideAnimation(
              child: Responsive(
                mobile: SavedArticleTile(
                  article: data[index],
                  animation: animation,
                  index: index,
                ),
                tablet: SavedArticleTileTab(
                  article: data[index],
                  animation: animation,
                  index: index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
