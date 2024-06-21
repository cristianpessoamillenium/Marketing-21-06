import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_pro/core/repositories/posts/post_repository.dart';
import 'package:news_pro/core/routes/app_routes.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../../config/wp_config.dart';
import '../../logger/app_logger.dart';
import '../../models/notification_model.dart';

class NotificationHandler {
  static Future<void> init(BuildContext context) async {
    await OneSignal.shared.setAppId(WPConfig.oneSignalId);

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) async {
      final notification =
          NotificationModel.fromOSnotification(event.notification);
      if (!(await isNotificationSaved(notification.postId))) {
        await saveNotification(notification);
      }
      handleNotificationClick(notification, context);
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      final data = result.notification.additionalData;
      if (data != null) {
        final notification =
            NotificationModel.fromOSnotification(result.notification);
        if (!(await isNotificationSaved(notification.postId))) {
          await saveNotification(notification);
        }
        handleNotificationClick(notification, context);
      }
    });
  }

  static Future<void> handleNotificationClick(
      NotificationModel notification, BuildContext context) async {
    if (notification.postId != 0) {
      final post =
          await PostRepository.getPostbyID(postID: notification.postId);
      if (post != null) {
        Navigator.pushNamed(context, AppRoutes.post, arguments: post);
      } else {
        Navigator.pushNamed(context, AppRoutes.notification);
      }
    } else {
      Navigator.pushNamed(context, AppRoutes.notification);
    }
  }

  static Future<void> saveNotification(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>('notifications');
    await box.add(notification);
    Log.info('Notification saved: ${notification.id}');
  }

  static Future<bool> isNotificationSaved(int notificationId) async {
    final box = Hive.box<NotificationModel>('notifications');
    final notifications = box.values;
    return notifications
        .any((notification) => notification.postId == notificationId);
  }

  static Future<List<NotificationModel>> getNotifications() async {
    final box = Hive.box<NotificationModel>('notifications');
    return box.values.toList();
  }

  static Future<void> deleteNotification(int notificationId) async {
    final box = Hive.box<NotificationModel>('notifications');
    final notifications = box.values;
    final notificationToDelete = notifications.firstWhere(
      (notification) => notification.postId == notificationId,
    );
    await notificationToDelete.delete();
    Log.info('Notification deleted: $notificationId');
  }

  static Future<void> clearAllNotifications() async {
    final box = Hive.box<NotificationModel>('notifications');
    await box.clear();
    Log.info('All notifications cleared');
  }

  static Future<void> disableNotifications() async {
    OneSignal.shared.disablePush(true);
  }

  static Future<void> enableNotifications() async {
    OneSignal.shared.disablePush(false);
  }
}
