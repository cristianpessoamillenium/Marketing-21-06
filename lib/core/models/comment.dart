import 'dart:convert';

import 'package:collection/collection.dart';

class CommentModel {
  int id;
  int postID;
  String authorName;
  String avatarURL;
  String content;
  DateTime time;
  int parentCommentID;
  List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.postID,
    required this.authorName,
    required this.avatarURL,
    required this.content,
    required this.time,
    required this.parentCommentID,
    required this.replies,
  });

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentModel(id: $id, postID: $postID, authorName: $authorName, avatarURL: $avatarURL, content: $content, time: $time, parentCommentID: $parentCommentID, replies: $replies)';
  }

  CommentModel copyWith({
    int? id,
    int? postID,
    String? authorName,
    String? avatarURL,
    String? content,
    DateTime? time,
    int? parentCommentID,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postID: postID ?? this.postID,
      authorName: authorName ?? this.authorName,
      avatarURL: avatarURL ?? this.avatarURL,
      content: content ?? this.content,
      time: time ?? this.time,
      parentCommentID: parentCommentID ?? this.parentCommentID,
      replies: replies ?? this.replies,
    );
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toInt(),
      postID: map['post']?.toInt(),
      authorName: map['author_name'],
      avatarURL: map['author_avatar_urls']['96'],
      content: map['content']['rendered'],
      parentCommentID: map['parent'] ?? 0,
      time: DateTime.parse(map['date_gmt']),
      replies: [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is CommentModel &&
        other.id == id &&
        other.postID == postID &&
        other.authorName == authorName &&
        other.avatarURL == avatarURL &&
        other.content == content &&
        other.time == time &&
        other.parentCommentID == parentCommentID &&
        listEquals(other.replies, replies);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        postID.hashCode ^
        authorName.hashCode ^
        avatarURL.hashCode ^
        content.hashCode ^
        time.hashCode ^
        parentCommentID.hashCode ^
        replies.hashCode;
  }
}
