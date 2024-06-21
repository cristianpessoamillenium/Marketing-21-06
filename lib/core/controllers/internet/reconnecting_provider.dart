import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'internet_state.dart';
import 'internet_state_provider.dart';
import 'reconnecting_state.dart';

final reconnectingInternetProvider = StateNotifierProvider.autoDispose<
    ReconnectingNotifier, InternetReconnectingState>((ref) {
  return ReconnectingNotifier(ref);
});

class ReconnectingNotifier extends StateNotifier<InternetReconnectingState> {
  ReconnectingNotifier(
    this.ref,
  ) : super(InternetReconnectingState.initial()) {
    {
      _applyListener();
    }
  }

  final AutoDisposeStateNotifierProviderRef ref;
  late Timer timer;

  _applyListener() {
    final internetState = ref.watch(internetStateProvider);
    if (internetState == InternetState.disconnected) {
      startTimer();
      debugPrint('Starting timer');
    } else if (internetState == InternetState.connected ||
        internetState == InternetState.loading) {
      disposeTimer();
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    if (mounted) {
      timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          try {
            int secondsRemaining = 0;
            if (mounted) secondsRemaining = state.secondsRemaining;

            if (secondsRemaining == 0) {
              // Fluttertoast.showToast(msg: 'Reconnecting...');
              if (mounted) state = state.copyWith(secondsRemaining: 15);
            } else {
              debugPrint('Decrementing Seconds ');
              if (mounted) {
                state = state.copyWith(secondsRemaining: secondsRemaining - 1);
              }
            }
          } on Exception catch (e) {
            debugPrint(e.toString());
          }
        },
      );
    }
  }

  disposeTimer() {
    ref.onDispose(() {
      timer.cancel();
    });
  }
}
