import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../config/wp_config.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/app_utils.dart';

class ConfigErrorPage extends StatelessWidget {
  const ConfigErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Lottie.asset(
                    'assets/animations/no_internet_animation.json'),
              ),
              const SizedBox(height: AppDefaults.margin),
              Text(
                'No configuration found for the app in this website',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h16,
              Text(
                'https://${WPConfig.url}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue,
                    ),
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h16,
              Text(
                'From NewsPro V3, a configuration is required, You can now change the basic settings of your app from your wordpress dashboard. Please upgrade your site config to the latest NewsPro version.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h5,
              Text(
                'If you are still facing this issue after adding configuration to your website, please kindly contact the app author.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              AppSizedBox.h16,
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(IconlyLight.document),
                label: const Text('NewsPro V3 Documentation'),
              ),
              AppSizedBox.h16,
              OutlinedButton.icon(
                onPressed: () =>
                    AppUtil.openLink('https://wa.me/+8801581721600'),
                icon: const Icon(FontAwesomeIcons.whatsapp),
                label: const Text('Contact Author'),
              ),
              AppSizedBox.h16,
              Text(
                'Or contact via email:',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  AppUtil.sendEmail(
                    email: 'mdmomin322@gmail.com',
                    content:
                        'Facing Configuration Error, My purchase code is: {insert your purchase code here}',
                    subject: 'Config error on newspro app',
                  );
                },
                child: const Text('mdmomin322@gmail.com'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
