import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification_model.dart';
import 'notification_handler.dart';

/// For saving and manipulating the notifications that are saved on the device
final localNotificationProvider = StateNotifierProvider.autoDispose<
    LocalNotificationNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return LocalNotificationNotifier();
});

/// For saving and manipulating the notifications that are saved on the device
class LocalNotificationNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  LocalNotificationNotifier() : super(const AsyncData([])) {
    {
      getAllSavedNotification();
    }
  }

  /// Get All Saved Notification
  Future<List<NotificationModel>> getAllSavedNotification() async {
    state = const AsyncLoading();
    List<NotificationModel> savedNotification =
        await NotificationHandler.getNotifications();
    if (mounted) state = AsyncData(savedNotification);
    return savedNotification;
  }

  /// Delete A Notifications
  Future<void> deleteNotification(NotificationModel target) async {
    await NotificationHandler.deleteNotification(target.postId);
    final updatedList = state.value?.where((e) => e != target).toList();
    state = AsyncData(updatedList!);
  }

  /// Delete All Notifications
  Future<void> clearAllNotifications() async {
    await NotificationHandler.clearAllNotifications();
    state = const AsyncData([]);
  }
}
