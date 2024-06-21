import 'package:flutter/material.dart';

import '../../../core/components/app_shimmer.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/responsive.dart';

class LoadingCategories extends StatelessWidget {
  const LoadingCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return AppShimmer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding / 2,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: AppDefaults.borderRadius,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          itemCount: 5,
        ),
      ),
      tablet: Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: AppDefaults.margin,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return AppShimmer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                  vertical: AppDefaults.padding / 2,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: AppDefaults.borderRadius,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
