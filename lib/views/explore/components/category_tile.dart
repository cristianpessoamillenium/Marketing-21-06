import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/app_images_config.dart';
import '../../../core/components/app_shimmer.dart';
import '../../../core/constants/constants.dart';
import '../../../core/models/category.dart';
import '../../../core/utils/app_utils.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.categoryModel,
    this.backgroundImage,
    required this.onTap,
  });

  final CategoryModel categoryModel;
  final String? backgroundImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDefaults.margin / 2,
        horizontal: AppDefaults.margin,
      ),
      child: ClipRRect(
        borderRadius: AppDefaults.borderRadius,
        child: CachedNetworkImage(
          imageUrl: backgroundImage ?? AppImagesConfig.defaultCategoryImage,
          imageBuilder: (context, imageProvider) => _CategoryImageWrapper(
            backgroundImage: imageProvider,
            onTap: onTap,
            categoryModel: categoryModel,
          ),
          placeholder: (context, url) => AppShimmer(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.16,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class _CategoryImageWrapper extends StatelessWidget {
  const _CategoryImageWrapper({
    required this.backgroundImage,
    required this.onTap,
    required this.categoryModel,
  });

  final ImageProvider backgroundImage;
  final void Function()? onTap;
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
        ),
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            padding: const EdgeInsets.all(AppDefaults.padding),
            height: MediaQuery.of(context).size.height * 0.16,
            width: double.maxFinite,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                AppUtil.trimHtml(categoryModel.name),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
