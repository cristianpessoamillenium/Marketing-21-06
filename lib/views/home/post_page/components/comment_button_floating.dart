import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/controllers/config/config_controllers.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';

class CommentButtonFloating extends ConsumerWidget {
  const CommentButtonFloating({
    super.key,
    required this.article,
    this.isVideoPage = false,
  });

  final ArticleModel article;
  final bool isVideoPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showComment = ref.watch(configProvider).value?.showComment ?? false;
    final isLoginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;
    if (showComment && isLoginEnabled) {
      if (isVideoPage) {
        return FloatingActionButton.extended(
          onPressed: () {
            ref.read(loadInterstitalAd)?.call();
            Navigator.pushNamed(context, AppRoutes.comment, arguments: article);
          },
          label: Text(
            '${article.totalComments}',
          ),
          icon: const Icon(Icons.comment),
          foregroundColor: Colors.white,
        );
      } else {
        return Positioned.directional(
          end: 16,
          bottom: 16,
          textDirection: Directionality.of(context),
          child: FloatingActionButton.extended(
            onPressed: () {
              ref.read(loadInterstitalAd)?.call();
              Navigator.pushNamed(context, AppRoutes.comment,
                  arguments: article);
            },
            label: Text(
              '${article.totalComments}',
            ),
            icon: const Icon(Icons.comment),
            foregroundColor: Colors.white,
          ),
        );
      }
    } else {
      return const SizedBox();
    }
  }
}
