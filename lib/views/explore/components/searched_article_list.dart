import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/components/list_view_responsive.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/article.dart';
import '../../../core/utils/responsive.dart';
import '../../home/home_page/components/loading_posts_responsive.dart';

class SearchedArticleList extends StatelessWidget {
  const SearchedArticleList({
    super.key,
    required List<ArticleModel> searchedList,
    required this.isSearching,
  }) : _searchedList = searchedList;

  final List<ArticleModel> _searchedList;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return isSearching
        ? const LoadingPostsResponsive(isInSliver: false)
        : _searchedList.isEmpty
            ? const SearchedListEmpty()
            : Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: ResponsiveListView(
                  data: _searchedList,
                  handleScrollWithIndex: (v) {},
                  isInSliver: false,
                  shrinkWrap: true,
                  isDisabledScroll: true,
                ),
              );
  }
}

class SearchedListEmpty extends StatelessWidget {
  const SearchedListEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Responsive(
          mobile: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: SvgPicture.asset(
              AppImages.emptyPost,
              height: 250,
              width: 250,
            ),
          ),
          tablet: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: SvgPicture.asset(
              AppImages.emptyPost,
              height: 350,
              width: 350,
            ),
          ),
        ),
        AppSizedBox.h16,
        AppSizedBox.h16,
        Text(
          'search_empty'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        AppSizedBox.h16,
        Text(
          'search_empty_message'.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
