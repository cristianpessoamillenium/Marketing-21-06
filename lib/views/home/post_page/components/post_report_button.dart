import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/controllers/auth/auth_controller.dart';
import '../../../../core/controllers/config/config_controllers.dart';
import '../../../../core/models/article.dart';
import '../../../../core/repositories/posts/post_repository.dart';

class PostReportButton extends ConsumerWidget {
  const PostReportButton({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authController);
    final postRepo = ref.read(postRepoProvider);
    final config = ref.watch(configProvider).value;
    final contactEmail = config?.reportEmail ?? '';
    return OutlinedButton.icon(
      onPressed: () {
        postRepo.reportPost(
          postID: article.id,
          postTitle: article.title,
          userEmail: auth.member?.email ?? 'null',
          userName: auth.member?.name ?? 'null',
          reportEmail: contactEmail,
        );
      },
      label: Text('report'.tr()),
      icon: const Icon(IconlyLight.shieldFail),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
      ),
    );
  }
}
