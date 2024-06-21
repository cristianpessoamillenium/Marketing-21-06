import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/core/components/article_tile_large.dart';
import '../controllers/config/config_controllers.dart';

import '../../../../core/constants/constants.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';
import '../utils/app_utils.dart';
import 'article_category_row.dart';
import 'network_image.dart';
import 'video_article_wrapper.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
    this.isMainPage = false,
  });

  final ArticleModel article;
  final bool isMainPage;

  @override
  Widget build(BuildContext context) {
    if (article.thumbnail == null) {
      return ArticleTileLarge(
        article: article,
        isMainPage: isMainPage,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDefaults.margin / 2),
        child: Material(
          color: isMainPage
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).canvasColor,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.post,
                arguments: article,
              );
            },
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                boxShadow: AppDefaults.boxShadow,
              ),
              child: Row(
                children: [
                  // thumbnail
                  if (article.thumbnail != null)
                    Expanded(
                      flex: 4,
                      child: VideoArticleWrapper(
                        isVideoArticle: ArticleModel.isVideoArticle(article),
                        child: Hero(
                          tag: article.heroTag,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppDefaults.radius),
                              bottomLeft: Radius.circular(AppDefaults.radius),
                            ),
                            child: NetworkImageWithLoader(
                              article.thumbnail!,
                              radius: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Description
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppUtil.trimHtml(article.title),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          /* <---- Category List -----> */
                          ArticleCategoryRow(article: article),
                          Row(
                            children: [
                              const Icon(
                                IconlyLight.timeCircle,
                                color: AppColors.placeholder,
                                size: 18,
                              ),
                              AppSizedBox.w5,
                              Text(
                                '${AppUtil.totalMinute(article.content, context)} ${'minute_read'.tr()}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          _ArticleDateRow(article: article)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _ArticleDateRow extends ConsumerWidget {
  const _ArticleDateRow({
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDate = ref.watch(configProvider).value?.showDateInApp ?? false;

    if (showDate) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            const Icon(
              IconlyLight.calendar,
              color: AppColors.placeholder,
              size: 18,
            ),
            AppSizedBox.w5,
            Text(
              AppUtil.getTime(article.date, context),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
