import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/repositories/others/onboarding_local.dart';
import '../../../core/utils/app_utils.dart';

class CookieConsentSheet extends ConsumerWidget {
  const CookieConsentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyPolicy =
        ref.watch(configProvider).value?.privacyPolicyUrl ?? '';

    final consentText =
        ref.watch(configProvider).value?.cookieConsentText ?? '';
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Cookie Consent',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            consentText,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              AppUtil.openLink(privacyPolicy);
            },
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.blue, // Make the link text blue
                decoration:
                    TextDecoration.underline, // Add underline to the link text
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: const Text('Decline'),
              ),
              TextButton(
                onPressed: () {
                  // Handle the 'Accept' action here
                  Navigator.of(context).pop();
                  OnboardingRepository().saveConsentDone();
                },
                child: const Text('Accept'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
