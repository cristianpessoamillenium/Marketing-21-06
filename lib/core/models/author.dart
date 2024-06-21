import 'dart:convert';

class AuthorData {
  String name;
  String avatarUrl;
  String avatarUrlHD;
  int userID;
  String description;
  String url;
  List<String> savedArticles;
  AuthorData({
    required this.name,
    required this.avatarUrl,
    required this.userID,
    required this.description,
    required this.url,
    required this.avatarUrlHD,
    required this.savedArticles,
  });

  factory AuthorData.fromMap(Map<String, dynamic> map) {
    return AuthorData(
      name: map['name'] ?? '',
      avatarUrl: map['avatar_urls']['24'] ?? '',
      avatarUrlHD: map['avatar_urls']['96'] ?? '',
      userID: map['id']?.toInt() ?? 0,
      description: map['description'],
      url: map['url'],
      savedArticles: map['saved_articles'] != null
          ? List<String>.from(map['saved_articles'])
          : [],
    );
  }

  factory AuthorData.fromJson(String source) =>
      AuthorData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthorData(name: $name, avatarUrl: $avatarUrl, avatarUrlHD: $avatarUrlHD, userID: $userID, description: $description, url: $url, savedArticles: $savedArticles)';
  }
}
