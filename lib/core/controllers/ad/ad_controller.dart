import 'package:flutter/material.dart';

import '../../components/ad_widgets.dart';
import '../../components/article_tile.dart';
import '../../components/article_tile_large.dart';
import '../../components/wp_ad_widget.dart';
import '../../models/article.dart';

class AdController {
  static List<Widget?> getAdWithPosts(
    List<ArticleModel> posts, {
    bool isMainPage = false,
    required bool isMobile,
    required bool isAdOn,
    required bool isCustomOn,
    required int adInterval,
    required int customAdInterval,
  }) {
    final data = posts;
    final int every = adInterval;
    final int everyWP = customAdInterval;

    final int size = data.length + data.length ~/ every;
    final List<Widget?> tempItems = List.generate(
      size,
      (i) {
        if (i != 0 && i % every == 0) {
          if (isAdOn) {
            return const NativeAdWidget();
          } else {
            return null;
          }
        } else if (i != 0 && i % everyWP == 0) {
          if (isCustomOn) {
            return const WPADWidget();
          } else {
            return null;
          }
        } else {
          if (isMobile) {
            if (i % 6 == 0 && i != 0) {
              return ArticleTileLarge(
                article: data[i - i ~/ every],
                isMainPage: isMainPage,
              );
            } else {
              return ArticleTile(
                article: data[i - i ~/ every],
                isMainPage: isMainPage,
              );
            }
          } else {
            return ArticleTile(
              article: data[i - i ~/ every],
              isMainPage: isMainPage,
            );
          }
        }
      },
    );
    final List<Widget> items =
        tempItems.where((item) => item != null).cast<Widget>().toList();
    return items;
  }
}
