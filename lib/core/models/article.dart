import 'dart:convert';

import 'package:flutter/foundation.dart';

class ArticleModel {
  int id;
  String title;
  String content;
  String link;
  String? featuredImage;
  String heroTag;
  List<int> categories;
  List<int> tags;
  DateTime date;
  bool commentStatus;
  int authorID;
  String? thumbnail;
  int totalComments;
  String? featuredVideo;
  List<String> extraImages;
  String? featuredYoutubeVideoUrl;
  String views;
  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    this.featuredImage,
    required this.heroTag,
    required this.categories,
    required this.tags,
    required this.date,
    required this.commentStatus,
    required this.authorID,
    this.thumbnail,
    required this.totalComments,
    this.featuredVideo,
    required this.extraImages,
    this.featuredYoutubeVideoUrl,
    required this.views,
  });

  ArticleModel copyWith({
    int? id,
    String? title,
    String? content,
    String? link,
    String? featuredImage,
    String? heroTag,
    List<int>? categories,
    List<int>? tags,
    DateTime? date,
    bool? commentStatus,
    int? authorID,
    String? thumbnail,
    int? totalComments,
    String? featuredVideo,
    String? featuredYoutubeVideoUrl,
    List<String>? extraImages,
    String? views,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      link: link ?? this.link,
      featuredImage: featuredImage ?? this.featuredImage,
      heroTag: heroTag ?? this.heroTag,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      commentStatus: commentStatus ?? this.commentStatus,
      authorID: authorID ?? this.authorID,
      thumbnail: thumbnail ?? this.thumbnail,
      totalComments: totalComments ?? this.totalComments,
      featuredVideo: featuredVideo ?? this.featuredVideo,
      featuredYoutubeVideoUrl:
          featuredYoutubeVideoUrl ?? this.featuredYoutubeVideoUrl,
      extraImages: extraImages ?? this.extraImages,
      views: views ?? this.views,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'link': link,
      'featuredImage': featuredImage,
      'heroTag': heroTag,
      'categories': categories,
      'tags': tags,
      'date': date.millisecondsSinceEpoch,
      'commentStatus': commentStatus,
      'authorID': authorID,
      'thumbnail': thumbnail,
      'totalComments': totalComments,
      'views': views,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title']['rendered'],
      content: map['content']['rendered'] ?? '',
      link: map['link'] ?? '',
      featuredImage: map['featured_image_url'],
      heroTag: map['slug'] ?? '',
      categories:
          map['categories'] != null ? List<int>.from(map['categories']) : [],
      tags: map['tags'] != null ? List<int>.from(map['tags']) : [],
      date: DateTime.parse("${map['date_gmt']}Z").toLocal(),
      commentStatus: map['comment_status'].toString() == 'open' ? true : false,
      authorID: map['author']?.toInt(),
      thumbnail: map['thumbnail'],
      totalComments: map['comment_count'] ?? 0,
      featuredVideo:
          map['featured_video'] == false ? null : map['featured_video'],
      featuredYoutubeVideoUrl: map['featured_youtube_video_url'] == ''
          ? null
          : map['featured_youtube_video_url'],
      extraImages: map['extra_images'] == false
          ? []
          : getLinksFromExtraImages(map['extra_images']),
      views: map['views'].toString(),
    );
  }

  static List<String> getLinksFromExtraImages(String text) {
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    List<String> results = [];
    for (var match in matches) {
      final singleUrl = text.substring(match.start, match.end);
      results.add(singleUrl);
    }
    return results;
  }

  static bool isVideoArticle(ArticleModel article) {
    return article.featuredVideo != null ||
        article.featuredYoutubeVideoUrl != null;
  }

  String toJson() => json.encode(toMap());

  factory ArticleModel.fromJson(String source) =>
      ArticleModel.fromMap(json.decode(source));

  @override
  bool operator ==(covariant ArticleModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        other.link == link &&
        other.featuredImage == featuredImage &&
        other.heroTag == heroTag &&
        listEquals(other.categories, categories) &&
        listEquals(other.tags, tags) &&
        other.date == date &&
        other.commentStatus == commentStatus &&
        other.authorID == authorID &&
        other.thumbnail == thumbnail &&
        other.totalComments == totalComments &&
        other.featuredVideo == featuredVideo &&
        listEquals(other.extraImages, extraImages) &&
        other.featuredYoutubeVideoUrl == featuredYoutubeVideoUrl &&
        other.views == views;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        link.hashCode ^
        featuredImage.hashCode ^
        heroTag.hashCode ^
        categories.hashCode ^
        tags.hashCode ^
        date.hashCode ^
        commentStatus.hashCode ^
        authorID.hashCode ^
        thumbnail.hashCode ^
        totalComments.hashCode ^
        featuredVideo.hashCode ^
        extraImages.hashCode ^
        featuredYoutubeVideoUrl.hashCode ^
        views.hashCode;
  }
}
