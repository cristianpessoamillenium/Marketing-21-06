import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_pro/config/app_images_config.dart';

import '../../../../core/components/network_image.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/config/config_controllers.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/app_utils.dart';

class FeaturedPostArticle extends StatelessWidget {
  const FeaturedPostArticle({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.article,
  });

  final void Function() onTap;
  final bool isActive;
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: AppDefaults.duration,
      padding: EdgeInsets.symmetric(
        horizontal: AppDefaults.padding / 2,
        vertical: isActive ? 8.0 : 16,
      ),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDefaults.duration,
          decoration: BoxDecoration(
            borderRadius: AppDefaults.borderRadius,
            boxShadow: [
              AppDefaults.boxShadow.first,
              AppDefaults.boxShadow.first,
            ],
          ),
          child: Stack(
            children: [
              Hero(
                tag: article.heroTag,
                child: NetworkImageWithLoader(
                    article.featuredImage ?? AppImagesConfig.noImageUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: AnimatedContainer(
                  duration: AppDefaults.duration,
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  decoration: BoxDecoration(
                    borderRadius: AppDefaults.topSheetRadius,
                    color: AppColors.scaffoldBackgrounDark.withOpacity(0.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppUtil.trimHtml(article.title),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSizedBox.h10,
                      _ArticleDateRow(article: article),
                    ],
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                end: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadiusDirectional.only(
                        topEnd: Radius.circular(AppDefaults.radius),
                        bottomStart: Radius.circular(AppDefaults.radius),
                      )),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

    return Row(
      children: [
        const Icon(
          IconlyLight.timeCircle,
          color: Colors.white,
        ),
        AppSizedBox.w10,
        if (showDate)
          Text(
            '${AppUtil.totalMinute(article.content, context)}  ${'minute_read'.tr()} | ${AppUtil.getTime(article.date, context)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          )
        else
          Text(
            '${AppUtil.totalMinute(article.content, context)}  ${'minute_read'.tr()}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
      ],
    );
  }
}
