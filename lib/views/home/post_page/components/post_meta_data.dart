import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/components/animated_page_switcher.dart';
import '../../../../core/components/app_shimmer.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/config/config_controllers.dart';
import '../../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../../core/controllers/users/author_data_provider.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_utils.dart';

class PostMetaData extends StatelessWidget {
  const PostMetaData({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _TimeWidget(article: article),
          _ViewsWidget(article: article),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: AuthorData(articleModel: article),
              ),
              const Spacer(),
              // CommentCounter(data: article),
              TrendingIndicator(article: article),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewsWidget extends ConsumerWidget {
  const _ViewsWidget({
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showViews = ref.watch(configProvider).value?.showPostViews ?? false;
    if (showViews) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(
              Icons.visibility,
              color: Colors.grey,
              size: 24,
            ),
            AppSizedBox.w5,
            Text(
              article.views,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: SizedBox(),
      );
    }
  }
}

class _TimeWidget extends ConsumerWidget {
  const _TimeWidget({
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDate = ref.watch(configProvider).value?.showDateInApp ?? false;

    return Row(
      children: [
        const Icon(
          IconlyBold.timeCircle,
          color: Colors.grey,
        ),
        AppSizedBox.w5,
        if (showDate)
          Text(
            '${AppUtil.totalMinute(article.content, context)} ${'minute_read'.tr()} | ${AppUtil.getTime(article.date, context)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          )
        else
          Text(
            '${AppUtil.totalMinute(article.content, context)} ${'minute_read'.tr()}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
      ],
    );
  }
}

class TrendingIndicator extends ConsumerWidget {
  const TrendingIndicator({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTrending = ref.watch(isTrendingProvider(article));
    final showTrendingIcon =
        ref.watch(configProvider).value?.showTrendingPopularIcon ?? false;
    if (isTrending && showTrendingIcon) {
      return Row(
        children: [
          const Icon(
            Icons.bolt_rounded,
            color: AppColors.primary,
            // size: 16,
          ),
          AppSizedBox.h5,
          Text(
            'Trending',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class CommentCounter extends StatelessWidget {
  const CommentCounter({
    super.key,
    required this.data,
  });

  final ArticleModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.comment,
          size: 16,
          color: Colors.grey,
        ),
        AppSizedBox.w5,
        Text(
          '${data.totalComments} ${'load_comments'.tr()}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class AuthorData extends ConsumerWidget {
  const AuthorData({
    super.key,
    required this.articleModel,
  });

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransitionWidget(
      child: ref.watch(authorDataProvider(articleModel.authorID)).map(
            data: (data) => InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.authorPage,
                  arguments: data.value!,
                );
              },
              child: Row(
                children: [
                  data.value?.avatarUrl == null
                      ? const Icon(
                          IconlyBold.profile,
                          color: Colors.grey,
                          size: 18,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(data.value!.avatarUrl),
                          radius: 9.5,
                        ),
                  AppSizedBox.w5,
                  Text(
                    data.value?.name ?? 'Author',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            loading: (d) => const LoadingAuthorData(),
            error: (e) => const Text('Error'),
          ),
    );
  }
}

class LoadingAuthorData extends StatelessWidget {
  const LoadingAuthorData({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Row(
        children: [
          const Icon(
            IconlyBold.profile,
            color: Colors.grey,
            size: 18,
          ),
          AppSizedBox.w5,
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: AppDefaults.borderRadius),
            child: Text(
              'Author',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
