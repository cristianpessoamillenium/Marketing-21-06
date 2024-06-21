import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/analytics/analytics_controller.dart';
import '../../../../core/models/article.dart';

class ShareButtonAlternative extends StatelessWidget {
  const ShareButtonAlternative({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        await Share.share(article.link);
        AnalyticsController.logUserContentShare(article);
      },
      icon: const Icon(
        IconlyLight.send,
        size: 18,
      ),
      label: Text(
        'share'.tr(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
        foregroundColor: AppColors.placeholder,
        side: const BorderSide(color: AppColors.placeholder),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        elevation: 0,
      ),
    );
  }
}
