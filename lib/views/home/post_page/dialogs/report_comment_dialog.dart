import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/auth/auth_controller.dart';
import '../../../../core/controllers/config/config_controllers.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/repositories/posts/comment_repository.dart';
import '../../../../core/utils/responsive.dart';

class ReportCommentDialog extends ConsumerWidget {
  const ReportCommentDialog({
    super.key,
    required this.comment,
  });

  final CommentModel comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authController);
    final commentRepo = ref.read(commentRepoProvider);
    final config = ref.watch(configProvider).value;
    final contactEmail = config?.reportEmail ?? '';
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
              Text(
                'report_this_comment'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h16,
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDefaults.padding / 2,
                ),
                decoration: BoxDecoration(
                  boxShadow: AppDefaults.boxShadow,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: AppDefaults.borderRadius,
                  border: Border.all(
                    width: 2,
                    color: AppColors.placeholder.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          comment.avatarURL,
                        ),
                      ),
                      title: Text(comment.authorName),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd(context.locale.toLanguageTag())
                            .format(comment.time),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Row(
                      children: [
                        /// This will act as a empty space
                        /// so we can align with the userpicture above
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Opacity(opacity: 0.0, child: CircleAvatar()),
                        ),
                        Expanded(
                          child: Html(
                            data: comment.content,
                            style: {
                              'body': Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontSize: FontSize(16.0),
                                lineHeight: const LineHeight(1.4),
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSizedBox.h16,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    commentRepo.reportComment(
                      commentID: comment.id,
                      commentbody: comment.content,
                      userEmail: auth.member?.email ?? 'null',
                      userName: auth.member?.name ?? 'null',
                      reportEmail: contactEmail,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('report'.tr()),
                ),
              ),
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
