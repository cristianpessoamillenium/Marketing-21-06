import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/auth/auth_controller.dart';
import '../../../../core/controllers/auth/auth_state.dart';
import '../../../../core/controllers/posts/saved_posts_controller.dart';
import '../../../../core/models/article.dart';

class SavePostButton extends ConsumerWidget {
  const SavePostButton({
    super.key,
    required this.article,
    this.iconSize = 18,
  });

  final ArticleModel article;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedPostsController);
    bool isSaved = saved.postIds.contains(article.id);
    bool isSaving = ref.watch(savedPostsController).isSavingPost;
    final controller = ref.read(savedPostsController.notifier);
    final auth = ref.watch(authController);

    void onTap() async {
      if (auth is AuthLoggedIn) {
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
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: isSaved
              ? AppColors.primary
              : AppColors.cardColorDark.withOpacity(0.3),
          padding: const EdgeInsets.all(4),
          elevation: 0,
        ),
        child: isSaving
            ? SpinKitPumpingHeart(
                color: isSaving ? Colors.white : Colors.blue, size: 16)
            : Icon(
                isSaved ? IconlyBold.heart : IconlyLight.heart,
                color: Colors.white,
                size: iconSize,
              ),
      );
    } else {
      return const SizedBox();
    }
  }
}
