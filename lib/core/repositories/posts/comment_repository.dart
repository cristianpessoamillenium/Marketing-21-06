import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/wp_config.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../models/comment.dart';
import '../../utils/app_utils.dart';

abstract class CommentRepoAbstract {
  /// Create a Comment to the post
  Future<bool> createComment({
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  });

  /// Get All Comments of Specifiied post
  Future<List<CommentModel>> getComments({
    required int postId,
    required int page,
  });

  Future<bool> replyToComment({
    required int parentCommentID,
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  });

  Future<bool> reportComment({
    required int commentID,
    required String commentbody,
    required String userEmail,
    required String userName,
    required String reportEmail,
  });
}

final commentRepoProvider = Provider<CommentRepository>((ref) {
  final dio = ref.read(dioProvider);
  return CommentRepository(dio: dio);
});

class CommentRepository extends CommentRepoAbstract {
  final Dio dio;
  CommentRepository({
    required this.dio,
  });

  final baseUrl = 'https://${WPConfig.url}/wp-json/wp/v2/comments';

  @override
  Future<bool> createComment({
    required String email,
    required String name,
    required String content,
    required int postID,
    required String token,
  }) async {
    String url =
        '$baseUrl/?post=$postID&author_email=$email&author_name=$name&content=$content';

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'comment_submitted'.tr(),
        );
        return true;
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Too many comments');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Something gone wrong');
        return false;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<List<CommentModel>> getComments({
    required int postId,
    required int page,
    int perPage = 3,
  }) async {
    String url = '$baseUrl?post=$postId&page=$page&per_page=$perPage';
    List<CommentModel> fetchedComments = [];
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final allComments = response.data as List;
        fetchedComments =
            allComments.map((e) => CommentModel.fromMap(e)).toList();
        return fetchedComments;
      } else {
        return fetchedComments;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error while getting comments');
      return fetchedComments;
    }
  }

  @override
  Future<bool> replyToComment(
      {required int parentCommentID,
      required String email,
      required String name,
      required String content,
      required int postID,
      required String token}) async {
    String url =
        '$baseUrl/?post=$postID&author_email=$email&author_name=$name&content=$content&parent=$parentCommentID';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'comment_submitted'.tr(),
        );
        return true;
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(msg: 'Duplicate Comment');
        return false;
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Too many comments');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Something gone wrong');
        return false;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> reportComment({
    required int commentID,
    required String commentbody,
    required String userEmail,
    required String userName,
    required String reportEmail,
  }) async {
    final mail = '''Hello Admin, Hoping you are having a wonderful day.

I noticed that this comment contains some inappropriate content that goes against certain policy of this app, please review this as soon as possible.

Comment content: "$commentbody",
Comment Id: $commentID,

Thanks & Regards.
$userName,
From: $userEmail''';

    try {
      await AppUtil.sendEmail(
        email: reportEmail,
        content: mail,
        subject: 'Reporting Comment $commentID',
      );
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
