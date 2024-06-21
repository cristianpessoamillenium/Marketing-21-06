import 'package:flutter/foundation.dart';

import '../../models/author.dart';

class AuthorPagination {
  List<AuthorData> items;
  int page;
  String errorMessage;
  bool initialLoaded;
  bool isPaginationLoading;
  AuthorPagination({
    required this.items,
    required this.page,
    required this.errorMessage,
    required this.initialLoaded,
    required this.isPaginationLoading,
  });

  AuthorPagination.initial()
      : items = [],
        page = 1,
        errorMessage = '',
        initialLoaded = false,
        isPaginationLoading = false;

  bool get refershError => errorMessage != '' && items.length <= 10;

  AuthorPagination copyWith({
    List<AuthorData>? items,
    int? page,
    String? errorMessage,
    bool? initialLoaded,
    bool? isPaginationLoading,
  }) {
    return AuthorPagination(
      items: items ?? this.items,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
      initialLoaded: initialLoaded ?? this.initialLoaded,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthorPagination &&
        listEquals(other.items, items) &&
        other.page == page &&
        other.errorMessage == errorMessage &&
        other.initialLoaded == initialLoaded &&
        other.isPaginationLoading == isPaginationLoading;
  }

  @override
  int get hashCode =>
      items.hashCode ^
      page.hashCode ^
      errorMessage.hashCode ^
      isPaginationLoading.hashCode ^
      initialLoaded.hashCode;
}
