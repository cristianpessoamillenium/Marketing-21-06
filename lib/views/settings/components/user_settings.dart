import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/controllers/config/config_controllers.dart';

import '../../../core/components/animated_page_switcher.dart';
import '../../../core/components/wp_ad_widget.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/auth/auth_state.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/ui_util.dart';
import '../dialogs/delete_user.dart';
import 'setting_list_tile.dart';

class UserSettings extends ConsumerWidget {
  const UserSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authController);
    final isLoginEnabled =
        ref.watch(configProvider).value?.isLoginEnabled ?? false;
    if (isLoginEnabled) {
      return TransitionWidget(child: handleAuthState(authProvider));
    } else {
      return const SizedBox();
    }
  }

  Widget handleAuthState(AuthState authProvider) {
    if (authProvider is AuthLoading) {
      return const _LoadingAuthentication();
    } else if (authProvider is AuthLoggedIn) {
      return _UserLoggedIn(authProvider: authProvider);
    } else {
      return const _UserLoggedOut();
    }
  }
}

class _LoadingAuthentication extends StatelessWidget {
  const _LoadingAuthentication();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'account_settings'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SettingTile(
          label: 'Carregando...',
          icon: IconlyLight.arrowUpCircle,
          iconColor: AppColors.primary,
          trailing: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

class _UserLoggedOut extends StatelessWidget {
  const _UserLoggedOut();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'account_settings'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingTile(
          label: 'login',
          icon: IconlyLight.logout,
          iconColor: AppColors.primary,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () => Navigator.pushNamed(context, AppRoutes.loginIntro),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: AppDefaults.padding),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: const WPADWidget(isBannerOnly: true),
        ),
      ],
    );
  }
}

class _UserLoggedIn extends ConsumerWidget {
  const _UserLoggedIn({
    required this.authProvider,
  });

  final AuthState authProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'account_settings'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SettingTile(
          label: authProvider.member?.name ?? 'Nenhum nome encontrado',
          icon: IconlyLight.profile,
          iconColor: Colors.blue,
          shouldTranslate: false,
        ),
        SettingTile(
          label: authProvider.member?.email ?? 'Nenhum email encontrado',
          icon: IconlyLight.message,
          iconColor: Colors.orangeAccent,
          shouldTranslate: false,
        ),
        SettingTile(
          label: 'delete_account',
          icon: IconlyLight.delete,
          iconColor: Colors.red,
          onTap: () {
            UiUtil.openDialog(
                context: context, widget: const DeleteUserDialog());
          },
        ),
        SettingTile(
          label: 'logout',
          icon: IconlyLight.logout,
          iconColor: Colors.redAccent,
          trailing: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(IconlyLight.arrowRight2),
          ),
          onTap: () {
            ref.read(authController.notifier).logout(context);
          },
        ),
      ],
    );
  }
}
