import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/wp_config.dart';
import '../../core/components/app_logo.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/sizedbox_const.dart';
import '../../core/controllers/config/config_controllers.dart';
import '../../core/repositories/others/onboarding_local.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/ui_util.dart';
import '../entrypoint/entrypoint.dart';
import '../settings/dialogs/change_language.dart';
import 'components/dont_have_account_button.dart';
import 'components/sign_in_with_apple_button.dart';
import 'components/sign_in_with_google_button.dart';
import 'dialogs/consent_sheet.dart';

class LoginIntroPage extends ConsumerWidget {
  const LoginIntroPage({super.key});

  checkIfConsent(BuildContext context, WidgetRef ref) {
    final showConsent =
        ref.watch(configProvider).value?.showCookieConsent ?? false;
    if (!showConsent) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final isDone = OnboardingRepository().isConsentDone();
      if (!isDone) {
        UiUtil.openBottomSheet(
            context: context, widget: const CookieConsentSheet());
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    checkIfConsent(context, ref);
    final isSocialLogin =
        ref.watch(configProvider).value?.isSocialLoginEnabled ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: Column(
            children: [
              /// Header
              const LoginIntroHeader(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: Column(
                  children: [
                    Responsive(
                      mobile: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: const AppLogo(),
                      ),
                      tablet: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const AppLogo(),
                      ),
                    ),
                    AppSizedBox.h16,
                    AppSizedBox.h16,
                    Text(
                      '${'welcome_newspro'.tr()} ${WPConfig.appName}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Responsive(
                      mobile: Padding(
                        padding: const EdgeInsets.all(16),
                        child: AutoSizeText(
                          'welcome_message'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      tablet: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AutoSizeText(
                            'welcome_message'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (isSocialLogin) const AppSignInWithAppleButton(),
              if (isSocialLogin) const SignInWithGoogleButton(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDefaults.margin),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text('sign_in_continue'.tr()),
                  ),
                ),
              ),
              const DontHaveAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginIntroHeader extends StatelessWidget {
  const LoginIntroHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Change Locale Button
        IconButton(
          onPressed: () {
            UiUtil.openBottomSheet(
                context: context, widget: const ChangeLanguageDialog());
          },
          icon: const Icon(Icons.language_rounded),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const EntryPointUI()),
              (v) => false,
            );
          },
          child: Text('skip'.tr()),
        ),
      ],
    );
  }
}
