import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../core/components/app_shimmer.dart';
import '../../../../core/components/column_builder.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/utils/ui_util.dart';
import '../dialogs/report_comment_dialog.dart';

class UserComment extends StatelessWidget {
  const UserComment({
    super.key,
    required this.comment,
    required this.replies,
    required this.onReply,
  });

  final CommentModel comment;
  final List<CommentModel> replies;
  final void Function() onReply;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment.avatarURL),
          ),
          title: Text(
            comment.authorName,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Text(AppUtil.getTime(comment.time, context)),
          trailing: IconButton(
            icon: const Icon(Icons.report_gmailerrorred_rounded),
            onPressed: () {
              UiUtil.openDialog(
                context: context,
                widget: ReportCommentDialog(
                  comment: comment,
                ),
              );
            },
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
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Opacity(opacity: 0.0, child: CircleAvatar()),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: onReply,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                label: const Text('Reply'),
                icon: const Icon(Icons.reply),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppDefaults.padding * 2),
          child: ColumnBuilder(
              itemBuilder: (context, index) {
                return ReplyComment(reply: replies[index]);
              },
              itemCount: replies.length),
        ),
        const Divider(),
      ],
    );
  }
}

class ReplyComment extends StatelessWidget {
  const ReplyComment({
    super.key,
    required this.reply,
  });

  final CommentModel reply;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(reply.avatarURL),
            ),
            title: Text(
              reply.authorName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            subtitle: Text(AppUtil.getTime(reply.time, context)),
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
                  data: reply.content,
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(14.0),
                      lineHeight: const LineHeight(1.4),
                    ),
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DummyUserComment extends StatelessWidget {
  const DummyUserComment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const AppShimmer(child: CircleAvatar()),
          title: AppShimmer(
            child: Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 3.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.borderRadius,
              ),
              child: const Text('App Text'),
            ),
          ),
          subtitle: AppShimmer(
            child: Container(
              margin: EdgeInsets.only(
                top: 8,
                right: MediaQuery.of(context).size.width / 3,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.borderRadius,
              ),
              child: const Text('App Text'),
            ),
          ),
          trailing: const AppShimmer(child: Icon(Icons.more_horiz_rounded)),
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
              child: AppShimmer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDefaults.borderRadius,
                  ),
                  child: const Text(
                      'Hello there, this is a test comment with some comment to show some dummy users'),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
