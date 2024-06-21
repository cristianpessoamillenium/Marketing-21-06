import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/author.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/users/user_repository.dart';

final userDataProvider = FutureProvider<AuthorData?>((ref) async {
  final auth = ref.read(authRepositoryProvider);
  final repo = ref.read(userRepoProvider);
  final token = await auth.getToken();
  AuthorData? author;
  if (token != null) author = await repo.getMe(token);
  return author;
});
