import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/article.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/posts/post_repository.dart';
import 'post_pagination_class.dart';

final authorPostController = StateNotifierProvider.family
    .autoDispose<AuthorPostController, PostPagination, int>((ref, authorID) {
  final repo = ref.read(postRepoProvider);
  final authRepo = ref.read(authRepositoryProvider);

  return AuthorPostController(repo, authorID, authRepo);
});

class AuthorPostController extends StateNotifier<PostPagination> {
  AuthorPostController(
    this.repository,
    this.authorID,
    this.authRepository, [
    PostPagination? state,
  ]) : super(state ?? PostPagination.initial()) {
    {
      getPosts();
    }
  }

  final PostRepository repository;
  final int authorID;
  final AuthRepository authRepository;

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

        // debugPrint('Getting post');

        List<ArticleModel> fetched = [];

        fetched = await repository.getPostByAuthor(
          pageNumber: state.page,
          authorID: authorID,
        );

        /// Make's seperate list for categories with different hero ID
        String isFeature = 'author_post:$authorID';
        final posts = fetched
            .map((e) => e.copyWith(heroTag: e.link + isFeature))
            .toList();

        if (mounted && state.page == 1) {
          state = state.copyWith(initialLoaded: true);
        }

        if (mounted) {
          state = state.copyWith(
            posts: [...state.posts, ...posts],
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
    state = PostPagination.initial();
    await getPosts();
  }
}
