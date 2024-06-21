import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../../../config/wp_config.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../models/author.dart';

final userRepoProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UserRepository(dio: dio);
});

class UserRepository {
  final Dio dio;
  UserRepository({
    required this.dio,
  });

  Future<AuthorData?> getUserNamebyID(int id) async {
    final url = 'https://${WPConfig.url}/wp-json/wp/v2/users/$id';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decodedData = response.data;
        final author = AuthorData.fromMap(decodedData);
        return author;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error happened while fetching author data');
      return null;
    }
    return null;
  }

  Future<AuthorData?> getMe(String token) async {
    final random = const Uuid().v4();
    final url =
        'https://${WPConfig.url}/wp-json/wp/v2/users/me?skip_cache=1&unused=$random';

    final headers = {
      'Authorization': 'Bearer $token',
      'Cache-Control': 'no-cache'
    };
    try {
      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        final decodedData = response.data;
        final author = AuthorData.fromMap(decodedData);
        return author;
      } else {
        debugPrint('Response code is ${response.statusCode}');
        debugPrint('Response body ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('User fetching error: $e');
      Fluttertoast.showToast(msg: 'Error while fetching user');
      return null;
    }
  }

  Future<AuthorData?> updateProfile(
    String token,
    Map<String, dynamic> data,
  ) async {
    final random = const Uuid().v4();
    final url =
        'https://${WPConfig.url}/wp-json/wp/v2/users/me?skip_cache=1&unused=$random';

    final headers = {
      'Authorization': 'Bearer $token',
      'Cache-Control': 'no-cache'
    };
    final body = jsonEncode(data);

    try {
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: body,
      );
      if (response.statusCode == 200) {
        final decodedData = response.data;
        final author = AuthorData.fromMap(decodedData);

        return author;
      } else {
        debugPrint('Response code is ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('User fetching error: $e');
      Fluttertoast.showToast(msg: 'Error while fetching user');
      return null;
    }
  }

  Future<void> deleteUsers(String token) async {
    const url = 'https://${WPConfig.url}/wp-json/newspro/v2/users/delete';
    try {
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        debugPrint('User deleted successfully');
        debugPrint(response.data.toString());
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint(response.data.toString());
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error happened while deleting user');
    }
  }

  Future<List<AuthorData>> getAllAuthor(int page) async {
    List<AuthorData> users = [];
    final url = 'https://${WPConfig.url}/wp-json/wp/v2/users/?page=$page';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = response.data as List;
        users = decodedResponse.map((e) => AuthorData.fromMap(e)).toList();
        // debugPrint(users.toString());
        return users;
      } else {
        debugPrint(response.statusMessage);
        return users;
      }
    } catch (e) {
      debugPrint(e.toString());
      return users;
    }
  }
}
