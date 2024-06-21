import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/controllers/internet/reconnecting_provider.dart';

class InternetNotAvailablePage extends StatelessWidget {
  const InternetNotAvailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'DESCONECTADO! Ta perdendo viu?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Lottie.asset('assets/animations/no_internet_animation.json'),
          ),
          const SizedBox(height: AppDefaults.margin),
          Text(
            'Atualmente você não tem internet disponível',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Por favor, abra suas configurações e ative a Internet ativando Wi-Fi ou dados móveis',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDefaults.margin),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppSettings.openAppSettingsPanel(AppSettingsPanelType.wifi);
                },
                child: const Text('Abrir configurações'),
              ),
            ),
          ),
          AppSizedBox.h10,
          const ReconnectingWidget(),
          const Spacer(),
        ],
      ),
    );
  }
}

class ReconnectingWidget extends ConsumerWidget {
  const ReconnectingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reconnnecting = ref.watch(reconnectingInternetProvider);
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          AppSizedBox.w16,
          Text('Reconectando em ${reconnnecting.secondsRemaining} Segundos...'),
        ],
      ),
    );
  }
}
