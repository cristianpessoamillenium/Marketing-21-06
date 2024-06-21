import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/wp_config.dart';
import '../../core/components/app_logo.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/config/config_controllers.dart';
import '../../core/utils/app_utils.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider).value;
    final description = config?.appDescription ?? '';
    final email = config?.ownerEmail ?? 'No email provided';
    final name = config?.ownerName ?? 'No name provided';
    final phone = config?.ownerPhone ?? 'No phone provided';
    final address = config?.ownerAddress ?? 'No address provided';

    void copyData(String data) async {
      await Clipboard.setData(ClipboardData(text: data));
      Fluttertoast.showToast(msg: 'Copiado');
    }

    return Scaffold(
      appBar: AppBar(title: Text('contact_us'.tr())),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 100,
              width: 100,
              child: AppLogo(),
            ),
          ),
          AppSizedBox.h10,
          Text(
            WPConfig.appName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDefaults.margin),
              child: Text(description),
            ),
          const Divider(),
          ListTile(
            title: const Text('Empresa'),
            subtitle: Text(name),
            leading: const Icon(Icons.person),
            onLongPress: () => copyData(name),
          ),
          const Divider(),
          ListTile(
            title: const Text('Email'),
            subtitle: Text(email),
            leading: const Icon(Icons.email),
            onLongPress: () => copyData(email),
            trailing: IconButton(
              onPressed: () {
                AppUtil.sendEmail(
                  email: email,
                  content: 'Escreva algo aqui...',
                  subject: 'Ganhar Dinheiro ...',
                );
              },
              icon: const Icon(Icons.send_outlined),
            ),
          ),
          ListTile(
            title: const Text('Telefone'),
            subtitle: Text(phone),
            leading: const Icon(Icons.phone),
            onLongPress: () => copyData(phone),
            trailing: IconButton(
              onPressed: () => copyData(phone),
              icon: const Icon(Icons.copy),
            ),
          ),
          ListTile(
            title: const Text('Endereço'),
            subtitle: Text(address),
            leading: const Icon(Icons.gps_fixed_rounded),
            onLongPress: () => copyData(address),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
