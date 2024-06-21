import 'package:hive_flutter/adapters.dart';

class NotificationsRepository {
  /* <---- Notifications Settings -----> */
  final String _notificationSwitchBox = 'notificationSwitchBox';
  final String _toggle = 'notificationToggle';

  Future<bool> isNotificationOn() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    return await box.get(_toggle) ?? true;
  }

  /// Turn on notifications
  Future<void> turnOnNotifications() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    await box.put(_toggle, true);
  }

  /// Turn off notifications
  Future<void> turnOffNotifications() async {
    var box = await Hive.openLazyBox(_notificationSwitchBox);
    await box.put(_toggle, false);
  }
}
