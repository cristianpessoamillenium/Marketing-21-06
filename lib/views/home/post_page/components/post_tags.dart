import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ads/ad_state_provider.dart';
import '../../../../core/components/animated_page_switcher.dart';
import '../../../../core/components/app_shimmer.dart';
import '../../../../core/constants/app_defaults.dart';
import '../../../../core/controllers/tags/tags_controller.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';

class ArticleTags extends ConsumerWidget {
  const ArticleTags({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider(article.tags));
    return TransitionWidget(
      child: tags.map(
        data: (data) {
          return Wrap(
            spacing: AppDefaults.padding / 2,
            children: List.generate(
              data.value.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tag,
                    arguments: data.value[index],
                  );
                  ref.read(loadInterstitalAd)?.call();
                },
                borderRadius: AppDefaults.borderRadius,
                child: Chip(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  label: Text(
                    '#${data.value[index].name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          );
        },
        error: (e) => Text(e.toString()),
        loading: (e) => const _LoadingTags(),
      ),
    );
  }
}

class _LoadingTags extends StatelessWidget {
  const _LoadingTags();

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: AppDefaults.padding, children: [
      ...List.generate(
        2,
        (index) => const AppShimmer(
          child: Chip(
            label: Text('Loading..'),
          ),
        ),
      ),
      ...List.generate(
        3,
        (index) => const AppShimmer(
          child: Chip(
            label: Text('Loading.. gej;k'),
          ),
        ),
      ),
    ]);
  }
}
