import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/author.dart';
import '../../repositories/users/user_repository.dart';

final authorDataProvider =
    FutureProvider.family<AuthorData?, int>((ref, id) async {
  final repo = ref.read(userRepoProvider);
  final theAuthor = await repo.getUserNamebyID(id);
  return theAuthor;
});
