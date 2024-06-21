import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../constants/constants.dart';
import 'app_shimmer.dart';

class DummyArticleTile extends StatelessWidget {
  const DummyArticleTile({
    super.key,
    this.isEnabled = true,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDefaults.margin / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: AppDefaults.boxShadow,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              AppDefaults.borderRadius.resolve(Directionality.of(context)),
        ),
        child: Row(
          children: [
            // thumbnail
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(AppDefaults.radius),
                  bottomStart: Radius.circular(AppDefaults.radius),
                ).resolve(Directionality.of(context)),
                clipBehavior: Clip.hardEdge,
                child: AppShimmer(
                  enabled: isEnabled,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Description
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer(
                      enabled: isEnabled,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppDefaults.borderRadius,
                        ),
                        child: Text(
                          'A Very Simple Title and Effective one with',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    AppSizedBox.h5,
                    /* <---- Category List -----> */
                    SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          3,
                          (index) => AppShimmer(
                            enabled: isEnabled,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: AppDefaults.borderRadius,
                              ),
                              child: const Text('Level'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppSizedBox.h5,
                    Row(
                      children: [
                        AppShimmer(
                          enabled: isEnabled,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppDefaults.borderRadius,
                            ),
                            child: const Icon(
                              IconlyLight.timeCircle,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                          ),
                        ),
                        AppSizedBox.w10,
                        AppShimmer(
                          enabled: isEnabled,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppDefaults.borderRadius,
                            ),
                            child: Text(
                              '0 Minute Read',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSizedBox.h10,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppShimmer(
                          enabled: isEnabled,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppDefaults.borderRadius,
                            ),
                            child: const Icon(
                              IconlyLight.calendar,
                              color: AppColors.placeholder,
                              size: 18,
                            ),
                          ),
                        ),
                        AppSizedBox.w10,
                        AppShimmer(
                          enabled: isEnabled,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppDefaults.borderRadius,
                            ),
                            child: Text(
                              '24 February',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
