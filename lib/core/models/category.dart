import 'dart:convert';

import '../../config/app_images_config.dart';

class CategoryModel {
  int id;
  String name;
  String slug;
  String link;
  int parent;
  String thumbnail;
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.link,
    required this.parent,
    required this.thumbnail,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toInt(),
      name: map['name'],
      slug: map['slug'],
      link: map['link'],
      parent: map['parent'],
      thumbnail: map['thumbnail'] == null || map['thumbnail'] == false
          ? AppImagesConfig.defaultCategoryImage
          : map['thumbnail'],
    );
  }

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, slug: $slug, link: $link, parent: $parent, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.link == link &&
        other.parent == parent &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        slug.hashCode ^
        link.hashCode ^
        parent.hashCode ^
        thumbnail.hashCode;
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? link,
    int? parent,
    String? thumbnail,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      link: link ?? this.link,
      parent: parent ?? this.parent,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }
}
