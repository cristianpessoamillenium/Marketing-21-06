import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/controllers/config/config_controllers.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';

class TotalCommentsButton extends ConsumerWidget {
  const TotalCommentsButton({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showComment = ref.watch(configProvider).value?.showComment ?? false;
    final loginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;

    if (showComment && loginEnabled) {
      return Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: SizedBox(
          width: double.infinity,
          child: Consumer(
            builder: (context, ref, child) {
              return ElevatedButton.icon(
                onPressed: () {
                  ref.read(loadInterstitalAd)?.call();
                  Navigator.pushNamed(context, AppRoutes.comment,
                      arguments: article);
                },
                icon: const Icon(Icons.comment_outlined),
                label: Text(
                  '${article.totalComments} ${'load_comments'.tr()}',
                ),
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
