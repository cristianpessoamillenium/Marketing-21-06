import 'package:flutter/material.dart';

import '../../../../core/components/app_loader.dart';
import '../../../../core/components/network_image.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/article.dart';
import '../../../../core/routes/app_routes.dart';

class PostImageRenderer extends StatelessWidget {
  const PostImageRenderer({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: article.extraImages.isEmpty && article.featuredImage == null
          ? 16 / 4
          : AppDefaults.aspectRatio,
      child: Hero(
        tag: article.heroTag,
        child: article.extraImages.isNotEmpty
            ? ExtraImagesHandler(article: article)
            : article.featuredImage != null
                ? Material(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.viewImageFullScreen,
                          arguments: article.featuredImage),
                      child: NetworkImageWithLoader(
                        article.featuredImage!,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.zero,
                        placeHolder: _PlaceHolderArticleImage(article: article),
                      ),
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}

class ExtraImagesHandler extends StatefulWidget {
  const ExtraImagesHandler({
    super.key,
    required this.article,
  });

  final ArticleModel article;

  @override
  State<ExtraImagesHandler> createState() => _ExtraImagesHandlerState();
}

class _ExtraImagesHandlerState extends State<ExtraImagesHandler> {
  List<String> images = [];

  late PageController controller;

  int _currentIndex = 0;
  _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _viewImageFullScreen(String url) {
    Navigator.pushNamed(
      context,
      AppRoutes.viewImageFullScreen,
      arguments: url,
    );
  }

  @override
  void initState() {
    controller = PageController();
    images.addAll(widget.article.extraImages);
    if (widget.article.featuredImage != null) {
      images.insert(0, widget.article.featuredImage!);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: controller,
            onPageChanged: _onPageChange,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _viewImageFullScreen(images[index]),
                child: NetworkImageWithLoader(
                  images[index],
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                  placeHolder: index == 0
                      ? _PlaceHolderArticleImage(article: widget.article)
                      : null,
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
                vertical: AppDefaults.padding / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: AppDefaults.borderRadius,
              ),
              child: Text(
                '${_currentIndex + 1} / ${images.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PlaceHolderArticleImage extends StatelessWidget {
  const _PlaceHolderArticleImage({
    required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (article.thumbnail != null)
          NetworkImageWithLoader(
            article.thumbnail!,
            borderRadius: BorderRadius.zero,
          ),
        const Center(
          child: AppLoader(size: 80),
        )
      ],
    );
  }
}
