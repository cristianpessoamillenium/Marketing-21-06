import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/comment.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/posts/comment_repository.dart';
import '../dio/dio_provider.dart';
import 'comment_pagination.dart';

final postCommentController = StateNotifierProvider.family
    .autoDispose<CommentPaginationController, CommentPagination, int>(
        (ref, int postID) {
  final dio = ref.read(dioProvider);
  final repo = CommentRepository(dio: dio);
  final authRepo = ref.read(authRepositoryProvider);
  return CommentPaginationController(repo, postID, authRepo);
});

class CommentPaginationController extends StateNotifier<CommentPagination> {
  CommentPaginationController(
    this.repository,
    this.postID,
    this._authRepo, [
    CommentPagination? state,
  ]) : super(state ?? CommentPagination.initial()) {
    {
      getComments();
    }
  }

  final CommentRepository repository;
  final int postID;
  final AuthRepository _authRepo;

  getComments() async {
    try {
      // get comments
      final comments = await repository.getComments(
        page: state.page,
        postId: postID,
        perPage: 10,
      );
      // for initial loading screen
      if (mounted && state.page == 1) {
        state = state.copyWith(initialLoaded: true);
      }
      if (mounted) {
        final commentWithReplies = <CommentModel>[];

        /// Adding replies to comment
        for (var comment in comments) {
          final replies = comments
              .where(
                (element) => element.parentCommentID == comment.id,
              )
              .toList();
          final singleComment = comment.copyWith(replies: replies);
          commentWithReplies.add(singleComment);
          // debugPrint(singleComment.toString());
        }

        state = state.copyWith(
          comments: [...state.comments, ...commentWithReplies],
          page: state.page + 1,
          isPaginationLoading: false,
        );

        totalCommentReceived = commentWithReplies
            .where((element) => element.parentCommentID == 0)
            .toList()
            .length;
      }
    } on Exception {
      state = state.copyWith(
        errorMessage: 'Fetch Error',
        initialLoaded: true,
        isPaginationLoading: false,
      );
    }
  }

  int totalCommentReceived = 0;

  void handlePagination(int index) {
    final itemPosition = index + 1;

    try {
      final requestMoreData =
          itemPosition % totalCommentReceived == 0 && itemPosition != 0;

      final pageToRequest = itemPosition ~/ totalCommentReceived;
      if (requestMoreData && pageToRequest + 1 >= state.page) {
        getComments();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onRefresh() async {
    state = CommentPagination.initial();
    await getComments();
  }

  /// Write a comment
  writeComment({
    required String email,
    required String name,
    required String content,
  }) async {
    final oldState = state;

    final token = await _authRepo.getToken();
    if (token != null) {
      bool isAdded = await repository.createComment(
        email: email,
        name: name,
        content: content,
        postID: postID,
        token: token,
      );
      if (isAdded) {
        state = CommentPagination.initial();
        await getComments();
      }
    } else {
      state = oldState;
    }
  }

  /// Reply To A Comment
  writeReply({
    required String email,
    required String name,
    required String content,
    required int parentCommentID,
  }) async {
    final oldState = state;

    final token = await _authRepo.getToken();
    if (token != null) {
      bool isAdded = await repository.replyToComment(
        email: email,
        name: name,
        content: content,
        postID: postID,
        token: token,
        parentCommentID: parentCommentID,
      );
      if (isAdded) {
        state = CommentPagination.initial();
        await getComments();
      }
    } else {
      state = oldState;
    }
  }
}
