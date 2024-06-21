import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/utils/ui_util.dart';
import 'view_image_full_screen.dart';

class PostGalleryRenderer extends StatefulWidget {
  const PostGalleryRenderer({
    super.key,
    required this.imagesUrl,
  });

  final List<String> imagesUrl;

  @override
  State<PostGalleryRenderer> createState() => _PostGalleryRendererState();
}

class _PostGalleryRendererState extends State<PostGalleryRenderer> {
  List<String> images = [];
  List<Image> imagesRaw = [];

  _viewImageFullScreen(String url) {
    UiUtil.openDialog(context: context, widget: ViewImageDialog(url: url));
  }

  @override
  void initState() {
    images.addAll(widget.imagesUrl);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: List.generate(
          images.length,
          (index) => InkWell(
            onTap: () => _viewImageFullScreen(images[index]),
            child: CachedNetworkImage(
              imageUrl: images[index],
            ),
          ),
        ),
      ),
    );
  }
}
