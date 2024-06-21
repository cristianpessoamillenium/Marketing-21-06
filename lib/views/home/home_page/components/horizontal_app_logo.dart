import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/animated_page_switcher.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/theme_manager.dart';

class HorizontalAppLogo extends ConsumerWidget {
  const HorizontalAppLogo({
    super.key,
    required this.isElevated,
  });

  final bool isElevated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkMode(context));
    return TransitionWidget(
      child: isElevated
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                isDark
                    ? AppImages.horizontalLogoDark
                    : AppImages.horizontalLogo,
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
