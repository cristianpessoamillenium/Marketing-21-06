import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/users/user_repository.dart';
import 'author_list_controller.dart';

final usersController =
    StateNotifierProvider<AuthorsController, AuthorPagination>((ref) {
  final repo = ref.read(userRepoProvider);
  return AuthorsController(repo);
});

class AuthorsController extends StateNotifier<AuthorPagination> {
  AuthorsController(
    this.userRepository, [
    AuthorPagination? state,
  ]) : super(state ?? AuthorPagination.initial()) {
    {
      getPosts();
    }
  }

  final UserRepository userRepository;

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

        final fetched = await userRepository.getAllAuthor(state.page);

        if (mounted && state.page == 1) {
          state = state.copyWith(initialLoaded: true);
        }

        if (mounted) {
          state = state.copyWith(
            items: [...state.items, ...fetched],
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
    state = AuthorPagination.initial();
    await getPosts();
  }
}
