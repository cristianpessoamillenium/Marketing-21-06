import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/comment.dart';
import 'user_comment.dart';

class AllComments extends StatelessWidget {
  const AllComments({
    super.key,
    required this.allComments,
    required this.articleID,
    required this.handlePagination,
    required this.onRefresh,
    required this.onReply,
  });

  final List<CommentModel> allComments;
  final int articleID;
  final void Function(int) handlePagination;
  final Future<void> Function() onRefresh;
  final void Function(String userName, int parentCommentID) onReply;

  @override
  Widget build(BuildContext context) {
    /// COMMENTS
    final comments =
        allComments.where((element) => element.parentCommentID == 0).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final CommentModel comment = comments[index];

          handlePagination(index);

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: AppDefaults.duration,
            child: SlideAnimation(
              child: UserComment(
                comment: comment,
                replies: comment.replies,
                onReply: () {
                  onReply(comment.authorName, comment.id);
                },
              ),
            ),
          );
        },
        itemCount: comments.length,
      ),
    );
  }
}

class CommentIsEmpty extends StatelessWidget {
  const CommentIsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSizedBox.h16,
                SvgPicture.asset(
                  AppImages.emptyPost,
                  height: 250,
                  width: 250,
                ),
                AppSizedBox.h16,
                AppSizedBox.h16,
                Text(
                  'comment_empty'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppSizedBox.h10,
                Text(
                  'comment_empty_message'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
