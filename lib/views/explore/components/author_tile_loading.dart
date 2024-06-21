import 'package:flutter/material.dart';

import '../../../core/components/app_shimmer.dart';
import '../../../core/constants/constants.dart';

class LoadingAuthorTile extends StatelessWidget {
  const LoadingAuthorTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _Avatar();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).cardColor, width: 1),
          boxShadow: AppDefaults.boxShadow,
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const ClipOval(child: SizedBox()),
      ),
    );
  }
}
