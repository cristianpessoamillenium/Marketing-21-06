import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/ads/ad_state_provider.dart';
import '../../../core/controllers/analytics/analytics_controller.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/models/article.dart';
import '../../../core/repositories/posts/post_repository.dart';
import 'components/normal_post.dart';
import 'components/video_post.dart';
import '../../../core/components/ad_widgets.dart'; // Importação do ad_widgets adicionada

class PostPage extends HookConsumerWidget {
  const PostPage({
    super.key,
    required this.article,
  });
  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(loadInterstitalAd)?.call();
    final isVideoPost = ArticleModel.isVideoArticle(article);
    AnalyticsController.logPostView(article);
    PostRepository.addViewsToPost(postID: article.id);

    Widget postContent;
    if (isVideoPost) {
      postContent = VideoPost(article: article);
    } else {
      postContent = NormalPost(article: article);
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: postContent),
          const BannerAdWidget(), // Adiciona o banner de anúncio aqui
        ],
      ),
    );
  }
}


