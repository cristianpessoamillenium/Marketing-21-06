import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/app_loader.dart';
import '../../core/controllers/users/authors_pagination.dart';
import 'components/author_list_tile.dart';

class AllAuthorsPage extends StatelessWidget {
  const AllAuthorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
      ),
      body: const _AuthorListRenderer(),
    );
  }
}

class _AuthorListRenderer extends ConsumerWidget {
  const _AuthorListRenderer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersController);
    final controllers = ref.watch(usersController.notifier);

    if (users.initialLoaded == false) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (users.refershError) {
      return Center(child: Text(users.errorMessage));
    } else if (users.items.isEmpty) {
      return const Center(child: Text('No Users Found'));
    } else {
      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: controllers.onRefresh,
              child: ListView.builder(
                itemCount: users.items.length,
                itemBuilder: (context, index) {
                  controllers.handleScrollWithIndex(index);
                  return AuthorListTile(
                    author: users.items[index],
                  );
                },
              ),
            ),
          ),
          if (users.isPaginationLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: AppLoader(),
            ),
        ],
      );
    }
  }
}
