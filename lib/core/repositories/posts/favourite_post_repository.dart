import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_repository.dart';
import '../users/user_repository.dart';

final favouritePostRepoProvider = Provider<FavouritePostRepository>((ref) {
  final auth = ref.read(authRepositoryProvider);
  final repo = ref.read(userRepoProvider);
  return FavouritePostRepository(auth: auth, repo: repo);
});

abstract class FavouritePostRepositoryAbstract {
  /// Get all favourite ids
  Future<List<int>> getFavouriteIDs();

  /// update to favourite
  Future<List<String>> updateFavouriteList(List<int> updatedList);
}

class FavouritePostRepository extends FavouritePostRepositoryAbstract {
  final AuthRepository auth;
  final UserRepository repo;
  FavouritePostRepository({
    required this.auth,
    required this.repo,
  });

  @override
  Future<List<int>> getFavouriteIDs() async {
    final token = await auth.getToken();
    if (token != null) {
      final me = await repo.getMe(token);
      if (me != null) {
        List<int> postIDs = [];
        for (var element in me.savedArticles) {
          final id = int.tryParse(element) ?? 0;
          postIDs.add(id);
        }
        // debugPrint('Found Ids: ${me.savedArticles}');
        return postIDs;
      } else {
        debugPrint('no profile found for this token');
        return [];
      }
    } else {
      debugPrint('No token found for favourite post');
      return [];
    }
  }

  @override
  Future<List<String>> updateFavouriteList(List<int> updatedList) async {
    final token = await auth.getToken();
    if (token != null) {
      final me = await repo.updateProfile(token, {
        'saved_articles': updatedList,
      });
      if (me != null) {
        return me.savedArticles;
      } else {
        debugPrint('no profile found for this token');
        return [];
      }
    } else {
      debugPrint('No token found for favourite post');
      return [];
    }
  }
}
