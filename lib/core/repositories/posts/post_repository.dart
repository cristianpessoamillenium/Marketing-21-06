import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/wp_config.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../models/article.dart';
import '../../utils/app_utils.dart';

final postRepoProvider = Provider<PostRepository>((ref) {
  final dio = ref.read(dioProvider);
  final repo = PostRepository(dio);
  return repo;
});

abstract class PostRepoAbstract {
  /// Get All Posts [Paginated]
  Future<List<ArticleModel>> getAllPost({
    required int pageNumber,
    int perPage = 10,
  });

  /// Get Post By Category
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
    int perPage = 10,
  });

  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
    int perPage = 10,
  });

  Future<List<ArticleModel>> getPostByAuthor({
    required int pageNumber,
    required int authorID,
    int perPage = 10,
  });

  /// Get Post
  Future<ArticleModel?> getPost({required int postID});

  /// Get Popular Posts
  ///
  /// [isPlugin] This is because sometimes the popular post plugin returns an empty
  /// array or you wanna just add a feature post by yourself, which
  /// in this case this is required
  Future<List<ArticleModel>> getPopularPosts({int perPage = 10});

  /// Get these posts
  Future<List<ArticleModel>> getThesePosts({required List<int> ids});

  /// Search Posts
  Future<List<ArticleModel>> searchPost({required String keyword});

  /// Get Post From Slug
  Future<ArticleModel?> getPostFromUrl({required String requestedURL});

  /// Get Post by Slug
  Future<List<ArticleModel>> getPostsBySlug({required String slug});

  /// Report a post
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
    required String reportEmail,
  });
}

/// [PostRepository] that is responsible for posts getting
/// It is an implementation from the above abstract class
class PostRepository extends PostRepoAbstract {
  PostRepository(
    this.dio,
  );

  final Dio dio;

  final String baseUrl = 'https://${WPConfig.url}/wp-json/wp/v2/posts';

  /* <---- Get All Posts -----> */
  @override
  Future<List<ArticleModel>> getAllPost({
    required int pageNumber,
    int perPage = 10,
  }) async {
    String url = '$baseUrl?page=$pageNumber&per_page=$perPage';
    List<ArticleModel> articles = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  /* <---- Get Post By Category -----> */
  @override
  Future<List<ArticleModel>> getPostByCategory({
    required int pageNumber,
    required int categoryID,
    int perPage = 10,
  }) async {
    String url =
        '$baseUrl?categories=$categoryID&page=$pageNumber&per_page=$perPage';
    List<ArticleModel> articles = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<List<ArticleModel>> getPostByTag({
    required int pageNumber,
    required int tagID,
    int perPage = 10,
  }) async {
    String url = '$baseUrl?tags=$tagID&page=$pageNumber&per_page=$perPage';
    List<ArticleModel> articles = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  /// Get post by Author
  @override
  Future<List<ArticleModel>> getPostByAuthor({
    required int pageNumber,
    required int authorID,
    int perPage = 10,
  }) async {
    String url =
        '$baseUrl?page=$pageNumber&author=$authorID&status=publish&per_page=$perPage';
    debugPrint('Url: $url');
    List<ArticleModel> articles = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response code is ${response.statusCode}');
      }
      return articles;
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return articles;
    }
  }

  @override
  Future<List<ArticleModel>> getThesePosts({
    required List<int> ids,
    int page = 1,
  }) async {
    final posts = ids.join(',');
    String url = '$baseUrl?include=$posts&page=$page&orderby=include';
    List<ArticleModel> articles = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map((e) => ArticleModel.fromMap(e)).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response code is ${response.statusCode}');
        debugPrint('Page number is $page');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return articles;
    }
  }

  /* <---- Get Popular Posts -----> */
  @override
  Future<List<ArticleModel>> getPopularPosts({
    int featureCategory = 1,
    int perPage = 10,
  }) async {
    List<ArticleModel> articles = [];
    String url =
        'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts?limit=$perPage';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        if (articles.isEmpty) articles = await getAllPost(pageNumber: 1);
        return articles;
      } else if (response.statusCode == 404) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        if (articles.isEmpty) articles = await getAllPost(pageNumber: 1);
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        if (articles.isEmpty) articles = await getAllPost(pageNumber: 1);
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } on Exception catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
    }
    return articles;
  }

  static Future<bool> addViewsToPost({required int postID}) async {
    final url =
        'https://${WPConfig.url}/wp-json/wordpress-popular-posts/v1/popular-posts?wpp_id=$postID';

    try {
      final response = await Dio().post(url);
      if (response.statusCode == 201) {
        // debugPrint('Post Views has been added $postID');
        return true;
      } else {
        debugPrint(response.data);
        return false;
      }
    } on Exception catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return false;
    }
  }

  /* <---- Get a Post -----> */
  @override
  Future<ArticleModel?> getPost({required int postID}) async {
    String url = '$baseUrl/$postID';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return ArticleModel.fromMap(response.data);
      } else {
        return null;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<ArticleModel?> getPostbyID({required int postID}) async {
    const String mainUrl = 'https://${WPConfig.url}/wp-json/wp/v2/posts';
    String url = '$mainUrl/$postID';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        return ArticleModel.fromMap(response.data);
      } else {
        return null;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
    }
    return null;
  }

  /* <---- Search a post -----> */
  @override
  Future<List<ArticleModel>> searchPost({required String keyword}) async {
    String url = '$baseUrl?search=$keyword';
    List<ArticleModel> articles = [];

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<ArticleModel?> getPostFromUrl({required String requestedURL}) async {
    final theUrl = Uri.parse(requestedURL);
    final host = theUrl.host;
    // String stripVersion = theUrl.path.replaceAll(RegExp(r'[^\w\s]+'), ' ');
    // debugPrint('Stripped Version: ${stripVersion.trim()}');
    String postParameter = theUrl.path;
    int postID = int.tryParse(theUrl.pathSegments[1]) ?? 0;

    if (host == WPConfig.url) {
      ArticleModel? article;
      if (WPConfig.usingPlainFormatLink) {
        final articles = await getPostsBySlug(
          slug: postParameter,
        );
        article = articles.isNotEmpty ? articles.first : null;
      } else {
        article = await getPost(postID: postID);
        debugPrint('Getting post with $postID');
      }
      return article;
    } else {
      debugPrint('This is not our app content');
    }
    return null;
  }

  @override
  Future<List<ArticleModel>> getPostsBySlug({
    required String slug,
  }) async {
    String url = 'https://${WPConfig.url}/wp-json/wp/v2/posts?slug=$slug';

    List<ArticleModel> articles = [];

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else if (response.statusCode == 304) {
        final posts = response.data as List;
        articles = posts.map(((e) => ArticleModel.fromMap(e))).toList();
        return articles;
      } else {
        debugPrint('Response Status code: ${response.statusCode}');
        return articles;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<bool> reportPost({
    required int postID,
    required String postTitle,
    required String userEmail,
    required String userName,
    required String reportEmail,
  }) async {
    final mail = '''Hello Admin, Hoping you are having a wonderful day.

I noticed that this post contains some inappropriate content that goes against certain policy of this app, please review this as soon as possible.

Post title: "$postTitle",
Post id: $postID,

Thanks & Regards.
$userName,
From: $userEmail''';

    try {
      await AppUtil.sendEmail(
        email: reportEmail,
        content: mail,
        subject: 'Reporting Post $postID',
      );
      return true;
    } on Exception catch (e) {
      // debugPrint(e.toString());
      debugPrint(e.toString());
      return false;
    }
  }
}
