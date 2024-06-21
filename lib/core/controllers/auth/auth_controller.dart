import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../logger/app_logger.dart';
import '../../models/member.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../routes/app_routes.dart';
import '../analytics/analytics_controller.dart';
import 'auth_state.dart';

final authController = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepo);
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository) : super(AuthLoading()) {
    {
      _init();
    }
  }

  final AuthRepository repository;

  _init() async {
    Member? theUser = await repository.getUser();
    if (theUser != null) {
      debugPrint('Got a user');
      debugPrint('The useremail is ${theUser.email}');
      final token = await repository.getToken();
      if (token != null) {
        debugPrint('Got a token');
        bool isValid = await repository.vallidateToken(token: token);
        if (isValid) {
          debugPrint('Token is valid');
          state = AuthLoggedIn(theUser);
          debugPrint('Settted State to Logged IN');
        } else {
          // Token is not valid
          debugPrint('Token is not valid');
          state = AuthGuestLoggedIn();
        }
      } else {
        // No token has been saved
        debugPrint('No token has been saved');
        state = AuthGuestLoggedIn();
      }
    } else {
      Log.info('No user found');
      state = AuthGuestLoggedIn();
    }
  }

  /// Login User
  Future<String?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final member = await repository.login(email: email, password: password);
    if (member != null) {
      state = AuthLoggedIn(member);
      if (mounted) Navigator.pushNamed(context, AppRoutes.loginAnimation);
      AnalyticsController.logUserLogin();
      return null;
    } else {
      return 'Invalid Credintials';
    }
  }

  /// Sign in With Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    final member = await repository.googleSignIn();
    if (member != null) {
      state = AuthLoggedIn(member);
      if (mounted) Navigator.pushNamed(context, AppRoutes.loginAnimation);
      AnalyticsController.logUserLogin();
      return true;
    } else {
      debugPrint('There\'s some error');
      Fluttertoast.showToast(msg: 'There\'s some issue with this account');
      return false;
    }
  }

  /// Sign in with apple
  Future<bool> signInWithApple(BuildContext context) async {
    final member = await repository.appleSignIn();
    if (member != null) {
      state = AuthLoggedIn(member);
      if (mounted) Navigator.pushNamed(context, AppRoutes.loginAnimation);
      AnalyticsController.logUserLogin();
      return true;
    } else {
      debugPrint('There\'s some error');
      Fluttertoast.showToast(msg: 'There\'s some issue with this account');
      return false;
    }
  }

  /// Login User
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final isCreated = await repository.signUp(
      userName: username,
      email: email,
      password: password,
    );
    if (isCreated == true) {
      /// Login With the new details
      // ignore: use_build_context_synchronously
      await login(email: email, password: password, context: context);
      AnalyticsController.logSignUp('Email');
      return true;
    } else {
      Fluttertoast.showToast(msg: 'Invalid Credintials');
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    state = AuthState();
    await repository.logout();
    await GoogleSignIn().signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.loginIntro, (v) => false);
  }

  Future<String?> sendResetLinkToEmail(String email) async {
    bool isValid = await repository.sendPasswordResetLink(email);
    if (isValid) {
      return null;
    } else {
      return 'The email is not registered';
    }
  }
}
