import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../config/app_images_config.dart';
import '../../core/components/app_loader.dart';
import '../../core/components/list_view_responsive.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/tags_post_controller.dart';
import '../../core/models/post_tag.dart';
import '../home/home_page/components/loading_posts_responsive.dart';
import 'components/empty_categories.dart';

class TagPage extends StatelessWidget {
  const TagPage({
    super.key,
    required this.tag,
  });

  final PostTag tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leadingWidth: MediaQuery.of(context).size.width * 0.2,
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text('#${tag.name}'),
                expandedTitleScale: 2,
                centerTitle: true,
                background: AspectRatio(
                  aspectRatio: AppDefaults.aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          AppImagesConfig.defaultCategoryImage,
                        ),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _TagsArticles(tag: tag),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(color: Theme.of(context).cardColor),
            )
          ],
        ),
      ),
    );
  }
}

class _TagsArticles extends ConsumerWidget {
  const _TagsArticles({
    required this.tag,
  });

  final PostTag tag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationController = ref.watch(tagPostController(tag));
    final controller = ref.watch(tagPostController(tag).notifier);

    if (paginationController.refershError) {
      return SliverToBoxAdapter(
        child: Center(child: Text(paginationController.errorMessage)),
      );

      /// on Initial State it will be empty
    } else if (paginationController.initialLoaded == false) {
      return const LoadingPostsResponsive();
    } else if (paginationController.posts.isEmpty) {
      return const SliverToBoxAdapter(child: EmptyCategoriesList());
    } else {
      return MultiSliver(
        children: [
          SliverPadding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            sliver: ResponsiveListView(
              data: paginationController.posts,
              handleScrollWithIndex: controller.handleScrollWithIndex,
            ),
          ),
          if (paginationController.isPaginationLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: AppLoader(),
              ),
            ),
        ],
      );
    }
  }
}
