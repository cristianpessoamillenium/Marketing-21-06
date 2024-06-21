import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/components/app_shimmer.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';
import 'active_indicator_feature_post.dart';
import 'feature_post_article.dart';

class PostSliderTablet extends StatefulWidget {
  const PostSliderTablet({
    super.key,
    required this.articles,
    required this.isAutoSlide,
  });

  final List<ArticleModel> articles;
  final bool isAutoSlide;

  @override
  State<PostSliderTablet> createState() => _PostSliderTabletState();
}

class _PostSliderTabletState extends State<PostSliderTablet> {
  late PageController _controller;

  int _currentIndex = 1;

  _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == widget.articles.length - 1) _disableAutoSlide();
  }

  Timer? _timer;

  _autoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < widget.articles.length) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  _disableAutoSlide() {
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.5,
      initialPage: _currentIndex,
    );

    if (widget.isAutoSlide) _autoSlide();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: AnimationLimiter(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.articles.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: FadeInAnimation(
                    child: FeaturedPostArticle(
                      onTap: () {
                        final article = widget.articles[index];
                        Navigator.pushNamed(context, AppRoutes.post,
                            arguments: article);
                        _disableAutoSlide();
                      },
                      isActive: _currentIndex == index,
                      article: widget.articles[index],
                    ),
                  ),
                );
              },
              onPageChanged: _onPageChange,
            ),
          ),
        ),

        /// Active Indicators
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.articles.length,
              (index) => ActiveIndicatorRect(
                isActive: _currentIndex == index,
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}

/// Used for loading
class DummyPostSliderTablet extends StatefulWidget {
  const DummyPostSliderTablet({
    super.key,
    this.totalPages = 4,
  });

  final int totalPages;

  @override
  State<DummyPostSliderTablet> createState() => _DummyPostSliderTabletState();
}

class _DummyPostSliderTabletState extends State<DummyPostSliderTablet> {
  late PageController _controller;

  int _currentIndex = 1;

  _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.5,
      initialPage: _currentIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.totalPages,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: FadeInAnimation(
                  child: AppShimmer(
                    child: AnimatedContainer(
                      duration: AppDefaults.duration,
                      margin: EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding / 2,
                        vertical: index == _currentIndex ? 8.0 : 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: AppDefaults.borderRadius,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
            onPageChanged: _onPageChange,
          ),
        ),

        /// Active Indicators
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.totalPages,
              (index) => ActiveIndicatorRect(
                isActive: _currentIndex == index,
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}
