import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/components/animated_page_switcher.dart';
import '../../../core/components/headline_with_row.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/posts/search_post_controller.dart';
import '../../../core/repositories/others/search_local.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/utils/responsive.dart';

class SearchHistoryList extends ConsumerWidget {
  const SearchHistoryList({
    super.key,
    required this.animatedListKey,
    required this.onTap,
  });

  final GlobalKey<AnimatedListState> animatedListKey;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(searchHistoryController);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadlineRow(headline: 'recent_search', isHeader: false),
              AppSizedBox.h10,
              // Recent Searches
              TransitionWidget(
                child: history.map(
                  data: (data) => data.value.isNotEmpty
                      ? AnimatedList(
                          key: animatedListKey,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index, animation) {
                            final current = data.value[index];
                            return SearchTile(
                              current: current,
                              animation: animation,
                              key: ValueKey(current.query),
                              onTap: () => onTap(current.query),
                              onDelete: () {
                                ref
                                    .read(searchHistoryController.notifier)
                                    .deleteEntry(current);

                                final currentItem = data.value[index];
                                animatedListKey.currentState?.removeItem(
                                  index,
                                  (context, animation) => SearchTile(
                                    current: currentItem,
                                    onDelete: () {},
                                    animation: animation,
                                    onTap: () {},
                                  ),
                                );
                              },
                            );
                          },
                          initialItemCount: data.value.length,
                        )
                      : const SearchHistoryEmpty(),
                  error: (t) => const Text('Erro ao buscar dados'),
                  loading: (t) => const CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SearchHistoryEmpty extends StatelessWidget {
  const SearchHistoryEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Responsive(
            mobile: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: SvgPicture.asset(
                  AppImages.illustrationSearch,
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            tablet: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: SizedBox(
                    height: 350,
                    width: 350,
                    child: SvgPicture.asset(AppImages.illustrationSearch)),
              ),
            ),
          ),
          AppSizedBox.h16,
          Text(
            'Sem historico',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSizedBox.h16,
          Text(
            'Suas pesquisas\napareceram aqui',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
    required SearchModel current,
    required this.onDelete,
    required this.animation,
    required this.onTap,
  }) : _current = current;

  final SearchModel _current;
  final void Function() onDelete;
  final Animation<double> animation;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          onTap: onTap,
          leading: const Icon(IconlyLight.timeSquare, size: 36),
          title: Text(
            _current.query,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(AppUtil.getTime(_current.time, context)),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(IconlyLight.closeSquare),
          ),
        ),
      ),
    );
  }
}
