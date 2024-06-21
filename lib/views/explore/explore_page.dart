import 'package:flutter/material.dart';

import '../../core/components/internet_wrapper.dart';
import 'components/authors_list_horizontal.dart';
import 'components/parent_categories.dart';
import 'components/search_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return InternetWrapper(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const SafeArea(
          child: Column(
            children: [
              SearchButton(),
              AuthorLists(),
              ParentCategories(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
