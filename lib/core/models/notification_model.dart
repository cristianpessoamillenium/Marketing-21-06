// ignore_for_file: public_member_api_docs, sort_constructors_first
// notification_model.dart

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 0)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final int postId;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime recievedTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.postId,
    this.imageUrl,
    required this.recievedTime,
  });

  factory NotificationModel.fromOSnotification(OSNotification data) {
    final postID = data.additionalData?['post_id'] ?? 0;
    String? imageUrl = Platform.isIOS
        ? data.attachments != null
            ? data.attachments!['id']
            : null
        : data.bigPicture;

    return NotificationModel(
      id: data.notificationId,
      title: data.title ?? '',
      body: data.body ?? '',
      postId: postID,
      imageUrl: imageUrl,
      recievedTime: DateTime.now(),
    );
  }
}
