import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/controllers/auth/auth_controller.dart';
import '../../../../core/controllers/auth/auth_state.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/saved_posts_controller.dart';
import '../../../../core/models/article.dart';

class SavePostButtonAlternative extends ConsumerWidget {
  const SavePostButtonAlternative({
    super.key,
    required this.article,
    this.iconSize = 18,
  });

  final ArticleModel article;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authController);
    final bool isLoggedIn = auth is AuthLoggedIn;
    final saved = ref.watch(savedPostsController);
    bool isSaved = saved.postIds.contains(article.id);
    bool isSaving = ref.watch(savedPostsController).isSavingPost;
    final controller = ref.read(savedPostsController.notifier);

    void onTap() async {
      if (isLoggedIn) {
        ref.read(loadInterstitalAd)?.call();
        if (isSaved) {
          await controller.removePostFromSaved(article.id);
          Fluttertoast.showToast(msg: 'article_removed_message'.tr());
        } else {
          await controller.addPostToSaved(article);
          Fluttertoast.showToast(msg: 'article_saved_message'.tr());
        }
      } else {
        Fluttertoast.showToast(msg: 'login_is_needed'.tr());
      }
    }

    if (saved.initialLoaded) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          foregroundColor: isSaved ? Colors.red : AppColors.placeholder,
          side: BorderSide(color: isSaved ? Colors.red : AppColors.placeholder),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 0,
        ),
        child: AnimatedSize(
          duration: AppDefaults.duration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSaved ? IconlyBold.heart : IconlyLight.heart,
                color: isSaved ? Colors.red : AppColors.placeholder,
                size: iconSize,
              ),
              AppSizedBox.w5,
              Text(
                isSaving
                    ? 'Adicionando...'
                    : isSaved
                        ? 'Favoritado'.tr()
                        : 'Add aos Favoritos',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
