import 'dart:io';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adicionar esta linha

import '../../firebase_options.dart';
import '../controllers/applinks/app_links_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/config/config_controllers.dart';
import '../controllers/internet/internet_state_provider.dart';
import '../controllers/notifications/notification_handler.dart';
import '../controllers/notifications/notification_local.dart';
import '../localization/app_locales.dart';
import '../logger/app_logger.dart';
import '../models/notification_model.dart';
import '../repositories/auth/auth_repository.dart';
import '../repositories/others/onboarding_local.dart';
import '../repositories/others/search_local.dart';

/// App Initial State
enum AppState {
  introNotDone,
  loggedIn,
  loggedOut,
}

final coreAppStateProvider =
FutureProvider.family<AppState, BuildContext>((ref, context) async {
  Log.info('Initializing dependencies');

  // Inicializa o estado da internet
  ref.read(internetStateProvider);
  await NotificationHandler.init(context);
  Directory appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ref.read(authRepositoryProvider).init();
  await SearchLocalRepo().init();
  Hive.registerAdapter(NotificationModelAdapter());
  await Hive.openBox<NotificationModel>('notifications');

  final config = ref.read(configProvider).value;
  ref.read(authController);

  ref.read(localNotificationProvider);
  if (config?.isAdOn ?? false) await MobileAds.instance.initialize();
  AppLocales.setLocaleMessages();

  ref.read(applinkNotifierProvider(context));

  // Verificar se o onboarding foi completado
  final prefs = await SharedPreferences.getInstance();
  final isOnboardingDone = prefs.getBool('onboarding_done') ?? false;

  if (isOnboardingDone) {
    return AppState.loggedOut;
  } else {
    return AppState.introNotDone;
  }
});
