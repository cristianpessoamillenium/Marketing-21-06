import 'package:flutter/foundation.dart';

import '../../models/article.dart';

class SavedPostPagination {
  List<ArticleModel> posts;
  List<int> postIds;
  int page;
  String errorMessage;
  bool initialLoaded;
  bool isPaginationLoading;
  bool isSavingPost;
  SavedPostPagination({
    required this.posts,
    required this.postIds,
    required this.page,
    required this.errorMessage,
    required this.initialLoaded,
    required this.isPaginationLoading,
    required this.isSavingPost,
  });

  SavedPostPagination.initial()
      : posts = [],
        postIds = [],
        page = 1,
        errorMessage = '',
        initialLoaded = false,
        isPaginationLoading = false,
        isSavingPost = false;

  bool get refershError => errorMessage != '' && posts.length <= 10;

  SavedPostPagination copyWith({
    List<ArticleModel>? posts,
    List<int>? postIds,
    int? page,
    String? errorMessage,
    bool? initialLoaded,
    bool? isPaginationLoading,
    bool? isSavingPost,
  }) {
    return SavedPostPagination(
      posts: posts ?? this.posts,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      initialLoaded: initialLoaded ?? this.initialLoaded,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      isSavingPost: isSavingPost ?? this.isSavingPost,
      postIds: postIds ?? this.postIds,
    );
  }

  @override
  bool operator ==(covariant SavedPostPagination other) {
    if (identical(this, other)) return true;

    return listEquals(other.posts, posts) &&
        listEquals(other.postIds, postIds) &&
        other.page == page &&
        other.errorMessage == errorMessage &&
        other.initialLoaded == initialLoaded &&
        other.isPaginationLoading == isPaginationLoading &&
        other.isSavingPost == isSavingPost;
  }

  @override
  int get hashCode {
    return posts.hashCode ^
        postIds.hashCode ^
        page.hashCode ^
        errorMessage.hashCode ^
        initialLoaded.hashCode ^
        isPaginationLoading.hashCode ^
        isSavingPost.hashCode;
  }
}
