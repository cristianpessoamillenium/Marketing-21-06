import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../repositories/others/notification_local.dart';
import 'notification_handler.dart';

final notificationStateProvider =
    StateNotifierProvider<NotificationToggleNotifier, NotificationState>((ref) {
  return NotificationToggleNotifier();
});

enum NotificationState { loading, on, off }

class NotificationToggleNotifier extends StateNotifier<NotificationState> {
  NotificationToggleNotifier() : super(NotificationState.loading) {
    {
      init();
    }
  }

  final _repository = NotificationsRepository();

  Future<bool> init() async {
    bool isNotificaitonOn = await _repository.isNotificationOn();
    if (isNotificaitonOn) {
      state = NotificationState.on;
      return true;
    } else {
      state = NotificationState.off;
      return false;
    }
  }

  /// Turn on Notifications
  turnOnNotifications() async {
    await _repository.turnOnNotifications();
    await NotificationHandler.enableNotifications();
    state = NotificationState.on;
    Fluttertoast.showToast(msg: 'notification_on_message'.tr());
  }

  /// Turn off Notifications
  turnOffNotifications() async {
    await _repository.turnOffNotifications();
    await NotificationHandler.disableNotifications();
    state = NotificationState.off;
    Fluttertoast.showToast(msg: 'notification_off_message'.tr());
  }

  setToLoadingState() {
    state = NotificationState.loading;
  }
}
