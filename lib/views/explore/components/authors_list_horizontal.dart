import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/controllers/users/authors_pagination.dart';
import '../../../core/routes/app_routes.dart';
import 'author_tile.dart';
import 'author_tile_loading.dart';

class AuthorLists extends ConsumerWidget {
  const AuthorLists({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show =
        ref.watch(configProvider).value?.showAuthorsInExplorePage ?? false;
    if (show) {
      final users = ref.watch(usersController);
      if (users.initialLoaded == false) {
        return const _LoadingAuthors();
      } else if (users.refershError) {
        debugPrint('Error from author data:${users.errorMessage}');
        return const SizedBox();
      } else if (users.items.isEmpty) {
        debugPrint('No Users Found');
        return const SizedBox();
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.only(start: AppDefaults.padding),
          child: Row(
            children: [
              ...List.generate(
                users.items.length,
                (index) => AuthorTile(
                  data: users.items[index],
                ),
              ),
              const _ViewAllAuthorButton(),
            ],
          ),
        );
      }
    } else {
      return const SizedBox();
    }
  }
}

class _LoadingAuthors extends StatelessWidget {
  const _LoadingAuthors();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: AppDefaults.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) => const LoadingAuthorTile()),
      ),
    );
  }
}

class _ViewAllAuthorButton extends StatelessWidget {
  const _ViewAllAuthorButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.allAuthors),
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(AppDefaults.padding * 1.1),
          ),
          child: const Icon(Icons.people),
        ),
        AppSizedBox.h5,
        const Text('View All')
      ],
    );
  }
}
