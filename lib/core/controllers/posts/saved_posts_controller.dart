import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../views/saved/components/saved_article_tile.dart';
import '../../models/article.dart';
import '../../repositories/posts/favourite_post_repository.dart';
import '../../repositories/posts/post_repository.dart';
import '../analytics/analytics_controller.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_state.dart';
import 'saved_post_pagination.dart';

/// Provides The Saved Posts
final savedPostsController =
    StateNotifierProvider<SavedPostNotifier, SavedPostPagination>(
  (ref) {
    final repo = ref.read(postRepoProvider);
    final fav = ref.read(favouritePostRepoProvider);
    final isLoggedIn = ref.watch(authController) is AuthLoggedIn;
    return SavedPostNotifier(repo, fav, isLoggedIn);
  },
);

class SavedPostNotifier extends StateNotifier<SavedPostPagination> {
  SavedPostNotifier(this._repo, this.fav, this.isLoggedIn)
      : super(SavedPostPagination.initial()) {
    {
      initialLoadIDs();
    }
  }

  final PostRepository _repo;
  final FavouritePostRepository fav;
  final bool isLoggedIn;

  bool _isAlreadyLoading = false;

  initialLoadIDs() async {
    if (isLoggedIn) {
      List<int> postIDs = [];
      postIDs = await fav.getFavouriteIDs();
      state = state.copyWith(postIds: postIDs);
      if (postIDs.isNotEmpty) {
        await getPosts();
      } else {
        state = state.copyWith(initialLoaded: true);
      }
    } else {
      state = state.copyWith(initialLoaded: true);
    }
  }

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

        final fetched = await _repo.getThesePosts(
          ids: state.postIds,
          page: state.page,
        );

        /// Make's seperate list for categories with different hero ID

        final newList = fetched
            .map((e) => e.copyWith(heroTag: '${e.link} + saved'))
            .toList();

        if (mounted && state.page == 1) {
          state = state.copyWith(initialLoaded: true);
        }

        if (mounted) {
          state = state.copyWith(
            posts: [...state.posts, ...newList],
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

  removePostFromSavedAnimated({
    required int id,
    required int index,
    required ArticleModel tile,
  }) async {
    state.copyWith(isSavingPost: true);
    final newList = state.posts.where((element) => element.id != id).toList();
    final newIdList = state.postIds.where((element) => element != id).toList();
    animatedListKey.currentState?.removeItem(
      index,
      (context, animation) => SavedArticleTile(
        article: tile,
        animation: animation,
        index: index,
      ),
    );
    state = state.copyWith(posts: newList, postIds: newIdList);
    await fav.updateFavouriteList(newIdList.toSet().toList());
    state.copyWith(isSavingPost: false);
    AnalyticsController.logUserFavouriteRemoved(tile);
  }

  removePostFromSaved(int id) async {
    state.copyWith(isSavingPost: true);
    final newList = state.posts.where((element) => element.id != id).toList();
    final newIdList = state.postIds.where((element) => element != id).toList();
    state = state.copyWith(posts: newList, postIds: newIdList);
    await fav.updateFavouriteList(newIdList.toSet().toList());
    state.copyWith(isSavingPost: false);
  }

  addPostToSaved(ArticleModel article) async {
    state = state.copyWith(isSavingPost: true);
    final currentList = state.posts;
    final currentIdList = state.postIds;

    final thePost = article.copyWith(heroTag: '${article.link} + saved');
    state = state.copyWith(
      posts: [...currentList, thePost],
      postIds: [...currentIdList, article.id],
    );
    animatedListKey.currentState?.insertItem(0);
    try {
      await fav.updateFavouriteList(state.postIds.toSet().toList());
      AnalyticsController.logUserFavourite(article);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    state = state.copyWith(isSavingPost: false);
  }

  /// Used for animation when deleting or inserting Article
  final animatedListKey = GlobalKey<AnimatedListState>();

  void handleScrollWithIndex(int index) {
    final itemPosition = index + 1;
    final requestMoreData = itemPosition % 10 == 0 && itemPosition != 0;

    final pageToRequest = itemPosition ~/ 10;
    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getPosts();
    }
  }

  Future<void> clearAll() async {
    await fav.updateFavouriteList([]);
    state = state.copyWith(
      postIds: [],
      posts: [],
    );
  }

  /// on Refresh
  Future<void> onRefresh() async {
    state = SavedPostPagination.initial();
    await initialLoadIDs();
    await getPosts();
  }
}
