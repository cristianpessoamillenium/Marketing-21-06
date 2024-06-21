import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/components/select_theme_mode.dart';
import '../../../core/constants/constants.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/controllers/notifications/notification_toggle.dart';
import '../../../core/utils/ui_util.dart';
import '../dialogs/change_language.dart';
import 'setting_list_tile.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: Text(
            'general_settings'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const NotificationTileRow(),
        const _LanguageSettings(),
        SelectThemeMode(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
    );
  }
}

class _LanguageSettings extends ConsumerWidget {
  const _LanguageSettings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiLanguage =
        ref.watch(configProvider).value?.multiLanguageEnabled ?? false;

    if (multiLanguage) {
      return SettingTile(
        label: 'language',
        icon: Icons.language_rounded,
        iconColor: Colors.purple,
        trailing: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(IconlyLight.arrowRight2),
        ),
        onTap: () async {
          await UiUtil.openBottomSheet(
            context: context,
            widget: const ChangeLanguageDialog(),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}

class NotificationTileRow extends ConsumerWidget {
  const NotificationTileRow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationNotifier = ref.read(notificationStateProvider.notifier);
    final notificationState = ref.watch(notificationStateProvider);

    return SettingTile(
      label: 'notification',
      icon: IconlyLight.notification,
      iconColor: Colors.green,
      trailing: CupertinoSwitch(
        value: notificationState == NotificationState.on,
        onChanged: (v) async {
          if (notificationState == NotificationState.loading) {
            debugPrint('Carregando agora...');
          } else if (v) {
            await notificationNotifier.turnOnNotifications();
          } else {
            await notificationNotifier.turnOffNotifications();
          }
        },
        activeColor: AppColors.primary,
      ),
    );
  }
}
