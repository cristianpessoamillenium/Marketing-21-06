import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../logger/app_logger.dart';

import 'internet_state.dart';

final internetStateProvider =
    StateNotifierProvider<IsConnectedNotifier, InternetState>((ref) {
  return IsConnectedNotifier(ref);
});

class IsConnectedNotifier extends StateNotifier<InternetState> {
  IsConnectedNotifier(
    this.ref,
  ) : super(InternetState.loading) {
    {
      _applyListener();
    }
  }

  final StateNotifierProviderRef ref;

  _applyListener() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      state = InternetState.disconnected;
    }

    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        debugPrint('Checking on internet connection');
        final isConnected = await InternetConnectionChecker().hasConnection;
        if (isConnected) {
          state = InternetState.connected;
          Log.info('Internet is connected ✅');
        } else {
          state = InternetState.disconnected;
          Log.info('Internet is not connected ❌');
        }
      } else if (result == ConnectivityResult.none) {
        state = InternetState.disconnected;
        Log.info('Internet is not connected ❌');
      } else {
        Log.error('No status of internet found');
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });
  }
}
