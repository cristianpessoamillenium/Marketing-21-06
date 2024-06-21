import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/components/headline_with_row.dart';
import '../../../../core/components/list_view_responsive.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/posts/more_post_controller.dart';
import '../../home_page/components/loading_posts_responsive.dart';

class MoreRelatedPost extends ConsumerWidget {
  const MoreRelatedPost({
    super.key,
    required this.categoryID,
    required this.currentArticleID,
  });

  final int categoryID;
  final int currentArticleID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final morePost = ref.watch(moreRelatedPostController(categoryID));
    return morePost.map(
      data: (data) {
        final updatedList = data.value
            .where((element) => element.id != currentArticleID)
            .toList();
        if (updatedList.isEmpty) {
          return const SizedBox();
        } else {
          return Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: HeadlineRow(headline: 'more_related_posts')),
                AppSizedBox.h16,
                ResponsiveListView(
                  data: updatedList,
                  handleScrollWithIndex: (v) {},
                  isMainPage: true,
                  isInSliver: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  isDisabledScroll: true,
                ),
              ],
            ),
          );
        }
      },
      error: (t) => Center(child: Text(t.toString())),
      loading: (t) => const LoadingPostsResponsive(isInSliver: false),
    );
  }
}
