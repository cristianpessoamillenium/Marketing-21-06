import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../config/wp_config.dart';
import '../../controllers/dio/dio_provider.dart';
import '../../models/member.dart';
import '../../utils/extensions.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepository(dio);
});

abstract class AuthRepoAbstract {
  /// Login User
  Future<Member?> login({required String email, required String password});

  /// Logout User
  Future<void> logout();

  /// Signup User
  Future<bool> signUp({
    required String userName,
    required String email,
    required String password,
  });

  /// Send OTP for password reset link
  Future<bool> sendPasswordResetLink(String email);

  /// Is User Logged In
  Future<bool> isLoggedIn();

  /// Saves Token to Secure Storage
  Future<bool> saveToken({required String token});

  /// Deletes token from secure Storage
  Future<bool> deleteToken();

  /// Retrieve Token from Secure Storage
  Future<String?> getToken();

  /// Validate Token from Server
  Future<bool> vallidateToken({required String token});

  /// Get Saved user on device
  Future<Member?> getUser();

  /// Delete Saved user on device;
  Future<void> deleteUserData();

  /// Save User Data on device
  Future<void> saveUserData(Member data);

  /// Google Social Login
  Future<Member?> googleSignIn();

  /// Apple Social Login
  Future<Member?> appleSignIn();
}

/// Responsible for Communicating with server get
/// data about authentication
class AuthRepository extends AuthRepoAbstract {
  final Dio dio;
  AuthRepository(this.dio);

  /// Used for fetching, deleting, updating, it can be anything in String
  /// Don't modify it unless necessary
  final String _tokenKey = '_thePro322';
  static const _iOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  static const _aOptions = AndroidOptions(encryptedSharedPreferences: true);

  @override
  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(
      key: _tokenKey,
      iOptions: _iOptions,
      aOptions: _aOptions,
    );
    return value;
  }

  @override
  Future<bool> saveToken({required String token}) async {
    const storage = FlutterSecureStorage();

    try {
      await storage.write(
        key: _tokenKey,
        value: token,
        iOptions: _iOptions,
        aOptions: _aOptions,
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> deleteToken() async {
    const storage = FlutterSecureStorage();
    try {
      await storage.delete(
        key: _tokenKey,
        iOptions: _iOptions,
        aOptions: _aOptions,
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> vallidateToken({required String token}) async {
    String url = 'https://${WPConfig.url}/wp-json/jwt-auth/v1/token/validate';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    bool loggedIn = false;

    if (token != null) {
      bool isValid = await vallidateToken(token: token);
      if (isValid) loggedIn = true;
    }
    return loggedIn;
  }

  @override
  Future<Member?> login({
    required String email,
    required String password,
  }) async {
    String url = 'https://${WPConfig.url}/wp-json/jwt-auth/v1/token';

    try {
      final response = await dio.post(
        url,
        data: {
          'username': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final decodeResponse = response.data;
        await saveToken(token: decodeResponse['token']);
        final user = Member.fromServer(decodeResponse);
        await saveUserData(user);
        return user;
      } else {
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await deleteToken();
      deleteUserData();
    } on Exception catch (_) {}
  }

  @override
  Future<bool> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    String url = 'https://${WPConfig.url}/wp-json/newspro/v2/users/register/';

    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(
          {'username': userName, 'email': email, 'password': password},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: 'Email/Username already exists');
        return false;
      } else {
        return false;
      }
    } on Exception catch (_) {
      Fluttertoast.showToast(msg: 'Oops! Something gone wrong');
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetLink(String email) async {
    String url =
        'https://${WPConfig.url}/wp-json/newspro/v2/users/forgot-password';

    debugPrint('Send Password $url');

    final response = await dio.post(url, data: {
      'email': email,
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: 'No Users Exist with this email');
      return false;
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: 'You must provide an email address');
      return false;
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(msg: 'You must provide an valid email address');
      return false;
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: 'Something gone wrong');
      return false;
    } else {
      debugPrint(e.toString());
      return false;
    }
  }

  /* <----  -----> */ /* <----  -----> */
  /* <-----------------------> 
      USER DATA SAVING [Local]     
  <-----------------------> */

  final String _userBoxKey = 'user';
  final String _userKey = '_jiie';

  @override
  Future<Member?> getUser() async {
    var box = Hive.box(_userBoxKey);
    final Map? data = box.get(_userKey);
    if (data != null) {
      final theUser = Member.fromLocal(Map.from(data));
      return theUser;
    } else {
      return null;
    }
  }

  @override
  Future<void> saveUserData(Member data) async {
    var box = Hive.box(_userBoxKey);
    await box.put(_userKey, data.toMap());
  }

  @override
  Future<void> deleteUserData() async {
    var box = Hive.box(_userBoxKey);
    await box.delete(_userKey);
  }

  /// Initializes Users Databases
  Future<void> init() async {
    await Hive.openBox(_userBoxKey);
  }

  @override
  Future<Member?> googleSignIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null && !user.isAnonymous) {
        // final token = await user.getIdToken();
        String firstName = '';
        String lastName = '';

        if (user.displayName.validate().split(' ').isNotEmpty) {
          firstName = user.displayName.splitBefore(' ');
        }
        if (user.displayName.validate().split(' ').length >= 2) {
          lastName = user.displayName.splitAfter(' ');
        }

        Map req = {
          'email': user.email,
          'firstName': firstName,
          'lastName': lastName,
          'photoURL': user.photoURL,
          'accessToken': googleSignInAuthentication.accessToken,
          'loginType': 'google',
        };
        await googleSignIn.signOut();

        const url = 'https://${WPConfig.url}/wp-json/newspro/v2/users/social';

        try {
          final response = await dio.post(url, data: req);
          debugPrint(response.data.toString());
          if (response.statusCode == 200) {
            final decodeResponse = response.data;
            await saveToken(token: decodeResponse['token']);
            final user = Member.fromServer(decodeResponse);
            await saveUserData(user);
            return user;
          } else {
            return null;
          }
        } catch (e) {
          debugPrint(e.toString());
          return null;
        }
      } else {
        debugPrint('User is null & user is anonymous');
        return null;
      }
    } else {
      debugPrint('Google user is null');
      return null;
    }
  }

  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<Member?> appleSignIn() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      var req = {
        'email': credential.email,
        'firstName': credential.givenName,
        'lastName': credential.familyName,
        'photoURL': '',
        'accessToken': credential.identityToken,
        'loginType': 'apple',
      };
      debugPrint('Credintials ${req.toString()}');

      const url = 'https://${WPConfig.url}/wp-json/newspro/v2/users/social';

      try {
        final response = await dio.post(url, data: req);
        debugPrint(response.data.toString());
        if (response.statusCode == 200) {
          final decodeResponse = response.data;
          await saveToken(token: decodeResponse['token']);
          final user = Member.fromServer(decodeResponse);
          await saveUserData(user);
          return user;
        } else {
          return null;
        }
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
