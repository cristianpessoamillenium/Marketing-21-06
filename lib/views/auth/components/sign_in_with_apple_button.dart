import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';

class AppSignInWithAppleButton extends ConsumerWidget {
  const AppSignInWithAppleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authController.notifier);
    if (Platform.isIOS) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.margin,
        ),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              context.loaderOverlay.show();
              await auth.signInWithApple(context);
              context.loaderOverlay.hide();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.placeholder.withOpacity(0.3)),
            ),
            label: Text(
              'sign_in_with_apple'.tr(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            icon: SvgPicture.asset(
              'assets/svgs/apple_logo.svg',
              height: 18,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
