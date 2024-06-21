import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../../core/constants/constants.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';
import '../utils/app_utils.dart';
import 'article_category_row.dart';
import 'network_image.dart';

class ArticleTileLarge extends StatelessWidget {
  const ArticleTileLarge({
    super.key,
    required this.article,
    this.isMainPage = false,
  });

  final ArticleModel article;
  final bool isMainPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDefaults.margin / 2),
      child: Material(
        color: isMainPage
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).canvasColor,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.post,
              (v) => v.isFirst,
              arguments: article,
            );
          },
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: AppDefaults.boxShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.featuredImage != null)
                  VideoArticleWrapperLarge(
                    isVideoArticle: ArticleModel.isVideoArticle(article),
                    child: Hero(
                      tag: article.heroTag,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppDefaults.radius),
                          topRight: Radius.circular(AppDefaults.radius),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: NetworkImageWithLoader(
                            article.featuredImage!,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(AppDefaults.radius),
                              topRight: Radius.circular(AppDefaults.radius),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppDefaults.padding / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding,
                  ),
                  child: Text(
                    AppUtil.trimHtml(article.title),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: AppDefaults.padding / 2,
                    start: AppDefaults.padding,
                  ),
                  child: Row(
                    children: [
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
                      AppSizedBox.w16,
                      Row(
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
                    ],
                  ),
                ),
                ArticleCategoryRowText(article: article),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoArticleWrapperLarge extends StatelessWidget {
  const VideoArticleWrapperLarge({
    super.key,
    required this.isVideoArticle,
    required this.child,
  });

  final bool isVideoArticle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVideoArticle)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: AppDefaults.borderRadius,
                ),
                child: const Icon(
                  Icons.play_circle,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
