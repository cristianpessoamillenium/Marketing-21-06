import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';

class SignInWithGoogleButton extends ConsumerWidget {
  const SignInWithGoogleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authController.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.margin,
        vertical: AppDefaults.margin,
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () async {
            context.loaderOverlay.show();
            await auth.signInWithGoogle(context);
            context.loaderOverlay.hide();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.placeholder.withOpacity(0.3)),
          ),
          label: Text(
            'sign_in_with_google'.tr(),
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          icon: SvgPicture.asset(
            'assets/svgs/google_logo.svg',
            height: 18,
          ),
        ),
      ),
    );
  }
}
