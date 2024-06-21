import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/posts/saved_posts_controller.dart';
import '../../../core/models/article.dart';
import '../../../core/utils/responsive.dart';

class WantToDeleteSavedDialog extends StatelessWidget {
  const WantToDeleteSavedDialog({
    super.key,
    required this.postID,
    required this.index,
    required this.articleModel,
  });

  final int postID;
  final int index;
  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).cardColor,
      child: SizedBox(
        width: Responsive.isMobile(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'warning'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Divider(),
              AppSizedBox.h10,
              Text(
                'delete_article'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h10,
              Text(
                'article_delete_info'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h16,
              Consumer(builder: (context, ref, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await ref
                          .read(savedPostsController.notifier)
                          .removePostFromSavedAnimated(
                            index: index,
                            id: postID,
                            tile: articleModel,
                          );
                      context.loaderOverlay.hide();
                      Navigator.pop(context);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('delete'.tr()),
                  ),
                );
              }),
              AppSizedBox.h16,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(),
                  child: Text('cancel'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
