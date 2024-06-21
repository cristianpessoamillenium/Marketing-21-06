import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../core/components/animated_page_switcher.dart';
import '../../../core/components/internet_wrapper.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/category/categories_controller.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/controllers/posts/categories_post_controller.dart';
import '../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../core/models/category.dart';
import 'components/category_tab_view.dart';
import 'components/home_app_bar.dart';
import 'components/loading_feature_post.dart';
import 'components/loading_home_page.dart';
import 'components/trending_tab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<CategoryModel> _feturedCategories = [];

  bool _isLoading = true;
  updateUI() {
    if (mounted) setState(() {});
  }

  /// Set Categories and update the UI
  _setCategories() async {
    _isLoading = true;
    updateUI();
    try {
      _feturedCategories =
          await ref.read(categoriesController.notifier).getFeaturedCategories();
      _tabController =
          TabController(length: _feturedCategories.length, vsync: this);
    } on Exception {
      _tabController = TabController(length: 1, vsync: this);
    }
    _isLoading = false;
    updateUI();
  }

  /// Tabs
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _setCategories();
    ref.read(authController);
    // OneSignal.Notifications.requestPermission(true);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popularPosts = ref.watch(popularPostsController);
    final showLogo =
        ref.watch(configProvider).value?.showTopLogoInHome ?? false;
    if (_isLoading) {
      return LoadingHomePage(showLogoInHome: showLogo);
    } else {
      return InternetWrapper(
        child: NestedScrollView(
          // physics: const BouncingScrollPhysics(),
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HomeAppBarWithTab(
              categories: _feturedCategories,
              tabController: _tabController,
              forceElevated: innerBoxIsScrolled,
              showLogoInHome: showLogo,
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              _feturedCategories.length,
              (index) {
                if (index == 0) {
                  return TransitionWidget(
                    child: popularPosts.map(
                      data: ((data) => TrendingTabSection(
                            posts: data.value,
                          )),
                      error: (t) => Text(t.toString()),
                      loading: (t) => const LoadingFeaturePost(),
                    ),
                  );
                } else {
                  return Container(
                    color: Theme.of(context).cardColor,
                    child: CategoryTabView(
                      arguments: CategoryPostsArguments(
                        categoryId: _feturedCategories[index].id,
                        isHome: true,
                      ),
                      key: ValueKey(_feturedCategories[index].slug),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
