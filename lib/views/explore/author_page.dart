import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/components/app_loader.dart';
import '../../core/components/list_view_responsive.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/author_post_controllers.dart';
import '../../core/models/author.dart';
import '../home/home_page/components/loading_posts_responsive.dart';

class AuthorPostPage extends StatelessWidget {
  const AuthorPostPage({
    super.key,
    required this.author,
  });

  final AuthorData author;

  @override
  Widget build(BuildContext context) {
    return _AuthorDataSection(
      authorData: author,
    );
  }
}

class _AuthorDataSection extends ConsumerWidget {
  const _AuthorDataSection({
    required this.authorData,
  });

  final AuthorData authorData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(authorData.name),
          actions: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                authorData.avatarUrlHD,
              ),
            ),
          ],
        ),
        body: _PostRenderer(data: authorData));
  }
}

class _PostRenderer extends ConsumerWidget {
  const _PostRenderer({
    required this.data,
  });

  final AuthorData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorPost = ref.watch(authorPostController(data.userID));
    final controller = ref.watch(authorPostController(data.userID).notifier);

    if (authorPost.initialLoaded == false) {
      return const LoadingPostsResponsive(isInSliver: false);
    } else if (authorPost.refershError) {
      return Center(child: Text(authorPost.errorMessage));
    } else if (authorPost.posts.isEmpty) {
      return const _NoPostsFound();
    } else {
      return Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.onRefresh,
              child: ResponsiveListView(
                data: authorPost.posts,
                handleScrollWithIndex: controller.handleScrollWithIndex,
                isInSliver: false,
                padding: const EdgeInsets.only(
                  right: AppDefaults.margin,
                  left: AppDefaults.margin,
                ),
              ),
            ),
          ),
          if (authorPost.isPaginationLoading)
            const Padding(padding: EdgeInsets.all(16.0), child: AppLoader()),
        ],
      );
    }
  }
}

class _NoPostsFound extends StatelessWidget {
  const _NoPostsFound();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding * 2),
            child: SvgPicture.asset(
              AppImages.emptyPost,
              height: 250,
              width: 250,
            ),
          ),
          AppSizedBox.h16,
          Text(
            'No posts found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Text(
              'The author don\'t have any posts. You can check other authors by going back.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            label: Text('go_back'.tr()),
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
