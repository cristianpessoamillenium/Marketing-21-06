import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../config/app_images_config.dart';
import '../../../../core/components/network_image.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/repositories/posts/post_repository.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_utils.dart';

class NotificationDetailsWidget extends ConsumerWidget {
  const NotificationDetailsWidget({
    super.key,
    required this.data,
    required this.onDelete,
  });

  final NotificationModel data;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: AppDefaults.borderRadius,
      onTap: () async {
        if (data.postId != 0) {
          context.loaderOverlay.show();
          final repo = ref.read(postRepoProvider);
          final post = await repo.getPost(postID: data.postId);
          if (post != null) {
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, AppRoutes.post, arguments: post);
          }
          // ignore: use_build_context_synchronously
          context.loaderOverlay.hide();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding / 2),
        child: Row(
          children: [
            if (data.imageUrl != null)
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: NetworkImageWithLoader(
                        data.imageUrl == '' || data.imageUrl == null
                            ? AppImagesConfig.noImageUrl
                            : data.imageUrl!,
                        radius: 4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AppSizedBox.h10,
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.timeCircle,
                        size: 16,
                        color: Colors.grey,
                      ),
                      AppSizedBox.w5,
                      Text(
                        AppUtil.getTime(data.recievedTime, context),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            if (data.imageUrl != null) AppSizedBox.w10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Details
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 3,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      data.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                      maxLines: 2,
                    ),
                  ),

                  if (data.imageUrl == null)
                    Row(
                      children: [
                        const Icon(
                          IconlyLight.timeCircle,
                          size: 16,
                          color: Colors.grey,
                        ),
                        AppSizedBox.w5,
                        Text(
                          AppUtil.getTime(data.recievedTime, context),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(IconlyLight.delete, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
